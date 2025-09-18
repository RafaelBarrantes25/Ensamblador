%include "io.mac"

.DATA
msj_entrada   db  "Inserte 10 números o menos: ",0
msj_fin       db  "Presione 0 para terminar: ",0
msj_suma      db  "La suma es: ",0

.CODE
    .STARTUP
    PutStr   msj_entrada  ; Para que el usuario inserte los números
    mov      ECX,10       ; para un loop de 10
    sub      EAX,EAX      ; la suma es 0

loop_lectura:
    GetLInt  EDX          ; lee la entrada
    cmp      EDX,0        ; revisa si es 0 o no
    je       fin_lectura  ; si es 0, deja de leer
    add      EAX,EDX
    cmp      ECX,1        ; revisa si los números son del input
    je       saltar_msj   ; no muestra msj_fin
    PutStr   msj_fin

saltar_msj:
    loop     loop_lectura

fin_lectura:
    PutStr   msj_suma
    PutLInt  EAX          ; escribe la suma
    nwln
    .EXIT