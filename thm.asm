
main proc
	presentacion
	PrincipalMenu:
		menu
		getChar
		cmp al,31h ; codigo ascii del numero 1 en hexadecimal
		;je opcion1;
		cmp al,32h ; codigo ascii del numero 2 en hexadecimal
		je  calculator
		cmp al,33h ; codigo ascii del numero 3 en hexadecimal
		je salir ;



	fileUpload1:
		;print cadena4;
		getChar
		jmp PrincipalMenu
	calculator:
	
		jmp calculadora

	factorial:
		jmp fact
    
	report:

	calculadora:

	fact:
      
	
	salir:
		mov ax,4c00h
		int 21h
main endp

end main

