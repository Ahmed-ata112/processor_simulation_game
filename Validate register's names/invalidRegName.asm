;include macr.inc
include mmm.txt

.model small
.stack 64
.data
validRegNamesArr db  'AX','BX','CX','DX'
                 db  'AH','AL','BH','BL','CH','CL','DH','DL'
                 db  'CS','IP','SS','SP'
                 db  'BP','SI','DI','DS','ES'   
            

validRegNamesArrSize db  21d 

result db ?                                   
    
    FirstOperand LABEL BYTE ; named the next it the same name 
	FirstOperandSize db 10
	ActualFirstOperandSize db ?
	FirstOperandData db 10 dup('$')  
	
	SecondOperand LABEL BYTE ; named the next it the same name 
	SecondOperandSize db 10
	ActualSecondOperandSize db ?
	SecondOperandData db 10 dup('$')

.code
    main proc far
    mov ax,@data
    mov ds,ax    
    mov es,ax
    readString   firstOperand  
    readString   secondOperand
   
    
      checkOperandsRegistersNames firstoperanddata,secondoperanddata,result  
    
    
    
    
    add result,'0'
      mov ah,2
      mov dl,result
      int 21h

    endp
    end main