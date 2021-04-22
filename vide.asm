;.286
;stack segment
spila segment stack
	DB 32 DUP ('stack___')
spila ends

; data segment
sdatos segment 
	numStr db "52","$"
	msg db "USAC","$"
sdatos ends


scodigo segment 'CODE'
    
	ASSUME SS:spila, DS:sdatos, CS:scodigo         
	
	imprimir macro param
		mov ah, 09h
		lea dx, param		
		int 21h
	endm

    delay macro param
        push ax
        push bx
        xor ax,ax
        xor bx,bx
        mov ax,param
        ret2:
            dec ax
            jz finret
            mov bx,param
            ret1:
                dec bx
            jnz ret1
        jmp ret2:
        finret:
        pop bx
        pop ax
    endm

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


    pintar_marco macro izq,der,arr,aba,color
        LOCAL ciclo1,ciclo2

        push si
        xor si,si
        mov si,izq
        ciclo1:
            pintar_pixel arr,si,color
            pintar_pixel arr,si ,color
            inc si 
            cmp si, der
        jne ciclo1
        xor si,si
        mov si,arr
        ciclo2:
            pintar_pixel si,der,color
            pintar_pixel si,izq ,color
            inc si 
            cmp si, aba
        jne ciclo2
        pop si
    endm




    ini_video PROC
        mov ax,0013h
        int 10h
        mov ax,0A000h
        mov ds,ax
        ret
    ini_video  endp


    fin_video proc
        mov ax,0003h
        int 10h
        mov ax,sdatos
        mov ds,ax
        ret
    fin_video endp

    main proc far
        push ds
        mov ax,0
        push ax
        mov ax,sdatos
        mov ds,ax
        push ds

        call ini_video
        pintar_marco 20d,299,20d,180d,10d
        delay 3000
        call fin_video

        mov ax,4c00h
        int 21h 
        ret
    main endp

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


scodigo ends
end main