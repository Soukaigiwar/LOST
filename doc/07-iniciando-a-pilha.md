# Iniciando o endereço do topo da pilha

A pilha deve ser definida para crescer a partir do endereço do início do código:

```asm
bits 16
org 0x7c00

main:

    ;
    ; Definição dos segmentos de dados...
    ;
    xor ax, ax      ; Registra 0x0000 em AX
    mov ds, ax      ; Segmento de Dados DS=AX=0x0000
    mov es, ax      ; Segmento de Dados ES=AX=0x0000
    ;
    ; Definindo o endereço do topo da pilha...
    ;
    mov ss, ax      ; Segmento do endereçamento da pilha: SS=AX=0x0000
    mov sp, 0x7c00  ; Todos os 'push' serão endereçados a partir daqui
```

Deste modo...

```
   0x0000                          0x7c00                       0x7e00
     |                               |                            |
     V                               V                            V
     +-----+-----------+-------------+----------------------------+---
RAM  | IVT | BIOS DATA |   (~30k)    | Código do boot (512 bytes) |   
     +-----+-----------+-------------+----------------------------+--- 
                            push <-- SP
```



---

[Voltar](../README.md#conceitos)

