#!/usr/bin/python

# https://gist.github.com/glassdfir/02c6126118925c080fd8
from hashlib import md5
from Crypto.Cipher import AES
from Crypto import Random
import os, sys
import base64

def derive_key_and_iv(password, salt, key_length, iv_length):
	d = d_i = ''
	while len(d) < key_length + iv_length:
		d_i = md5(d_i + password + salt).digest()
		d += d_i
	return d[:key_length], d[key_length:key_length+iv_length]

def to_hex(in_str):
	out = ""
	tmp = ["\\x%02x" % ord(c) for c in in_str]
	for c in in_str:
		out += "\\x%02x" % ord(c)
	return out

def padding(str, bs):
	if len(str) % bs > 0:
		return str + (bs - len(str) % bs) * chr(bs - len(str) % bs)
	else:
		return str

def encrypt(plaintext, password, key_length=32):
	bs = AES.block_size
	key, iv = derive_key_and_iv(password, "ASDFGHJKASDFGHJK", key_length, bs)
	cipher = AES.new(key, AES.MODE_CBC, iv)
	paddedPlaintext = padding(plaintext, bs)
	EncryptedShellcode = base64.b64encode(cipher.encrypt(paddedPlaintext))
	EncryptedShellcode = to_hex(EncryptedShellcode)
	print "Encrypted Shellcode:\n" + EncryptedShellcode + "\n"

def main():
	if len(sys.argv) != 3:
		print "Usage: python %s <shellcode> <password>"
		exit()
	encrypt(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
	main()
