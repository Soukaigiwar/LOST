org 0x7c00
bits 16

main:

halt:
	; Parada da CPU...
	hlt
	jmp halt

times 510-($-$$) db 0
dw 0xaa55

