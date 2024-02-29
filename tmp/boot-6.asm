;
; MACROS E DIRETIVAS
;
%define TIMER  0x046c
%define ORIGIN 0x7c00

    bits 16
    org ORIGIN
;
; TEXT
;
main:
    ;
	; Definir segmentos de dados...
    ;
	mov ax, 0
	mov ds, ax
	mov es, ax
    ;
	; Iniciar a pilha...
    ;
	mov ss, ax
	mov sp, ORIGIN

wait_timer:
    ;
	; Espera 3s antes de mudar o modo de vídeo...
    ;
    ; O BIOS conta "ticks" de 55ms desde o reset da CPU no
    ; endereço 0040:006c (0x0040 * 16 + 0x006c => 0000:046c).
    ;
    ; 1s ~ 18.2 ticks => 3s ~ 55 ticks
    ;
    ; Ver BIOS Data Area em...
    ; http://www.techhelpmanual.com/93-rom_bios_variables.html
    ;
    mov cx, 3 * 18      ; Total de ticks para ~3 segundos
	mov bx, [TIMER]     ; Valor inicial no timer do BIOS
    inc bx              ; Incrementa {bx} em 1 "tick"
.wait:
	cmp [TIMER], bx     ; Verifica se já passou 1 "tick"
	jl .wait            ; se não passou, continua esperando
    mov bx, [TIMER]     ; se passou, atualiza {bx}
    inc bx              ; Incrementa {bx} em 1 "tick"
    loop .wait          ; continua no loop até completar 90 "ticks"

clear_screen:
    ;
	; Limpar a tela
    ;
    ; AH 0x00 => Alterar modo de vídeo
    ; AL 0x03 => Modo VGA texto 80x25, char 9x16, 16 cores
    ;
    mov al, 0x03
	int 0x10

print_msg:
    ;
    ; Imprimir mensagem no TTY (com contador)...
    ;
    ; AH    0x0e Imprimir caractere
    ; AL    character to write
    ; BL    (graphics modes only) foreground color number
    ;
    mov ah, 0x0e
    mov cx, pad - msg
	mov si, msg
.next_char:
    lodsb
    int 0x010
    loop .next_char

halt:
    ;
    ; Parada da CPU...
    ;
	cli
	hlt
;
; DATA
;
msg:
	db `Loading...`
pad:
	times 510-($-$$) db 0
sig:
	dw 0xaa55

