;Ordenar alfabéticamente
;Función: Pide 10 palabras al usuario y las ordena alfabéticamente
;
;ITCR Cartago  -  Escuela de Ingeniería en Computación
;IC-3101 Arquitectura de Computadoras
;Tarea 3  -  18 de Octubre del 2025  -  Segundo semestre del 2025
;Jose Rafael Barrantes Quesada 2025122443
;Profesor Esteban Arias Méndez

%include "io.mac"

TAMAÑO_PALABRA  EQU 10
MÁXIMO_PALABRAS EQU 10
TAMAÑO_TOTAL    EQU 11
ORDENADO        EQU 0
DESORDENADO     EQU 1

.DATA
        pregunta1   db     "Inserte un máximo de 10 palabras de 10 letras cada una",0
        pregunta2   db     "Envíe una palabra vacía para terminar.",0
        errorLargo  db     "La palabra debe medir un máximo de 10 caracteres",0
        separador   db     "----------------------------------------------------",0
.UDATA
        textos      rest   TAMAÑO_TOTAL*MÁXIMO_PALABRAS         ;+1 por el \n

.CODE
    .STARTUP
    PutStr          pregunta1
    nwln
    PutStr          pregunta2
    nwln
    mov             ecx,MÁXIMO_PALABRAS            ;Para pedir 10 palabras
    sub             edx,edx                        ;Se usa como índice
    
pedirPalabras:
    mov             eax,edx
    imul            eax,TAMAÑO_TOTAL               ;Multiplica para guardar posiciones, tuve que buscar porque no me dejaba hacer como mov eax,[edx*TAMAÑO_TOTAL] porque no es múltiplo de 2
    lea             ebx, [textos+eax]              ;Cada iteración suma 11, 0-11-22-33... a la posición en textos
    push            ecx                            ;se almacena porque se va a necesitar después
    mov             ecx,TAMAÑO_TOTAL               ;Para el contador de loops
    mov             esi,ebx                        ;Acomoda el puntero esi al inicio de la palabra
limpiar:                                           ;evitar que haya overflow, se limpia lo siguiente antes
    mov             byte [esi],0                   ;pone un 0 en todos los espacios,
    inc             esi                            ;Va pasando espacio por espacio de la siguiete palaabra
    loop            limpiar
    pop             ecx                            ;Se vuelve el ecx para usarlo en el loop de pedir palabras
    GetStr          ebx                            ;pide la palabra
    cmp             byte[ebx],0                    ;Revisa si la palabra está vacía
    je              preComparar                        ;Si sí, se va a convertir todo en minúsculas
    mov             eax,11                         ;Se le ponen 11 al eax para ver si tiene la palabra 10 dígitos (+ \n)
    jmp             verificar10Dígitos
verificar10Dígitos:                                ;Revisa que la palabra tenga 10 dígitos o menos
    cmp              eax,0                         ;Si el eax llega a 0 es porque mide más de 10
    je               errorPalabraLarga
    dec              eax
    cmp              byte[ebx],0                   ;Significa que es menor que 0, entonces continúa
    je               repetir10
    inc              ebx                           ;Va pasando letra por letra
    jmp              verificar10Dígitos
repetir10:
    inc              edx                           ;Va a la siguiente palabra
    loop             pedirPalabras
    jmp              preComparar                      ;Al terminar el loop, continúa con la siguiente parte
errorPalabraLarga:
;  mov             byte [ebx + TAMAÑO_PALABRA],0   ;Pone un 0 al final si se pasa del límite, evita overflow
    PutStr          errorLargo
    nwln
    jmp             pedirPalabras

preComparar:
    push            edx
    mov             ecx,edx                         ;largo
ordenarLoop:
    dec             ecx
    jz              ordenar                         ;si terminó

    push            ecx
    push            edx
    mov             esi,textos                      ;Se acomodan los punteros
    mov             edi,textos
    add             edi,TAMAÑO_TOTAL

    mov             ecx,edx
    dec             ecx
comparar:
    cmp             ecx,0                            ;terminó la pasada
    je              comparar2

compararTodasLetras:
    mov             al,byte[esi]                     ;Se ponen las letras iniciales en al y bl y se comparan
    mov             bl,byte[edi]
    cmp             al,0                             ;Si son iguales y la primera palabra mide menos, no se intercambian
    je              siguientePar
    cmp             bl,0                             ;Caso contrario, si son iguales y bl es menor, se intercambian
    je              siguientePar
    cmp             al,bl
    je              siguienteCaracter
    cmp             al,bl
    jg              intercambiar                     ;si al es mayor es que hay que cambiarlos
    jmp             siguientePar
siguienteCaracter:                                   ;Si la primera es igual, compara la segunda y así
    inc             esi
    inc             edi
    jmp             compararTodasLetras
intercambiar:
    push            ecx
    push            esi
    push            edi
    mov             ecx,TAMAÑO_TOTAL
loopIntercambiar:

    mov             al,byte[esi]                      ;Intercambia las letras entre sí
    mov             bl,byte[edi]
    mov             byte[esi],bl
    mov             byte[edi],al
    inc             esi
    inc             edi
    loop            loopIntercambiar
    pop             edi
    pop             esi
    pop             ecx
siguientePar:                                          ;Avanza a las siguientes dos palabras y compara
    add             esi,TAMAÑO_TOTAL
    add             edi,TAMAÑO_TOTAL
    dec             ecx
    jmp             comparar
comparar2:
    pop             edx                                 ;Hace otra pasada en la comparación
    pop             ecx
    jmp             ordenarLoop


ordenar:
    mov            ecx,edx                                     ;edx lleva la cuenta de las palabras, se pasa a ecx para loop
    sub            ebx,ebx                                     ;índice
    jmp            convMinus

convMinus:                                                     ;convierte a minúscula, si es mayúscula, le suma 32 por utf8
    mov            ecx,110
    mov            esi,textos
convMinus2:
    cmp            ecx,0                                        ;si es 0 es que terminó
    je             imprimir1
    mov            al,[esi]                                     ;se mueve la primera letra a al para comparar
    cmp            al,0
    je             mantener                                     ;Revisa si es 0 o minúscula, entonces se mantiene si sí, sino
    cmp            al, 'A'                                      ;Se pasa a minúscula
    jl             mantener
    cmp            al, 'Z'
    jg             mantener
    add            byte [esi], 32                               ;32 es diferencia en utf8 entre mayúsculas y minúsculas

mantener:
    inc            esi                                          ;pasa a siguiente letra sin hacer nada
    dec            ecx
    jmp            convMinus2
imprimir1:
    mov            ecx,edx                                      ;edx lleva la cuenta de las palabras, se pasa a ecx para loop
    sub            ebx,ebx                                      ;índice
    PutStr         separador
    nwln
    nwln
imprimir:

    cmp            ebx, ecx
    jge fin

    mov eax, ebx
    imul eax, TAMAÑO_TOTAL                                      ;se multiplica el índice por 11 del tamaño de cada palabra
    lea edi, [textos + eax]                                     ;ebx se usa como índice, entonces se multiplica cada vez por 11
                                                                ;Para ir a la siguiente palabra
    PutStr edi
    nwln
    
    inc ebx
    jmp imprimir

fin:
.EXIT