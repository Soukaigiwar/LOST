;
; Framework do código do setor de boot: não faz nada!
;
    bits 16     ; Orienta o montador a gerar código 16 bits.
    org 0x7c00  ; Todos os endereços no código serão relativos a esta origem.
;
; TEXT
;
main:
    ;
    ; O código vem aqui...
    ;

halt:
    ;
	; Parada da CPU...
    ;
	hlt
	jmp halt
;
; DATA
;
times 510-($-$$) db 0
dw 0xaa55

