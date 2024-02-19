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
org 0x7c00
bits 16

main:
	; Iniciar segmento de dados com 0x0...
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax

	; Definir o endereço inicial na pilha...
	mov sp, 0x7c00

	; Impressão da mensagem na tela...
	mov si, hello_msg
	call puts

halt:
	; Parada da CPU...
	hlt
	jmp halt

%define EOL 0x0d, 0x0a
%include "src/lib/stdio/puts.asm"

loading_msg: db 'Loading...', EOL, 0
hello_msg:   db 'Make yourself free to be LOS/T', EOL, 0

times 510-($-$$) db 0
dw 0xaa55

