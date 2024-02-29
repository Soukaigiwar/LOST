    bits 16
    org 0x7c00
;
; TEXT
;
main:
    ;
	; Definir segmentos de dados...
    ;
	xor ax, ax
	mov ds, ax
	mov es, ax
    ;
	; Iniciar a pilha...
    ;
	mov ss, ax
	mov sp, 0x7c00

clear_screen:
    ;
	; Limpar a tela
    ; AH 0x00 => Alterar modo de vídeo
    ; AL 0x03 => Modo VGA texto 80x25, char 9x16, 16 cores
    ;
    mov al, 0x03
	int 0x10

print_msg:
    ;
	; Imprimir string...
    ;
    ; AH 0x13 => Imprimir string
    ; AL 0x01 => Atualizar posição do cursor
    ; BH 0x00 => Página de vídeo 0
    ; BL      => Atributos de cor [4 bits BG][4 bits FG]
    ; CX      => Comprimento da string
    ; DH      => Linha
    ; DL      => Coluna
    ; ES:BP   => Endereço do início da string
	;
    mov ax, 0x1301      ;
    mov bx, 0x02        ; BH=0x00 - BL=[BG 0x0][FG 0x2 (verde)]
    mov cx, pad - msg
    xor dx, dx          ; Linha 0x00 - Coluna 0x00
    mov bp, msg         ; ES já está definido como 0
    int 0x10

halt:
    ;
    ; Parada da CPU...
	cli
	hlt

;
; DATA
;
msg:
	db `Welcome to LOS/T!\r\nLoading...`

pad:
	times 510-($-$$) db 0

sig:
	dw 0xaa55

