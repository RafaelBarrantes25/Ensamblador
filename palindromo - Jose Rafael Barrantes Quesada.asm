;Palíndromo
;Pide un input al usuario y verifica si es palíndromo
;
;ITCR Cartago  -  Escuela de Ingeniería en Computación
;IC-3101 Arquitectura de Computadoras
;Tarea 3  -  18 de Octubre del 2025  -  Segundo semestre del 2025
;Jose Rafael Barrantes Quesada 2025122443
;Profesor Esteban Arias Méndez
%include "io.mac"

.DATA
        pregunta     db      "Ingrese caracteres, máximo 200. Presione enter al terminar: ",0
        vacío        db      "No ingresó texto.",0
        síPalíndromo db      "El texto sí es un palíndromo",0
        noPalíndromo db      "El texto no es un palíndromo",0
.UDATA
        textoDelUsuario     resb    200
        textoInvertido      resb    200
        
.CODE
.STARTUP
        PutStr      pregunta
        GetStr      textoDelUsuario
        mov   esi,  textoDelUsuario
        mov   edi,  textoInvertido
        mov   ecx,  0
        mov   edx,  0
contar_caracteres:
        cmp   byte [esi], 0              ;Revisa si termina el string al comparar con 0
        je    revisiónVacío
        inc   ecx                        ;Incrementa ecx para que contenga el número de caracteres para el loop
        inc   esi                        ;esi apunta al byte nulo al final
        jmp   contar_caracteres
revisiónVacío:                           ;Caso especial por si no se ingresa texto
        cmp   ecx,0                      ;Si el cx es 0, es que no ingresó texto
        je    noTexto
        mov   ebx, ecx                   ;Guarda largo del texto para el loop de comparación de strings
        dec   esi                        ;Se le resta 1 a esi para que apunte al último caracter, no al nulo
        jmp   convMinus

convMinus:
        mov   al, byte [esi]             ;Mueve la primera letra del textoDelUsuario al al
        cmp   al, 'A'                    ;Si es menor a A, no es mayúscula
        jl    invertir
        cmp   al, 'Z'                    ;Si es mayor a Z, no es mayúscula
        jg    invertir
        add   al,32                      ;Si sí es mayúscula, añade 32, que es la diferencia para minúscula
        add   byte [esi], 32             ;Modifica el texto original para la comparación al final
invertir:
        mov   byte [edi], al             ;Mete la última letra en el texto invertido
        dec   esi                        ;Disminuye el puntero original a la letra anterior
        inc   edi                        ;Aumenta el puntero del invertido al sigueinte byte
        loop  convMinus                  ;Loop según el ecx para el número de letras
        jmp   finalizarString
noTexto:                                 ;Si no ingresa texto, se acaba
        PutStr vacío                     ;Mensaje por si no inserta nada
        jmp    final                     ;Se acaba
finalizarString:
        mov   byte [edi],0               ;Se pone un 0 al final del string, para que no dé error
        mov   ecx, ebx                   ;Se ajusta el ecx para el loop de comparar
        mov   edi, textoDelUsuario       ;Se ponen los punteros, uno en cada
        mov   esi, textoInvertido        ;Texto para compararlos
compararStrings:
        mov   al, byte [esi]             ;Mueve el primer caracter del texto invertido a AL
        cmp   byte [edi], al             ;Compara los primeros caracteres de los textos
        jne   negativo                   ;Si es distinto, no es palíndromo
        inc   edi                        ;Aumentan registros al
        inc   esi                        ;Siguiente caracter
        loop  compararStrings            ;Se loopea por todos los caracteres
        jmp   positivo                   ;Si llega al final es que sí es palíndromo
positivo:
        PutStr   síPalíndromo
        jmp      final
negativo:
        PutStr   noPalíndromo
        jmp      final
final:
.EXIT
