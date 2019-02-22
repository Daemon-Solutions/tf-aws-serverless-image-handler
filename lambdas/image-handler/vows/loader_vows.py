# se!/usr/bin/python
# -*- coding: utf-8 -*-
from mock import Mock

from pyvows import Vows, expect

from thumbor.context import Context
from derpconf.config import Config

from fixtures.storage_fixture import IMAGE_PATH

from tc_aws.loaders import *

import logging
logging.getLogger('botocore').setLevel(logging.CRITICAL)

s3_bucket = 'thumbor-images-test'

@Vows.batch
class S3LoaderVows(Vows.Context):

    class CanGetBucketAndKey(Vows.Context):

        def topic(self):
            conf = Config()
            conf.TC_AWS_LOADER_BUCKET = None
            conf.TC_AWS_LOADER_ROOT_PATH = ''
            return Context(config=conf)

        def should_detect_bucket_and_key(self, topic):
            path = 'some-bucket/some/image/path.jpg'
            bucket, key = _get_bucket_and_key(topic, path)
            expect(bucket).to_equal('some-bucket')
            expect(key).to_equal('some/image/path.jpg')

    class CanDetectBucket(Vows.Context):

        def topic(self):
            return _get_bucket('/'.join([s3_bucket, IMAGE_PATH]))

        def should_detect_bucket(self, topic):
            expect(topic).to_equal(s3_bucket)

    class CanDetectKey(Vows.Context):

        def topic(self):
            conf = Config()
            conf.TC_AWS_LOADER_BUCKET = None
            conf.TC_AWS_LOADER_ROOT_PATH = ''
            context = Context(config=conf)
            return _get_key(IMAGE_PATH, context)

        def should_detect_key(self, topic):
            expect(topic).to_equal(IMAGE_PATH)
