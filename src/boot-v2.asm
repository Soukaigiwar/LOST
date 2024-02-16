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
;; BOOT
;; ----------------------------------------------------------------------------
org 0x7c00
bits 16

%define EOL 0x0d, 0x0a

start:
	jmp	main

put_string:
	push	si			; Salvar registradores que serão alterados...
	push	ax			;
	.until_null:			; Loop através dos bytes da string.
		lodsb			; Copia o caractere seguinte em {al}.
		or	al, al		; Verifica se o byte em {al} é nulo (0x0).
		jz	.done

		mov	ah, 0x0e	; Chama a função 0x0e da interrupção 0x10:
					; imprimir caracteres no modo TTY. 
		mov	bh, 0		; Página do modo texto: 0
		int	0x10		; Interrupção 0x10 do BIOS: funções de vídeo.

		jmp	.until_null	; Continua o loop se não for um caractere nulo.
	.done:
	pop	ax			; Restaurar registradores que foram alterados...
	pop	si			;
	ret				; Retorna à linha seguinte à chamada.

main:
	; Configurar segmento de dados...
	mov	ax, 0
	mov	ds, ax
	mov	es, ax

	; Configurar a pilha...
	mov	ss, ax
	mov	sp, 0x7c00

	; Impressão da mensagem na tela...
	mov	si, str
	call	put_string

	; Parada da CPU...
	hlt
	jmp	$

str:	db	EOL, 'LOS/T', EOL, 'Type Ctrl+Alt+Q do quit QEMU...', EOL, 0

times 510-($-$$) db 0
dw 0xaa55

