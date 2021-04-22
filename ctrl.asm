fileLoadController MACRO  A
	
	.data
		manejador	  	DW ?
		bufferRuta    	DB 0100 DUP('$'), 0
		bufferContenido DB 9999 DUP('$'), '$'

		msg1  	DB 0Ah, 0Ah, 09h, "Ingrese la ruta del archivo: ", 0Ah, " > $"
		msg2	DB 0Ah, 0Ah, 09h, "Archivo Leido Satisfactoriamente!! $"


	.code
		imprimir 		msg1
		leerCadena 		bufferRuta

		abrirArchivo 	bufferRuta, manejador
		leerArchivo		bufferContenido, SIZEOF bufferContenido, manejador
		cerrarArchivo	manejador

		analisis 		bufferContenido,A

		imprimir 		msg2

		leerCaracter
        JMP     	PANTALLA2
	
ENDM
menuController MACRO
	
	leerCaracter

    CMP al, 49
        JE  LOAD_FILE
    CMP al, 50
        JE  EXIT

    JMP MAIN_MENU

ENDM

menuController2 MACRO
	xor al,al
	leerCaracter

    CMP al, 49
        JE  BURBUJA
    CMP al, 50
        JE  EXIT

    JMP MAIN_MENU

ENDM


menuController3 MACRO
	xor al,al
	leerCaracter

    CMP al, 49
        JE  grafico
    CMP al, 50
        JE  EXIT

    JMP MAIN_MENU

ENDM
