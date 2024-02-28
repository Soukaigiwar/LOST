bits 16
org 0x7c00

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
	; Imprimir mensagem no TTY (com contador)...
    ;
    mov ah, 0x0e
    mov cx, pad - msg
	mov si, msg
.next_char:
    lodsb
    int 0x010
    loop .next_char
	
halt:
    cli
	hlt

msg:
    db 'Loading OS...'

pad:
    times 510-($-$$) db 0

sig:
    dw 0xaa55

