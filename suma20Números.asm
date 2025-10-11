%include "io.mac"

.DATA
        pregunta     db     "Ingrese números, presione enter después de cada uno",0
        pregunta2    db     "Ingrese el siguiente número o ingrese un 0 para detener",0
        numLeídos    db     "Los números ingresados son: ",0
        sumaTotal    db     "La suma de los números ingresados es: ",0
        overflowSí   db     "Sí hubo overflow",0
        overflowNo   db     "No hubo overflow",0
.UDATA
        números      resd    20
        resultado    resd    20

.CODE
.STARTUP
        sub          eax,eax
        sub          ecx,ecx
        PutStr       pregunta
        nwln
        mov          ecx,20
        mov          esi,números
        sub          ebx,ebx
pedirNúmeros:
        GetLInt      eax
        inc          ebx
        cmp          eax,0
        je           detenidoCero
        mov          [esi],eax
        add          esi,4
        sub          eax,eax
        PutStr       pregunta2
        nwln
        loop         pedirNúmeros
        jmp          impMens
detenidoCero:
        PutStr       numLeídos
        nwln
        mov          esi,números
        mov          ecx,ebx
        sub          eax,eax
        sub          ecx,1
        jmp          imprimirNúmeros
impMens:
        PutStr       numLeídos
        nwln
        mov          esi,números
        mov          ecx,ebx
        sub          eax,eax
        jmp          imprimirNúmeros
imprimirNúmeros:
        PutLInt      [esi]
        nwln
        add           eax,[esi]
        add           esi,4
        loop imprimirNúmeros
        PutStr        sumaTotal
        PutLInt       eax
.EXIT