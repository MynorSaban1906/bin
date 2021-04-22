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

dosnumeros macro 
	mov ah,01h
	int 21h
	sub al,30h
	mov d,al

	mov ah,01h
	int 21h
	sub al,30h
	mov u,al

	mov al,d
	mov bl,10
	mul bl
	add al,u
	xor ah,ah
	mov res,ax
endm

dosnumeros2 macro 
	mov ah,01h
	int 21h
	sub al,30h
	mov d,al

	mov ah,01h
	int 21h
	sub al,30h
	mov u,al

	mov al,d
	mov bl,10
	mul bl
	add al,u
	xor ah,ah
	mov res2,ax
endm


operafactorial  macro 
	add u,30h
	mov al,u
	cmp al,30h
		je FACT0
	cmp al,31h
		je FACT1
	cmp al,32h
		je FACT2
	cmp al,33h
		je FACT3
	cmp al,34h
		je FACT4
	cmp al,35h
		je FACT5
	cmp al,30h
		je FACT6
	cmp al,37h
		je FACT7

	FACT0:
		print fa0
		jmp PrincipalMenu
	FACT1:
		print fa1
		jmp PrincipalMenu
	FACT2:
		print fa2
		jmp PrincipalMenu
	FACT3:
		print fa3
		jmp PrincipalMenu
	FACT4:
		print fa4
		jmp PrincipalMenu
	FACT5:
		print fa5
		jmp PrincipalMenu
	FACT6:  
		jmp PrincipalMenu
	FACT7:
		print fa7
		jmp PrincipalMenu

endm

limvalor macro
	mov u,0
	mov d,0
	mov res,0001h
	mov res2,0001h

endm


.model small
.stack
.data
	ResultadoFactorial dw 0001h
	NStr db 30h dup("$")
	u db 0
	d db 0
	res dw 0001h
	res2 dw 0001h
	t db 31h
	xer db 0;0001h
	general db 30h dup("$")

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
	separador db 0ah,0dh,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  $'
	encabezado db 0ah,0dh, '%%%%%%%%%%%   MENU PRINCIPAL  %%%%%%%%%%%%%%%%%%%%%%%%%  $'
	opc1 db 0ah,0dh,'%%% 1. Cargar Archivo          %%%  $'
	opc2 db 0ah,0dh,'%%% 2. Modo Calculadora        %%%  $'
	opc3 db 0ah,0dh,'%%% 3. Factorial               %%%  $'
	opc4 db 0ah,0dh,'%%% 4. Crear reporte           %%%  $'
	opc5 db 0ah,0dh,'%%% 5. Salir                   %%%  $'

	;Strings para calculadora--------------------------
	encabezado2 db 0ah,0dh, '%%%%%%%%%%%%%%%%%%%  Modo Calculadora   %%%%%%%%%%%%%  $'
	enternumero db 0ah,0dh, '%%% Ingrese Un Numero:         %%%  $'
	entersimbolo db 0ah,0dh,  '%%% Ingrese Un Operador:     %%%   $'

	;string fpara el factorial 
	mfactorial db 0ah,0dh,  '%%%%%%%%%%%    FACTORIAL    %%%%%%%%%%%  $'
	doperacion db 0ah,0dh,  '%%% Operaciones : $'
	rfactorial db 0ah,0dh,  '%%% Resultado : $'
	cal3 db 0ah,0dh, '	',0a8h,'DESEA SALIR DE LA CALCULADORA?',0ah,0dh, '	1. SI',0ah,0dh, '	2. NO','$'
	fa0 db 0ah,0dh,'Operaciones: 0!=1;$'
	fa1 db 0ah,0dh,'Operaciones: 0!=1; 1!=1; $'
	fa2 db 0ah,0dh, 'Operaciones: 0!=1; 1!=1; 2!=1*2; $'
	fa3 db 0ah,0dh,'Operaciones: 0!=1; 1!=1; 2!=1*2; 3!=2*3=6; $'
	fa4 db 0ah,0dh, 'Operaciones: 0!=1; 1!=1; 2!=1*2; 3!=2*3=6; 4!=6*4=24;$'
	fa5 db 0ah,0dh, 'Operaciones: 0!=1; 1!=1; 2!=1*2; 3!=2*3=6; 4!=6*4=24; 5!=20*5=120; $'
	fa6 db 0ah,0dh, 'Operaciones: 0!=1; 1!=1; 2!=1*2; 3!=2*3=6; 4!=6*4=24; 5!=20*5=120; 6!=120*6=720;$'
	fa7 db 0ah,0dh, 'Operaciones: 0!=1; 1!=1; 2!=1*2; 3!=2*3=6; 4!=6*4=24; 5!=20*5=120; 6!=120*6=720; 7!=720*7=5040;$'

	;----------------------------NUMEROS PARA MODO CALCULADORA------------------------------

	Operador db ? ,'$'
	Numero1 dw ? ,'$'
	Numero2 dw ? ,'$'
	Resultado dw ?


.code


main proc
	; muestra datos personales
	presentacion
	PrincipalMenu:
		limvalor
		menu  ; muestra menu
		getChar
		cmp al,31h ; codigo ascii del numero 1 en hexadecimal
		;je opcion1;
		cmp al,32h ; codigo ascii del numero 2 en hexadecimal
		je  modocalcu
		cmp al,33h ; codigo ascii del numero 3 en hexadecimal
		je modofactorial ;
		cmp al,35h ; codigo ascii del numero 3 en hexadecimal
		je salir


	fileUpload1:
		;print cadena4;
		getChar
		jmp PrincipalMenu
	modocalcu:
		LimpiarPantalla
		print separador
		print encabezado2
		caloperacion:
			print enternumero ;Numero1
			dosnumeros
			print entersimbolo
			ObtenerOperador Operador
			print enternumero ;Numero1
			dosnumeros2
			Opera res,Operador,res2
			print rfactorial
			CNumero general
			ResFact general
			print separador
			print salto
			jmp PrincipalMenu

	modofactorial:
		LimpiarPantalla
		print separador
		print mfactorial
		print enternumero
		dosnumeros
		mov cx,res
		ciclo:
		  mov ax, res2
		  mov bx,cx
		  mul bx
		  mov res2, ax
		loop ciclo
		CNumero NStr
		print rfactorial
		ResFact NStr
		print salto
		operafactorial 
		


	salir:
		mov ax,4c00h
		int 21h
main endp

end main

