%include "io.mac"

.DATA
            mensaje1     db    "Ingrese una cadena de caracteres",0
            mayúscula    db    "¿Quiere que se ignoren mayúsculas? Si sí, ingrese un 1.",0
            mensaje2     db    "Las veces que aparecieron los caracteres fueron: ",0
            dosPuntos    db    ": ",0
            espacioTexto db    "Espacio",0
            tabTexto     db    "Tab",0
            
.UDATA
            texto             resb  32
            tablaContadores   resb 256         ;Los 256 valores de utf-8



.CODE
.STARTUP
            PutStr      mensaje1
            nwln
            GetStr      texto
            PutStr      mayúscula
            GetLInt     eax
            cmp         al,1                   ;Si pone un 1 es que quiere que se ignoren mayúsculas
            je          preConvertir
            jmp         preContar

preConvertir:
            mov         ebx,texto
convertir:
            mov         al, [ebx]       ;mueve el caracter a AL
            cmp         al,0            ;revisa si es nulo
            je          preContar       ;cuando termina
            cmp         al,'a'          ;si es menor que a
            jl          noMinúscula    ;es que no es minúscula
            cmp         AL,'z'          ;si el caracter es mmayor que z
            jg          noMinúscula    ;tampoco es minúscula
minúscula:
            add         AL, 'A'-'a'     ;convierte a mayúscula
            mov         [ebx],al        ;Se mueve el valor 
            inc         ebx
            jmp         convertir
noMinúscula:
            inc         ebx
            jmp         convertir       ;procesa el siguiente

preContar:
            mov         esi,texto              ;Inicio de lo que se insertó
            mov         ebx,tablaContadores    ;puntero a los 256 bytes
contar:
            mov         al, [esi]              ;Se mueve el primer caracter a al
            cmp         al,0                   ;Si es 0 es porque se terminó
            je          contado                ;termina conteo
            movzx       ecx,al                 ;eax tiene el primer caracter
            inc         byte[ebx+ecx]          ;el ebx tiene dirección a la tabla, ecx tiene el caracter, esto suma 1 al contador de dicho caracter en la tabla

            inc         esi                    ;Se mueve al segundo caracter ingresado
            jmp         contar                 ;Hasta leer y sumar todos
contado:
            mov         edi,tablaContadores    ;apuntador
            mov         ecx,0                  ;se va a usar como índice
            PutStr      mensaje2
            nwln
imprimir:
            cmp         ecx,256                ;Si es 256 es que leyó toda la tabla
            je          final
            mov         edi,tablaContadores    ;se pone el puntero en la tabla
            add         edi,ecx                ;se le añade el caracter actual
            mov         al,[edi]               ;se mete el número de veces que aparece el caracter en el al
            cmp         al,0                   ;Se revisa si tiene más de 0 apariciones
            je          ignorar                ;si el caracter no aparece, no se imprime
            movzx       eax,al
            cmp         ecx,32                  ;Por si se ingresa un espacio
            je          espacio
            cmp         ecx,9                   ;Por si se ingresa un tab
            je          tab
            PutCh       cl                     ;imprime el caracter
            PutStr      dosPuntos
            PutLInt     eax
            nwln
ignorar:
            inc ecx
            jmp imprimir
espacio:
            PutStr      espacioTexto           ;Si hay un espacio, se imprime la palabra
            PutStr      dosPuntos
            PutLInt     eax
            nwln
            inc         ecx
            jmp         imprimir
tab:
            PutStr      tabTexto                ;si hay un tab, se imprime la palabra
            PutStr      dosPuntos
            PutLInt     eax
            nwln
            inc         ecx
            jmp         imprimir
final:
.EXIT