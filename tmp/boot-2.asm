;
; BIOS Service - Impressão de caractere como TTY
; AH    0eH
; AL    character to write
; BL    (graphics modes only) foreground color number
;
bits 16
org 0x7c00

main:

    mov al, 0x2
	mov ah, 0x0e
	int 0x10

cli     ; Limpa a flag de interrupções
hlt

times 510-($-$$) db 0
dw 0xaa55

