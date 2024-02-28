bits 16
org 0x7c00

main:

print_str:
	mov si, hello
    mov ah, 0x0e
.next_char:
    lodsb
    or al, al
    jz halt
    int 0x10
    jmp .next_char

halt:
	cli
    hlt

hello: db 'Welcome to LOS/T!', 0

times 510-($-$$) db 0
dw 0xaa55

