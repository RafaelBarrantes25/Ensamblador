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
        PutStr vacío
        jmp    final
finalizarString:
        mov   byte [edi],0
        mov   ecx, ebx
        mov   edi, textoDelUsuario
        mov   esi, textoInvertido
compararStrings:
        mov   al, byte [esi]
        cmp   byte [edi], al
        jne   negativo
        inc   edi
        inc   esi
        loop  compararStrings
        jmp   positivo
positivo:
        PutStr   síPalíndromo
        jmp      final
negativo:
        PutStr   noPalíndromo
        jmp      final
final:
.EXIT
