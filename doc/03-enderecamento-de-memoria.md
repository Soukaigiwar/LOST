# Endereçamento de memória

- A CPU 8086 tinha um barramento de endereços de 20 bits.
- Endereçamento máximo 2^20 bytes: 1.048.576 bytes ≃ 1MB.
- Computadores tinha de 64kB a 128kB de memória.
- Como o limite era muito maior, decidiu-se usar um esquema de memória definido *segmentos* e *offsets*.
- Desta forma, o endereçamento era feito com um par de valores com 16 bits.

## Esquema de segmentos e offset

```
SEGMENTO   OFFSET
    \       /
  0x1234:0x5678
```

- Cada *segmento* abrange 64kB de memória.
- Cada byte é acessado pelo valor do *offset*
- Os segmentos são sobrepostos com um deslocamento de 16 bytes.

```
0   16  32  48  ...     64kB
[segmento 0...............]
    [segmento 1...............]
        [segmento 2...............]

Endereço real = segmento * 16 + offset
```

Isso significa que há várias formas de acessar o mesmo local na memória.

**Exemplo:** endereço do código de boot na memória (`0x7c00`)

| Segmento:Offset | Cálculo (base 10)           | Endereço real |
|-----------------|-----------------------------|---------------|
| `0x0000:0x7c00` | `0    * 16 + 31744 = 31744` | `0x7c00`      |
| `0x0001:0x7bf0` | `1    * 16 + 31728 = 31744` | `0x7c00`      |
| `0x0010:0x7b00` | `16   * 16 + 31488 = 31744` | `0x7c00`      |
| `0x00c0:0x7000` | `192  * 16 + 28672 = 31744` | `0x7c00`      |
| `0x07c0:0x0000` | `1984 * 16 + 0     = 31744` | `0x7c00`      |

## Registradores de segmentos

- **Code Segment** (`CS`): segmento do código em execução (\*).
- **Data Segment** (`DS`): segmento de dados.
- **Stack Segment** (`SS`): segmento endereço corrente da pilha.
- **Extra Segments** (`ES`, `FS`, `GS`): segmentos de dados extra.

> (\*) O registrador do ponteiro de instruções (`IP`) registra apenas o *offset*.

## Referenciando endereços em assembly

Esquema geral:

```
segmento:[base + índice * escala + deslocamento]
```

Onde:

| Campo        | Registrador/Valor                                                       |
|--------------|-------------------------------------------------------------------------|
| Segmento     | `CS`, `DS` (padrão), `ES`, `FS`, `GS`, `SS` (padrão se a base for `BP`) |
| Base         | `BP`, `BX` (em 32/64 bits, qualquer registrador de propósito geral)     |
| Índice       | `SI`, `DI` (em 32/64 bits, qualquer registrador de propósito geral)     |
| Escala       | (Apenas em 32/64 bits) valor imediato 1, 2 4 ou 8                       |
| Deslocamento | Um valor imediato com sinal                                             |

### Exemplo 1:

```asm
var: dw 100

    mov ax, var     ; Copia o endereço no offset definido por 'var' para {ax}.
    mov ax, [var]   ; Implicitamente, copia o conteúdo do segmento de dados ({DS})
                    ; no offset definido por 'var' para {ax}.
```

### Exemplo 2:

```asm
array: dw 100, 200, 300

    mov bx, array       ; Copia o endereço de 'array' para {bx}.
    mov si, 2 * 2       ; Copia 4 para {si} (será o offset de array[2]).
    mov ax, [bx + si]   ; Copia para {ax} o conteúdo no endereço base em {bx} + 4 bytes.
```

