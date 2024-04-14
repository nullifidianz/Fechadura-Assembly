      Org 0000h
       
      RS	Equ	P1.3
      E	Equ	P1.2
       
      ; ---------------------------------- Main -------------------------------------
      Main:
0000| 		Clr RS		; RS=0 - Registro de instruções está selecionado.
       
0002| 		Call ConfigFunc	; Configuração da função
      	
0004| 		Call ExibeDisplay	; Liga o display e o cursor
      	
0006| 		Call ModoEntrada	; Move o cursor para a direita em 1
       
0008| 		SetB RS		; RS=1
      		
000A| 		Mov DPTR,#LUT1	; Tabela de consulta para a mensagem "Digite o PIN:"
000D| Novamente:	Clr A
000E| 		Movc A,@A+DPTR	; Obtém o caractere
000F| 		Jz Proximo		; Sai quando A=0
0011| 		Call EnviarCar	; Exibe o caractere
0013| 		Inc DPTR		; Aponta para o próximo caractere
0014| 		Jmp Novamente
      	
0016| Proximo: Mov R4,#00h	; Contador para verificar o número de atualizações
0018| 		Mov R5,#00h	; Contador para verificar o número de entradas corretas
001A| 		Mov DPTR,#LUT4	; Copia o início da tabela de consulta para o PIN
      ;----------------------------------- Obter Entrada ----------------------------------		
001D| Iterar: Call ScanTeclado	; valida a entrada do teclado
001F| 		SetB RS		; RS=1 
0021| 		Clr A
0022| 		Mov A,#'*'
0024| 		Call EnviarCar	; Exibe o asterisco para cada tecla pressionada
      ;------------------- Verifica PINS corretos inseridos ---------------		
0026| 		Clr A
0027| 		Movc A,@A+DPTR	; Tabela de consulta do PIN
0028| 		Call VerificarEntrada	; Verifica o número de entradas corretas
002A| 		Inc DPTR
002B| 		Inc R4
002C| 		Cjne R4,#04h,Iterar
      		
002F| 		Cjne R5,#04h,Incorreto	; Verifica o número de entradas corretas
0032| Correto: Call PosicaoCursor  	; Coloca o cursor na próxima linha
0034| 		SetB RS		; RS=1 - Registro de dados está selecionado.
0036| 		Call Concedido
0038| 		Jmp FimAqui
003A| Incorreto: Call PosicaoCursor  	; Coloca o cursor na próxima linha
003C| 		SetB RS		; RS=1 - Registro de dados está selecionado.
003E| 		Call Negado
0040| FimAqui: Jmp $
      ;-------------------------------- Sub-rotinas ---------------------------------				
0042| ConfigFunc:	Clr  P1.7		
0044| 		Clr  P1.6		
0046| 		SetB P1.5		
0048| 		Clr  P1.4		; | (DB4)DL=0 - coloca o módulo LCD em modo de 4 bits 
      	
004A| 		Call Pulso
       
004C| 		Call Delay		
       
004E| 		Call Pulso
      							
0050| 		SetB P1.7		 
0052| 		Clr  P1.6
0054| 		Clr  P1.5
0056| 		Clr  P1.4
      			
0058| 		Call Pulso
      			
005A| 		Call Delay
005C| 		Ret
      ;------------------------------------------------------------------------------
      ;------------------------------- Controle de Exibição -----------------------------------
      ; O display é ligado, o cursor é ligado
005D| ExibeDisplay:	Clr P1.7		 
005F| 		Clr P1.6		 
0061| 		Clr P1.5		 
0063| 		Clr P1.4	  
       
0065| 		Call Pulso
       
0067| 		SetB P1.7		
0069| 		SetB P1.6		; Define todo o display ON
006B| 		SetB P1.5		; Cursor ON
006D| 		SetB P1.4		; Cursor piscando ON
006F| 		Call Pulso
       
0071| 		Call Delay			
0073| 		Ret
      ;--------------------------------------------------------------------------------
      ;----------------------------- Configuração do Modo de Entrada (modo de 4 bits) ----------------------
      ;    Definido para incrementar o endereço em um e o cursor deslocado para a direita
0074| ModoEntrada:	Clr P1.7		; P1.7=0
0076| 		Clr P1.6		; P1.6=0
0078| 		Clr P1.5		; P1.5=0
007A| 		Clr P1.4		; P1.4=0
       
007C| 		Call Pulso
       
007E| 		Clr  P1.7		; P1.7 = '0'
0080| 		SetB P1.6		; P1.6 = '1'
0082| 		SetB P1.5		; P1.5 = '1'
0084| 		Clr  P1.4		; P1.4 = '0'
       
0086| 		Call Pulso
       
0088| 		Call Delay		
008A| 		Ret
      		
      ;------------------------------------ Pulso --------------------------------------
008B| Pulso:		SetB E		; P1.2 está conectado ao pino 'E' do módulo LCD
008D| 		Clr  E		; borda negativa em E	
008F| 		Ret
       
      ;------------------------------------- EnviaChar----------------------------------			
0090| EnviarCar:	Mov C, ACC.7		
0092| 		Mov P1.7, C		
0094| 		Mov C, ACC.6		
0096| 		Mov P1.6, C		
0098| 		Mov C, ACC.5		
009A| 		Mov P1.5, C		
009C| 		Mov C, ACC.4		
009E| 		Mov P1.4, C		
      		;Jmp $
00A0| 		Call Pulso
       
00A2| 		Mov C, ACC.3		
00A4| 		Mov P1.7, C		
00A6| 		Mov C, ACC.2		
00A8| 		Mov P1.6, C		
00AA| 		Mov C, ACC.1		
00AC| 		Mov P1.5, C		
00AE| 		Mov C, ACC.0		
00B0| 		Mov P1.4, C		
       
00B2| 		Call Pulso
       
00B4| 		Call Delay		
      		
00B6| 		Mov R1,#55h
00B8| 		Ret
       
      ;------------------------------------- Delay ------------------------------------			
00B9| Delay:		Mov R0, #50
00BB| 		Djnz R0, $
00BD| 		Ret
      				
      ;--------------------------- Scan do Teclado------------------------------
       
00BE| ScanTeclado:	CLR P0.3			;Limpa Linha3
00C0| 			CALL IDCodigo0		;Chama sub-rotina de scan de coluna
00C2| 			SetB P0.3			;Define Linha 3
00C4| 			JB F0,Feito  		;Se F0 estiver definido, encerra o scan
      						
      			;Varre Linha2
00C7| 			CLR P0.2			;Limpa Linha2
00C9| 			CALL IDCodigo1		;Chama sub-rotina de scan de coluna
00CB| 			SetB P0.2			;Define Linha 2
00CD| 			JB F0,Feito			;Se F0 estiver definido, encerra o scan					
       
      			;Varre Linha1
00D0| 			CLR P0.1			;Limpa Linha1
00D2| 			CALL IDCodigo2		;Chama sub-rotina de scan de coluna
00D4| 			SetB P0.1			;Define Linha 1
00D6| 			JB F0,Feito			;Se F0 estiver definido, encerra o scan
       
      			;Varre Linha0			
00D9| 			CLR P0.0			;Limpa Linha0
00DB| 			CALL IDCodigo3		;Chama sub-rotina de varredura de coluna
00DD| 			SetB P0.0			;Define Linha 0
00DF| 			JB F0,Feito			;Se F0 estiver definido, encerra o scan
      														
00E2| 			JMP ScanTeclado	;Volta para o scan para linha 3
      							
00E4| Feito:		Clr F0		        ;Limpa F0 antes de sair
00E6| 			Ret
      		
      ;---------------------------- Sub-rotina de Varredura de Coluna ----------------------------
00E7| IDCodigo0:	JNB P0.4, Keycode03	;Se Col0 Linha3 estiver limpa - chave encontrada
00EA| 			JNB P0.5, Keycode13	;Se Col1 Linha3 estiver limpa - chave encontrada
00ED| 			JNB P0.6, Keycode23	;Se Col2 Linha3 estiver limpa - chave encontrada
00F0| 			RET					
       
00F1| Keycode03:	SETB F0			;Chave encontrada - define F0
00F3| 			Mov R7,#'3'		;Código para '3'
00F5| 			RET				
       
00F6| Keycode13:	SETB F0			;Chave encontrada - define F0
00F8| 			Mov R7,#'2'		;Código para '2'
00FA| 			RET				
       
00FB| Keycode23:	SETB F0			;Chave encontrada - define F0
00FD| 			Mov R7,#'1'		;Código para '1'
00FF| 			RET				
       
0100| IDCodigo1:	JNB P0.4, Keycode02	;Se Col0 Linha2 estiver limpa - chave encontrada
0103| 			JNB P0.5, Keycode12	;Se Col1 Linha2 estiver limpa - chave encontrada
0106| 			JNB P0.6, Keycode22	;Se Col2 Linha2 estiver limpa - chave encontrada
0109| 			RET					
       
010A| Keycode02:	SETB F0			;Chave encontrada - define F0
010C| 			Mov R7,#'6'		;Código para '6'
       
010E| 			RET				
       
010F| Keycode12:	SETB F0			;Chave encontrada - define F0
0111| 			Mov R7,#'5'		;Código para '5'
      			;Mov P1,R7		;Exibe tecla pressionada
0113| 			RET				
       
0114| Keycode22:	SETB F0			;Chave encontrada - define F0
0116| 			Mov R7,#'4'		;Código para '4'
0118| 			RET				
       
0119| IDCodigo2:	JNB P0.4, Keycode01	
011C| 			JNB P0.5, Keycode11	
011F| 			JNB P0.6, Keycode21	
0122| 			RET					
       
0123| Keycode01:	SETB F0			;Chave encontrada - define F0
0125| 			Mov R7,#'9'		;Código para '9'
0127| 			RET				
       
0128| Keycode11:	SETB F0			;Chave encontrada - define F0
012A| 			Mov R7,#'8'		;Código para '8'
012C| 			RET				
       
012D| Keycode21:	SETB F0			;Chave encontrada - define F0
012F| 			Mov R7,#'7'		;Código para '7'
0131| 			RET				
       
0132| IDCodigo3:	JNB P0.4, Keycode00	; Se Col0 Linha0 estiver limpa - chave encontrada
0135| 			JNB P0.5, Keycode10	; Se Col1 Linha0 estiver limpa - chave encontrada
0138| 			JNB P0.6, Keycode20	; Se Col2 Linha0 estiver limpa - chave encontrada
013B| 			RET					
       
013C| Keycode00:	SETB F0			; Chave encontrada - define F0
013E| 			Mov R7,#'#'		;Código para '#' 
0140| 			RET				
       
0141| Keycode10:	SETB F0			; Chave encontrada - define F0
0143| 			Mov R7,#'0'		;Código para '0'
0145| 			RET				
       
0146| Keycode20:	SETB F0			; Chave encontrada - define F0
0148| 			Mov R7,#'*'	   	;Código para '*' 
014A| 			RET		
       
      ;--------------------------------- Verificar Entrada -----------------------------------
      VerificarEntrada:	
014B| 		Cjne A,07H,Saida	
014E| 		Inc R5
      Saida:					
014F| 		Ret
       
      ;-----------------------------------PosicaoCursor------------------------------------------
0150| PosicaoCursor:	Clr RS
0152| 		SetB P1.7		
0154| 		SetB P1.6		
0156| 		Clr P1.5											 
0158| 		Clr P1.4		 									 
      						
015A| 		Call Pulso
       
015C| 		Clr P1.7		 									 
015E| 		Clr P1.6											 
0160| 		Clr P1.5											 
0162| 		Clr P1.4		 									 
      						
0164| 		Call Pulso
       
0166| 		Call Delay			
0168| 		Ret	
       
      ;------------------------------ Aberto ---------------------------------------------
0169| Concedido:	Mov DPTR,#LUT2		;Tabela de consulta para "Acesso Concedido"
016C| Voltar:		Clr A
016D| 		Movc A,@A+DPTR
016E| 		Jz Casa
0170| 		Call EnviarCar
0172| 		Inc DPTR
0173| 		Jmp	Voltar		
0175| Casa:		Ret	
       
      ;------------------------------ Negado --------------------------------------------
0176| Negado:		Mov DPTR,#LUT3		;Tabela de consulta para "Acesso Negado"
0179| MaisUm:		Clr A
017A| 		Movc A,@A+DPTR
017B| 		Jz VoltarCasa
017D| 		Call EnviarCar
017F| 		Inc DPTR	
0180| 		Jmp MaisUm
0182| VoltarCasa:	Ret					
      ;------------------------------ Tabela LUT -----------------------------
      ;---------------------------------- Mensagens ------------------------------------
      		Org 0200h
      LUT1:       DB 'E', 'n', 't', 'r', 'a', 'r', ' ', 'P', 'I', 'N',':',0
      LUT2:		DB 'A', 'c', 'e', 's', 's', 'o', ' ', 'C', 'o', 'n', 'c', 'e', 'd','i','d','o', 0
      LUT3:		DB 'A', 'c', 'e', 's', 's', 'o', ' ', 'N', 'e', 'g', 'a', 'd', 'o', 0
       
      ;------------------------------------- PIN --------------------------------------
      		Org 0240h		
      LUT4:		DB '1', '8', '1', '2',0 ; mude de acordo com a necessidade
      ;--------------------------------- Fim do Programa -------------------------------	
0245| Parar:		Jmp $
      	
      		End
