
print macro cadena
    mov   ax,@data    ;Segmento
    mov   ds,ax          ;ds = ax = saludo
    mov   ah,09          ;Function(print string)
    mov   dx,offset cadena         ;DX = String terminated by "$"
    int   21h  
endm

PrintRegistro macro Num
    xor ax,ax
    mov dl,Num 
    mov ah,02h
    int 21h
endm

Salto macro 
    mov dl,10 
    mov ah,02h
    int 21h
    mov dl,13 
    mov ah,02h
    int 21h
endm

PrintN macro Num
    local zero
    xor ax,ax
    mov dl,NUm
    add dl,48
    mov ah,02h
    int 21h
endm

Print8 macro Regis
    local zero,noz
    mov bx,2
    xor ax,ax
    mov al,Regis
    mov cx,10
    zero:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz zero
    xor bx,2
    noz:
    pop dx
    PrintN dl
    dec bx
    jnz noz
endm


Print16 macro Regis
local zero,noz

mov bx,4
xor ax,ax
mov ax,Regis
mov cx,10
zero:
xor dx,dx
div cx
push dx
dec bx
jnz zero


xor bx,4
noz:
pop dx
PrintN dl
dec bx
jnz noz

endm


Entrada macro tama
local Input,FININPUT,reinicio
mov si,00h
mov bl,tama
mov longitud,0
reinicio:
mov Teclado[si],0h
inc si
dec bl
jnz reinicio
mov Teclado[si],0h
mov bl,tama
mov si,00h
mov ah,1;Entrada en al
Input:
int 21h
cmp al,13
JZ FININPUT
mov Teclado[si],al
inc si
inc longitud
dec bl
jz FININPUT
Jnz Input
FININPUT:
mov ax,si
xor si,si
xor ax,ax
xor dx,dx
endm