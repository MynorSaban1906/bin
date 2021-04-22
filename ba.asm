include ope.asm
.model small
.stack
.data 
; DEFINIR VARIABLES
    p db 0
    j db 0 ;int aux;
    aux db 0;int p, j;
    A db 10 dup(0)
.code
;CODIGO 
main proc
    mov ax,@data;segmento de datos
    mov ds,ax;mover a ds 
    
    xor bx,bx
    mov A[bx],4
    mov A[bx+1],60
    mov A[bx+2],20
    mov A[bx+3],165
    mov A[bx+4],39
    mov A[bx+5],12
    mov A[bx+6],2
    mov A[bx+7],9
    call ordenar

    xor si,si
    miniCiclo:
        push si
        print8 a[si]
        Salto
        pop si
        inc si
        cmp si,10
        jne miniciclo

    mov ax,4c00h;Salir del sistema
    int 21h;interrupcion de DOS

main endp

ordenar proc
    mov p,1;p = 1
    cicloFor:;for()
        cmp p,10; p < A.length;
        je salidaFor
        mov bl,p
        mov al,A[BX]
        mov aux,al;aux = A[p];           // el final, guardamos el elemento y
        mov al,p
        mov j,al
        dec j;j = p - 1;            // empezamos a comprobar con el anterior
            mientras:
                cmp j,0;(j >= 0)
                JNGE finMientras
                
                xor bx,bx
                mov bl,j
                mov al,A[bx];A[j]
                cmp aux,al;(aux < A[j])
                JGE finMientras;while ( && ){ // mientras queden posiciones y el      
                xor bx,bx
                mov bl,j
                mov al,a[bx];A[j]
                inc bx;j+1
                mov a[bx],al;A[j + 1] = A[j];   // de la izquierda, 
                dec j;j--;               // la derecha
                
                jmp mientras
            finMientras:
        mov bl,j
        inc bl
        mov al,aux
        mov A[BX],al;        A[j + 1] = aux;       // colocamos aux en su sitio
        inc p;p++
        jmp cicloFor

    salidaFor:
    ret
ordenar endp
end main