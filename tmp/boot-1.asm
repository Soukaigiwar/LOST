; da pra adicionar um simples "oi" nesse codigo com uma interrupcao da bios. o
; modo teletype (mov ah, 0x0e mov al, 'o' int 0x10; mov ah, 0x0e mov al 'i' int
; 0x10') mas ai acho que acabaria seu tempo para explicar

org 0x7c00
bits 16

main:

	mov al, 0x02
	mov ah, 0x0e ;  [  AH  ] [  AL  ] AX
	mov bh, 0
	int 0x10

halt:
	; Parada da CPU...
	hlt
	jmp halt

times 510-($-$$) db 0
dw 0xaa55

