%include "io.mac"

.DATA
        pregunta     db     "Ingrese números, presione enter después de cada uno",0
        pregunta2    db     "Ingrese el siguiente número o ingrese un 0 para detener",0
        numLeídos    db     "Los números ingresados son: ",0
        sumaTotal    db     "La suma de los números ingresados es: ",0
        overflowSí   db     "Hubo overflow.",0
.UDATA
        números      resd    20
        resultado    resd    20

.CODE
.STARTUP
        sub          eax,eax     ;se limpian registros por si acaso
        sub          ecx,ecx
        sub          ebx,ebx
        PutStr       pregunta
        nwln
        mov          ecx,20       ;Se pone 20 en el ecx para el loop de 20 números
        mov          esi,números  ;Se pone el puntero al inicio del arreglo para después

pedirNúmeros:
        GetLInt      eax          ;Almacena el número en el eax
        inc          ebx          ;Actúa como contador de números ingresados
        cmp          eax,0        ;Si es 0, es que el usuario quiere detener
        je           detenidoCero
        mov          [esi],eax    ;Almacena el número ingresado en números
        add          esi,4        ;Continúa al siguiente espacio de memoria
        sub          eax,eax      ;Se limpia el registro eax para que almacene el siguienete número
        PutStr       pregunta2
        nwln
        loop         pedirNúmeros ;Continúa hasta que se ponga un 0 o que haya insertado 20 números
        jmp          impMens
detenidoCero:
        PutStr       numLeídos
        nwln
        mov          esi,números  ;Acomoda el puntero para que imprima los números ingresados
        mov          ecx,ebx      ;ebx almacena cuántos números ingresó el usuario, se mueve al ecx para el loop
        sub          eax,eax      ;Se limpia
        sub          ecx,1        ;como el último número que ingresó el usuario es un 0, se omite
        jmp          imprimirNúmeros
impMens:
        PutStr       numLeídos
        nwln
        mov          esi,números  ;Se acomoda el puntero
        mov          ecx,ebx      ;Se mueve la cantidad de números ingresados al ecx
        sub          eax,eax      ;Limpia el registro para usarlo al imprimir
        jmp          imprimirNúmeros
imprimirNúmeros:
        PutLInt      [esi]        ;muestra el primer número
        nwln
        add           eax,[esi]   ;Se suma para mostrar el total
        jo            overflow
        add           esi,4       ;Se mueve al siguiente número
        jo            overflow
        loop          imprimirNúmeros
        PutStr        sumaTotal
        PutLInt       eax         ;Imprime la suma
        jmp fin
overflow:
        PutStr        overflow
fin:

.EXIT