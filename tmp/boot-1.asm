;
; Framework do código do setor de boot: não faz nada!
;
bits 16
org 0x7c00

main:


halt:
	; Parada da CPU...
	hlt
	jmp halt

times 510-($-$$) db 0
dw 0xaa55

