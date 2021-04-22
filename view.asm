fileLoadView MACRO A


	.CODE
		limpiarConsola
        imprimir frame

        fileLoadController A
		
		
ENDM	



typeOrder MACRO

	.DATA
		ti2 DB 0Ah, "1. Ordenamiento BubbleSort", 0Ah, "2. Ordenamiento QuickSort", 0Ah, "3. Ordenamiento ShellSort $"
                                                 
	.CODE
		imprimir ti2
		imprimir frame
		menuController2

ENDM	

VelocidadData MACRO

	.DATA
		m  DB 0Ah, "Ingrese Velocidad (0-9): $"                                              
	.CODE
		imprimir frame
		imprimir m
		menuController3

ENDM

EstiloData MACRO

	.DATA
		enc2 DB 0Ah, "1. Desendente", 0Ah, "2. Asendente$"                                            
	.CODE
		limpiarConsola
		imprimir enc1
        imprimir frame

        fileLoadController

ENDM


mainMenuView MACRO 

	.DATA
		enc2 DB 0Ah, " ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0Ah, " SECCION A$"
		enc3 DB 0Ah, " Nombre: Mynor Alison Isai Saban Che", 0Ah, " Carnet: 201800516", 0Ah, " Proyecto 2 $"

		
	
                                                          
        menu4  DB 0Ah, 09h, 09h, 09h,  "1 Carga de Archivo", 0Ah, 09h, 09h, 09h, "2 Salir", 0Ah,"$"
		menu5  DB 0Ah, 09h, 09h, 09h, "Escoge una Opcion: $"
	

	.CODE
	    limpiarConsola
        imprimir   enc1
        imprimir   enc2
        imprimir   enc3
        imprimir   frame
        
        imprimir   menu4
        imprimir   frame

        imprimir   menu5
        
        menuController

ENDM
