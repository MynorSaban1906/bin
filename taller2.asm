;La palabra reservada INCLUDE permite importar macros propias desde
;otro archivo de código.
include macros.asm
include ope.asm
.model small; Modelo de tamaño de programa(SOLO para sintaxis MASM). Valores que puede tomar: tiny, small, medium, large & huge.
.stack 100h; Definiendo el tamaño de la pila
.data
;================ SEGMENTO DE DATOS ==============================
my_handle dw 0h; Handle del archivo
file_name db "t.xml",00h ;Nombre del archivo
buffer db 500d dup("$"); Buffer de lectura de datos
lista_num dw 100h dup();Listado de numeros de 16bits (Notas de un curso)
titulo db 30d dup ("$");Titulo de la lista.
buffer_num db 30d dup("$"); Buffer del numero temporal
 
ln db 0Ah,0Dh, "$";salto de linea
item  db "item $" ; Cadena de texto "item"
igual db "= $"

;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
	;================== SEGMENTO DE CODIGO ===========================
	mov dx,@data;Se mueve la dirección de nuestros datos al reistro AX
	mov ds, dx ; Se mueve el registro DX al registro de semento de dato
	ImprPant titulo;Imprimimos el titulo de la lista
	ImprPant ln;Imprimimos en salto de linea.
	call LeerJSON;Llamamos a nuestro procedimiento JSON
	call ImprLst;Llamamos a nuestro procedimiento de imprimir lista
	
	;Llamamos a la macro del sistema:Terminación de Programa con Código de Retorno
	mov ah,4ch
	int 21h;Interrumpimos nuestro programa

	;Procedimiento que permite imprimir una lista de numeros
	ImprLst proc
		mov cx, 0000h;Utilizamos el registro contador para llevar el control de iteraciones
		ImprPant titulo ;Imprimimos la cadena que contiene el titulo de la lista.
		ImprPant ln; Se imprime la variable que representa un salto de linea.
		ciclo:;Ciclo que permite iterar los elementos de la lista de numeros de 16 bits
			cmp cx, 0006h;Comparamos si ha alcanzado el maximo de elementos.
			jz salida; Como se activa la bandera ZERO saltamos a la salida.
			ImprPant item; Imprimimos a la cadena almacenada en la varable item.
			mov ax, cx;Copiamos el numero de iteracion (CX) al registro AX.
			NumToStr buffer_num ;Con ayuda de nuestra macro convertimos el número almacenado en AX a cadena.
			;El resultado se almacena en la variable "buffer_num"

			ImprPant buffer_num ;Imprimimos la cadena almacenada en "buffer_num"
			ImprPant igual ;Imprimimos la cadena que contiene el signo igual.
			;Convertimos el numero
			mov si, cx;Copiamos el contador de iteraciones al registro SI.
			sal si, 01h;Realizamos un desplazamiento a la izquierda(Multiplica por 2).
			mov ax, lista_num[si]; Copiamos el numero de lista de numeros idexada por el registro SI, y este es almacenada en el registro AX.
			numToStr buffer_num;Tomamos el registro AX y converimos el número a cadena con ayuda de nuestra macro, El resultado se almacena en la variable "buffer_num".
			ImprPant buffer_num; Se imprime la variable de tipo arreglo de caracteres "buffer_num".
			ImprPant ln; Se imprime la variable que representa un salto de linea.
			inc cx; Se incrementa el contador de iteraciones (CX).
			jmp ciclo;Salto obligatorio a la etiqueta ciclo
		salida:;Salida del procedimiento
			ret;Saca de la pila los valores de los registros IP & CS. y regresa al punto donde se ha llamado el procedimiento
	ImprLst endp

	;Procedimiento que permite leer los valores de un arreglo en un archivo JSON.
	;Aqui no se almacenan las llaves de los numeros.
	;Solo se almacenan unicamente los valores de cada llave.
	LeerJSON proc
		;leer el archivo json
		LeerArchivo file_name, buffer;Leemos el archivo JSON con ayuda de nuestra macro, almacenamos los caracteres leidos en la variable buffer.
		;Una vez cargado el buffer recorremos cada caracter para recolectar la información
		;de interes. Este proceso es similar al que se hace cuando se hace un analizador léxico de forma manual.
		mov si, 0000h;Inicializamos el registro SI al inicio del buffer de datos.
		mov bx, 0000h;Inicializamos el registro BX. Este es utilizado para llevar el control del indice donde se almacenará el numero en la lista de números.
		cicloP:;Ciclo principal
			;Utilizamos el registro DI como indice de la posicion de insercion de caracter en la variable temporal donde almacenaremos la informacion de interes.
			mov di, 0000h;Limpiamos el registro DI
			mov al, buffer[si];Copiamos el caracter en la posicion SI del buffer hacia el registro AL.
			cmp al, 24h;Compara si el caracter en el registro AL es el fin de cadena '$'
			jz salidaLJS; Si se activa la bandera ZERO, salimos del procedimiento de lectura.
			cmp al, 3eh;Compara si el caracter en el registro AL es el signo ':'
			jz capturaDato ;Si se activa la bandera ZERO, lo mandamos al la etiqueta de captura de datos.
			inc si; Incrementamos el indice de lectura en el buffer de dato.
			jmp cicloP;Salta obligatoriamente al ciclo principal.
		capturaDato:;Estado de captura de dato.
			mov al, buffer [si]; Copiamos al registro AL el caracter del buffer en la posicion SI.
			inc si; Incrementamos el indice de lectura en el buffer de dato.
			cmp al, 3Ch ;Co0mpara si el caracter en el registro AL es el signo '<'
			jz cicloP;Como se activa la bandera ZERO, salta al ciclo principal.
            cmp al, 2Fh ;Co0mpara si el caracter en el registro AL es el signo '/'
			jz cicloP;Como se activa la bandera ZERO, salta al ciclo principal.
            CMP al, 00ah			;; if bl = '\n' (salto de linea)
			jz capturaDato
			CMP al, 00dh		;; if bl = '\r' (regreso de carro)
			jz capturaDato
			cmp al, 30h;Compara si el caracter en el registro AL es caracter del digito CERO
			jb capturaDato; Salta la etiqueta capturaDato ya que se activa la bandera compuesta Below. Salta si AL < 30.
			cmp al, 39h;Compara si el caracter en el registro AL es caracter del digito NUEVE
			ja capturaDato; Salta la etiqueta capturaDato ya que se activa la bandera compuesta Above. Salta si AL > 30.
			;Aqui empieza a capturar la cadena que representa el numero.
			dec si;Decrementamos SI para volver al indice del caracter anterior.
			
		capturarNumero:;Estado de captura de los caracteres que conforman el número
			mov al, buffer[si] ; Copiamos al registro AL el caracter del buffer en la posicion SI.
			inc si; Incrementamos el indice de lectura en el buffer de dato.
			cmp al, 30h;Compara si el caracter en el registro AL es caracter del digito CERO
			jb almcenarNumero; Salta la etiqueta almcenarNumero ya que se activa la bandera compuesta Below. Salta si AL < 30.
			cmp al, 39h;Compara si el caracter en el registro AL es caracter del digito NUEVE
			ja almcenarNumero; Salta la etiqueta almcenarNumero ya que se activa la bandera compuesta Above. Salta si AL > 30.
			;Si es otro caracter que conforma el numero.
			mov buffer_num[di], al; Copiamos el caracter en AL hacia nuestra variable  buffer_num en la posicion del registro DI.
			inc di; Incrementamos el indice de escritura en la variable temporal buffer_num.
			jmp capturarNumero; Salta obligatoriamente hacia la etiqueta capturarNumero para capturar el siguiente digito.
			ImprPant buffer_num
			print buffer_num
		almcenarNumero:;Estado donde se almacena el numero consolidado 'numero'
			push ax; Guardamos en la pila el registro AX, ya que se utilizará el registro AX para convertir la cadena a un número consolidado.
			StrToNum buffer_num; Con ayuda de nuestra macro almacenamos en el registro AX la cadena del número.
			sal bx, 01h;Corrimiento a la izquierda del registro BX, multiplica por 2.
			mov lista_num[bx], ax; Copiamos el número consolidado 'AX' hacia nuestra lista de numeros de 16 bits.
			sar bx, 01h;Corrimiento a la derecha, divide por 2, (Restaura el desplazamiento anteriormente)
			inc bx; incrementamos BX(indice de la posicion en la lista de numeros).
			pop ax;Sacamos de la pila a AX
			jmp cicloP;Salta obligatoriamente al ciclo principal.
		capturaTitulo:;Estado donde se captura los caracteres que conforman el titulo.
			mov al, buffer[si] ; Copiamos al registro AL el caracter del buffer en la posicion SI.
			inc si; Incrementamos el indice de lectura en el buffer de dato.
			cmp al, 22h;Compara si el caracter en el registro AL es caracter '"'
			jz cicloP;Como se activa la bandera ZERO, salta al ciclo principal.
			mov titulo[di], al ;Copiamos el caracter en AL hacia nuestra variable titulo en la posicion del registro DI.
			inc di; Incrementamos el indice de escritura en la variable titulo.
			jmp capturaTitulo;Salta obligatoriamente a la etiqueta capturaTitulo, para capturar el siguiente caracter.
		salidaLJS:;Estado de salida
			ret;Saca de la pila los valores de los registros IP & CS. y regresa al punto donde se ha llamado el procedimiento
	LeerJSON endp
end
