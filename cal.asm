
addProc macro   buffer            ;Inicia proceso "addProc"
	    print addHeader     ;Invoca al macro "print" y envia como argumento a "addHeader"
	
	   ; call inputNum       ;Llama al proceso "inputNum"     

	    ;//OPERACION DE SUMA
        mov ax,number1      ;Mueve el contenido de number1 a ax
        add ax,number2      ;Suma ax con el contenido de number2
        push ax
        print resultado     ;Invoca al macro "print" y envia como argumento a "resultado"
        pop ax
       ; call intTochar      ;Llama al proceso "intTochar"
        
        print continue      ;Invoca al macro "print" y envia como argumento a "continue"

	    gchar               ;Invoca al macro "gchar"
	    cls                 ;Invoca al macro "cls"
	    ret                 ;Regresa a la etiqueta que lo llamo
endm  
cls 	macro       ;Inicia macro para limpiar pantalla
	    mov	AH,0FH	;Funcion 0F (lee modo de video)
	    int 10H		;de la INT 10H a AH.
	    mov AH,0	;Funcion 0 (selecciona modo de video) de la INT 10H a AH
	    int 10H 	;las 4 instrucciones limpian la pantalla.
        endm        ;Termina macro para limpiar pantalla
print   macro tag	;Inicia macro para imprimir cadena de caracteres en pantalla
	mov	DX,offset tag ;asigna el OFFSET TAG a DX (DS:DX)
	mov	AH,09H  ;Funcion 09 (mensaje en pantalla) de la INT 21H a AH
        int 21H     ;muestra mensaje en pantalla
        endm        ;Termina macro para cadena de caracteres en pantalla

gchar   macro       ;Inicia macro para guardar caracter con eco
	    mov	AH,01H	;Funcion 01 (lee el teclado con eco) de la INT 21H a AH	
	    int	21H     ;guarda caracter ascii leido desde el teclado mostrando eco
        endm        ;Termina macro para guardar caracter con eco


showMenu  macro bufer      ;Inicia macro para guardar caracter con eco
        print mainHeader
        print menu
        ret
        endm        ;Termina macro para guardar caracter con eco

getchar macro       ;Inicia macro para guardar caracter sin eco
	    mov	AH,07H	;Funcion 07 (lee el teclado sin eco) de la INT 21H a AH	
	    int	21h     ;guarda caracter ascii leido desde el teclado sin mostrar eco
        endm        ;Termina macro para guardar caracter sin eco

printchar macro     ;Inicia macro para imprimir un solo caracter en pantalla
	    mov AH,02H  ;Funcion 02 (desplegar dato en pantalla) de la INT 21H a AH
  	    int 21H     ;de la INT 21H a AH
        endm        ;Termina macro para imprimir un solo caracter en pantalla

backspace macro     ;Inicia macro para borrar un caracter
		mov DL,08H  ;Asigna 08H (tecla borrar) a dl
  		printchar   ;Invoca al macro "printchar"
  		mov DL,20H  ;Asgina 20H (tecla espacio) a dl
  		printchar   ;Invoca al macro "printchar"
  		mov DL,08H  ;Asigna 08H (tecla borrar) a dl
  		printchar   ;Invoca al macro "printchar"
        endm        ;Termina macro para borrar un caracter


endl  equ	 10,13  ;Reemplaza todo endl en el codigo por 10,13

.model small    ;Inicio de memoria peque~a
	
.stack          ;Inicia segmento de pila

.data           ;inicia segmento de datos

        mainHeader	db	endl,endl,9,9,'MENU',endl,endl              ;Se define la variable mainHeader
                        db	'Calculadora de +,-,x,',0F6H, endl,endl,'$'
        menu		db	'1. Suma.',endl                             ;Se define la variable menu
                        db	'2. Resta.',endl
                        db	'3. Multiplicacion.',endl
                        db	'4. Division.',endl
                        db	'5. Salir.',endl
                        db	endl,0A8H,'Que operacion desea hacer?: ','$'

        addHeader	db	endl,endl,9,9,'SUMA',endl,endl,'$'          ;Se define la variable addHeader
        subHeader	db	endl,endl,9,9,'RESTA',endl,endl,'$'         ;Se define la variable subHeader
        mulHeader	db	endl,endl,9,9,'MULTIPLICACION',endl,endl,'$';Se define la variable mulHeader
        divHeader	db	endl,endl,9,9,'DIVISION',endl,endl,'$'      ;Se define la variable divHeader

        askNum1	    db	endl,'Deme un numero 1: ','$'               ;Se define la variable askNum1	
        askNum2	    db	endl,'Deme un numero 2: ','$'               ;Se define la variable askNum2
        resultado	db	endl,'Resultado: ','$'                      ;Se define la variable resultado
        outOfRange  db  'Error! Fuera de rango: -99.99 +99.99','$'  ;Se define la variable outOfRange
        noZero      db  'Error! No se permite la division entre 0$' ;Se define la variable noCero
        noNegativ   db  'Error! Falta el signo "-"$'                ;Se define la variable noNegativ
        continue    db  endl,endl                                   ;Se define la variable continue
                db  'Presione "Enter" para volver al menu...$'

        number1     dw  0       ;Se define la variable number1
        number2     dw  0       ;Se define la variable number2
        tenTimes    dw  10      ;Se define la variable tenTimes

    .code               ;Inicia segmento de codigo

main proc      ;Inicia la ejecucion del programa   

	mov	AX,@data    ;Asigna la direccion de DATOS a AX
	mov	DS,AX       ;y atraves de ax asigna la direccion de datos a ds
	cls             ;Invoca al macro "cls"

        callmenu:               ;Etiqueta "callmenu"
                showMenu   ;Llama al proceso "showMenu"
                getchar           ;Invoca al macro "gchar

                cmp	AL,31h      ;Compara si lo que esta en AL es igual a '1'
                jmp	option1  
                        
        option1:                ;Etiqueta "option1"
                cmp	AL,'1'      ;Compara si lo que esta en AL es igual a '1'
                        jne	option2     ;Si no es igual, salta a la etiqueta "option2"
                addProc    ;Si es igual llama al proceso "addProc"
                jmp  callmenu   ;Salta a la etiqueta "callmenu" si no es igual
                                ;a '1','2','3','4','5'.

        option2:                ;Etiqueta "option2"      
                cmp	AL,'2'      ;Compara si lo que esta en AL es igual a '2'
              ;          jne	option3     ;Si no es igual, salta a la etiqueta "option3"
             ;   call  subProc   ;Si es igual llama al proceso "subProc"
                jmp  callmenu   ;Salta a la etiqueta "callmenu" si no es igual
                                ;a '1','2','3','4','5'.
                                        ;a '1','2','3','4','5'.

main endp

end main

 

inputNum proc               ;Inicia proceso "inputNum"
	    print askNum1       ;Invoca al macro "print" y envia como argumento a "askNum1"
        call getdigit       ;Llama al proceso "getdigit"

        call toInt          ;Llama al proceso "toInt"
        mov number1,ax
              
        push bx

	    print askNum2       ;Invoca al macro "print" y envia como argumento a "askNum2"
        call getdigit       ;Llama al proceso "getdigit"
              
        ;JUNTA EL FORMATO DE AMBOSNUMEROS
        pop dx
        cmp bh,dh
        jg  first
        mov bh,dh
first:                      ;Etiqueta "first"
              
        call toInt          ;Llama al proceso "toInt"
        mov number2,ax

	    ret                 ;Regresa a la etiqueta que lo llamo
inputNum endp               ;Termina proceso "inputNum"

toInt proc                  ;Inicia proceso "toInt"
        mov ax,0            ;Limpia ax
        mov dx,0            ;Limpia dx
        mov dl,ch           ;Copia ch a dl
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,ch           ;Copia ch a dl
        shl dl,4            ;Mueve los bits de dl 4 a la izquierda
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,cl           ;Copia cl a dl
        shr dl,4            ;Mueve los bits de fl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,cl           ;Copia cl a dl
        shl dl,4            ;Mueve los bits de dl 4 a la izquierda
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        test bl,1           ;Comprueba bl con 1
        jz toIntEnd         ;Si es zero salta a toIntEnd
        not ax              ;Niega a ax
        add ax,1            ;Suma 1 a ax
tointEnd:                   ;Etiqueta "tointEnd"
    
        ret                 ;Regresa a la etiqueta que lo llamo

toInt endp                  ;Termina proceso "toInt"


intTochar proc              ;Inicia proceso "intTochar"
  
        cmp ax,0            ;Compara con 0 ax,
        jg  noNegat         ;Si es mayor salta a noNegat
        jz  noNegat         ;Si es cero, salta a noNegat
        not ax              ;Complemento de ax
        add ax,1            ;Suma 1 a ax
        push ax             ;Guarda ax en la pila
        mov dl,'-'          ;Mueve el caracter '-' a dl
        printchar           ;Invoca al macro "printchar"
        pop ax              ;Restaura ax
        cmp ax,10000        ;Compara con 10000 (con una resta)
        jl  okRange         ;Si es mayor, el rango esta bien
        backspace           ;Invoca al macro "backspace"
        print outOfRange    ;Invoca al macro "print" y envia como argumento a "outOfRange"
        ret                 ;Regresa al proceso que le llamo

noNegat:                    ;Etiqueta "noNegat"

        cmp ax,10000        ;Compara con 10000
        jl  okRange         ;Si es menor esta en el rango,
        print outOfRange    ;Invoca al macro "print" y envia como argumento a "outOfRange"
        ret                 ;Regresa al proceso que le llamo
        
okRange:                    ;Etiqueta "okRange"

        mov cx,4            ;Mueve 4 a cx
  
convertir:                  ;Etiqueta "convertir" 
        mov dx, 0           ;Limpia dx
        div tenTimes        ;divide ax entre 10
        or dl,030h          ;Convierte dl en ancii agregando 30h 
        push dx             ;Guarda dx
        loop convertir      ;Salta a convertir si cx no es cero
  
        ;Primer caracter puede ser cero , ese no se imprime
        pop dx              ;Restaura el primer caracter
        cmp dl,030h         ;Compara con 30h
        je  cerofirst       ;Si es igual, salta a cerofirst
        printchar           ;Invoca al macro "printchar"

cerofirst:                  ;Etiqueta "cerofirst"
        ;segundo caracter
        pop dx              ;Restura el segundo caracter
        printchar           ;Invoca al macro "printchar"

        mov cl,bh           ;Mueve cl a bh
        test cl,0ffh        ;Comprueba cl con 0ffh
        jz  noDecimal       ;Si es cero no hay decimales
        mov dl,'.'          ;Mueve el caracter '.' a dl
        printchar           ;Invoca al macro "printchar"

decimalPrint:               ;Etiqueta "decimalPrint"
        pop dx              ;Restaura dx
        printchar           ;Invoca al macro "printchar"
        loop  decimalPrint  ;Imprime hasta que cx sea 0
        
noDecimal:                  ;Etiqueta "noDecimal"
        mov cl,2            ;Mueve 2 a cl
        sub cl,bh           ;Resta bh a cl
        test cl,0FFh        ;Comprueba con FFh
        jz nostack          ;Si es cero salta a nostack
          
cleanStack:                 ;Etiqueta "cleanStack"

        pop dx              ;Restaura a dx
        loop cleanStack     ;Salta hasta que cx sea 0
nostack:                    ;Etiqueta "nostack"
        ret                 ;Retorna al proceso que le llamo
intTOchar endp              ;Termina proceso "intTochar"

            

getdigit proc near          ;Inicia proceso "getdigit"
  
        mov bx,0		    ;Limpia bx
        mov cx,0		    ;Limpia cx

initial_state:      	    ;Inicio de la maquina de estado

        getchar			    ;llama a la macro getchar

        cmp al,0Dh		    ;Comprueba 0Dh (tecla enter) con AL
        jne  ne1		    ;si no es igual salta a ne1.
        ret			        ;retorna al procedimiento que le llamo
ne1:
        cmp al,'-'          ;Comprueba '-' con AL, si es igual
        je  negative        ;Marca el numero como negativo
      	
        cmp al,'.'		    ;Comprueba '.' con Al, si es igual
        je  point_jump	    ;espera por un numero para guardarlo como decimal

        ;Comprobacion del caracter ingresado, si es un decimal del 1 al 9
        ;Si al < 31 y al > 39 el caracter no es valido  
        cmp al,'1'		    ;Comprueba '1' con AL, si es mayor
        jl  initial_state 	;Pide de nuevo un caracter
        cmp al,'9'		    ;Comprueba '9' con AL, si es menor
        jg  initial_state 	;Pide de nuevo un caracter

        jmp interger    	;Guarda el digito

interger:		            ;Guarda un digito
        mov dl,al      		;Mueve al a dl para poder imprimir 
        printchar     		;imprime el digito

        ;----GUARDAR ENTERO----------
              	            ;Para dejar espacio en CH
        shl ch,4      		;mueve 4 bits a la izquierda.
        sub al,30h      	;convierte a bcd desempaquetado
        add ch,al       	;Mueve el AL a CH
        ;----------------------------

        test ch,0F0h		;AND con el nibble izquierdo de ch
        jz  interger_get	;si es cero, estamos guardando el digito 1.
              			    ;Si no es cero, guardamos el segundo decimal
        jmp point		    ;e imprime el punto y espera al primer decimal.

interger_get:			    ;Pedir siguiente digito  
        getchar			    ;Llama a la macro getchar
                         
        cmp al,0Dh		    ;Compara 0Dh con al, si no es igual
        jne  ne3		    ;salta a ne3
        ret			        ;Retorna al proceso que lo llamo
ne3:
        cmp al,08h      	;Compeuba al con la tecla de retroseso
        je  interger_return ;Si es igual, elimina el entero anterior
    
        cmp al,'.'	      	;Comprueba '.' con AL, si es igual
        je  point       	;y va al estado del punto decimal
    
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30 y al > 39 el caracter no es valido  
        cmp al,'0'		    ;Compara '0' con AL, si es menor
        jl  interger_get  	;Pide de nuevo un caracter.
        cmp al,'9'		    ;Compara '9' con AL, si es mayor
        jg  interger_get  	;Pide de nuevo un caracter.
            			    ;Si esta dentro del rango
        jmp interger    	;guarda el digito.

interger_return:    		;Elimina el entero anterior
        backspace     		;Elimina el caracter de la consola
        
        ;-----ELIMINAR ENTERO---------
        shr ch,4    ;limpia el nibble derecho de cl
        	        ;desplazando a la derecha 4 bites
        ;-----------------------------

        ;DEBE DE REGRESAR A UN ESTADO DEPENDIENDO DE LAS SIGUIENTES CONDICIONES
        test ch,00Fh    	;Compara el nibble derecho
        jnz interger_get  	;Si no es cero, significa que es el segundo entero.
              			
		;Si es cero, se ha borrado el primer entero.
        test bl,1     		;Comprueba si hay marca de numero negativo 
        jnz negative_get    ;pide siguiente caracter despues del negativo
        jmp initial_state 	;Si bl=0, no se ha introducido el negativo y regresa al estado inicial

point_jump:			        ;Salto necesario por el alcance corto
        jmp point		    ;de las etiquetas.

negative:       		    ;marcar un numero como negativo  
        mov dl,al           ;Mueve a dl el caracter a imprimir
        printchar     	    ;Imprime el caracter '-'
    
        mov bl,1      	    ;Marca la existencia de signo menos con BL=1
negative_get:     		    ;Obtener el siguiente caracter
  
        getchar			    ;Pedir un caracter desde consoloa

        cmp al,0Dh		    ;Comparar 0Dh con al, si no es igual
        jne  ne2		    ;Salta a ne2
        ret			        ;Regresa a el procedimiento que le llamo
ne2:
        cmp al,08h      	;Comprueba si se presiono la tecla return
        je  negative_return ;Elimina la marca de negativo
    
        cmp al,'.'		    ;Compara al con '.', si es igual
        je point		    ;Imprime el punto y espera al siguiente caracter

        ;Comprobacion del caracter ingresado, si es un decimal del 1 al 9
        ;Si al < 31 y al > 39 el caracter no es valido  
        cmp al,'1'		    ;Compara '1' con al, si es menor
        jl  negative_get    ;Pide de nuevo un caracter
        cmp al,'9'		    ;Compara '9' con AL, so es mayor
        jg  negative_get  	;Pide de nuevo un caracter
            			    ;Si esta dentro del rango
        jmp interger    	;Guardar el digito

negative_return:    		;Elimina la marca de negativo
        backspace     		;remueve el caracter '-' de la consola
        mov bl,0      		;remueve la existencia de signo menos con bl=0
        jmp initial_state 	;retorna al estado inicial

point:          		    ;Imprime un punto y espera a un caracter
        mov dl,'.'     	    ;Mueve '.' en dl 
        printchar     	    ;imprime el punto decimal

point_get:        		    ;Pedir siguiente caracter
        getchar			    ;Pide un caracter en consola

        cmp al,0Dh		    ;Compara 0Dh con al, si no es igual
        jne  ne4		    ;Salta a ne4
        ret			        ;Retorna al procedimiento que le llamo
ne4:
        cmp al,08h      	;Comprobar si se presiono la tecla de retroceso
        je  point_return  	;Elimina el punto decimal de la consola
        
	    ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30  y al > 39 el caracter no es valido  
        cmp al,'0'		    ;Compara '0' con al, si es menor
        jl  point_get     	;Pide de nuevo un caracter
        cmp al,'9'		    ;Compara '9' con al, si es mayor
        jg  point_get     	;Pide de nuevo un caracter
  		                    ;Si esta dentro del rango
        jmp decimal   		;Guardar el primer decimal

point_return:       		;Elimina el punto de la consola
        
        backspace		    ;Eliminar el punto decimal
        ;SALTA A UN ESTADO ANTERIOR DEPENDIENDO DE LAS SIGUIENTES CONDICIONES     
        ;Si ch=0, Se introdujo el punto desde el principio
        ;consola -> [.]  o [-.]
        test ch,0FFh     	;Compara ch con FF
        jnz to_interger     ;Si ch es 0, Salta al inicio o salta a la marca de negativo
        test bl,1       	;Verifica si hay marca de negativo
        jnz negative_get    ;Si hay marca regresa a pedir un caracter despues del negativo
        jmp initial_state   ;Si no hay marca regresa al estado inicial

        ;Si no es cero, se introdujo uno o dos enteros consola
	    ;-> [12.] 0 [-12.] 0 [1.] o [-1.]
to_interger:
        jmp interger_return ;Elimina el ultimo entero

decimal:
 	      			        ;Imprime el digito que se va a guardar
        mov dl,al       	;Mueve al a dl para poder imprimir 
        printchar     		;imprime el digito

        ;----STORE Cl Decimal 1-------
        sub al,30h      	;convierte a bcd desempaquetado
        add cl,al       	;Mueve decimal a ch
        shl cl,4      		;Mueve a su posicion al decimal
        add bh,1      		;marca que el formato debe tener solo un decimal
        ;----------------------------
decimal_get:
    
        getchar			    ;Pide un caracter

        cmp al,0Dh		    ;Compara 0D con al
        jne  ne5		    ;Si no es igual, salta ne5
        ret			        ;Retorna a el procedimiento que le llamo
ne5:
        cmp al,08h     		;Comprobar si se presiono la tecla de retroseso
        je  decimal_return  ;Elimina un decimal.
    
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30  y al > 39 el caracter no es valido  
        cmp al,'0'		    ;Compara '0' con al, si es menor
        jl  decimal_get   	;Pide de nuevo un caracter.
        cmp al,'9'		    ;Compara '9' con al, si es mayor
        jg  decimal_get   	;Pide de nuevo un caracter.
        ;Si esta dentro del rango
        jmp decimal_2     	;Guardar el decimal 2 
decimal_return:   
        backspace     		;Elimina el caracter de la consola
        ;-----UNSTORE DIGIT-----
        shl cl,4      		;limpia cl desplazando a la derecha los ultimos 4 bites
        sub bh,1      		;desmarca el primer decimal para el formato
        ;-----------------------------
        jmp point_get
decimal_2:

        ;Imprime el digito que se va a guardar
        mov dl,al       	;Mueve al a dl para poder imprimir 
        printchar     		;imprime el digito

        ;----STORE Cl Decimal 2-------
        sub al,30h		    ;convierte a bcd desempaquetado
        add cl,al           ;Mueve decimal a ch
        add bh,1            ;Marca el segundo decimal para el formato
        ;----------------------------
decimal_2_get:
    
        getchar			    ;Pide un nuevo caracter

        cmp al,0Dh		    ;Compara 0Dh con Al, si no es igual
        jne  ne6		    ;Salta a ne6
        ret			        ;Regrea al procedimiento que le llamo
ne6:
        cmp al,08h	      	;Comprobar si se presiono la tecla de retroceso
        je  decimal_2_return;Elimina el decimal
        
	jmp decimal_2_get   	;Si no es enter o return pide de nuevo  
decimal_2_return:   

        backspace     		;Elimina el caracter de la consola
        
        ;-----UNSTORE DECIMAL 2-----
        shr cl,4     		;limpia cl desplazando a la derecha los ultimos 4 bites
        shl cl,4      		;limpia cl desplazando a la derecha los ultimos 4 bites
        sub bh,1      		;Desmarca el segundo decimal para el formato
        ;-----------------------------
    
        jmp decimal_get		;Salta a pedir el segundo decimal

getdigit endp       ;Termina proceso "getdigit"



end