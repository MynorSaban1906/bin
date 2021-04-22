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

.model small
.stack 100h
.data
;================ SEGMENTO DE DATOS ==============================
;Numeros con valores iniciales
num_1 dw -121d
num_2 dw 5d
resultadoStr db 30h dup ("$");Resultado de operacion en caracteres
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
;================== SEGMENTO DE CODIGO ===========================
	mov dx,@data
	mov ds,dx
	;Hacemos una multiplicacion de 16 bits de -121 x 5
	mov ax, num_1
	mov bx, num_2
	imul bx; -121 x 5 = -605(base 10) = 1111111111111111	1111110110100011 (base binaria)
	;																		Parte ALTA:DX				Parte BAJA:AX
	;Como sabemos que DX esta solo contendra 16 bits con UNO's, entonces podemos descartarlo
	;Y solo trabajar con AX.

	;Hacemos una suma: (Resultado + 312)
	;como vamos a sumar un nuevo valor 'num_2' al registro AX(Resultado anterior)
	mov num_2, 312d;Cargamos un nuevo valor al num_2
	mov bx, num_2
	add ax, bx; Suma -605 + 312= -291(base10) =  1111111011011101
	;Aca aun conserva su signo                   *

	NumToStr resultadoStr
	;Imprimimos el resultado
	mov ah, 09h
	mov dx, OFFSET resultadoStr
	int 21h;Realizamos una interrupcion por software
	;Sale del programa
	MOV ah,4ch
	int 21h
end
