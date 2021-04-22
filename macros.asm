;Macro que permite imprimir en pantalla en modo TEXTO
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

;Macro personal que leer un archivo de texto y carga su contenido en la
;variable de salida "buffer_salida"
LeerArchivo macro nombre_archivo, buffer_salida
	LOCAL salida
	;La palabra reservada LOCAL, permite declarar las etiquetas internas
	;de nuestra macro.

	;backup de los registros:
	push ax
	push bx
	push cx
	push dx
	;Primero se abre el archivo, para obtener el handle.
	;Para ello se configura la macro "Abrir archivo" (función 3Dh)
	mov ah, 3Dh
	mov al, 000b
	mov dx, OFFSET nombre_archivo
	int 21h;Realizamos una interrupcion por software
	jc salida;Si activa la bandera Carry, salimos (Error al abrir archivo).
	;Se lee el contenido del archivo, con la macro: "Lectura de Fichero o dispositivo" (Función 3Fh)
	mov bx, ax; Se almacena el handle en el registro BX
	mov ah, 3Fh
	mov cx, 500d; Números de bytes a leer
	mov dx, offset buffer_salida
	int 21h;Realizamos una interrupcion por software
	;Cerramos el archivo
	mov ah,3Eh
	int 21h
	salida:;Desapilamos los registros almacenados en el segmento de pila.
		pop dx
		pop cx
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
;convierte un numero guardado en AX (16 bits) y lo  convierte a cadena
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
