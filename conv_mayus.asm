%include "io.mac"

.DATA
nombre      db "Escriba su nombre: ",0
salida      db "Su nombre en mayúsculas es: ",0

.UDATA
en_nombre   resb  31 ; reserva memoria

.CODE
    .STARTUP
    PutStr  nombre          ; pide el nombre
    GetStr  en_nombre,31    ; lee el nombre

    PutStr  salida
    mov     EBX,en_nombre   ; EBX es un puntero a en_nombre
proceso_car:
    mov     AL, [EBX]       ; mueve el caracter a AL
    cmp     AL,0            ; revisa si es nulo
    je      listo           ; cuando termina
    cmp     AL,'a'          ; si es menor que a
    jl      no_minúscula    ; si no es minúscula
    cmp     AL,'z'          ; si el caracter es mmayor que z
    jg      no_minúscula    ; no es minúscula

minúscula:
    add     AL, 'A'-'a'     ; convierte a mayúscula
no_minúscula:
    PutCh   AL              ; escribe el caracter
    inc     EBX             ; puntero al siguiente
    jmp     proceso_car     ; procesa el siguiente

listo:
    nwln
    .EXIT
    
    
