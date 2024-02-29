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

print_str:
    ;
    ; Impressão da string com 'loop until'...
    ;
	mov si, hello
    mov ah, 0x0e
.until_null:
    lodsb
    or al, al
    jz halt
    int 0x10
    jmp .until_null

halt:
    ;
    ; Parada da CPU...
    ;
	cli
    hlt
;
; DATA
;
hello: db 'Loading OS...', 0

times 510-($-$$) db 0
dw 0xaa55

