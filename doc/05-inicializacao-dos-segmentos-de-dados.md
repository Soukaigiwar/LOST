# Inicialização dos segmentos de memória

- Geralmente, o BIOS define DS para apontar para o segmento `0x0000`, mas isso não é uma regra!
- Como não temos certeza, convenciona-se determinar os segmentos de dados no início do código.
- Registradores de segmentos não recebem valores diretamente: os endereços são copiados de registradores.

## Inicialização de segmentos no boot

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
```

