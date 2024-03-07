# Discos flexíveis (floppy disks)

## Por que floppy disks?

- É a forma mais simples de armazenamento com que poderíamos trabalhar os
  conceitos da carga de um sistema operacional.
- Fácil de usar.
- Suportado por todos os BIOS e programas de virtualização.
- A criação de arquivos de imagem é muito simples.
- O FAT12 é um dos sistemas de arquivos mais simples.

## Implementação mais simples

- Bootloader lido no primeiro setor do disco.
- Sistema operacional iniciado a pertir do segundo setor.

```
FLOPPY
| SETOR 1 | SETOR 2
+---------+---------------------------------
|   BOOT  | SISTEMA OPERACIONAL...
+---------+---------------------------------
```

### Problema desta abordagem

O disco não poderia ser utilizado para armazenar outros arquivos.

### Soluções

- Criar o nosso próprio sistema de arquivos.
- Utilizar um dos sistemas de arquivos com padrões já especificados (FAT, EXT,
  NTFS, etc).

## Sistema de arquivos FAT-12

- Projetado para discos flexíveis.
- Gerencia até 18MB.
- Utiliza 12 bits para endereçar os *clusters*.

### Registro de boot

- Ocupa um setor.
- Sempre localizado no setor lógico `0` da partição.
- Se a mídia não estiver particionada, fica no começo da mídia.
- Se a mídia estiver particionada, o seu início conterá o MBR ou informações de
  outras formas de particionamento.
- Neste caso, o primeiro setor de cada partição conterá um **registro de volume
  de boot**.

### Bloco de parâmetros do BIOS (BPB)

Os primeiros 3 bytes devem ser uma instrução `jmp short` seguida de `nop`. No código do bootloader, portanto...

```asm
bits 16
org 0x7c00

; -----------------------------------------------------------------------------
; Cabeçalho FAT12
; -----------------------------------------------------------------------------
;
; BIOS Parameter Block (BPB)
;
jmp short main
nop

main:
```

Em seguida, os bytes de 3 a 10 (os 8 bytes seguintes) devem conter o
**identificador OEM**. Qualquer coisa pode ser escrita aqui, mas é
comum utilizar a string `MSWIN4.1` para maximizar a compatibilidade:

```asm
bits 16
org 0x7c00

; -----------------------------------------------------------------------------
; Cabeçalho FAT12
; -----------------------------------------------------------------------------
;
; BIOS Parameter Block (BPB)
;
jmp short main
nop

BPB_OEM     db  'MSWIN4.1'  ; 8 bytes


main:
```

> Um disquete formatado no GNU/Linux provavelmente conteria a string `mkdosfs`.

O registro seguinte deve conter uma *word* indicando o número de bytes por
setor, que são 512 byes para um disquete de 1.44MB:

```asm
bits 16
org 0x7c00

; -----------------------------------------------------------------------------
; Cabeçalho FAT12
; -----------------------------------------------------------------------------
;
; BIOS Parameter Block (BPB)
;
jmp short main
nop

BPB_OEM     db  'MSWIN4.1'  ; 8 bytes
BPB_BPS     dw  512         ; 2 bytes

main:
```

Em seguida, virão:

- Número de setores por *cluster* (1 byte - valor `1`);
- Número de setores reservados (2 bytes - valor `1`);
- Contagem da tabela de alocação de arquivos FAT (1 byte - valor: `2`);
- Contagem de entradas no diretório raiz (2 bytes - valor `0xe0`);
- Total de setores (2 bytes - valor `2880`);
- Descritor do tipo de mídia (1 byte - valor `0xf0` = disqquete de 3½");
- Número de setores por tabela de alocação de arquivos (2 bytes - valor `9`);
- Número de setores por trilha (2 bytes - valor `18`);
- Número de cabeçotes/faces (2 bytes - valor `2`);
- Número de setores ocultos (4 bytes - valor `0`);
- Contagem de setores grandes (4 bytes - valor `0`).

No código...

```asm
bits 16
org 0x7c00

; -----------------------------------------------------------------------------
; Cabeçalho FAT12
; -----------------------------------------------------------------------------
;
; BIOS Parameter Block (BPB)
;
jmp short main
nop

BPB_OEM     db  'MSWIN4.1'  ; 8 bytes - OEM
BPB_BPS     dw  512         ; 2 bytes - Bytes por setor
BPB_SPC     db  1           ; 1 byte  - Número de setores por cluster
BPB_RSC     dw  1           ; 2 bytes - Número de setores reservados
BPB_FATC    db  2           ; 1 byte  - Contagem da FAT
BPB_DEC     dw  0xe0        ; 2 bytes - Contagem de entradas no diretório raiz
BPB_NTS     dw  2880        ; 2 bytes - Número total de setores (2880 x 512 bytes = 1440 bytes)
BPB_MDT     db  0xf0        ; 1 byte  - Descritor de tipo de mídia (0xf0 = disquete 3½")
BPB_SPFAT   dw  9           ; 2 bytes - Número de setores por FAT
BPB_SPT     dw  18          ; 2 bytes - Setores por trilha
BPB_NH      dw  2           ; 2 bytes - Número de cabeçotes/faces
BPB_HS      dd  0           ; 4 bytes - Número de setores ocultos
BPB_LSC     dd  0           ; 4 bytes - Contagem de grandes setores

main:
```

### Registro de boot estendido (EBR ou EBPB)

Depois dos campos do BPB, vêm os campos do registro estendido de boot (EBR),
que contém diversas informações específicas do sistema de particionamento:

- Número do drive (1 byte - valor `0` = floppy);
- Byte reservado (1 byte - valor `0`);
- Assinatura (1 byte - valor `0x29`);
- Número de série identificador do volume (4 bytes - qualquer valor);
- Rótulo do volume (11 bytes - string de 11 caracteres);
- String de identificação do sistema (8 bytes - string de 8 caracteres).

No código...

```asm
bits 16
org 0x7c00

; -----------------------------------------------------------------------------
; Cabeçalho FAT12
; -----------------------------------------------------------------------------
;
; BIOS Parameter Block (BPB)
;
jmp short main
nop

BPB_OEM     db  'MSWIN4.1'  ; 8 bytes - OEM
BPB_BPS     dw  512         ; 2 bytes - Bytes por setor
BPB_SPC     db  1           ; 1 byte  - Número de setores por cluster
BPB_RSC     dw  1           ; 2 bytes - Número de setores reservados
BPB_FATC    db  2           ; 1 byte  - Contagem da FAT
BPB_DEC     dw  0xe0        ; 2 bytes - Contagem de entradas no diretório raiz
BPB_NTS     dw  2880        ; 2 bytes - Número total de setores (2880 x 512 bytes = 1440 bytes)
BPB_MDT     db  0xf0        ; 1 byte  - Descritor de tipo de mídia (0xf0 = disquete 3½")
BPB_SPFAT   dw  9           ; 2 bytes - Número de setores por FAT
BPB_SPT     dw  18          ; 2 bytes - Setores por trilha
BPB_NH      dw  2           ; 2 bytes - Número de cabeçotes/faces
BPB_HS      dd  0           ; 4 bytes - Número de setores ocultos
BPB_LSC     dd  0           ; 4 bytes - Contagem de grandes setores
;
; BPB estendido (EBR)
;
EBR_DN      db  0               ; 1 byte   - Número do drive (0x00 floppy; 0x80 HDD)
EBR_RES     db  0               ; 1 byte   - Reservado (a menos que fossem flags do Win NT)
EBR_SIG     db  0x29            ; 1 byte   - Assinatura (também poderia ser 0x28)
EBR_VID     dd  0x12345678      ; 4 bytes  - Número de série do volume
EBR_LBL     db  'LEARNING OS'   ; 11 bytes - Rótulo do volume
EBR_SYS     db  'FAT12   '      ; 8 bytes  - Sistema de particionamento

; -----------------------------------------------------------------------------
; Código do boot
; -----------------------------------------------------------------------------
main:

```







---

[Voltar](../README.md#conceitos)

