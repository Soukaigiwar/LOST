;; ----------------------------------------------------------------------------
;; COPYRIGHT AND LICENSE
;; ----------------------------------------------------------------------------
;; Copyright (C) 2024, Blau Araujo <blau@debxp.org>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;; ----------------------------------------------------------------------------
;; BOOTLOADER - Antes de carregar o kernel.
;; ----------------------------------------------------------------------------
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
; -----------------------------------------------------------------------------
; Definição dos segmentos de dados...
; -----------------------------------------------------------------------------
    xor ax, ax      ; Registra 0x0000 em AX
    mov ds, ax      ; Segmento de Dados DS=AX=0x0000
    mov es, ax      ; Segmento de Dados ES=AX=0x0000
; -----------------------------------------------------------------------------
; Definição do topo da pilha...
; -----------------------------------------------------------------------------
    mov ss, ax      ; Segmento do endereçamento da pilha: SS=AX=0x0000
    mov sp, 0x7c00  ; Todos os 'push' serão endereçados a partir daqui
; -----------------------------------------------------------------------------
; Limpar a tela...
; -----------------------------------------------------------------------------
clr_screen:
    mov al, 0x03    ; AX=0x0003 = Modo texto VGA 80x25, char 9x16, 16 cores
    int 0x10
; -----------------------------------------------------------------------------
; Imprimir mensagem...
; -----------------------------------------------------------------------------
    mov si, msg         ; {si} recebe endereço da string
    mov cx, pad - msg   ; Contador recebe tamanho da string
    call print_str
; -----------------------------------------------------------------------------
; Parada da CPU...
; -----------------------------------------------------------------------------
halt:
    cli                 ; Limpa a flag de interrupções
    hlt                 ; Para a CPU
; -----------------------------------------------------------------------------
; SUBS
; -----------------------------------------------------------------------------
print_str:
    ;
    ; Imprimir strings em {si} com tamanho em {cx}...
    ;
    pusha
    mov ah, 0x0e        ; Escrever caractere no TTY
.char_loop:
    lodsb               ; Carrega byte corrente em {al} e incrementa o endereço
    int 0x10
    loop .char_loop     ; Repete e decrementa o contador
    popa
    ret
; -----------------------------------------------------------------------------
; DATA
; -----------------------------------------------------------------------------
msg:
    db 'Loading OS...'
pad:
    times 510-($-$$) db 0
sig:
    dw 0xaa55

