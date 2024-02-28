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
print_str:
    mov ah, 0x0e        ; Escrever caractere no TTY
    mov cx, pad - msg   ; Contador recebe tamanho da string
    mov si, msg         ; {si} recebe endereço da string
.char_loop:
    lodsb               ; Carrega byte corrente em {al} e incrementa o endereço
    int 0x10
    loop .char_loop     ; Repete e decrementa o contador
; -----------------------------------------------------------------------------
; Parada da CPU...
; -----------------------------------------------------------------------------
halt:
    cli                 ; Limpa a flag de interrupções
    hlt                 ; Para a CPU
; -----------------------------------------------------------------------------
; DATA
; -----------------------------------------------------------------------------
msg:
    db 'Loading OS...'

pad:
    times 510-($-$$) db 0

sig:
    dw 0xaa55

