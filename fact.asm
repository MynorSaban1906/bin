.model small
.stack
.data
    res db 1
	unidad db 0
	decena db 0
	centena db 0
.code
    mov dx, seg @data
    mov ds,dx

    mov cx,7
    ciclo:
		mov al, res
		mov bl,cl
		mul bl
		mov res, al
	loop ciclo


	mov al,res
	AAM    
	mov unidad,al
	mov al,ah
	AAM 
	MOV centena,ah   
	mov decena,al   

	mov ah,02h

	mov dl,centena
	add dl,30h
	int 21h

	mov dl,decena
	add dl,30h
	int 21h

	mov dl,unidad
	add dl,30h
	int 21h

	mov ah,04ch
	int 21h

    .exit
end