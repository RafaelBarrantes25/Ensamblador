%include "io.mac"

.DATA
        pregunta1   db      "Ingrese el primer número: ",0
        pregunta2   db      "Ingrese el segundo número: ",0
        suma        db      "La suma es: ",0
        overf       db      "Error, hubo overflow",0

.UDATA
        número1     resb    1
        número2     resb    1
        resultado   resb    1

.CODE
    .STARTUP
repetición:
    PutStr      pregunta1
    GetLInt     EAX
    PutStr      pregunta2
    GetLInt     EDX
    add         EAX,EDX
    jno correcto
    PutStr      overf
    nwln
    jmp         repetición
correcto:
    PutStr      suma
    PutLInt     EAX
    nwln
    .EXIT
