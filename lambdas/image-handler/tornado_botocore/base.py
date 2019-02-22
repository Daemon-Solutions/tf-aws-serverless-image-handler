import logging

from functools import partial
try:
    # python2
    from urlparse import urlparse
    from urllib import getproxies_environment
except ImportError:
    # python3
    from urllib.parse import urlparse
    from urllib.request import getproxies_environment

from tornado.httpclient import HTTPClient, AsyncHTTPClient, HTTPRequest, HTTPError

import botocore.credentials
import botocore.parsers
import botocore.response
import botocore.session


__all__ = ('Botocore',)


logger = logging.getLogger(__name__)


# Tornado proxies are currently only supported with curl_httpclient
# http://www.tornadoweb.org/en/stable/httpclient.html#request-objects
AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")


class Botocore(object):

    def __init__(self, service, operation, region_name, endpoint_url=None, session=None):
        # set credentials manually
        session = session or botocore.session.get_session()
        # get_session accepts access_key, secret_key
        self.client = session.create_client(
            service,
            region_name=region_name,
            endpoint_url=endpoint_url
        )
        self.endpoint = self.client._endpoint
        self.operation = operation
        self.http_client = AsyncHTTPClient()

        self.proxy_host = None
        self.proxy_port = None
        https_proxy = getproxies_environment().get('https')
        if https_proxy:
            proxy_parts = https_proxy.split(':')
            if len(proxy_parts) == 2 and proxy_parts[-1].isdigit():
                self.proxy_host, self.proxy_port = proxy_parts
                self.proxy_port = int(self.proxy_port)
            else:
                proxy = urlparse(https_proxy)
                self.proxy_host = proxy.hostname
                self.proxy_port = proxy.port

    def _send_request(self, request_dict, operation_model, callback=None):
        request = self.endpoint.create_request(request_dict, operation_model)
        adapter = self.endpoint.http_session.get_adapter(url=request.url)
        conn = adapter.get_connection(request.url, proxies=None)
        adapter.cert_verify(conn, request.url, verify=True, cert=None)
        adapter.add_headers(request)

        request = HTTPRequest(
            url=request.url,
            headers=request.headers,
            method=request.method,
            body=request.body,
            validate_cert=False,
            proxy_host=self.proxy_host,
            proxy_port=self.proxy_port
        )

        if callback is None:
            # sync
            return self._process_response(
                HTTPClient().fetch(request),
                operation_model=operation_model
            )

        # async
        self.http_client.fetch(
            request,
            callback=partial(
                self._process_response,
                callback=callback,
                operation_model=operation_model
            )
        )

    def _make_request(self, operation_model, request_dict, callback):
        logger.debug(
            "Making request for %s (verify_ssl=%s) with params: %s",
            operation_model, self.endpoint.verify, request_dict)
        return self._send_request(
            request_dict=request_dict,
            operation_model=operation_model,
            callback=callback
        )

    def _make_api_call(self, operation_name, api_params, callback=None):
        operation_model = self.client._service_model.operation_model(operation_name)
        request_dict = self.client._convert_to_request_dict(api_params, operation_model, {})
        return self._make_request(
            operation_model=operation_model,
            request_dict=request_dict,
            callback=callback
        )

    def _process_response(self, http_response, operation_model, callback=None):
        response_dict = {
            'headers': http_response.headers,
            'status_code': http_response.code,
        }
        if response_dict['status_code'] >= 300:
            response_dict['body'] = http_response.body
        elif operation_model.has_streaming_output:
            response_dict['body'] = botocore.response.StreamingBody(
                http_response.buffer,
                response_dict['headers'].get('content-length')
            )
        else:
            response_dict['body'] = http_response.body
        parser = self.endpoint._response_parser_factory.create_parser(operation_model.metadata['protocol'])
        parsed = parser.parse(response_dict, operation_model.output_shape)

        self.client.meta.events.emit(
            "after-call.{endpoint_prefix}.{operation_name}".format(
                endpoint_prefix=self.client._service_model.endpoint_prefix,
                operation_name=self.operation
            ),
            http_response=response_dict, parsed=parsed,
            model=operation_model
        )

        if http_response.error and isinstance(http_response.error, HTTPError):
            if 'Error' not in parsed:
                parsed['Error'] = {
                    'Message': http_response.error.message,
                    'Code': unicode(http_response.error.code)
                }
        if callback:
            callback(parsed)
        else:
            return parsed

    def call(self, callback=None, **kwargs):
        return self._make_api_call(
            operation_name=self.operation,
            api_params=kwargs,
            callback=callback
        )
