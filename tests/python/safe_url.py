from libthumbor import CryptoURL

crypto = CryptoURL(key='testing')

encrypted_url = crypto.generate(
    width=200,
    height=200,
    smart=True,
    image_url='face.jpg'
)

print("https://media.trynotto.click" + encrypted_url)
