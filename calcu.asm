include macros.asm
.model small
.stack
.data
	n1 db 0;0001h;
	n2 db 0; 0001h;
	n3 db 0
	numeroStr db 30h dup("$")

	;Strings used to calculator mode--------------------------
	calcHead db 0ah,0dh, '*+*+*+  Modo Calculadora   +*+*+*$'
	enterNum db 0ah,0dh, '*+*+ Ingrese Un Numero:         +*+*$'
	enterOp db 0ah,0dh,  '*+*+ Ingrese Un Operador:       +*+*$'
	en db 0ah,0dh,  '*+*+ resultado:       +*+*$'

.code




main proc
	print calcHead
	print  enterNum
	getChar

	print enterOp
	getChar
	print  enterNum
	mov ah,01h
	int 21h
	add al,30h
	mov n2,al
	mov al,n1
	add al,n2
	mov n3,al

	mov al,n2
	AAM
	mov bx,ax
	mov ah,02h
	mov dl,bh
	add dl,30h
	int 21h 

	mov ah,02h
	mov dl,bh
	add dl,30h
	int 21h 
	int 21h;Realizamos una interrupcion por software
	;Salimos del programa
	MOV AX, 4C00H
	INT 21H

main endp

end main

