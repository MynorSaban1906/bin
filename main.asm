;*******************************************************
;       	MACRO SEGMENT
;*******************************************************

INCLUDE ctrl.asm
INCLUDE file.asm
include anali.asm
INCLUDE view.asm

include ope.asm

;*******************************************************
;          END MACRO SEGMENT
;*******************************************************

  
;*******************************************************
;       	STACK SEGMENT
;*******************************************************
.model small
.STACK  


sdatos segment 
	numStr db "52","$"
    order db "Ordenamiento : ","$"
    timer db "Tiempo : ","$"
    velocity db "Velocidad : ","$"
sdatos ends
;*******************************************************
;           END STACK SEGMENT
;*******************************************************
;Iniciar el modo video con la fucion 13h y cambiar DS a memoria de video
	
	pintar_marco macro izq, der, arr, aba, color
		LOCAL ciclo1, ciclo2
		push si
		xor si, si
		mov si, izq
		ciclo1:
			pintar_pixel arr, si, color
			pintar_pixel aba, si, color
			inc si
			cmp si, der
		jne ciclo1

		xor si, si
		mov si, arr
		ciclo2:
			pintar_pixel si, der, color
			pintar_pixel si, izq, color
			inc si
			cmp si, aba
		jne ciclo2
		pop si
	endm
    
    
	pintar_pixel macro i, j, color
		push ax
		push bx
		push di
		xor ax, ax
		xor bx, bx
		xor di, di
		mov ax, 320d
		mov bx, i
		mul bx
		add ax, j
		mov di, ax
        xor ax,ax
        mov ax, color
		mov [di], ax
		pop di
		pop bx
		pop ax
	endm


    delay macro param   
        push ax
        push bx
        xor ax, ax
        xor bx, bx
        mov ax,param
        ret2:
            dec ax
            jz finRet
            mov bx, param
            ret1:
                dec bx
            jnz ret1
        jmp ret2                
        finRet:
        pop bx
        pop ax
    endm 


    ;convierte una cadena a numero, este es guardado en AX.
    StrToNum macro numStr
    local ciclo, salida, chkNeg, cfgNeg, signoN
    push bx
    push cx
    push dx
    push si
    ;Limpiando los registros AX, BX, CX, SI
    xor ax, ax
        xor bx, bx
    xor dx, dx
    xor si, si
    mov bx, 000Ah	;multiplicador 10
    ciclo:
        mov cl, numStr[si]
        inc si
        cmp cl, 2Dh ;Si se trata de el signo menos de la cadena 'numero', lo ignoramos
        jz ciclo    ;Se ignora el simbolo '-' del número
        cmp cl, 30h ;Si el caracter es menor a '0', se procede a la verificación de numeros negativos
        jb chkNeg
        cmp cl, 39h ;Si el caracter es mayor a '9',se procede a la verificación de numeros negativos
        ja chkNeg
            sub cl, 30h	;Se le resta el ascii '0' para obtener el número real
            mul bx      ;multplicar ax por
        mov ch, 00h
            add ax, cx  ;sumar lo que tengo mas el siguiente
            jmp ciclo
    cfgNeg:
        neg ax ;Aqui se niega el numero resultante
        jmp salida
    chkNeg:;Verificacion
        cmp numStr[0], 2Dh;Si existe un signo al inicio del numero, negamos el numero
        jz cfgNeg
    salida:
        ;Restaurando los registros AX, BX, CX, SI
        pop si
        pop dx
        pop cx
        pop bx
    endm
;*******************************************************
;       	DATA SEGMENT
;*******************************************************
.DATA
    frame  DB 0Ah, '|------------------------------------------------------------------------------|$'
    
    comparasionFlag  DB 0

    axBk DW ?
    bxBK DW ?
    cxBK DW ?
    dxBk DW ?
    siBk DW ?
    diBk DW ?



    i db 0
    j db 0
    buffer db 0


	A 	 DW 20 DUP()
    buffer_num db 30d dup("$"); Buffer del numero temporal
    AB	 DB 20 DUP(), '$'



    tpila db 0
    aux db 0
    errorCreateFile DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to create file... $'
    errorCloseFile  DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to close  file... $'
    errorOpenFile   DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to open   file... $'
    errorReadFile   DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to read   file... $'
    errorWriteFile  DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to write  file... $'
    err  DB 'AAAA$'
    

barra macro 

    xor cx,cx
    xor si,si
    mov si,150d
    ciclo1:
        xor cx,cx
        mov cx,25d
        ciclo2:
            pintar_pixel cx,si,9d
            inc cx
        cmp cx,155
        jnz ciclo2
        inc si

    cmp si,170d
    jne ciclo1
endm




NumToStr macro numStr
	local div10, signoN, unDigito, jalar
  ;Realizando backup de los registros BX, CX, SI
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov bx,0ah; Divisor: 10
	test ax,1000000000000000 ;Se verifica que el bit mas significativo sea negativo
	jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov numStr[si], 30h; Se agrega un CERO para que sea un numero de dos digitos
      inc si
	    jmp div10
	signoN:;Aqui se cambia de signo
  		neg ax; Se niega el numero para que sea positivo
  		mov numStr[si], 2dh; Se agrega el signo negativo a la cadena de salida
  		inc si
  		jmp unDigito
  div10:
      xor dx, dx; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx ;Se divide entre 10
      inc cx ;Se incrementa el contador
      push dx ;Se guarda el residuo DX
      cmp ax,0h ;Si el cociente es CERO
      je jalar
		  jmp div10
  jalar:
      pop dx; Obtenemos el top de la pila
      add dl,30h ;Se le suma '0' en su valor ascii
      mov numStr[si],dl; Metemos el numero al buffer de salida
      inc si
      loop jalar
      mov ah, '$'; Se agrega el fin de cadena
      mov numStr[si],ah
      ;Restaurando registros
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm


StrToNum macro numStr
  local ciclo, salida, chkNeg, cfgNeg, signoN
  push bx
  push cx
  push dx
  push si
  ;Limpiando los registros AX, BX, CX, SI
  xor ax, ax
	xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah	;multiplicador 10
  ciclo:
      mov cl, numStr[si]
      inc si
      cmp cl, 2Dh ;Si se trata de el signo menos de la cadena 'numero', lo ignoramos
      jz ciclo    ;Se ignora el simbolo '-' del número
      cmp cl, 30h ;Si el caracter es menor a '0', se procede a la verificación de numeros negativos
      jb chkNeg
      cmp cl, 39h ;Si el caracter es mayor a '9',se procede a la verificación de numeros negativos
      ja chkNeg
  		sub cl, 30h	;Se le resta el ascii '0' para obtener el número real
  		mul bx      ;multplicar ax por
      mov ch, 00h
  		add ax, cx  ;sumar lo que tengo mas el siguiente
  		jmp ciclo
  cfgNeg:
      neg ax ;Aqui se niega el numero resultante
      jmp salida
  chkNeg:;Verificacion
      cmp numStr[0], 2Dh;Si existe un signo al inicio del numero, negamos el numero
      jz cfgNeg
  salida:
      ;Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
endm
;convierte un numero guardado en AX (16 bits) y lo  convierte a cadena

ImprPant macro texto
	;Backup de los registros
	push ax
	push dx
	;Configuramos para hacer la llamada a la macro: Visualización de una cadena de caracteres
	mov ah, 09h
	mov dx, OFFSET texto
	;Nota: La palabra OFFSET permite calcular "el numero con signo" donde esta
	;almacenada nuestra cadena a mostrar.
	int 21h;Realizamos una interrupcion por software
	;Restaurando el valor a los registros (desapilar registros en la pila)
	pop dx
	pop ax
endm

mensajevideo macro fila, columna, mensaje
    xor ax,ax
    mov ah,02h
    mov bh,00h
    mov dh,fila
    mov dl,columna
    int 10h
    call DS_DATOS
    imprimir mensaje
    call DS_VIDEO

endm


;*******************************************************
;       	END DATA SEGMENT
;*******************************************************


;*******************************************************
;       	CODE SEGMENT
;*******************************************************
.CODE

    main PROC 
        MOV dx, @data
        MOV ds, dx
        MOV es, dx


        MAIN_MENU:
            mainMenuView 
        LOAD_FILE:
            fileLoadView  AB
        

        PANTALLA2:
            Salto
            print err
            call CNUMERO
            jmp EXIT

        grafico:
            mov tpila,0
            push ds
            mov ax,0
            push ax
            mov ax,sdatos
            mov ds,ax
            push ds

        
            call INI_VIDEO
            pintar_marco 20d, 299d, 20d, 180d, 10d
            barra
            mensajevideo 20d,59d,numStr
            mensajevideo 1d,3d,order
            delay 2000
            call FIN_VIDEO

        EXIT:
            MOV ah, 4ch
            INT 21h

   
        mov ax,4c00h
        int 21h 
        ret


    main ENDP

    limpiarRegistros PROC
        XOR ax, ax
        XOR bx, bx
        XOR cx, cx
        XOR dx, dx
        XOR si, si
        XOR di, di
        ret
    limpiarRegistros ENDP

    respaldo PROC
        MOV axBk, ax
        MOV bxBk, bx
        MOV cxBk, cx
        MOV dxBk, dx
        MOV siBk, si
        MOV diBk, di
        ret
    respaldo ENDP

    restaurar PROC
        MOV ax, axBk
        MOV bx, bxBk
        MOV cx, cxBk
        MOV dx, dxBk
        MOV si, siBk
        MOV di, diBk
        ret
    restaurar ENDP

    INI_VIDEO proc
        mov ax,0013h
        int 10h
        mov ax,0A000h
        mov ds,ax
        ret
    INI_VIDEO endp

    ;Finalizar el modo video y retornar a modo texto
    FIN_VIDEO proc
        mov ax,0003h
        int 10h
		mov ax, sdatos
		mov ds, ax
		ret
    FIN_VIDEO endp

    DS_DATOS proc
        push dx
        mov  dx,sdatos
        mov ds,dx
        pop dx
        ret
    DS_DATOS endp

    DS_VIDEO proc
        push ax
        mov ax,0A00h
        mov ds,ax
        pop ax
        ret
    DS_VIDEO endp

CNUMERO PROC
    mov si,0
    mov bx,0
    mov cx,0;Utilizamos el registro contador para llevar el control de iteraciones
    cicloP: 
        cmp cx,3;Comparamos si ha alcanzado el maximo de elementos.
        jz salidade; Como se activa la bandera ZERO saltamos a la salida.
		capturarNumero:;Estado de captura de los caracteres que conforman el número
			mov al, AB[si] ; Copiamos al registro AL el caracter del buffer en la posicion SI.
			inc si; Incrementamos el indice de lectura en el buffer de dato.
			cmp al, 30h;Compara si el caracter en el registro AL es caracter del digito CERO
			jb almcenarNumero; Salta la etiqueta almcenarNumero ya que se activa la bandera compuesta Below. Salta si AL < 30.
			cmp al, 39h;Compara si el caracter en el registro AL es caracter del digito NUEVE
			ja almcenarNumero; Salta la etiqueta almcenarNumero ya que se activa la bandera compuesta Above. Salta si AL > 30.
			;Si es otro caracter que conforma el numero.
			mov buffer_num[di], al; Copiamos el caracter en AL hacia nuestra variable  buffer_num en la posicion del registro DI.
			inc di; Incrementamos el indice de escritura en la variable temporal buffer_num.
			jmp capturarNumero; Salta obligatoriamente hacia la etiqueta capturarNumero para capturar el siguiente digito.
			ImprPant buffer_num
		almcenarNumero:;Estado donde se almacena el numero consolidado 'numero'
			push ax; Guardamos en la pila el registro AX, ya que se utilizará el registro AX para convertir la cadena a un número consolidado.
			StrToNum buffer_num; Con ayuda de nuestra macro almacenamos en el registro AX la cadena del número.
			sal bx, 01h;Corrimiento a la izquierda del registro BX, multiplica por 2.
			mov A[bx], ax; Copiamos el número consolidado 'AX' hacia nuestra lista de numeros de 16 bits.
			sar bx, 01h;Corrimiento a la derecha, divide por 2, (Restaura el desplazamiento anteriormente)
			inc bx; incrementamos BX(indice de la posicion en la lista de numeros).
			pop ax;Sacamos de la pila a AX
			jmp cicloP;Salta obligatoriamente al ciclo principal.
        salidade:
            Salto
            print err
            ret
    ret

CNUMERO ENDP
END   