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
		mov [di], color
		pop di
		pop bx
		pop ax
	endm

;Iniciar el modo video con la fucion 13h y cambiar DS a memoria de video
INI_VIDEO proc
	mov ax, 0013h
	int 10h
	mov ax, 0A000h
	mov ds, ax
	ret
INI_VIDEO endp

;Finalizar el modo video y retornar a modo texto
FIN_VIDEO proc
	mov ax, 0003h
	int 10h
	mov ax, sdatos
	mov ds, ax
	ret
FIN_VIDEO endp


pintar_pixel macro i,j,color
	push ax
	push bx
	push di
	xor ax,ax
	xor bx,bx
	xor di,di
	mov ax,320d
	mov bx,i
	mul bx
	add ax,j
	mov di,ax
	mov [di],color
	pop di
	pop bx
	pop ax
endm



call INI_VIDEO


Call 


scodigo segment 'CODE'
    
	ASSUME SS:spila, DS:sdatos, CS:scodigo         
	
	imprimir macro param
		mov ah, 09h
		lea dx, param		
		int 21h
	endm



	;Encargado de pintar un pixel en (i, j) => 320 * i + j --> 320 decimal => 140 hexadecimal
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
		mov [di], color
		pop di
		pop bx
		pop ax
	endm

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


	;Cambia DS a donde tenemos las variables 
	DS_DATOS proc
		push ax
		mov ax,sdatos
		mov ds,ax
		pop ax
		ret
	DS_DATOS endp

	;Cambia DS a memoria de video
	DS_VIDEO proc
		push ax
		mov ax, 0A000h
		mov ds, ax
		pop ax
		ret
	DS_VIDEO endp

	main proc far 
	    push ds
		mov ax,0
		push ax
		mov ax,sdatos
		mov ds,ax
		push ds
		
		call INI_VIDEO

		;SE ENCARGA DE IMPRIMIR USAC EN PANTALLA, (PUEDE IR EN CUALQUIER LUGA DEL CODIGO)
		xor ax, ax
		mov ah, 02h
		mov bh, 00h
		mov dh, 1d ;23 fil
		mov dl, 3d ;118 col
		int 10h
		call DS_DATOS ;Cambia de DS al lugar de las variables
		imprimir msg 
		call DS_VIDEO ;Cambio de DS a memoria de video

		;Pinta el marco de color verde
		pintar_marco 20d, 299d, 20d, 180d, 10d
		

		;Pinta la barra centrada de 20px X 130px de color azulado
		xor cx, cx
		xor si, si
		mov si, 150d
		ciclo1:
			xor cx, cx
			mov cx, 25d
			ciclo2:
				pintar_pixel cx, si, 9d
				inc cx
			cmp cx, 155
			jnz ciclo2
			inc si
		cmp si, 170d
		jne ciclo1

		;Pinta el 55 abajo de la barra
		xor ax, ax
		mov ah, 02h
		mov bh, 00h
		mov dh, 20d ;23 fil
		mov dl, 59d ;118 col
		int 10h
		call DS_DATOS
		imprimir numStr 
		call DS_VIDEO ;Cambia de DS al lugar de las variables
		delay 3000
		call FIN_VIDEO ;Cambio de DS a memoria de video
		
		mov ax,4c00h
  		int 21h
		ret
    main endp
	
scodigo ends
end main