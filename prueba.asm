%include "io.mac"

TAMAÑO_PALABRA  EQU 10
MÁXIMO_PALABRAS EQU 10
TAMAÑO_TOTAL    EQU 11
ORDENADO        EQU 0
DESORDENADO     EQU 1

.DATA
        pregunta1   db     "Inserte un máximo de 10 palabras de 10 letras cada una",0
        pregunta2   db     "Envíe una palabra vacía para terminar.",0
        errorLargo  db     "La palabra debe medir menos de 10 caracteres",0
.UDATA
        textos      rest   TAMAÑO_PALABRA+1         ;+1 por el \n

.CODE
    .STARTUP                                        ;Basándome en los códigos de ejemplo de Sivarama, cap. 12 y 13 (página 285 arrays)
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
    je              ordenar                        ;Si sí, se va a convertir todo en minúsculas
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
    jmp              ordenar                       ;Al terminar el loop, continúa con la siguiente parte
errorPalabraLarga:
;  mov             byte [ebx + TAMAÑO_PALABRA],0   ;Pone un 0 al final si se pasa del límite, evita overflow
    PutStr          errorLargo
    nwln
    jmp             pedirPalabras

ordenar:
    
    mov ecx,edx                                     ;edx lleva la cuenta de las palabras, se pasa a ecx para loop
    sub ebx,ebx      ;índice
    jmp convMinus
convMinus:
    mov      ecx,110
    mov      esi,textos
convMinus2:
    cmp ecx,0
    je imprimir1
    mov      al,[esi]
    cmp   al,0
    je mantener
    cmp   al, 'A'
    jl    mantener
    cmp   al, 'Z' 
    jg    mantener
    add   byte [esi], 32

mantener:
    inc   esi
    dec ecx
    jmp convMinus2



imprimir1:
    mov ecx,edx     ;edx lleva la cuenta de las palabras, se pasa a ecx para loop
    sub ebx,ebx      ;índice
imprimir:

    cmp ebx, ecx
    jge fin

    mov eax, ebx
    imul eax, TAMAÑO_TOTAL           ;se multiplica el índice por 11 del tamaño de cada palabra
    lea edi, [textos + eax]     ; dirección palabra[ebx]

    PutStr edi
    nwln
    inc ebx
    jmp imprimir

fin:
.EXIT