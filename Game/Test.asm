;;; this file is for testing the macros
include macr.inc 

.model small
	.stack 64
	.data       
	
	Result_2 db ?
	
	Command LABEL BYTE
	Command_size db 15
	Command_Actualsize db ? 
	Command_data db 15 dup('$')
	
	operand1 db 5 dup('$')
	
	operand2 db 5 dup('$')
	
	
	.code     	
	
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,aX ;; for string operations
	
	
	ReadString Command
	 
	
	split_operands Command_data operand1 operand2
	
	DisplayString operand1
	DisplayString operand2
	Check_memorytomemory operand1 operand2 Result_2
	
	
	
	main endp
	
	end main
	
	