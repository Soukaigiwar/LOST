    bits 16
    org 0x7c00
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
	mov sp, 0x7c00

print_msg:
    ;
	; Imprimir string com 'loop for'...
    ;
    mov ah, 0x0e
    mov cx, pad - msg
	mov si, msg
.next_char:
    lodsb
    int 0x10
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
    db 'Loading OS...'

pad:
    times 510-($-$$) db 0

sig:
    dw 0xaa55

