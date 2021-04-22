

	    push ds
		mov ax,0
		push ax
		mov ax,sdatos
		mov ds,ax
		push ds

    
        call INI_VIDEO
    	pintar_marco 20d, 299d, 20d, 180d, 10d
        barra
        mensajevideo 20d,59d,numStr
        mensajevideo 1d,3d,order
        delay 2000
        call FIN_VIDEO





        MOV dx, @data
        MOV ds, dx
        MOV es, dx

        MAIN_MENU:
            mainMenuView
        LOAD_FILE:
            fileLoadView 

        EXIT:
            MOV ah, 4ch
            INT 21h