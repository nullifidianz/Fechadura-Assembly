Org 0000h

RS	Equ	P1.3
E	Equ	P1.2

; ---------------------------------- Main -------------------------------------
Main:
		Clr RS		; RS=0 - Registro de instruções está selecionado.
;------------------------- Configuração dos Códigos de Instrução ------------------------------
		Call ConfigFunc	; Configuração da função (modo de 4 bits)
	
		Call ExibirCont	; Liga o display e o cursor
	
		Call ModoEntrada	; Move o cursor para a direita em 1
;-------------------------------------------------------------------------------		
		SetB RS		; RS=1 - Registro de dados está selecionado.
		
		Mov DPTR,#LUT1	; Tabela de consulta para a mensagem "Digite o PIN:"
Novamente:	Clr A
		Movc A,@A+DPTR	; Obtém o caractere
		Jz Proximo		; Sai quando A=0
		Call EnviarCar	; Exibe o caractere
		Inc DPTR		; Aponta para o próximo caractere
		Jmp Novamente
	
Proximo: Mov R4,#00h	; Contador para verificar o número de varreduras
		Mov R5,#00h	; Contador para verificar o número de entradas corretas
		Mov DPTR,#LUT4	; Copia o início da tabela de consulta para o PIN
;----------------------------------- Obter Entrada ----------------------------------		
Iterar: Call VarreduraTeclado	; Varre a entrada do teclado
		SetB RS		; RS=1 - Registro de dados está selecionado.
		Clr A
		Mov A,#'*'
		Call EnviarCar	; Exibe o asterisco para cada tecla pressionada
;------------------- Verifica o número de códigos corretos inseridos ---------------		
		Clr A
		Movc A,@A+DPTR	; Tabela de consulta do PIN
		Call VerificarEntrada	; Verifica o número de entradas corretas
		Inc DPTR
		Inc R4
		Cjne R4,#04h,Iterar
		
		Cjne R5,#04h,Incorreto	; Verifica o número de entradas corretas
Correto: Call PosicaoCursor  	; Coloca o cursor na próxima linha
		SetB RS		; RS=1 - Registro de dados está selecionado.
		Call Concedido
		Jmp FimAqui
Incorreto: Call PosicaoCursor  	; Coloca o cursor na próxima linha
		SetB RS		; RS=1 - Registro de dados está selecionado.
		Call Negado
FimAqui: Jmp $
;------------------------------ *Fim Do Main* ---------------------------------
;----------------- Nota: Use 7 para Frequência de Atualização em EdSim51 ----------------
;-------------------------------- Sub-rotinas ---------------------------------				
; ------------------------- Configuração de função --------------------------------------
ConfigFunc:	Clr  P1.7		; |
		Clr  P1.6		; |
		SetB P1.5		; | bit 5=1
		Clr  P1.4		; | (DB4)DL=0 - coloca o módulo LCD em modo de 4 bits 
	
		Call Pulso

		Call Atraso		; espera BF ser limpo

		Call Pulso
							
		SetB P1.7		; P1.7=1 (N) - 2 linhas 
		Clr  P1.6
		Clr  P1.5
		Clr  P1.4
			
		Call Pulso
			
		Call Atraso
		Ret
;------------------------------------------------------------------------------
;------------------------------- Controle de Exibição -----------------------------------
; O display é ligado, o cursor é ligado
ExibirCont:	Clr P1.7		; |
		Clr P1.6		; |
		Clr P1.5		; |
		Clr P1.4		; | alto nibble definido (0H - hex)

		Call Pulso

		SetB P1.7		; |
		SetB P1.6		; |Define todo o display ON
		SetB P1.5		; |Cursor ON
		SetB P1.4		; |Cursor piscando ON
		Call Pulso

		Call Atraso		; espera BF ser limpo	
		Ret
;--------------------------------------------------------------------------------
;----------------------------- Configuração do Modo de Entrada (modo de 4 bits) ----------------------
;    Definido para incrementar o endereço em um e o cursor deslocado para a direita
ModoEntrada:	Clr P1.7		; |P1.7=0
		Clr P1.6		; |P1.6=0
		Clr P1.5		; |P1.5=0
		Clr P1.4		; |P1.4=0

		Call Pulso

		Clr  P1.7		; |P1.7 = '0'
		SetB P1.6		; |P1.6 = '1'
		SetB P1.5		; |P1.5 = '1'
		Clr  P1.4		; |P1.4 = '0'
 
		Call Pulso

		Call Atraso		; espera BF ser limpo
		Ret
;--------------------------------------------------------------------------------		
;------------------------------------ Pulso --------------------------------------
Pulso:		SetB E		; |*P1.2 está conectado ao pino 'E' do módulo LCD*
		Clr  E		; | borda negativa em E	
		Ret
;---------------------------------------------------------------------------------
;------------------------------------- EnviarCar ----------------------------------			
EnviarCar:	Mov C, ACC.7		; |
		Mov P1.7, C		; |
		Mov C, ACC.6		; |
		Mov P1.6, C		; |
		Mov C, ACC.5		; |
		Mov P1.5, C		; |
		Mov C, ACC.4		; |
		Mov P1.4, C		; | alto nibble definido
		;Jmp $
		Call Pulso

		Mov C, ACC.3		; |
		Mov P1.7, C		; |
		Mov C, ACC.2		; |
		Mov P1.6, C		; |
		Mov C, ACC.1		; |
		Mov P1.5, C		; |
		Mov C, ACC.0		; |
		Mov P1.4, C		; | baixo nibble definido

		Call Pulso

		Call Atraso		; espera BF ser limpo
		
		Mov R1,#55h
		Ret
;--------------------------------------------------------------------------------
;------------------------------------- Atraso ------------------------------------			
Atraso:		Mov R0, #50
		Djnz R0, $
		Ret
;--------------------------------------------------------------------------------				
;---------------------------Varredura do Teclado------------------------------
;------------------------------- Varredura de Linha ---------------------------------------
VarreduraTeclado:	CLR P0.3			;Limpa Linha3
			CALL IDCodigo0		;Chama sub-rotina de varredura de coluna
			SetB P0.3			;Define Linha 3
			JB F0,Feito  		;Se F0 estiver definido, encerra a varredura 
						
			;Varre Linha2
			CLR P0.2			;Limpa Linha2
			CALL IDCodigo1		;Chama sub-rotina de varredura de coluna
			SetB P0.2			;Define Linha 2
			JB F0,Feito			;Se F0 estiver definido, encerra a varredura 						

			;Varre Linha1
			CLR P0.1			;Limpa Linha1
			CALL IDCodigo2		;Chama sub-rotina de varredura de coluna
			SetB P0.1			;Define Linha 1
			JB F0,Feito			;Se F0 estiver definido, encerra a varredura

			;Varre Linha0			
			CLR P0.0			;Limpa Linha0
			CALL IDCodigo3		;Chama sub-rotina de varredura de coluna
			SetB P0.0			;Define Linha 0
			JB F0,Feito			;Se F0 estiver definido, encerra a varredura 
														
			JMP VarreduraTeclado	;Volta para varrer Linha3
							
Feito:		Clr F0		        ;Limpa a bandeira F0 antes de sair
			Ret
;--------------------------------------------------------------------------------			
;---------------------------- Sub-rotina de Varredura de Coluna ----------------------------
IDCodigo0:	JNB P0.4, CodigoChave03	;Se Col0 Linha3 estiver limpa - chave encontrada
			JNB P0.5, CodigoChave13	;Se Col1 Linha3 estiver limpa - chave encontrada
			JNB P0.6, CodigoChave23	;Se Col2 Linha3 estiver limpa - chave encontrada
			RET					

CodigoChave03:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'3'		;Código para '3'
			RET				

CodigoChave13:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'2'		;Código para '2'
			RET				

CodigoChave23:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'1'		;Código para '1'
			RET				

IDCodigo1:	JNB P0.4, CodigoChave02	;Se Col0 Linha2 estiver limpa - chave encontrada
			JNB P0.5, CodigoChave12	;Se Col1 Linha2 estiver limpa - chave encontrada
			JNB P0.6, CodigoChave22	;Se Col2 Linha2 estiver limpa - chave encontrada
			RET					

CodigoChave02:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'6'		;Código para '6'

			RET				

CodigoChave12:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'5'		;Código para '5'
			;Mov P1,R7		;Exibe tecla pressionada
			RET				

CodigoChave22:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'4'		;Código para '4'
			RET				

IDCodigo2:	JNB P0.4, CodigoChave01	;Se Col0 Linha1 estiver limpa - chave encontrada
			JNB P0.5, CodigoChave11	;Se Col1 Linha1 estiver limpa - chave encontrada
			JNB P0.6, CodigoChave21	;Se Col2 Linha1 estiver limpa - chave encontrada
			RET					

CodigoChave01:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'9'		;Código para '9'
			RET				

CodigoChave11:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'8'		;Código para '8'
			RET				

CodigoChave21:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'7'		;Código para '7'
			RET				

IDCodigo3:	JNB P0.4, CodigoChave00	;Se Col0 Linha0 estiver limpa - chave encontrada
			JNB P0.5, CodigoChave10	;Se Col1 Linha0 estiver limpa - chave encontrada
			JNB P0.6, CodigoChave20	;Se Col2 Linha0 estiver limpa - chave encontrada
			RET					

CodigoChave00:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'#'		;Código para '#' 
			RET				

CodigoChave10:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'0'		;Código para '0'
			RET				

CodigoChave20:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'*'	   	;Código para '*' 
			RET		
;--------------------------------------------------------------------------------
;--------------------------------- Verificar Entrada -----------------------------------
VerificarEntrada:	
		Cjne A,07H,Saida	;07H é o registrador R7 - ele contém o código inserido.
		Inc R5
Saida:					
		Ret
;--------------------------------------------------------------------------------			
;-----------------------------------PosicaoCursor------------------------------------------
PosicaoCursor:	Clr RS
		SetB P1.7		; Define o endereço DDRAM
		SetB P1.6		; Define o endereço. O endereço começa aqui - '1'
		Clr P1.5		; 									 '0'
		Clr P1.4		; 									 '0' 
						; alto nibble
		Call Pulso

		Clr P1.7		; 									 '0'
		Clr P1.6		; 									 '0'
		Clr P1.5		; 									 '0'
		Clr P1.4		; 									 '0'
						; baixo nibble
		Call Pulso

		Call Atraso		; espera BF ser limpo	
		Ret	
;--------------------------------------------------------------------------------			
;------------------------------ Aberto ---------------------------------------------
Concedido:	Mov DPTR,#LUT2		;Tabela de consulta para "Acesso Concedido"
Voltar:		Clr A
		Movc A,@A+DPTR
		Jz Casa
		Call EnviarCar
		Inc DPTR
		Jmp	Voltar		
Casa:		Ret	
;--------------------------------------------------------------------------------
;------------------------------ Negado --------------------------------------------
Negado:		Mov DPTR,#LUT3		;Tabela de consulta para "Acesso Negado"
MaisUm:		Clr A
		Movc A,@A+DPTR
		Jz VoltarCasa
		Call EnviarCar
		Inc DPTR	
		Jmp MaisUm
VoltarCasa:	Ret					
;--------------------------------- Fim das sub-rotinas ---------------------------
;------------------------------ Tabela de Consulta (LUT) -----------------------------
;---------------------------------- Mensagens ------------------------------------
		Org 0200h
LUT1:       DB 'E', 'n', 't', 'r', 'a', 'r', ' ', 'P', 'I', 'N',':',0
LUT2:		DB 'A', 'c', 'e', 's', 's', 'o', ' ', 'C', 'o', 'n', 'c', 'e', 'd','i','d','o', 0
LUT3:		DB 'A', 'c', 'e', 's', 's', 'o', ' ', 'N', 'e', 'g', 'a', 'd', 'o', 0
;--------------------------------------------------------------------------------
;------------------------------------- PIN --------------------------------------
		Org 0240h		
LUT4:		DB '1', '8', '1', '2',0
;--------------------------------------------------------------------------------
;--------------------------------- Fim do Programa -------------------------------	
Parar:		Jmp $
	
		End
