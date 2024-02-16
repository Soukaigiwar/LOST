# LOS/T - Learning OS/Tutorial

Tutorial sobre a criação de um sistema operacional do zero para fins de aprendizado.

## Conteúdo

* [Objetivos](#objetivos)
  * [Fase 1](#fase-1)
* [Fontes de pesquisa](#fontes-de-pesquisa)
  * [Artigos](#artigos)
  * [Vídeos](#vídeos)
  * [Códigos para referência](#códigos-para-referência)
* [Requisitos](#requisitos)
  * [NASM e QEMU](#nasm-e-qemu)
* [Conceitos](#conceitos)
  * [Como o BIOS encontra o OS](#como-o-bios-encontra-o-os)
    * [Modo legado](#modo-legado)
    * [Modo EFI](#modo-efi)
* [Diferenças entre 'diretivas' e 'instruções'](#diferenças-entre-'diretivas'-e-'instruções')
    * [Diretivas](#diretivas)
    * [Instruções](#instruções)
* [Makefile](#makefile)
* [Código do boot - versão 1](#código-do-boot---versão-1)

## Objetivos

### Fase 1

- Dar boot na máquina
- Carregar o kernel

## Fontes de pesquisa

### Artigos

- [BIOS Interrupt call - Wikipedia](https://en.wikipedia.org/wiki/BIOS_interrupt_call)
- [Interrupt Vector Table (IVT) - Wikipedia](https://en.wikipedia.org/wiki/Interrupt_vector_table)
- [How to write a simple operating system - Mike Saunders (MikeOS)](https://mikeos.sourceforge.net/write-your-own-os.html)

### Vídeos

- [Building an OS - Youtube (playlist)](https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN)

### Códigos para referência

- [BootMine ("Campo Minado" para o setor de boot) - GitHub](https://github.com/io12/BootMine/blob/master/mine.asm)
- [ghaiklor-os-gcc (OS educacional) - GitHub](https://github.com/ghaiklor/ghaiklor-os-gcc)

## Requisitos

### NASM e QEMU

Debian e derivados:

```
sudo apt install build-essential qemu nasm
```

## Conceitos

### Como o BIOS encontra o OS

#### Modo legado

- O BIOS carrega o primeiro setor do dispositivo na memória.
- Endereço: `0x7c00`.
- O BIOS procura a assinatura de boot: `0xaa55`.
- Se encontrada, inicia a execução do código do boot.

#### Modo EFI

- O BIOS procura pela partição especial EFI.
- O sistema operacional deve ser compilado com um programa de EFI.

### Diferenças entre 'diretivas' e 'instruções'

#### Diretivas

- Determinam como o montador deverá compilar o código.
- Não são traduzidas em código de máquina.
- Diferem de montador para montador.

#### Instruções

- Determinam o que a CPU deverá executar.
- São traduzidas em código de máquina.
- Conjuntos de códigos de operação (OpCodes) da CPU.

### Memória

- A CPU 8086 tinha um barramento de endereços de 20 bits.
- Endereçamento máximo 2^20 bytes: 1.048.576 bytes ≃ 1MB.
- Computadores tinha de 64kB a 128kB de memória.
- Como o limite era muito maior, decidiu-se usar um esquema de memória definido *segmentos* e *offsets*.
- Desta forma, o endereçamento era feito com um par de valores com 16 bits.

#### Esquema de segmentos e offset

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

#### Registradores de segmentos

- **Code Segment** (`CS`): segmento do código em execução (\*).
- **Data Segment** (`DS`): segmento de dados.
- **Stack Segment** (`SS`): segmento endereço corrente da pilha.
- **Extra Segments** (`ES`, `FS`, `GS`): segmentos de dados extra.

> (\*) O registrador do ponteiro de instruções (`IP`) registra apenas o *offset*.

### Referenciando endereços em assembly (16 bits)

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

Exemplo 1:

```asm
var: dw 100

    mov ax, var     ; Copia o endereço no offset definido por 'var' para {ax}.
    mov ax, [var]   ; Implicitamente, copia o conteúdo do segmento de dados ({DS})
                    ; no offset definido por 'var' para {ax}.
```

Exemplo 2:

```asm
array: dw 100, 200, 300

    mov bx, array       ; Copia o endereço de 'array' para {bx}.
    mov si, 2 * 2       ; Copia 4 para {si} (será o offset de array[2]).
    mov ax, [bx + si]   ; Copia para {ax} o conteúdo no endereço base em {bx} + 4 bytes.
```



## Makefile

> **Importante!** Antes de executar o `make`, é preciso copiar
> o código-fonte trabalhado para o arquivo `src/main.asm`!

```
ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/disk.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/lost.img
	truncate -s 1440k $(BUILD_DIR)/lost.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin

run:
	@qemu-system-i386 -drive file=build/lost.img,format=raw,index=0,if=floppy
```

## Código do boot - versão 1

Esta versão do código apenas inicia o boot e não faz mais nada.

Arquivo `src/main.asm`:

```asm
    org 0x7c00              ; Onde o BIOS carregará o nosso boot na memória.
    bits 16                 ; Produzir código em 16 bits.

main:                       ; Apenas uma referência para o início do código.

    hlt		                ; Para a execução do código.
    jmp $                   ; Salte para cá se a execução continuar (loop infinito).

    times 510-($-$$) db 0   ; Preenche com zeros o restante do binário até 510 bytes.
    dw 0xaa55               ; Escreve a palavra 0xaa55 (assinatura de boot).
```

