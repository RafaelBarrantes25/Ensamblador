%include "io.mac"

TAMAÑO_PALABRA  EQU 10
MÁXIMO_PALABRAS EQU 10
TAMAÑO_TOTAL    EQU 11
.DATA
        pregunta1   db     "Inserte un máximo de 10 palabras de 10 letras cada una",0
        pregunta2   db     "Envíe una palabra vacía para terminar.",0
        errorLargo  db     "La palabra debe medir menos de 10 caracteres",0
.UDATA
        textos      rest   TAMAÑO_PALABRA+1     ;+1 por el \n

.CODE
    .STARTUP     ;Basándome en los códigos de ejemplo de Sivarama, cap. 12 y 13 (página 285 arrays)
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
    mov             ecx,TAMAÑO_TOTAL               
    mov             esi,ebx
limpiar:                                           ;evitar que haya overflow, se limpia lo siguiente antes
    mov             byte [esi],0
    inc             esi
    loop            limpiar
    pop             ecx
    GetStr          ebx
    cmp             byte[ebx],0
    je              ordenar
    mov             eax,11             ;Se le ponen 11 al eax para ver si tiene la palabra 10 dígitos (+ \n)
    jmp             verificar10Dígitos
verificar10Dígitos:
    cmp              eax,0
    je               errorPalabraLarga
    dec              eax
    cmp              byte[ebx],0
    je               repetir10
    inc              ebx
    jmp              verificar10Dígitos


repetir10:
    inc              edx
    loop             pedirPalabras
    jmp              ordenar

    
ordenar:
    
    mov ecx, edx     ;edx lleva la cuenta de las palabras, se pasa a ecx para loop
    sub ebx,ebx      ;índice

imprimir:
    cmp ebx, ecx
    jge fin

    mov eax, ebx
    imul eax, TAMAÑO_TOTAL           ;se multiplica el índice por 11 del tamaño de cada palabra
    lea edi, [textos + eax]     ; dirección palabra[ebx]

    PutLInt [edi]
    nwln
    inc ebx
    jmp imprimir
errorPalabraLarga:
;  mov             byte [ebx + TAMAÑO_PALABRA],0       ;Pone un 0 al final si se pasa del límite, evita overflow
    PutStr          errorLargo
    nwln
    jmp             pedirPalabras
fin:
.EXIT