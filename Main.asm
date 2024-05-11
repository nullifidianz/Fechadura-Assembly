Org 0000h


; definição de variaveis
RS	Equ	P1.3
E	Equ	P1.2


Main:
		Clr RS		
		Call ConfigFunc	
		Call ExibeDisplay	
		Call ModoEntrada	
		SetB RS		
		Mov DPTR,#LUT1
		;loop principal
Novamente:	Clr A
		Movc A,@A+DPTR	
		Jz Proximo		
		Call EnviarCar	
		Inc DPTR		
		Jmp Novamente
	
Proximo: Mov R4,#00h	
		Mov R5,#00h	
		Mov DPTR,#LUT4	
Iterar: Call ScanTeclado	
		SetB RS		
		Clr A
		Mov A,#'*'
		Call EnviarCar	
		
		Clr A
		Movc A,@A+DPTR	
		Call VerificarEntrada	
		Inc DPTR
		Inc R4
		Cjne R4,#04h,Iterar
		
		Cjne R5,#04h,Incorreto	
Correto: Call PosicaoCursor  	
		SetB RS		
		Call Concedido
		SETB P3.0 
		CLR P3.1 
		
		MOV R6, #0 
		MOV R7, #150 
		
Temporizar:	DJNZ R7, Temporizar 

		CLR P3.0 

		Jmp FimAqui
Incorreto: Call PosicaoCursor  	
		SetB RS		
		Call Negado
FimAqui: Jmp $
				
ConfigFunc:	Clr  P1.7		
		Clr  P1.6		
		SetB P1.5		
		Clr  P1.4	
		
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
		SetB P1.6		
		SetB P1.5		
		SetB P1.4		
		Call Pulso

		Call Delay			
		Ret

ModoEntrada:	Clr P1.7		
		Clr P1.6		
		Clr P1.5		
		Clr P1.4		

		Call Pulso

		Clr  P1.7		
		SetB P1.6		
		SetB P1.5		
		Clr  P1.4		 
 
		Call Pulso

		Call Delay		
		Ret
		

Pulso:		SetB E		
		Clr  E		
		Ret

		
EnviarCar:	Mov C, ACC.7		
		Mov P1.7, C		
		Mov C, ACC.6		
		Mov P1.6, C		
		Mov C, ACC.5		
		Mov P1.5, C		
		Mov C, ACC.4		
		Mov P1.4, C		
		
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
				


ScanTeclado:	CLR P0.3			
			CALL IDCodigo0		
			SetB P0.3			
			JB F0,Feito  		
						
			CLR P0.2			
			CALL IDCodigo1		
			SetB P0.2			
			JB F0,Feito						

			CLR P0.1			
			CALL IDCodigo2		
			SetB P0.1			
			JB F0,Feito							

			CLR P0.0			
			CALL IDCodigo3		
			SetB P0.0			
			JB F0,Feito														
			JMP ScanTeclado							
							
Feito:		Clr F0		        	
			Ret
		

IDCodigo0:	JNB P0.4, Keycode03	
			JNB P0.5, Keycode13	
			JNB P0.6, Keycode23	
			RET					

Keycode03:	SETB F0			
			Mov R7,#'3'		
			RET				

Keycode13:	SETB F0			
			Mov R7,#'2'		
			RET				

Keycode23:	SETB F0			
			Mov R7,#'1'		
			RET				

IDCodigo1:	JNB P0.4, Keycode02	
			JNB P0.5, Keycode12	
			JNB P0.6, Keycode22	
			RET					

Keycode02:	SETB F0			
			Mov R7,#'6'		

			RET				

Keycode12:	SETB F0			
			Mov R7,#'5'		
			RET				

Keycode22:	SETB F0			
			Mov R7,#'4'		
			RET				

IDCodigo2:	JNB P0.4, Keycode01	
			JNB P0.5, Keycode11	
			JNB P0.6, Keycode21	
			RET					

Keycode01:	SETB F0			
			Mov R7,#'9'		
			RET				

Keycode11:	SETB F0			
			Mov R7,#'8'		
			RET				

Keycode21:	SETB F0			
			Mov R7,#'7'		
			RET				

IDCodigo3:	JNB P0.4, Keycode00	
			JNB P0.5, Keycode10	
			JNB P0.6, Keycode20	
			RET					

Keycode00:	SETB F0			
			Mov R7,#'#'		 
			RET				

Keycode10:	SETB F0			
			Mov R7,#'0'		
			RET				

Keycode20:	SETB F0			
			Mov R7,#'*'	   	
			RET		


VerificarEntrada:	
	Cjne A,07H,Saida	
	Inc R5
Saida:					
	Ret


PosicaoCursor:	
	Clr RS
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


Concedido:	
	Mov DPTR,#LUT2		
Voltar:	
	Clr A
	Movc A,@A+DPTR
	Jz Casa
	Call EnviarCar
	Inc DPTR
	Jmp	Voltar		
Casa:	
	Ret	


Negado:		
	Mov DPTR,#LUT3		
MaisUm:	
	Clr A
	Movc A,@A+DPTR
	Jz VoltarCasa
	Call EnviarCar
	Inc DPTR	
	Jmp MaisUm
VoltarCasa:	
	Ret					

LUT1:       DB 'E', 'n', 't', 'r', 'a', 'r', 32, 'P', 'I', 'N',':',0
LUT2:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'C', 'o', 'n', 'c', 'e', 'd','i','d','o', 0
LUT3:		DB 'A', 'c', 'e', 's', 's', 'o', 32, 'N', 'e', 'g', 'a', 'd', 'o', 0
LUT4:		DB '1', '1', '1', '1',0 ; senha salva

Parar:		
	Jmp $
End
