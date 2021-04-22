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


.MODEL SMALL
.STACK
.DATA
res dw 0001h
numeroStr db 30h dup("$")
.CODE
MOV ax, @DATA
MOV ds, ax

mov cx, 7;Contador
ciclo:
  mov ax, res
  mov bx,cx
  mul bx
  mov res, ax
loop ciclo
NumToStr numeroStr

;Imprimimos el resultado
mov ah, 09h
mov dx, OFFSET numeroStr
int 21h;Realizamos una interrupcion por software
;Salimos del programa
MOV AX, 4C00H
INT 21H

END
