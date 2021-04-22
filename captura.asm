include macros.asm
.model small
.stack 
.data
    res dw 0001h;
    msg db 10,13,17, 'Ingrese nuemro$'
    msg2 db 10,13,17, 'resultado es $'
    numeroStr db 30h dup("$")

.code
    print msg
    mov al,01h
    int 21h
    sub ax,30h
    mov res,ax

    
end