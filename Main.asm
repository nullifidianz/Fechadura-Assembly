Org 0000h

RS	Equ	P1.3
E	Equ	P1.2

; ---------------------------------- Main -------------------------------------
Main:
		Clr RS		; RS=0 - Registro de instruÃ§Ãµes estÃ¡ selecionado.

		Call ConfigFunc	; ConfiguraÃ§Ã£o da funÃ§Ã£o
	
		Call ExibeDisplay	; Liga o display e o cursor
	
		Call ModoEntrada	; Move o cursor para a direita em 1

		SetB RS		; RS=1
		
		Mov DPTR,#LUT1	; Tabela de consulta para a mensagem "Digite o PIN:"
Novamente:	Clr A
		Movc A,@A+DPTR	; ObtÃ©m o caractere
		Jz Proximo		; Sai quando A=0
		Call EnviarCar	; Exibe o caractere
		Inc DPTR		; Aponta para o prÃ³ximo caractere
		Jmp Novamente
	
Proximo: Mov R4,#00h	; Contador para verificar o nÃºmero de atualizaÃ§Ãµes
		Mov R5,#00h	; Contador para verificar o nÃºmero de entradas corretas
		Mov DPTR,#LUT4	; Copia o inÃ­cio da tabela de consulta para o PIN
;----------------------------------- Obter Entrada ----------------------------------		
Iterar: Call ScanTeclado	; valida a entrada do teclado
		SetB RS		; RS=1 
		Clr A
		Mov A,#'*'
		Call EnviarCar	; Exibe o asterisco para cada tecla pressionada
;------------------- Verifica PINS corretos inseridos ---------------		
		Clr A
		Movc A,@A+DPTR	; Tabela de consulta do PIN
		Call VerificarEntrada	; Verifica o nÃºmero de entradas corretas
		Inc DPTR
		Inc R4
		Cjne R4,#04h,Iterar
		
		Cjne R5,#04h,Incorreto	; Verifica o nÃºmero de entradas corretas
Correto: Call PosicaoCursor  	; Coloca o cursor na prÃ³xima linha
		SetB RS		; RS=1 - Registro de dados estÃ¡ selecionado.
		Call Concedido
		; Ativa o motor no sentido anti-horÃ¡rio
		SETB P3.0 ; Supondo que P3.0 seja o pino de controle para girar o motor
		CLR P3.1 ; Se necessÃ¡rio, dependendo do seu circuito

		; Inicia temporizador para uma volta e meia
		MOV R6, #0 ; Contador de temporizaÃ§Ã£o
		MOV R7, #150 ; Limite para uma volta e meia
		
Temporizar:	DJNZ R7, Temporizar ; Aguarda completar uma volta e meia

		; Desativa o motor
		CLR P3.0 ; Desliga o pino de controle do motor

		Jmp FimAqui
Incorreto: Call PosicaoCursor  	; Coloca o cursor na prÃ³xima linha
		SetB RS		; RS=1 - Registro de dados estÃ¡ selecionado.
		Call Negado
FimAqui: Jmp $
;-------------------------------- Sub-rotinas ---------------------------------				
ConfigFunc:	Clr  P1.7		
		Clr  P1.6		
		SetB P1.5		
		Clr  P1.4		; | (DB4)DL=0 - coloca o mÃ³dulo LCD em modo de 4 bits 
	
		Call Pulso

		Call Delay		

		Call Pulso
							
		SetB P1.7		 
		Clr  P1.6
		Clr  P1.5
		Clr  P1.4
			
		Call Pulso
			
		Call Delay
		Ret
;------------------------------------------------------------------------------
;------------------------------- Controle de ExibiÃ§Ã£o -----------------------------------
; O display Ã© ligado, o cursor Ã© ligado
ExibeDisplay:	Clr P1.7		 
		Clr P1.6		 
		Clr P1.5		 
		Clr P1.4	  

		Call Pulso

		SetB P1.7		
		SetB P1.6		; Define todo o display ON
		SetB P1.5		; Cursor ON
		SetB P1.4		; Cursor piscando ON
		Call Pulso

		Call Delay			
		Ret
;--------------------------------------------------------------------------------
;----------------------------- ConfiguraÃ§Ã£o do Modo de Entrada (modo de 4 bits) ----------------------
;    Definido para incrementar o endereÃ§o em um e o cursor deslocado para a direita
ModoEntrada:	Clr P1.7		; P1.7=0
		Clr P1.6		; P1.6=0
		Clr P1.5		; P1.5=0
		Clr P1.4		; P1.4=0

		Call Pulso

		Clr  P1.7		; P1.7 = '0'
		SetB P1.6		; P1.6 = '1'
		SetB P1.5		; P1.5 = '1'
		Clr  P1.4		; P1.4 = '0'
 
		Call Pulso

		Call Delay		
		Ret
		
;------------------------------------ Pulso --------------------------------------
Pulso:		SetB E		; P1.2 estÃ¡ conectado ao pino 'E' do mÃ³dulo LCD
		Clr  E		; borda negativa em E	
		Ret

;------------------------------------- EnviaChar----------------------------------			
EnviarCar:	Mov C, ACC.7		
		Mov P1.7, C		
		Mov C, ACC.6		
		Mov P1.6, C		
		Mov C, ACC.5		
		Mov P1.5, C		
		Mov C, ACC.4		
		Mov P1.4, C		
		;Jmp $
		Call Pulso

		Mov C, ACC.3		
		Mov P1.7, C		
		Mov C, ACC.2		
		Mov P1.6, C		
		Mov C, ACC.1		
		Mov P1.5, C		
		Mov C, ACC.0		
		Mov P1.4, C		

		Call Pulso

		Call Delay		
		
		Mov R1,#55h
		Ret

;------------------------------------- Delay ------------------------------------			
Delay:		Mov R0, #50
		Djnz R0, $
		Ret
				
;--------------------------- Scan do Teclado------------------------------

ScanTeclado:	CLR P0.3			;Limpa Linha3
			CALL IDCodigo0		;Chama sub-rotina de scan de coluna
			SetB P0.3			;Define Linha 3
			JB F0,Feito  		;Se F0 estiver definido, encerra o scan
						
			;Varre Linha2
			CLR P0.2			;Limpa Linha2
			CALL IDCodigo1		;Chama sub-rotina de scan de coluna
			SetB P0.2			;Define Linha 2
			JB F0,Feito			;Se F0 estiver definido, encerra o scan					

			;Varre Linha1
			CLR P0.1			;Limpa Linha1
			CALL IDCodigo2		;Chama sub-rotina de scan de coluna
			SetB P0.1			;Define Linha 1
			JB F0,Feito			;Se F0 estiver definido, encerra o scan

			;Varre Linha0			
			CLR P0.0			;Limpa Linha0
			CALL IDCodigo3		;Chama sub-rotina de varredura de coluna
			SetB P0.0			;Define Linha 0
			JB F0,Feito			;Se F0 estiver definido, encerra o scan
														
			JMP ScanTeclado	;Volta para o scan para linha 3
							
Feito:		Clr F0		        ;Limpa F0 antes de sair
			Ret
		
;---------------------------- Sub-rotina de Varredura de Coluna ----------------------------
IDCodigo0:	JNB P0.4, Keycode03	;Se Col0 Linha3 estiver limpa - chave encontrada
			JNB P0.5, Keycode13	;Se Col1 Linha3 estiver limpa - chave encontrada
			JNB P0.6, Keycode23	;Se Col2 Linha3 estiver limpa - chave encontrada
			RET					

Keycode03:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'3'		;CÃ³digo para '3'
			RET				

Keycode13:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'2'		;CÃ³digo para '2'
			RET				

Keycode23:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'1'		;CÃ³digo para '1'
			RET				

IDCodigo1:	JNB P0.4, Keycode02	;Se Col0 Linha2 estiver limpa - chave encontrada
			JNB P0.5, Keycode12	;Se Col1 Linha2 estiver limpa - chave encontrada
			JNB P0.6, Keycode22	;Se Col2 Linha2 estiver limpa - chave encontrada
			RET					

Keycode02:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'6'		;CÃ³digo para '6'

			RET				

Keycode12:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'5'		;CÃ³digo para '5'
			;Mov P1,R7		;Exibe tecla pressionada
			RET				

Keycode22:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'4'		;CÃ³digo para '4'
			RET				

IDCodigo2:	JNB P0.4, Keycode01	
			JNB P0.5, Keycode11	
			JNB P0.6, Keycode21	
			RET					

Keycode01:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'9'		;CÃ³digo para '9'
			RET				

Keycode11:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'8'		;CÃ³digo para '8'
			RET				

Keycode21:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'7'		;CÃ³digo para '7'
			RET				

IDCodigo3:	JNB P0.4, Keycode00	; Se Col0 Linha0 estiver limpa - chave encontrada
			JNB P0.5, Keycode10	; Se Col1 Linha0 estiver limpa - chave encontrada
			JNB P0.6, Keycode20	; Se Col2 Linha0 estiver limpa - chave encontrada
			RET					

Keycode00:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'#'		;CÃ³digo para '#' 
			RET				

Keycode10:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'0'		;CÃ³digo para '0'
			RET				

Keycode20:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'*'	   	;CÃ³digo para '*' 
			RET		

;--------------------------------- Verificar Entrada -----------------------------------
VerificarEntrada:	
		Cjne A,07H,Saida	
		Inc R5
Saida:					
		Ret

;-----------------------------------PosicaoCursor------------------------------------------
PosicaoCursor:	Clr RS
		SetB P1.7		
		SetB P1.6		
		Clr P1.5											 
		Clr P1.4		 									 
						
		Call Pulso

		Clr P1.7		 									 
		Clr P1.6											 
		Clr P1.5											 
		Clr P1.4		 									 
						
		Call Pulso

		Call Delay			
		Ret	

;------------------------------ Aberto ---------------------------------------------
Concedido:	Mov DPTR,#LUT2		;Tabela de consulta para "Acesso Concedido"
Voltar:		Clr A
		Movc A,@A+DPTR
		Jz Casa
		Call EnviarCar
		Inc DPTR
		Jmp	Voltar		
Casa:		Ret	

;------------------------------ Negado --------------------------------------------
Negado:		Mov DPTR,#LUT3		;Tabela de consulta para "Acesso Negado"
MaisUm:		Clr A
		Movc A,@A+DPTR
		Jz VoltarCasa
		Call EnviarCar
		Inc DPTR	
		Jmp MaisUm
VoltarCasa:	Ret					
;------------------------------ Tabela LUT -----------------------------
;---------------------------------- Mensagens ------------------------------------
		Org 0200h
LUT1:       DB 'E', 'n', 't', 'r', 'a', 'r', 32, 'P', 'I', 'N',':',0
LUT2:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'C', 'o', 'n', 'c', 'e', 'd','i','d','o', 0
LUT3:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'N', 'e', 'g', 'a', 'd', 'o', 0

;------------------------------------- PIN --------------------------------------
		Org 0240h		
LUT4:		DB '1', '3', '1', '2',0 ; mude de acordo com a necessidade
;--------------------------------- Fim do Programa -------------------------------	
Parar:		Jmp $
	
		End

org 001Bh
int01:
CPL P3.0 ; Inverte o estado do pino para girar no sentido anti-horÃ¡rio
CPL P3.1
RETI

org 0030h
MAIN:
MOV TMOD, #01100000b
SETB EA
SETB ET1
SETB TR1
SETB P3.0
CLR P3.1
JMP $
