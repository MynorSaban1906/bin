;-------------------IMPORTO EL .ASM CON LOS MACROS A UTILIZAR-------------
include macros.asm
;------------------------------------------------------------------------
.model small
;-------------------SEGMENTO DE PILA--------------------------
.stack
;-------------------SEGMENTO DE DATO--------------------------
.data
	;---------------ARRAYS PARA GUARDAR LOS OBTENER------------------
	ArrayEspejos db 100 dup(' ')
	ArrayPalindromos db 100 dup(' ')
	ArrayPares db 100 dup(' ')
	ArrayImpares db 100 dup(' ')
	ArraySplit db 100 dup(' ')
	temp1 db 100 dup(' ')
	TotalElementos db ?
	Temp db ?
	ArrayOrigales dw 50 dup(' ')
	;---------------VARIABLES PARA LEER LA RUTA DEL ARCHIVO---------
	ArrayRuta db 50 dup('$') ;un maximo de 50 caracteres para la ruta
	;---------------VARIABLES REPORTE---------------------
	fileReporte db 'c:\reporte.rep','00h' ;tiene que tener el mismo nombre que el archivo de entrada
	handlerReporte dw ? 
	;---------------VARIABLES ARCHIVO---------------------
	fileEntrada db 'c:\entrada.arq','00h'
	handlerEntrada dw ? 
	ArrayInfo db 100 dup(' ') 
	;----------------VARIABLES MENSAJES----------------------
	salt db 0ah,0dh, '	', '$'
	mov0 db 0ah,0dh, '	haciendo suma', '$'
	mov1 db 0ah,0dh, '	itera 1', '$'
	mov2 db 0ah,0dh, '	itera 2', '$'
	mov3 db 0ah,0dh, '	sumando', '$'
	mov4 db 0ah,0dh, '	es split', '$'
	mov5 db 0ah,0dh, '	no split', '$'
	err0 db 0ah,0dh, '	SEPARADOR INCORRECTO -> ', '$'
	err1 db 0ah,0dh, '	CARACTER INVALIDO -> ', '$'
	err2 db 0ah,0dh, '	FALTA SALTO DE LINEA (\n).............', '$'
	err3 db 0ah,0dh, '	Error No Deberia Llegar Aqui','$'
	err4 db 0ah,0dh, '	Extension de archivo no valida','$'
	msg1 db 0ah,0dh, '	REPORTE CREADO CON EXITO..............', '$'
	msg2 db 0ah,0dh, '	NO SE CREO EL ARCHIVO REPORTE.........', '$'
	msg3 db 0ah,0dh, '	NO SE ENCONTRO EL ARCHIVO.............', '$'
	msg4 db 0ah,0dh, '	NO SE LEYO BIEN EL ARCHIVO............', '$'
	msg5 db 0ah,0dh, '	NO SE CERRO BIEN EL ARCHIVO...........', '$'
	msg6 db 0ah,0dh, '	ARCHIVO LEIDO Y SIN ERRORES...........', '$'
	msg7 db 0ah,0dh, '	LISTA NUMEROS ESPEJO..................', '$'
	msg8 db 0ah,0dh, '	LISTA NUMEROS PALINDROMOS.............', '$'
	msg9 db 0ah,0dh, '	LISTA NUMEROS PARES...................', '$'
	ms10 db 0ah,0dh, '	LISTA NUMEROS IMPARES.................', '$'
	ms11 db 0ah,0dh, '	LISTA NUMEROS SPLIT...................', '$'
	enc0 db 0ah,0dh, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', '$'
	enc1 db 0ah,0dh, '	FACULTAD DE INGENIERIA', '$'
	enc2 db 0ah,0dh, '	ESCUELA DE CIENCIAS Y SISTEMAS', '$'
	enc3 db 0ah,0dh, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A', '$'
	enc4 db 0ah,0dh, '	SEGUNDO SEMESTRE 2017', '$'
	enc5 db 0ah,0dh, '	OSCAR RENE CUELLAR MANCILLA', '$'
	enc6 db 0ah,0dh, '	201503712', '$'
	enc7 db 0ah,0dh, '	REPORTE PRACTICA NO. 1', '$'
	enc8 db 0ah,0dh, '	FECHA 9 DE SEPTIEMBRE DE 2017', '$'
	lin0 db 0ah,0dh, '	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&', '$'
	lin1 db 0ah,0dh, '	&&&&&&&&&& MENU PRINCIPAL &&&&&&&&&&', '$'
	lin2 db 0ah,0dh, '	&&&&&&  1. CARGAR ARCHIVO   &&&&&&&&', '$'
	lin3 db 0ah,0dh, '	&&&&&&  2. SALIR            &&&&&&&&', '$'
	lin4 db 0ah,0dh, '	&&&&& INGRESE RUTA DEL ARCHIVO &&&&&', '$'
	ope0 db 0ah,0dh, '	&&&&&  1. OBTENER PARES        &&&&&', '$'
	ope1 db 0ah,0dh, '	&&&&&  2. OBTENER IMPARES      &&&&&', '$'
	ope2 db 0ah,0dh, '	&&&&&  3. OBTENER ESPEJOS      &&&&&', '$'
	ope3 db 0ah,0dh, '	&&&&&  4. OBTENER PALINDROMOS  &&&&&', '$'
	ope4 db 0ah,0dh, '	&&&&&  5. OBTENER SPLIT        &&&&&', '$'
	ope5 db 0ah,0dh, '	&&&&&  6. LISTA ASCENDENTE     &&&&&', '$'
	ope6 db 0ah,0dh, '	&&&&&  7. LISTA DESCENDENTE    &&&&&', '$'
	ope7 db 0ah,0dh, '	&&&&&  8. CREAR REPORTE        &&&&&', '$'
	ope8 db 0ah,0dh, '	&&&&&  9. SALIR                &&&&&', '$'
	rep0 db 0ah,0dh, '	TOTAL ELEMENTOS CARGADOS: ', '$'
	rep1 db 0ah,0dh, '	LISTA ORIGINAL: ', '$'
	rep2 db 0ah,0dh, '	NUMEROS PARES: ', '$'
	rep3 db 0ah,0dh, '	NUMEROS IMPARES: ', '$'
	rep4 db 0ah,0dh, '	NUMEROS ESPEJO: ', '$'
	rep5 db 0ah,0dh, '	NUMEROS PALINDROMOS: ', '$'
	rep6 db 0ah,0dh, '	NUMEROS SPLIT: ', '$'


;-------------------SEGMENTO DE CODIGO------------------------
.code
main proc ;Inicia proceso
	Menu_Principal:
		;----------IMPRIMO TODO EL ENCABEZADO---------------------
		impCad enc0
		impCad enc1
		impCad enc2
		impCad enc3
		impCad enc4
		impCad enc5
		impCad enc6
		;----------IMPRIMO EL MENU PRINCIPAL----------------------
		impCad lin0
		impCad lin1
		impCad lin0
		impCad lin2
		impCad lin3
		impCad lin0
		impCad salt
		;----------LEEMOS EL CARACTER OPRIMIDO-----------------
		mov ah,0dh
  		int 21h
		mov ah,01h ;01h en ah para leer un caracter desde el teclado
		int 21h
		cmp al,31h; COMPARO CON EL ASCII DEL NUMERO 1 QUE ES 49 Y EN HEXA 31H
		je Cargar_Archivo ;si los numeros son iguales salto
		cmp al,32h ;comparo con el ascii del numero 2
  		je Fin
  		jmp Menu_Principal;cualquier otro numero se vuelve a cargar el menu principal
  	Menu_Operaciones1:
  		mov TotalElementos, al
  		add TotalElementos,'0'
  		xor ax,ax
  		impCad msg6
  		impCad salt
  	Menu_Operaciones:
  		;--------------IMPRIMO EL MENU OPERACIONES---------------
  		impCad salt
  		impCad lin0
  		impCad lin1
  		impCad lin0
  		impCad ope0
  		impCad ope1
  		impCad ope2
  		impCad ope3
  		impCad ope4
  		impCad ope5
  		impCad ope6
  		impCad ope7
  		impCad ope8
  		impCad lin0
  		impCad salt
  		;----------LEEMOS EL CARACTER OPRIMIDO-----------------
		mov ah,0dh
  		int 21h
		mov ah,01h ;01h en ah para leer un caracter desde el teclado
		int 21h
		cmp al,31h; COMPARO CON EL ASCII DEL NUMERO 1 QUE ES 49 Y EN HEXA 31H
		je BuscarPares
		cmp al,32h ;comparo con el ascii del numero 2
		je BuscarImpares
		cmp al,33h
		je BuscarEspejos
		cmp al,34h
		je BuscarPalindromos
		cmp al,35h
		je BuscarSplit
		cmp al,36h
		cmp al,37h
		cmp al,38h
		je Crear_Reporte
		cmp al,39h
  		je Limpiar_Consola_Menu
  		jmp Limpiar_Consola_Operaciones

	Cargar_Archivo:
		;----------------- MENSAJE INGRESAR RUTA ----------------
		impCad lin0
		impCad lin0
		impCad lin4
		impCad lin0
		impCad lin0
		impCad salt
		mov si,0
		xor cx,cx
	Obtener_Ruta:
		mov ah,01h
		int 21h
		cmp al,26h ;ascii del &
   	    je Obtener_Ruta
   	    cmp al,0dh ;ascii del \n
		je FinRuta
	    mov ArrayRuta[si],al
   	    inc si
   	    inc cx
   	    jmp Obtener_Ruta
	FinRuta:
		mov ArrayRuta[si],00h
		xor si,si
	VerificarExtension:
		cmp ArrayRuta[si],2eh
		je VerSiguiente
		inc si
		Loop VerificarExtension
		jmp Error
	VerSiguiente:
		inc si
		cmp ArrayRuta[si],61h
		jne ExtensionInvalida
		xor si,si
		;----------------- LUEGO DE TERMINAR TODO EL ANALISIS SE CARGA EL MENU OPERACIONES------------
		abrir ArrayRuta,handlerEntrada
		leer 100,ArrayInfo,handlerEntrada
		cerrar handlerEntrada
		;impCad ArrayInfo
		jmp Analizar_Archivo
	;-------------FINALIZA EL PROGRAMA---------------------
	Fin:
		mov ax,4c00h
		int 20h
	Limpiar_Consola_Menu:
		mov ax,0600h
		mov bh,89h
		mov cx,0000h
		mov dx,184Fh
		int 10h
		jmp Menu_Principal
	Limpiar_Consola_Operaciones:
		mov ax,0600h ; Peticion para limpiar pantalla
		mov bh,89h ; Color de letra ==9 "Azul Claro"
		; Fondo ==8 "Gris"
		mov cx,0000h ; Se posiciona el cursor en Ren=0 Col=0
		mov dx,184Fh ; Cursor al final de la pantalla Ren=24(18) 
		; Col=79(4F)
		int 10h ; interrupcion al BIOS
		jmp Menu_Operaciones
	;---------------MENSAJE CUANDO NO SE ENCUENTRA LA RUTA-----------
	NoSeEncontroRuta:
		impCad msg3
		impCad salt
		jmp Cargar_Archivo
	;--------------MENSAJE CUANDO NO SE LEE BIEN EL ARCHIVO------------
	ErrorAlLeer:
		impCad msg4
		impCad salt
		jmp Cargar_Archivo
	;--------------MENSAJE CUANDO NO SE LOGRA CERRAR BIEN EL ARCHIVO---------
	ErrorAlCerrar:
		impCad msg5
		impCad salt
		jmp Cargar_Archivo
	;-------------MENSAJE CUANDO NO SE CREA EL ARCHIVO PARA REPORTE----------
	ErrorAlCrear:
		impCad msg2
		impCad salt
		jmp Menu_Operaciones
	;------------METODO CREAR REPORTE------------------------
	ReemplazarARQ:
		xor si,si
	Seguir:
		cmp ArrayRuta[si],2eh ;ascii del punto
		inc si
		jne Seguir
		mov ArrayRuta[si],72h ;le cambio por una r
		inc si
		mov ArrayRuta[si],65h ;le cambio por una e
		inc si
		mov ArrayRuta[si],70h ;le cambio por una p
		jmp SeguirReporte
	Crear_Reporte:
		jmp ReemplazarARQ
	SeguirReporte:
		crear ArrayRuta,handlerReporte
		escribir SIZEOF enc0, enc0,handlerReporte
		escribir SIZEOF enc1, enc1,handlerReporte
		escribir SIZEOF enc2, enc2,handlerReporte
		escribir SIZEOF enc3, enc3,handlerReporte
		escribir SIZEOF enc4, enc4,handlerReporte
		escribir SIZEOF enc5, enc5,handlerReporte
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF enc6, enc6,handlerReporte
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF enc7, enc7,handlerReporte
		escribir SIZEOF enc8, enc8,handlerReporte
		escribir SIZEOF rep0, rep0,handlerReporte;TOTAL DE ELEMENTOS CARGADOS
		escribir SIZEOF TotalElementos,TotalElementos,handlerReporte
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF rep1, rep1,handlerReporte
		escribir SIZEOF ArrayInfo, ArrayInfo,handlerReporte
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF rep4, rep4,handlerReporte ;numeros espejos
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF ArrayEspejos,ArrayEspejos,handlerReporte
		escribir SIZEOF rep5, rep5,handlerReporte ;numeros palindromos
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF ArrayPalindromos,ArrayPalindromos,handlerReporte
		escribir SIZEOF rep2, rep2,handlerReporte ;numeros pares
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF ArrayPares,ArrayPares,handlerReporte
		escribir SIZEOF rep3, rep3,handlerReporte ;numeros impares
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF ArrayImpares,ArrayImpares,handlerReporte
		escribir SIZEOF rep6, rep6,handlerReporte ;numeros impares
		escribir SIZEOF salt, salt,handlerReporte
		escribir SIZEOF ArraySplit,ArraySplit,handlerReporte
		;mov Temp,3bh
		;sub Temp,30h
		;add Temp,'0'
		;escribir SIZEOF Temp, Temp,handlerReporte

		cerrar handlerReporte
		impCad msg1
		impCad salt
		jmp Menu_Operaciones
	;---------------METODO PARA ANALIZAR EL CONTENIDO DEL ARCHIVO EN BUSCA DE ERRORES------------
	Analizar_Archivo:
		xor si,si;dejo en 0 el apuntador
		xor ax,ax
		jmp PrimerSeparador
	OmitirSaltos:
		inc si
		inc si
		;impCad mov0
	PrimerSeparador:
		cmp ArrayInfo[si],2Bh ;43 ascii del +
		jne FaltaSimbolo
		inc si
		;impCad mov1
	SigueNumero:
		cmp ArrayInfo[si],30h ;48 ascii del numero 0
		jb  CaracterInvalido ; si es menor al ascii del numero 0 es por que es un error de CaracterInvalido
		cmp ArrayInfo[si],39h ;57 ascii del numero 9
		ja CaracterInvalido ; si es mayor que el ascii del numero 9 tambien es un error de caracter
		inc si
		;impCad mov2
		cmp ArrayInfo[si],2Bh ;43 ascii del +
		jne SigueNumero ;si no son iguales es por que aun no ha terminado el numero y se sigue leyendo

		inc ax ;me sirve para llevar el conteo de cuantos numeros se ingresaron

		inc si
		;impCad mov3
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je Menu_Operaciones1
		cmp ArrayInfo[si],0dh ;salto de linea
		je OmitirSaltos
		jmp FaltaSalto
	;----------------------------------METODO PARA BUSCAR LOS NUMEROS ESPEJO---------------------------
	ImprimirEspejos:
		impCad msg7
		impCad salt
		;impCad ArrayEspejos
		jmp Esperar_Enter_Operaciones
	BuscarEspejos:
		xor si,si;dejo en 0 el apuntador
		xor di,di;dejo en 0 el apuntador
		jmp PrimerSeparador2
	OmitirSaltos2:
		mov al, ArrayInfo[si]
		mov ArrayEspejos[si],al
		imp al
		inc si
		inc di
		mov al, ArrayInfo[si]
		mov ArrayEspejos[si],al
		imp al
		inc si
		inc di
	PrimerSeparador2:
		mov al, ArrayInfo[si]
		;mov ArrayEspejos[si],al ;copio el primer separador 
		mov cx,0
		inc si
		inc di
	SigueNumero2:
		mov al, ArrayInfo[si]
		push ax ;meto el primer numero a la pila
		inc si
		inc cx
		cmp ArrayInfo[si],2Bh ;43 ascii del +
		jne SigueNumero2 ;si no son iguales es por que aun no ha terminado el numero y se sigue leyendo
	SacarNumeros:
		pop ax
		mov ArrayEspejos[di],al
		imp al
		inc di
		Loop SacarNumeros;Ejecuto el for hasta que termine de sacar todo de la pila
		mov al, ArrayInfo[si]
		;mov ArrayEspejos[si],al ;copio el segundo separador 
		inc di
		inc si
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je ImprimirEspejos;imprimo los numeros en espejo
		cmp ArrayInfo[si],0dh ;salto de linea
		je OmitirSaltos2
	;---------------------METODO PARA BUSCAR LOS NUMEROS PALINDROMOS-------------------------------------
	ImprimirPalindromos:
		;impCad ArrayPalindromos
		xor bp,bp
		jmp Esperar_Enter_Operaciones
	BuscarPalindromos:
		impCad msg8
		impCad salt
		xor si,si; limpio mi registro si para llevar la pos del arreglo
		xor di,di;arreglo temporal
		xor bp,bp ;arreglo de palindromos
		jmp PrimerSeparador3
	OmitirSaltos3:
		inc si ;antes salto despues retorno
		inc si ;antes retorno despues +
	PrimerSeparador3:
		inc si ;antes el + despues el numero
		mov cx,0
		mov di,0
	SigueNumero3:
		inc cx					;contador que me va a servir para ver cuantos numeros sacar de la pila y cuantas posiciones regresar
		mov al,ArrayInfo[si]	;agrego a la pila el
		push ax					;el numero que estoy leyendo
		mov temp1[di],al		;guardo en mi arreglo temporal el numero tambien
		inc di
		inc si ;antes numero despues (?)
		cmp ArrayInfo[si],2Bh ;43 ascii del +
		jne SigueNumero3 ;si no son iguales es por que aun no ha terminado el numero y se sigue leyendo
		mov di,0 				;regreso a 0 el contador de mi arreglo temporal
		mov bx,cx
		jmp ComprobarPalindromo
	ComprobarPalindromo:
		pop ax						;saco el ultimo valor ingresado a la pila
		cmp temp1[di],al			;comparo la pos cx-i con la pos i
		jne NoEsPalindromo			;si no son iguales es por que no es palindromo
		inc di						;incremeto contador del array temporal
		loop ComprobarPalindromo	;sigo ejecutando hasta que termine valor de cx
		mov cx,bx
		mov di,0

		mov al,0ah
		mov ArrayPalindromos[bp],al
		imp al
		inc bp

		;mov al,2bh
		;mov ArrayPalindromos[bp],al	;agrego al principio el separador
		;imp ArrayPalindromos[bp]
		;inc bp

	GuardarPalindromo:

		mov al,temp1[di]
		mov ArrayPalindromos[bp],al
		imp al
		inc bp

		inc di
		loop GuardarPalindromo

		;mov al,2bh
		;mov ArrayPalindromos[bp],al	;agrego de ultimo el separador
		;imp ArrayPalindromos[bp]
		;inc bp

		mov al,0dh
		mov ArrayPalindromos[bp],al	;agrego de ultimo el separador
		imp al
		inc bp

		mov al,0ah
		mov ArrayPalindromos[bp],al
		imp al
		inc bp

	NoEsPalindromo:
		mov cx,0
		mov di,0
		mov bx,0
		inc si ;antes + despues (?)
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je ImprimirPalindromos
		cmp ArrayInfo[si],0dh ;salto de linea
		je OmitirSaltos3
	;---------------METODO PARA BUSCAR LOS NUMEROS SPLIT-----------------------
	Error:
		impCad err3
	ImprimirSplit:
		;cerrar handlerReporte
		jmp Esperar_Enter_Operaciones
	BuscarSplit:
		impCad ms11
		mov al,0dh
		imp al
		xor ax,ax
		xor si,si;dejo en 0 el apuntador
		xor di,di;dejo en 0 el apuntador
		xor bp,bp;dejo en 0 el apuntador
		jmp VieneMas4
	Saltos4:
		inc si
		inc si
	VieneMas4:
		inc si
		xor cx,cx ;limpio el contador cx
		xor dx,dx ;limpio el contador cx
		mov di,si
		mov bp,si
	VieneNumero4:
		;--------BLOQUE DONDE VIENE NUMERO-----------
		inc dx
		;--------------------------------------------
		inc si
		cmp ArrayInfo[si],2Bh ;ascii del +
		jne VieneNumero4 ;si no viene un mas es por que sigue viniendo un numero

	ComprobarSplit:
		push dx
		cmp dx,5
		je iterardos
		cmp dx,4
		je iterardos
		cmp dx,3
		je iteraruno
		cmp dx,2
		je iteraruno
		cmp dx,1
		je EsSplit
		jmp Error

	iteraruno:
		;impCad mov1
		dec si
		mov cx,1
		xor ax,ax
		xor bx,bx
		xor dx,dx
		jmp Seguir4

	iterardos:
		;impCad mov2
		dec si
		mov cx,2
		xor ax,ax
		xor bx,bx
		xor dx,dx
	Seguir4:
		xor dx,dx
		mov dl, ArrayInfo[di]
		;impCad mov3
		add ax,dx
		xor dx,dx
		mov dl, ArrayInfo[si]
		add bx,dx
		dec si
		inc di
		loop Seguir4
	CompararSumas:
		cmp ax,bx
		je EsSplit
		jmp NoEsSplit

	EsSplit:
		;impCad mov4
		pop cx
		mov si,bp
	Guardar:
		mov al,ArrayInfo[si]
		imp al ;-----------------------------------IMPRIMO EL SPLIT
		mov ArraySplit[si],al
		inc si
		inc bp
		loop Guardar
		mov al,0dh
		mov ArraySplit[si],al
		impCad salt
		jmp FinNumero4

	NoEsSplit:
		;impCad mov5
		pop cx
	seguir5:
		inc bp
		loop seguir5
	FinNumero4:
		mov si,bp
		inc si
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je ImprimirSplit;imprimo los numeros en espejo
		cmp ArrayInfo[si],0dh ;salto de linea
		je Saltos4
		jmp Error
	;-------------METODO PARA BUSCAR LOS PARES---------------------------
	ImprimirPares:
		;impCad ArrayPares
		jmp Esperar_Enter_Operaciones
	BuscarPares:
		impCad msg9
		impCad salt
		xor si,si;dejo en 0 el apuntador
		xor di,di;dejo en 0 el apuntador
		jmp VieneMas2
	Saltos2:
		inc si
		inc si
	VieneMas2:
		inc si
		mov cx,0
	VieneNumero2:
		mov al,ArrayInfo[si] ;muevo al registro (al) siempre el ultimo numero que vino
		;push al
		inc cx
		inc si
		cmp ArrayInfo[si],2Bh ;ascii del +
		jne VieneNumero2 ;si no viene un mas es por que sigue viniendo un numero
	ComprobarPar:
		;imp al
		mov bx,cx ;guardo el valor de cuantos numeros vinieron
		mov dx,00000001b
		and ax,dx
		jz EsPar
		jmp FinNumero2
	EsPar: 
		dec si
		loop EsPar
		mov cx,bx ;devuelvo el valor de cuantos numeros vinieron

		mov al, 0ah					;agrego al arreglo
		mov ArrayPares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		
		imp al

	EscribirPar:
		mov al, ArrayInfo[si]
		mov ArrayPares[di],al
		inc di
		inc si

		imp al
		;mov Temp,al
		;sub Temp,30h
		;add Temp,'0'
		;abrir ArrayRuta, handlerReporte
		push ax
		push bx
		push cx
		push dx
		;escribir SIZEOF Temp, Temp,handlerReporte
		pop dx
		pop cx
		pop bx
		pop ax

		loop EscribirPar

		mov al, 0dh					;agrego al arreglo
		mov ArrayPares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		imp al

		mov al, 0ah					;agrego al arreglo
		mov ArrayPares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		imp al

	FinNumero2:
		inc si
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je ImprimirPares;imprimo los numeros en espejo
		cmp ArrayInfo[si],0dh ;salto de linea
		je Saltos2
	;----------------------------------IMPRIMIR IMPARES-----------------------------------------------
	ImprimirImpares:
		jmp Esperar_Enter_Operaciones
	BuscarImpares:
		impCad ms10
		impCad salt
		xor si,si;dejo en 0 el apuntador
		xor di,di;dejo en 0 el apuntador
		jmp VieneMas3
	Saltos3:
		inc si
		inc si
	VieneMas3:
		inc si
		mov cx,0
	VieneNumero3:
		mov al,ArrayInfo[si] ;muevo al registro (al) siempre el ultimo numero que vino
		;push al
		inc cx
		inc si
		cmp ArrayInfo[si],2Bh ;ascii del +
		jne VieneNumero3 ;si no viene un mas es por que sigue viniendo un numero
	ComprobarImpar:
		;imp al
		mov bx,cx ;guardo el valor de cuantos numeros vinieron
		mov dx,00000001b
		and ax,dx
		jnz EsImpar
		jmp FinNumero3
	EsImpar: 
		dec si
		loop EsImpar
		mov cx,bx ;devuelvo el valor de cuantos numeros vinieron

		mov al, 0ah					;agrego al arreglo
		mov ArrayImpares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		imp al
		
	EscribirImpar:
		mov al, ArrayInfo[si]
		mov ArrayImpares[di],al
		inc di
		inc si
		imp al
		loop EscribirImpar

		mov al, 0dh					;agrego al arreglo
		mov ArrayImpares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		imp al

		mov al, 0ah					;agrego al arreglo
		mov ArrayImpares[di],al		;los saltos de
		inc di						;linea para que se vea bien
		imp al

	FinNumero3:
		inc si
		cmp ArrayInfo[si],3Bh ;59 ascii del ;
		je ImprimirImpares;imprimo los numeros en espejo
		cmp ArrayInfo[si],0dh ;salto de linea
		je Saltos3
	;------------MENSAJES PARA CUANDO HAY ERRORES EN EL ARCHIVO DE ENTRADA---------
	FaltaSimbolo:
		impCad err0
		imp ArrayInfo[si]
		jmp Menu_Principal
	CaracterInvalido:
		impCad err1
		imp ArrayInfo[si]
		jmp Menu_Principal
	FaltaSalto:
		impCad err2
		jmp Menu_Principal
	;----------METODO PARA ESPERAR QUE PRESIONE ENTER (PARA VER BIEN LAS LISTAS)---------------------
	Esperar_Enter_Operaciones:
		mov ah,01h
		int 21h
		cmp al,0dh ;si viene un enter entonoces mandar a menu operaciones
		je Menu_Operaciones
		jmp Esperar_Enter_Operaciones
	ExtensionInvalida:
		impCad err4
		jmp Cargar_Archivo

main endp ;Termina proceso
end main