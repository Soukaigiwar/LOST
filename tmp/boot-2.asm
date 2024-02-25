; da pra adicionar um simples "oi" nesse codigo com uma interrupcao da bios. o
; modo teletype (mov ah, 0x0e mov al, 'o' int 0x10; mov ah, 0x0e mov al 'i' int
; 0x10') mas ai acho que acabaria seu tempo para explicar

org 0x7c00
bits 16

main:

	mov ah, 0x0e
	mov bh, 0
	mov si, msg

next_char:
	mov al, [si]
	int 0x10

	inc si
	test al, al
	jnz next_char

	jmp $

msg: db 'Welcome to be LOS/T...', 0

times 510-($-$$) db 0
dw 0xaa55

