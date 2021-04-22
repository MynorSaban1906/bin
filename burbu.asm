include ope.asm
.model small
.stack
.data 
; DEFINIR VARIABLES
    i db 0
    j db 0
    buffer db 0
    A dw 19 dup(0)
	enc1 	DB 0Ah, 09h, "cambio$"
	enc2 	DB 0Ah, 09h, " ciclo2  $"


.code
;CODIGO 
main proc
    mov ax,@data;segmento de datos
    mov ds,ax;mover a ds 

    xor bx,bx
    mov A[bx],50
    mov A[bx+1],1
    mov A[bx+2],4  
    mov A[bx+3],2
    mov A[bx+4],8
    mov A[bx+5],12
    mov A[bx+6],24
    mov A[bx+7],999
    mov A[bx+8],76
    mov A[bx+9],28
    mov A[bx+10],15
    mov A[bx+11],47 
    mov A[bx+12],53
    mov A[bx+13],3
    mov A[bx+14],80
    mov A[bx+15],99
    mov A[bx+16],68
    xor si,si
    miniCiclo:
        push si
        Print16 a[si]
        Salto
        pop si
        inc si
        cmp si,19
        jne miniciclo

    mov ax,4c00h;Salir del sistema
    int 21h;interrupcion de DOS

main endp
end main


            