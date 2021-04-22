analisis MACRO buffer,bufferRegistro 

	.data
		;; ///////// palabras claves o reservadas ////////////////////////////////////
		
		pcRegistro 	DB "Numero$"

		;; ///////// Buffer's ////////////////////////////////////

		bufferString 	 DB 100 DUP(), '$'

		;; ///////// mensajes ////////////////////////////////////

		msgRegistro	DB 0Ah, 09h, "REGISTRO: $"


	.code
		CALL limpiarRegistros
		MOV si, -1

		S0:
			CALL siguienteCaracter

			CMP bl, 10							;; if bl = '\n' (salto de linea)
				JE S1
			CMP bl, 13							;; if bl = '\r' (regreso de carro)
				JE S1
			CMP bl, 36							;; if bl == '$' (FIN_ANALISIS de archivo->EOF)
				JE FIN_ANALISIS
			JMP S0 

		S1: 
			CALL siguienteCaracter
						
			CMP bl, 36							;; if bl == '$' (FIN_ANALISIS de archivo->EOF)
				JE FIN_ANALISIS
			CMP bl, 47							;; if bl == '/'
				JE LIMPIAR_DI_1
			CMP bl, 60							;; if bl == '<'
				JE LIMPIAR_DI
			
			JMP S1

		LIMPIAR_DI:
			limpiarBuffer 	bufferString
			XOR 			di, di

		ETIQUETA:
			CALL siguienteCaracter

			CMP bl, 47							;; if bl == '/'
				JE LIMPIAR_DI_1
			CMP	 bl, 62							;; if bl == '>'
				JE PALABRA_CLAVE
			
			MOV bufferString[di], bl
			INC di
			JMP ETIQUETA

		PALABRA_CLAVE:
			
			CALL respaldo

			compararIngorandoCase pcRegistro, bufferString	   	;; kwAdd.equalIgnoreCase(buffer)
			JE ACCION_2

			

			CALL restaurar

			JMP S1


		ACCION_2:
			CALL restaurar
			CALL leerCarnet
			inc tpila
			Salto
            Print8 tpila
			JMP  S1


		LIMPIAR_DI_1:
			limpiarBuffer 	bufferString
			XOR 			di, di

		ETIQUETA_DE_CIERRE:
			CALL siguienteCaracter
			CMP	 bl, 62							;; if bl == '>'
				JE VERIFICAR_ID
			
			MOV bufferString[di], bl
			INC di
			JMP ETIQUETA_DE_CIERRE

		VERIFICAR_ID:
			CALL respaldo
			
			JE 	 ACCION_3
			CALL restaurar
			JMP  S1

		ACCION_3:
			
			
			
			CALL restaurar
			JMP  S1	


		leerCarnet PROC
			XOR di, di 

			L1:
				CALL siguienteCaracter

			    CMP  bl, 60						;; if bl == '<'
				 JE  L2 
				CMP  bl, 45						;; if bl == '-'
				 JE  L1
				MOV bufferRegistro[di], bl
				INC di

				JMP L1 

			L2: 
				ret
		leerCarnet ENDP

		

		siguienteCaracter PROC
			INC si
			MOV bl, buffer[si]
			ret 
		siguienteCaracter ENDP


		FIN_ANALISIS:



ENDM