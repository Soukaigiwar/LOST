org 0x7c00
bits 16

main:

print_str:
	mov ah, 0x0e	; Serão os mesmos dados durante o loop.
	mov bh, 0	;
	mov si, hello	; 

.until_null:
	lodsb		; O mesmo que:	mov al, [si]
			;		inc si
	int 0x10

	test al, al
	jnz .until_null

halt:
	jmp $

%define EOL 0x0d, 0x0a

hello: db 'Welcome to LOS/T!', EOL, 0

times 510-($-$$) db 0
dw 0xaa55

