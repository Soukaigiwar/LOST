%ifndef SAVE_AND_RESTORE_REGISTERS
%define SAVE_AND_RESTORE_REGISTERS
;
; Escrito por Daniel Boll <https://codeberg.org/daniel-boll>
;
%macro save_registers 0-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro restore_registers 0-*
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

%endif ; SAVE_AND_RESTORE_REGISTERS
