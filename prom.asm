
include ope.asm
include macros.asm

.model small
.stack
.data
    dato dw 100d dup()
    res dw 0
	ArrayRes db 5 dup(),'$'
    aux db 00h
;---------------CONVERTIR RESULTADO---------------------
ConvertirResultado macro res,buffer
    xor si,si
    xor cx,cx
    xor ax,ax
    xor dx,dx
    mov ax,res
    mov dl,0ah
    jmp segDiv

    segDiv1:
    xor ah,ah
    segDiv:
    div dl
    ;print msg10
    inc cx
    push ax
    cmp al,00h ;si ya dio 0 en el cociente dejar de dividir
    je FinCR
    jmp segDiv1

    FinCR:
    pop ax
    add ah,30h
    mov buffer[si],ah
    inc si
    loop FinCR

    mov ah,24h ;ascii del $
    mov buffer[si],ah
    inc si
endm
.code
    mov ax,@data;segmento de datos
    mov ds,ax;mover a ds 

    xor bx,bx
    mov dato[bx],100
    mov dato[bx+1],1
    mov dato[bx+2],18
    mov dato[bx+3],17
    mov dato[bx+4],34
    mov dato[bx+5],100
    mov dato[bx+6],34
    mov dato[bx+7],45
    mov dato[bx+8],76

    xor cx, cx
    xor ax,ax
    xor bx,bx
    StartLoop:
        cmp cx, 9
        jge EndLoop
        
        add ax, dato[bx]
        mov res,ax
        mov ax,res
        inc cx
        inc bx
        jmp StartLoop
    EndLoop:
    
        NumToStr ArrayRes
        print ArrayRes
        mov ax,4c00h;Salir del sistema
        int 21h;interrupcion de DOS



    .exit
end



    StartLoop:
        cmp cx, 9
        jge EndLoop
        add ax, dato[bx]
        add res,ax
        inc cx
        inc cx
        jmp StartLoop
    EndLoop:
    
    ConvertirResultado res,ArrayRes
    print ArrayRes