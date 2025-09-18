%include "io.mac"

.DATA
en_número       db  "Escriba un número de menos de 11 dígitos: ",0
msj_salida      db  "La suma de los dígitos individuales es: ",0

.UDATA
número       resb  11

.CODE
    .STARTUP
    PutStr en_número         ; pide el input
    GetStr número,11         ; lee el número como string

    mov         EBX,número   ; EBX es puntero al número
    sub         DX,DX        ; DX es 0 entonces la suma se guarda en DL
añadir_repetir:
    mov         AL,[EBX]     ; mueve número a AL
    cmp         AL,0         ; revisa si es nulo
    je          fin          ; se termina la suma
    and         AL,0FH       ; los últimos 4 dígitos
    add         DL,AL        ; añade el dígito a la suma
    inc         EBX          ; mueve el puntero
    jmp         añadir_repetir

fin:
    PutStr      msj_salida
    PutInt      DX
    nwln
    .EXIT
    
    
