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
org 0x7c00		; Onde o BIOS carregará o nosso boot na memória:
			;
			; - Mesmo que usemos outro endereço, o BIOS carregará
			;   o código em 0X7c00.
			;
			; Diretiva ORG:
			;
			; - Diz ao montador onde queremos que o código deverá
			;   ser carregado no endereço 0x7c00.
			; - O montador usa este endereço como referência para
			;   calcular os endereços dos rótulos.
;; ----------------------------------------------------------------------------
bits 16			; Produzir código em 16 bits.
			;
			; Diretiva BITS:
			; 
			; Orienta o montador a produzir código em 16/32/64 bits.
;; ----------------------------------------------------------------------------
main:			; Apenas uma referência para o início do código.
;; ----------------------------------------------------------------------------
	hlt		; Instrução HLT (halt):
			; 
			; - Manda a CPU pausar execução.
			; - A execução pode continuar com uma 'interrupção'.
;; ----------------------------------------------------------------------------
	jmp	$	; Salte para cá (loop infinito):
			;
			; - O salto é feito incondicionalmente para o endereço
			;   da própria linha da instrução corrente ($).
			; - Se a CPU continuar a execução, ficará presa neste
			;   loop infinito.
;; ----------------------------------------------------------------------------
times 510-($-$$) db 0	; Preenche com zeros o restante do binário até
                        ; totalizar 510 bytes:
			;
			; - O tamanho total do binário deve ser de 512 bytes.
			; - Os 2 bytes restantes serão da assinatura de boot.
			;
			; Símbolo $:
			;   Representa o endereço relativo da linha corrente
			;   na memória
			; 
			; Símbolo $$:
			;   Representa o endereço relativo do início do
			;   código na memória.
;; ----------------------------------------------------------------------------
dw 0xaa55		; Escreve a palavra 0xaa55 (assinatura de boot).
;; ----------------------------------------------------------------------------
