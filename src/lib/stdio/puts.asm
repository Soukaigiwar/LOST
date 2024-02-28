%ifndef PUTS
%define PUTS
;
; Imprime a string no endereço passado em {si}
; até encontrar o byte 0x00.
;
puts:
    push si
    push ax

    mov ah, 0x0e

.until_null:
    lodsb
    or al, al
    jz .done

    int 0x10
    jmp .until_null

.done:
    pop ax
    pop si

    ret

%endif
