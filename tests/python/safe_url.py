import hashlib
import hmac
import base64

def make_digest(message, key):

    key = bytes(key, 'UTF-8')
    message = bytes(message, 'UTF-8')

    digester = hmac.new(key, message, hashlib.sha1)
    signature1 = digester.digest()

    signature2 = base64.urlsafe_b64encode(signature1)

    return str(signature2, 'UTF-8')


path = 'fit-in/200x200/face.jpg'
key  = 'testing'

result = make_digest(path, key)
print('https://media.trynotto.click/' + result + '/' + path)
