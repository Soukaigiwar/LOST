%ifndef PUTS
%define PUTS
;
; Imprime string no endereço passado em {si}
;
puts:
	; Salvar registradores que serão alterados...
	push si
	push ax
	push bx

.until_null:
	; Carregar sequencialmente em {al} cada byte no endereço em {si}...
	lodsb
	or al, al
	jz .done

	; Imprime o caractere em {al}...
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	jmp .until_null

.done:
	; Restaurar registradores que foram alterados...
	pop bx
	pop ax
	pop si

	ret

%endif
