Org 0000h

RS	Equ	P1.3
E	Equ	P1.2


Main:
		Clr RS		; RS=0 - Registro de instruções está selecionado.

		Call ConfigFunc	; Configuração da função
	
		Call ExibeDisplay	; Liga o display e o cursor
	
		Call ModoEntrada	; Move o cursor para a direita em 1

		SetB RS		; RS=1
		
		Mov DPTR,#LUT1	; Tabela de consulta para a mensagem "Digite o PIN:"
Novamente:	Clr A
		Movc A,@A+DPTR	; Obtém o caractere
		Jz Proximo		; Sai quando A=0
		Call EnviarCar	; Exibe o caractere
		Inc DPTR		; Aponta para o próximo caractere
		Jmp Novamente
	
Proximo: Mov R4,#00h	; Contador para verificar o número de atualizações
		Mov R5,#00h	; Contador para verificar o número de entradas corretas
		Mov DPTR,#LUT4	; Copia o início da tabela de consulta para o PIN
	
Iterar: Call ScanTeclado	; valida a entrada do teclado
		SetB RS		; RS=1 
		Clr A
		Mov A,#'*'
		Call EnviarCar	; Exibe o asterisco para cada tecla pressionada
		
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
		; Ativa o motor no sentido anti-horário
		SETB P3.0 ; Supondo que P3.0 seja o pino de controle para girar o motor
		CLR P3.1 ; Se necessário, dependendo do seu circuito

		; Inicia temporizador para uma volta e meia
		MOV R6, #0 ; Contador de temporização
		MOV R7, #150 ; Limite para uma volta e meia
		
Temporizar:	DJNZ R7, Temporizar ; Aguarda completar uma volta e meia

		; Desativa o motor
		CLR P3.0 ; Desliga o pino de controle do motor

		Jmp FimAqui
Incorreto: Call PosicaoCursor  	; Coloca o cursor na próxima linha
		SetB RS		; RS=1 - Registro de dados está selecionado.
		Call Negado
FimAqui: Jmp $
				
ConfigFunc:	Clr  P1.7		
		Clr  P1.6		
		SetB P1.5		
		Clr  P1.4		; | (DB4)DL=0 - coloca o módulo LCD em modo de 4 bits 
	
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
		

Pulso:		SetB E		; P1.2 está conectado ao pino 'E' do módulo LCD
		Clr  E		; borda negativa em E	
		Ret

		
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

			
Delay:		Mov R0, #50
		Djnz R0, $
		Ret
				


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
		

IDCodigo0:	JNB P0.4, Keycode03	;Se Col0 Linha3 estiver limpa - chave encontrada
			JNB P0.5, Keycode13	;Se Col1 Linha3 estiver limpa - chave encontrada
			JNB P0.6, Keycode23	;Se Col2 Linha3 estiver limpa - chave encontrada
			RET					

Keycode03:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'3'		;Código para '3'
			RET				

Keycode13:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'2'		;Código para '2'
			RET				

Keycode23:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'1'		;Código para '1'
			RET				

IDCodigo1:	JNB P0.4, Keycode02	;Se Col0 Linha2 estiver limpa - chave encontrada
			JNB P0.5, Keycode12	;Se Col1 Linha2 estiver limpa - chave encontrada
			JNB P0.6, Keycode22	;Se Col2 Linha2 estiver limpa - chave encontrada
			RET					

Keycode02:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'6'		;Código para '6'

			RET				

Keycode12:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'5'		;Código para '5'
			;Mov P1,R7		;Exibe tecla pressionada
			RET				

Keycode22:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'4'		;Código para '4'
			RET				

IDCodigo2:	JNB P0.4, Keycode01	
			JNB P0.5, Keycode11	
			JNB P0.6, Keycode21	
			RET					

Keycode01:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'9'		;Código para '9'
			RET				

Keycode11:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'8'		;Código para '8'
			RET				

Keycode21:	SETB F0			;Chave encontrada - define F0
			Mov R7,#'7'		;Código para '7'
			RET				

IDCodigo3:	JNB P0.4, Keycode00	; Se Col0 Linha0 estiver limpa - chave encontrada
			JNB P0.5, Keycode10	; Se Col1 Linha0 estiver limpa - chave encontrada
			JNB P0.6, Keycode20	; Se Col2 Linha0 estiver limpa - chave encontrada
			RET					

Keycode00:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'#'		;Código para '#' 
			RET				

Keycode10:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'0'		;Código para '0'
			RET				

Keycode20:	SETB F0			; Chave encontrada - define F0
			Mov R7,#'*'	   	;Código para '*' 
			RET		


VerificarEntrada:	
		Cjne A,07H,Saida	
		Inc R5
Saida:					
		Ret


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


Concedido:	Mov DPTR,#LUT2		;Tabela de consulta para "Acesso Concedido"
Voltar:		Clr A
		Movc A,@A+DPTR
		Jz Casa
		Call EnviarCar
		Inc DPTR
		Jmp	Voltar		
Casa:		Ret	


Negado:		Mov DPTR,#LUT3		;Tabela de consulta para "Acesso Negado"
MaisUm:		Clr A
		Movc A,@A+DPTR
		Jz VoltarCasa
		Call EnviarCar
		Inc DPTR	
		Jmp MaisUm
VoltarCasa:	Ret					

		Org 0200h
LUT1:       DB 'E', 'n', 't', 'r', 'a', 'r', 32, 'P', 'I', 'N',':',0
LUT2:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'C', 'o', 'n', 'c', 'e', 'd','i','d','o', 0
LUT3:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'N', 'e', 'g', 'a', 'd', 'o', 0


		Org 0240h		
LUT4:		DB '1', '3', '1', '2',0 ; mude de acordo com a necessidade
	
Parar:		Jmp $
	
		End
