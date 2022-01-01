include kk.inc


.MODEL SMALL
.STACK 64
.DATA 


_AX dw 1234h
_BX dw 50H
_CX dw 2H
_DX dw 1000H
_SI dw ?
_DI dw ?
_SP dw ?
_BP dw ?


_00 db 56h
_01 db 78H
_02 db ?
_03 db ?
_04 db ?
_05 db ?
_06 db ?
_07 db ?
_08 db ?
_09 db ?
_A  db ?
_B  db ?
_C  db ?
_D  db ?
_E  db ?
_F  db ? 

command_splited db 5 dup('$') 
Operand1 db 5 dup('$')
Operand2 db 5 dup('$')
Two_Operands_Together_splited db 10 dup('$')   


 
Operand2_Value dw ? 
Operand1_Value dw ?
sizeIndex db 0                                                                             
                                       
                                       
                                           ;MOV [00],AX DONE
                                           ;MOV [00],Al DONE
HASH DW ?                                  ;MOV AX,[00] DONE
HASH_Operand2 DW ?                         ;MOV Al,[00] DONE
HASH_Operand1 DW ?                         ; ADD AX,[00] DONE
                                           ;ADC DX,BX  DONE
command DB 'MOV [00],AXe','$'                ;SUB DX,BX  DONE   ;SBB DX,BX DONE
                                            ;................................................
.code                                       ;DIV CX
MAIN PROC far

    MOV AX,@DATA
	MOV DS,AX
	mov es,ax
    
	DisplayString command
    ;Convert_OP_TO_HEXA Operand1
    CALL split_command
    split_operands Two_Operands_Together_splited Operand1 Operand2
    HASHING command_splited HASH    
    HASHING_op Operand1 HASH_Operand1
    HASHING_op Operand2 HASH_Operand2 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    check_Operand HASH_Operand1 Operand1_Value Operand1 sizeIndex ;; 0 for byte, 1 for word
    ;check_Operand HASH_Operand2 Operand2_Value Operand2 sizeIndex
    CALL check_command                
     
    HLT
	     
MAIN ENDP     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hany

;; split operand and store it in split_command 
;; split operands and store it in Two_Operands_Together_splited
split_command               PROC
    mov SI, offset command
    mov DI, offset command_splited
    mov al,' ' ;; to check space
moving11:	
	MOVSB
	cmp al,[SI]
	jnz moving11
;; Mena	
	mov DI, offset Two_Operands_Together_splited
	mov al,'$' ;; to check end 
	inc SI     ;; to skip space
moving22:
    MOVSB
    cmp al,[SI]
    jnz moving22	

    ret

split_command               ENDP 

check_command                PROC 

    MOV SI,offset HASH 
    MOV DI,offset command_splited  
      
     
    ;; ADD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    CMP [SI],29CH
    jz asdasd
    Jmp CHECK1 
    asdasd:    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADD AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK1:
    
    
    ;; ADC
    
    CMP [SI],299H
     JNZ CHECK2
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADC AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK2:
    
    ;; SUB  
    
    CMP [SI],311H
     JNZ CHECK3
    
    ;; CODE                    
    DisplayString command_splited
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SUB AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    
    
    CHECK3:
    
    ;; SBB   
    
    CMP [SI],2D8H
     JNZ CHECK4
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SBB AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    
    
    
    CHECK4:
    
    ;; DIV   
    
    CMP [SI],2EDH
     JNZ CHECK5
    
    ;; CODE
    
                                                             
                                                                   
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE1
    MOV AX,_AX                                  ;;;;;;    div error div overflow
    DIV BX
                                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,24DH
    
    put_Operand HASH_Operand1 AX sizeIndex                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,25CH
     
                                                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    put_Operand HASH_Operand1 DX sizeIndex
    JMP CONT
                                                                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BYTE1:
    MOV AX,_AX                                                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DIV BL
    
     MOV HASH_Operand1,24DH
                                                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    put_Operand HASH_Operand1 AX sizeIndex
    CONT:
    
    CHECK5:
    
    ;; MUL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    CMP [SI],317H
     JNZ CHECK6
    
      ;; CODE
      
    
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE1
    MOV AX,_AX
    MUL BX
    
    
    MOV HASH_Operand1,24DH
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    MOV HASH_Operand1,25CH
     
                                                             
    put_Operand HASH_Operand1 DX sizeIndex
    JMP CONT
    
    BYTE1:
    MOV AX,_AX 
    MUL BL
    
     MOV HASH_Operand1,24DH
    
    put_Operand HASH_Operand1 AX sizeIndex
    CONT1:
    
    CHECK6:
    
    ;; MOV   
    
    CMP [SI],323H
     JNZ CHECK7
    
    ;; CODE
    put_Operand HASH_Operand1 Operand2_Value sizeIndex  
    
    CHECK7:
    
    ;; XOR   
    
    CMP [SI],343H
     JNZ CHECK8
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    XOR AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK8:
    
    ;; AND   
    
    CMP [SI],2BAH
     JNZ CHECK9
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    AND AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK9:
    
    ;; OR    
    
    CMP [SI],232H
     JNZ CHECK10
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    OR AX,BX
    
     
    
    put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK10:
    
    ;; NOP   
    
    CMP [SI],315H
     JNZ CHECK11
   
    ;; CODE
    
    CHECK11:
    
    ;; SHR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CL CX CH  
    
    CMP [SI],31AH                                                                                           ;   xxxx xxxx xxxx xxxx
     JNZ CHECK15
     
     ;; CODE 
     MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SHR AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    
    
    
    CHECK15:
    
    
    ;; INC   
    
    CMP [SI],2D7H
     JNZ CHECK12
    
    ;; CODE
    MOV AX,Operand1_Value
    
    INC AX
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK12:
    
    ;; DEC   
    
    CMP [SI],2A8H
     JNZ CHECK13
    
    ;; CODE
    MOV AX,Operand1_Value
    
    DEC AX
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK13:
    
    ;; CLC   
    
    CMP [SI],2B9H
     JNZ CHECK14
    
    ;; CODE
    CLC
    
    CHECK14:
    
    ;; SHL   
    
    CMP [SI],308H 
     JNZ CHECK16
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SHL AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK16:
    
    ;; SAR   
    
    CMP [SI],305H 
     JNZ CHECK17
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SAR AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK17:
    
    ;; ROR   
    
    CMP [SI],32BH 
     JNZ CHECK18
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROR AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK18:
    
    ;; RCL   
    
    CMP [SI],2F5H 
     JNZ CHECK19
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     RCL AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK19: 
    
    ;; RCR   
    
    CMP [SI],307H 
     JNZ CHECK20
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     RCR AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK20: 
    
    ;; ROL   
    
    CMP [SI],319H 
     JNZ CHECK21
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROL AX,CL
     
     
     put_Operand HASH_Operand1 AX sizeIndex
    
    CHECK21:
     
    
      
            
    RET

check_command                ENDP  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   


;;Mena



END MAIN
                                                    
