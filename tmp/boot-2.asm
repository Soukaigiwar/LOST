    bits 16
    org 0x7c00
;
; TEXT
;
main:
    ;
    ; BIOS INT 0x10 - Serviços de vídeo
    ;
    ; AH    0x0e - Função para impressão de caracteres no TTY
    ; AL    Caractere a ser impresso
    ; BL    Número da cor de frente (somante em modo gráfico)
    ;
    mov al, 0x2
	mov ah, 0x0e
	int 0x10

halt:
    ;
    ; Parada da CPU
    ;
    cli     ; Limpa a flag de interrupções
    hlt
;
; DATA
;
    times 510-($-$$) db 0
    dw 0xaa55

