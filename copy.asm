include macros.asm

presentacion macro 
	print universidad
	print facultad
	print escuela
	print curso
	print seccion
	print semestre
	print nombre
	print carnet
	print estado
	print salto
endm

menu macro buffer
	print separador
	print encabezado
	print opc1
	print opc2
	print opc3
	print opc4
	print opc5
	print separador
endm



.model small
.stack
.data
	num5 db 5
	universidad db 0ah,0dh, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$'
	facultad db 0ah,0dh, 'FACULTAD DE INGENIERIA$'
	escuela db 0ah,0dh, 'ESCUELA DE CIENCIAS Y SISTEMAS$'
	curso db 0ah,0dh, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A$'
	seccion db 0ah,0dh, 'SECCION B$'
	semestre db 0ah,0dh, 'PRIMER SEMESTRE 2021$'
	nombre db 0ah,0dh, 'MYNOR ALISON ISAI SABAN CHE$'
	carnet db 0ah,0dh, '201800516$'
	estado db 0ah,0dh, 'PRIMERA PRACTICA ASSEMBLER$'
	salto db 0ah,0dh, ' $'

	;mensaje de la calculadora 
	separador db 0ah,0dh,'*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*$'
	encabezado db 0ah,0dh, '*+*+*+*+*+ MENU PRINCIPAL +*+*+*+*+*$'
	opc1 db 0ah,0dh,'*+*+ 1. Cargar Archivo          +*+*$'
	opc2 db 0ah,0dh,'*+*+ 2. Modo Calculadora        +*+*$'
	opc3 db 0ah,0dh,'*+*+ 3. Factorial               +*+*$'
	opc4 db 0ah,0dh,'*+*+ 4. Crear reporte           +*+*$'
	opc5 db 0ah,0dh,'*+*+ 5. Salir                   +*+*$'

	;Strings used to calculator mode--------------------------
	encabezado2 db 0ah,0dh, '*+*+*+  Modo Calculadora   +*+*+*$'
	enternumero db 0ah,0dh, '*+*+ Ingrese Un Numero:         +*+*$'
	entersimbolo db 0ah,0dh,  '*+*+ Ingrese Un Operador:       +*+*$'

	;string fpara el factorial 
	mfactorial db 0ah,0dh,  '%%%%%%%%%%%    FACTORIAL    %%%%%%%%%%%'
	doperacion db 0ah,0dh,  '%% Operaciones : '
	rfactorial db 0ah,0dh,  '%% Resultado : '




.code


main proc
	; muestra datos personales
	presentacion
	PrincipalMenu:
		menu  ; muestra menu
		getChar
		cmp al,31h ; codigo ascii del numero 1 en hexadecimal
		;je opcion1;
		cmp al,32h ; codigo ascii del numero 2 en hexadecimal
		je  modocalcu
		cmp al,33h ; codigo ascii del numero 3 en hexadecimal
		je modofactorial ;



	fileUpload1:
		;print cadena4;
		getChar
		jmp PrincipalMenu
	modocalcu:
		LimpiarPantalla
		print enternumero

	modofactorial:
		LimpiarPantalla
		print separador
		print mfactorial
		print enternumero
		getChar
		.exit
	
	salir:
		mov ax,4c00h
		int 21h
main endp

end main

