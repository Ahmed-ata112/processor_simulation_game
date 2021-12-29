;; Hany && Mena

include Ex_macr.inc
    extrn L_AX: word 
    extrn L_BX: word
    extrn L_CX: word 
    extrn L_DX: word
    extrn L_SI: word
    extrn L_DI: word
    extrn L_SP: word
    extrn L_BP: word
    extrn ;;DA: bytegment
    extrn L_00: byte
    extrn L_01: byte
    extrn L_02: byte
    extrn L_03: byte
    extrn L_04: byte
    extrn L_05: byte
    extrn L_06: byte
    extrn L_07: byte
    extrn L_08: byte
    extrn L_09: byte
    extrn L_A : byte    
    extrn L_B : byte    
    extrn L_C : byte    
    extrn L_D : byte    
    extrn L_E : byte    
    extrn L_F : byte
    extrn L_command : byte
    extrn L_commandData : byte
    public ex_MAIN
.MODEL SMALL
.STACK 64
.DATA 




command_splited db 5 dup('$') 
Operand1 db 5 dup('$')
Operand2 db 5 dup('$')
Two_Operands_Together_splited db 10 dup('$')   


 
Operand2_Value dw ? 
Operand1_Value dw ?
sizeIndex db 0                                                                             
                                       
                                       
                                           ;MOV [00],AX DONE
HASH_Operand DW ?
Operand_Value DW ?
Operand DB 5 dup('$')
                                           ;MOV [00],Al DONE
HASH_comand DW ?                                  ;MOV AX,[00] DONE
HASH_Operand2 DW ?                         ;MOV Al,[00] DONE
HASH_Operand1 DW ?                         ; ADD AX,[00] DONE
                                           ;ADC DX,BX  DONE
;L_commandData DB 'MOV [00],AXe','$'                ;SUB DX,BX  DONE   ;SBB DX,BX DONE
                                            ;................................................
.code                                       ;DIV CX
ex_MAIN PROC far

    MOV AX,@DATA
	MOV DS,AX
	mov es,ax
    
	;DisplayString command
    ;Convert_OP_TO_HEXA Operand1
    CALL split_command
    split_operands Two_Operands_Together_splited Operand1 Operand2
    HASHING command_splited HASH_comand    
    HASHING_op Operand1 HASH_Operand1
    HASHING_op Operand2 HASH_Operand2 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV AX,HASH_Operand1

    MOV HASH_Operand,AX




    MOV SI,offset Operand1
    MOV DI, offset Operand
    MOV CX,5
    REP STOSB

    CALL check_Operand     ;; 0 for byte, 1 for word

    MOV AX, Operand_Value
    MOV Operand1_Value,AX 


    MOV AX,HASH_Operand2

    MOV HASH_Operand,AX


    MOV SI,offset Operand2
    MOV DI, offset Operand
    MOV CX,5
    REP STOSB

    CALL check_Operand

    MOV AX, Operand_Value
    MOV Operand2_Value,AX 
    
    
    CALL check_command                
    ;;Dont Use HLT
    MOV AH,4CH
	INT 21H ;GO BACK TO DOS ;to end the program
	     
ex_MAIN ENDP     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 

;; split operand and store it in split_command 
;; split operands and store it in Two_Operands_Together_splited
split_command               PROC
    mov SI, offset L_commandData
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

    MOV SI,offset HASH_comand 
    MOV DI,offset command_splited  
      
     
    ;; ADD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    CMP [SI],29CH
    jz asdasd
    Jmp CHECK1 
    asdasd:    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADD AX,BX
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand
    
    CHECK1:
    
    
    ;; ADC
    
    CMP [SI],299H


     JNZ CHECK2
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADC AX,BX
    
     

    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    CHECK2:
    
    ;; SUB  
    
    CMP [SI],311H
     JNZ CHECK3
    
    ;; CODE                    
    DisplayString command_splited
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SUB AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    
    CHECK3:
    
    ;; SBB   
    
    CMP [SI],2D8H
     JNZ CHECK4
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SBB AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    
    
    CHECK4:
    
    ;; DIV   
    
    CMP [SI],2EDH
     JNZ CHECK5
    
    ;; CODE
    
                                                             
                                                                   
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE1
    MOV AX,L_AX                                  ;;;;;;    div error div overflow
    DIV BX
                                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,24DH
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,25CH
     
                                                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,DX

    CALL put_Operand
    JMP CONT
                                                                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BYTE1:
    MOV AX,L_AX                                                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DIV BL
    
     MOV HASH_Operand1,24DH
                                                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand
    CONT:
    
    CHECK5:
    
    ;; MUL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    CMP [SI],317H
     JNZ CHECK6
    
      ;; CODE
      
    
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE11
    MOV AX,L_AX
    MUL BX
    
    
    MOV HASH_Operand1,24DH
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    MOV HASH_Operand1,25CH
     
                                                             
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,DX

    CALL put_Operand    
    JMP CONT
    
    BYTE11:
    MOV AX,L_AX 
    MUL BL
    
     MOV HASH_Operand1,24DH
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    CONT1:
    
    CHECK6:
    
    ;; MOV   
    
    CMP [SI],323H
     JNZ CHECK7
    
    ;; CODE
    MOV AX,Operand2_Value
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    CHECK7:
    
    ;; XOR   
    
    CMP [SI],343H
     JNZ CHECK8
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    XOR AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand        
    CHECK8:
    
    ;; AND   
    
    CMP [SI],2BAH
     JNZ CHECK9
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    AND AX,BX
    
     
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK9:
    
    ;; OR    
    
    CMP [SI],232H
     JNZ CHECK10
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    OR AX,BX
    
     
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
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
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    
    
    
    CHECK15:
    
    
    ;; INC   
    
    CMP [SI],2D7H
     JNZ CHECK12
    
    ;; CODE
    MOV AX,Operand1_Value
    
    INC AX
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK12:
    
    ;; DEC   
    
    CMP [SI],2A8H
     JNZ CHECK13
    
    ;; CODE
    MOV AX,Operand1_Value
    
    DEC AX
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
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
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK16:
    
    ;; SAR   
    
    CMP [SI],305H 
     JNZ CHECK17
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SAR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK17:
    
    ;; ROR   
    
    CMP [SI],32BH 
     JNZ CHECK18
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK18:
    
    ;; RCL   
    
    CMP [SI],2F5H 
     JNZ CHECK19
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     RCL AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK19: 
    
    ;; RCR   
    
    CMP [SI],307H 
     JNZ CHECK20
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     RCR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK20: 
    
    ;; ROL   
    
    CMP [SI],319H 
     JNZ CHECK21
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROL AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK21:  
    RET
check_command                ENDP  


check_Operand proc      

    MOV SI,offset HASH_Operand 
     
    ;; AX
    
    CMP [SI],24dH
    JNZ CHECKBX
    
    mov ax,L_AX;; CODE       
    mov Operand_Value,ax
    mov sizeIndex,1h 
    jmp end

    CHECKBX:
    
    
    ;; BX
    
    CMP [SI],252H
     JNZ CHECKCX
    
    mov ax,L_BX;; CODE                                               
     mov Operand_Value,ax 
     mov sizeIndex,1h
    jmp end

    CHECKCX:
    
    ;; CX 
    
    CMP [SI],257H
    jz continue1
     jmp CHECKDX
    continue1:
    mov ax,L_CX;; CODE
     mov Operand_Value,ax 
     mov sizeIndex,1h                   
    jmp end
    CHECKDX:
    
    ;; DX   
                                    
    CMP [SI],25cH
     JNZ CHECKSI
    
    mov ax,L_DX;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp end
    CHECKSI:
    
    ;; SI   
    
    CMP [SI],27aH
     JNZ CHECKDI
    
    mov ax,L_SI;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp end
    CHECKDI:
    
    ;;  ja
    ;; jbe + jmp
    ;; DI   
    
    CMP [SI],22fH
     JNZ CHECKSP
    
    mov ax,L_DI;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp end
    CHECKSP:
    
    ;; SP   
    
    CMP [SI],28fH
     JNZ CHECKBP
    
    mov ax,L_SP;; CODE
     mov Operand_Value,ax 
     mov sizeIndex,1h
    jmp end
    CHECKBP:
    
    ;; BP   
    
    CMP [SI],23aH
     JNZ CHECKAL
    
    mov ax,L_BP;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp end
    CHECKAL:
    
    ;; AL    
    
    CMP [SI],229H
     JNZ CHECKBL
    
    mov ax,L_AX;; CODE
    mov Ah,00H
    mov Operand_Value,ax
    ;mov sizeIndex,0h
    jmp end
    CHECKBL:
    
    ;; BL    
    
    CMP [SI],22eH
     JNZ CHECKCL
    
    mov ax,L_BX;; CODE
    MOV AH,00H 
     mov Operand_Value,ax 
       ;mov sizeIndex,0h
    jmp end
    CHECKCL:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL
   
    mov ax,L_CX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKDL:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH
    
    mov ax,L_DX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKAH:
    
    
    ;; AH  
    
    CMP [SI],21dH
     JNZ CHECKBH
    
    mov ax,L_AX;; CODE
    MOV AL,AH
    MOV AH,00H                              
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKBH:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH
    
    mov ax,L_BX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKCH:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH
    
    mov ax,L_CX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKDH:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK00
     
    mov ax,L_DX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECK00:
    
    ;; 00  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TO CHECK
    
    CMP [SI],3feH 
    JNZ CHECK01
    movml00: 
    mov aL,L_00
    MOV AH,L_01                                          
    mov Operand_Value,ax
    jmp end
    CHECK01:
    
;     ;; 01  
    
    CMP [SI],401H 
    JNZ CHECK02
     movml1:
    mov aL,L_01
    MOV AH,L_02
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp end
    CHECK02:
    
;     ;; 02  
    
    CMP [SI],404H 
     JNZ CHECK03
      movml2:
    mov aL,L_02
    MOV AH,L_03 
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp end
    CHECK03:
    
;     ;; 03  
    
    CMP [SI],407H 
     JNZ CHECK04
      movml3:
    mov aL,L_03
    MOV AH,L_04
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
     jmp end
    CHECK04:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK05
       movml4:
    mov aL,L_04
    MOV AH,L_05
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end    
    CHECK05:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK06
      movml5:
    mov aL,L_05
    MOV AH,L_06 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end    
    CHECK06:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK07
      movml6:
    mov aL,L_06
    MOV AH,L_07 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end    
    CHECK07:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK08
      movml7:
    mov aL,L_07
    MOV AH,L_08 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end   
    CHECK08:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK09
      movml8:
    mov aL,L_08
    MOV AH,L_09
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end       
    CHECK09:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA
      movml9:
    mov aL,L_09
    MOV AH,L_A 
     mov Operand_Value,ax 
  ;mov sizeIndex,0h
 jmp end    
    CHECKA:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB
      movmlA:
    mov aL,L_A
    MOV AH,L_B 
     mov Operand_Value,aX
  ;mov sizeIndex,0h
 jmp end     
    CHECKB:
    
;     ;; B  
    
    CMP [SI],3a4H 
     JNZ CHECKC
      movmlB:
    mov aL,L_B
    MOV AH,L_C 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end     
    CHECKC:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD
      movmlC:
    mov aL,L_C
    MOV AH,L_D
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end     
    CHECKD:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE
      movmlD:
    mov aL,L_D
    MOV AH,L_E
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end     
    CHECKE:
    
;     ;; E  
   
     CMP [SI],3adH 
      JNZ CHECKF
       movmlE:
     mov aL,L_E
     MOV AH,L_F
      mov Operand_Value,ax
        ;mov sizeIndex,0h 
  jmp end         
     CHECKF:
   
     ;; F  
   
     CMP [SI],3b0H 
     JNZ CHECKmlSI 
     movmlF:
     mov aL,L_F
     MOV AH,L_00
     mov Operand_Value,ax
       ;mov sizeIndex,0h 
     jmp end 
         
     CHECKmlSI:
    
                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
         ;                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
      ;[SI]
    CMP [SI],4b2H 
    jz as1
     jmp CHECKmlDI
     as1:   
    
    ;;
     cmp L_SI,0H

     jnz escape1
     jmp movml00 
     escape1:

     cmp L_SI,1H
     jnz escape2
     jmp movml1 
     escape2:
      
     cmp L_SI,2H

     jnz escape3
     jmp movml2 
     escape3:


     cmp L_SI,3H

     jnz escape4
     jmp movml3 
     escape4:

      
     cmp L_SI,4H
     jnz escape5
     jmp movml4 
     escape5:
      
     cmp L_SI,5H

    jnz escape6
     jmp movml5
     escape6:

     cmp L_SI,6H
jnz escape7
     jmp movml6
     escape7:

     cmp L_SI,7H

jnz escape8
     jmp movml7
     escape8:

     cmp L_SI,8H


jnz escape9
     jmp movml8
     escape9:

     cmp L_SI,9H


     jnz escape10
     jmp movml9
     escape10:

     cmp L_SI,0AH

    jnz escape11
     jmp movmlA
     escape11:

     cmp L_SI,0BH

    jnz escape12
     jmp movmlB
     escape12:

     cmp L_SI,0CH
jnz escape13
     jmp movmlc
     escape13:     
     
     cmp L_SI,0DH
jnz escape14
     jmp movmlE
     escape14:     
     cmp L_SI,0EH

    jnz escape15
     jmp movmlE
     escape15:

     cmp L_SI,0FH
     jnz escape16
     jmp movmlF
     escape16:



    ; ;
    
     ;RegisterIndirect_Addressing_Mode _SI 
         jmp end              
     CHECKmlDI:
        ; ;; [DI]
         CMP [SI],485H  
         jnz escape17
     jmp CHECKmlBX
     escape17:

    

     cmp L_DI,0H
   jnz escape18
     jmp movml00
     escape18:

                     
     cmp L_DI,1H
     jnz escape19
     jmp movml1
     escape19:
    
     cmp L_DI,2H
       jnz escape20
     jmp movml2
     escape20:

     cmp L_DI,3H
      jnz escape21
     jmp movml3
     escape21:

     cmp L_DI,4H
       jnz escape22
     jmp movml4
     escape22:
   
     cmp L_DI,5H
     jnz escape23
     jmp movml5
     escape23:
    
     cmp L_DI,6H
      jnz escape24
     jmp movml6
     escape24:
 
     cmp L_DI,7H
      jnz escape25
     jmp movml7
     escape25:
    
     cmp L_DI,8H
     jnz escape26
     jmp movml8
     escape26:
   
     cmp L_DI,9H
      jnz escape27
     jmp movml9
     escape27:
    
     cmp L_DI,0AH
        jnz escape28
     jmp movmlA
     escape28:
     
     cmp L_DI,0BH
        jnz escape29
     jmp movmlB
     escape29:
     
     cmp L_DI,0CH
        jnz escape30
     jmp movmlC
     escape30:
  
     cmp L_DI,0DH
        jnz escape31
     jmp movmlD
     escape31:
  
     cmp L_DI,0EH
      jnz escape32
     jmp movmlE
     escape32:
     
     cmp L_DI,0FH
      jnz escape33
     jmp movmlF
     escape33:
 
    ; ;
    
     ;RegisterIndirect_Addressing_Mode _DI
                     
               
     CHECKmlBX:
         ;; [BX] 
     CMP [SI],4acH 
      jnz escape34
     jmp CHECKdata
     escape34:
        
         ;
     cmp L_BX,0H
     jnz escape35
     jmp movml00
     escape35:
                    
     cmp L_BX,1H
     jnz escape36
     jmp movml1
     escape36:
     
     cmp L_BX,2H
     jnz escape37
     jmp movml2
     escape37:
   
     cmp L_BX,3H
      jnz escape38
     jmp movml3
     escape38:
    
     cmp L_BX,4H
      jnz escape39
     jmp movml4
     escape39:

     cmp L_BX,5H
      jnz escape40
     jmp movml5
     escape40:

     cmp L_BX,6H
     jnz escape41
     jmp movml6
     escape41:

     cmp L_BX,7H
     jnz escape42
     jmp movml7
     escape42:
  
     cmp L_BX,8H
     jnz escape43
     jmp movml8
     escape43:
   
     cmp L_BX,9H
      jnz escape44
     jmp movml9
     escape44:

     cmp L_BX,0AH
    jnz escape45
     jmp movmlA
     escape45:
  
     cmp L_BX,0BH
     jnz escape46
     jmp movmlB
     escape46:
   
     cmp L_BX,0CH
     jnz escape47
     jmp movmlC
     escape47:
 
     cmp L_BX,0DH
      jnz escape48
     jmp movmlD
     escape48:

     cmp L_BX,0EH
      jnz escape49
     jmp movmlE
     escape49:
  
    cmp L_BX,0FH
     jnz escape50
     jmp movmlF
     escape50:
   
   
    
    ; ;RegisterIndirect_Addressing_Mode _BX                                               
   CHECKdata:
    Convert_OP_TO_HEXA Operand 
    mov Operand_Value,ax
 
    end:
            
    ret

ENDp check_Operand


put_Operand PROC

    MOV SI,offset HASH_Operand 
    mov cl,sizeIndex
    mov ch,1h
     
    ;; AX
    
    CMP [SI],24dH
    jz con1
    Jmp CHECKBX1
    con1:    
    mov ax,Operand_Value;; CODE
    mov L_AX,ax 
    jmp end1

    CHECKBX1:
    
    
    ;; BX
    
    CMP [SI],252H
    jz con2

     Jmp CHECKCX1
    con2:
    mov ax,Operand_Value;; CODE
     mov L_BX,ax
    jmp end1

    CHECKCX1:
    
    ;; CX 
    
    CMP [SI],257H
    jz con3
     Jmp CHECKDX1
    con3:
    mov ax,Operand_Value;; CODE
     mov L_CX,ax                    
    jmp end1
    CHECKDX1:
                                                                           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; DX   
                                    
    CMP [SI],25cH
    jz con4
    jmp CHECKSI1
    con4:
    mov ax,Operand_Value;; CODE
     mov L_DX,ax
    jmp end1
    CHECKSI1:
    
    ;; SI   
    
    CMP [SI],27aH
    jz con5
     Jmp CHECKDI1
    con5:
    mov ax,Operand_Value;; CODE
     mov L_SI,ax
    jmp end1
    CHECKDI1:
    
    ;; DI   
    
    CMP [SI],22fH
    jz con6
     Jmp CHECKSP1
    con6:
    mov ax,Operand_Value;; CODE
     mov L_DI,ax
    jmp end1
    CHECKSP1:
    
    ;; SP   
    
    CMP [SI],28fH
    jz con7
     Jmp CHECKBP1
    con7:
    mov ax,Operand_Value;; CODE
     mov L_SP,ax
    jmp end1
    CHECKBP1:
    
    ;; BP   
    
    CMP [SI],23aH
    jz con8
    Jmp CHECKAL1
    con8:
    mov ax,Operand_Value;; CODE
     mov L_BP,ax
    jmp end1
    CHECKAL1:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; AL   
    
    CMP [SI],229H
     jz con9
     Jmp CHECKBL1
    con9:
    mov ax,Operand_Value;; CODE 
    mov bx,L_AX
    mov bl,al
     mov L_AX,bx
    jmp end1
    CHECKBL1:
    
    ;; BL    
    
    CMP [SI],22eH
    jz con10
     Jmp CHECKCL1
    con10:
    mov ax,Operand_Value;; CODE 
    mov bx,L_BX
    mov bl,al
    mov _bX,bx
    jmp end1
    CHECKCL1:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL1
   
    mov ax,Operand_Value;; CODE
     mov bx,L_CX
    mov bl,al
     mov L_CX,bx
    jmp end1
    CHECKDL1:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_DX
    mov bl,al
     mov L_DX,bx
    jmp end1
    CHECKAH1:
    
    
    ;; AH   
    
    CMP [SI],21dH
     JNZ CHECKBH1
    
    mov ax,Operand_Value;; CODE
    mov bx,L_AX
    mov bh,al
     mov L_AX,bx
    jmp end1
    CHECKBH1:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_BX
    mov bh,al
     mov L_BX,bx
    jmp end1
    CHECKCH1:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_CX
    mov bh,al
     mov L_CX,bx
    jmp end1
    CHECKDH1:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK001
     
    mov ax,Operand_Value;; CODE
        mov bx,L_DX
    mov bh,al
     mov L_DX,bx
    jmp end1
    CHECK001:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; 00  
    
     CMP [SI],3feH 
     JNZ CHECK011
     movml001:                                                       
                                                                     
     mov ax,Operand_Value;; CODE
     mov L_00,al 
     cmp cl,ch
   je escape63
     jmp end1
     escape63:
     mov L_01,ah
     jmp end1
     CHECK011:
    
;     ;; 01  
    
     CMP [SI],401H 
     JNZ CHECK021
      movml11:
     mov ax,Operand_Value;; CODE
      mov L_01,al
      cmp cl,ch
     je escape65
     jmp end1
     escape65:
     mov L_02,ah 
     jmp end1
     CHECK021:
    
;     ;; 02  
    
     CMP [SI],404H 
      JNZ CHECK031
       movml21:
     mov ax,Operand_Value;; CODE 
      mov L_02,al
            cmp cl,ch
     je escape66
     jmp end1
     escape66:
     mov L_03,ah 
     jmp end1
     CHECK031:
   
;     ;; 03  
    
     CMP [SI],407H 
      JNZ CHECK041
       movml31:
     mov ax,Operand_Value;; CODE
      mov L_03,al 
            cmp cl,ch
    je escape51
     jmp end1
     escape51:
   
     mov L_04,ah
      jmp end1
     CHECK041:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK051
       movml41:
    mov ax,Operand_Value;; CODE
     mov L_04,al 
      cmp cl,ch
     je escape52
     jmp end1
     escape52:
     mov L_05,ah
 jmp end1    
    CHECK051:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK061
      movml51:
    mov ax,Operand_Value;; CODE 
     mov L_05,al
      cmp cl,ch
     je escape53
     jmp end1
     escape53:
     mov L_06,ah
 jmp end1    
    CHECK061:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK071
      movml61:
    mov ax,Operand_Value;; CODE 
     mov L_06,al
      cmp cl,ch
     je escape54
     jmp end1
     escape54:
     mov L_07,ah
 jmp end1    
    CHECK071:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK081
      movml71:
    mov ax,Operand_Value;; CODE 
     mov L_07,al
      cmp cl,ch
    je escape55
     jmp end1
     escape55:
     mov L_08,ah
 jmp end1   
    CHECK081:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK091
      movml81:
    mov ax,Operand_Value;; CODE
     mov L_08,al
      cmp cl,ch
     je escape56
     jmp end1
     escape56:
     mov L_09,ah 
 jmp end1       
    CHECK091:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA1
      movml91:
    mov ax,Operand_Value;; CODE 
     mov L_09,al
      cmp cl,ch
    je escape57
     jmp end1
     escape57:
     mov L_A,ah
 jmp end1    
    CHECKA1:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB1
      movmlA1:
    mov ax,Operand_Value;; CODE 
     mov L_A,al
      cmp cl,ch
    je escape58
     jmp end1
     escape58:
     mov L_B,ah
 jmp end1     
    CHECKB1:
    
;     ;; B  
    
    CMP [SI],3a4H 
    jz asdasd1
     Jmp CHECKC1
    asdasd1:
    movmlB1:
    mov ax,Operand_Value;; CODE 
     mov L_B,al
      cmp cl,ch
      je dede1
     jmp end1
     dede1:
     mov L_C,ah
 jmp end1     
    CHECKC1:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD1
      movmlC1:
    mov ax,Operand_Value;; CODE
     mov L_C,al
      cmp cl,ch
    je escape59
     jmp end1
     escape59:
     mov L_D,ah 
 jmp end1     
    CHECKD1:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE1
      movmlD1:
    mov ax,Operand_Value;; CODE
     mov L_D,al
      cmp cl,ch
    je escape60
     jmp end1
     escape60:
     mov L_E,ah 
 jmp end1    
    CHECKE1:
    
;     ;; E  
    
    CMP [SI],3adH 
     JNZ CHECKF1
      movmlE1:
    mov ax,Operand_Value;; CODE
     mov L_E,al
      cmp cl,ch
    je escape61
     jmp end1
     escape61:
     mov L_F,ah 
 jmp end1         
    CHECKF1:
    
;     ;; F  
    
    CMP [SI],3b0H 
    JNZ CHECKmlSI1 
    movmlF1:
    mov ax,Operand_Value;; CODE
    mov L_F,al
      cmp cl,ch
    je escape62
     jmp end1
     escape62:
     mov L_00,ah 
    jmp end1 
          
    CHECKmlSI1:
    
    
;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      
    
    
    ;[SI]
    CMP [SI],4b2H 
    jz con1101
    jmp CHECKmlDI1   
    con1101:
    ;;
     cmp L_SI,0H
     jnz cont11
     jmp movml001                  
    cont11:
     cmp L_SI,1H
     jnz cont21
     jmp movml11
     cont21:
     cmp L_SI,2H
     jnz cont31
     jmp movml21
     cont31:
     cmp L_SI,3H
     jnz cont41
     jmp movml31
     cont41:
     cmp L_SI,4H
     jnz cont51
     jmp movml41
     cont51:
     cmp L_SI,5H
     jnz cont61
     jmp movml51
     cont61:
     cmp L_SI,6H
     jnz cont71
     jmp movml61
     cont71:
     cmp L_SI,7H
     jnz cont81
     jmp movml71
     cont81:
     cmp L_SI,8H
     jnz cont91
     jmp movml81
     cont91:
     cmp L_SI,9H
     jnz cont101
     jmp movml91
     cont101:
     cmp L_SI,0AH
     jnz cont111
     jmp movmlA1
     cont111:
     cmp L_SI,0BH
     jnz cont121
     jmp movmlB1
     cont121:
     cmp L_SI,0CH
     jnz cont131
     jmp movmlC1
     cont131:
     cmp L_SI,0DH
     jnz cont141
     jmp movmlD1
     cont141:
     cmp L_SI,0EH
     jnz cont151
     jmp movmlE1
     cont151:
     cmp L_SI,0FH
     jnz cont161
     jmp movmlF1
     cont161:
    ; ;
    
;     ;RegisterIndirect_Addressing_Mode _SI 
    
    jmp end1              
    CHECKmlDI1:
    
    ; ;; [DI]
    CMP [SI],485H   
    jz erer1
     Jmp CHECKmlBX1 
        erer1:
     cmp L_DI,0H
     jnz cont171
     jmp movml001
     cont171:                  
     cmp L_DI,1H
     jnz cont181
     jmp movml11
     cont181:
     cmp L_DI,2H
     jnz cont191
     jmp movml21
     cont191:
     cmp L_DI,3H
     jnz cont201
     jmp movml31
     cont201:
     cmp L_DI,4H
     jnz cont211
     jmp movml41
     cont211:
     cmp L_DI,5H
     jnz cont221
     jmp movml51
     cont221:
     cmp L_DI,6H
     jnz cont231
     jmp movml61
     cont231:
     cmp L_DI,7H
     jnz cont241
     jmp movml71
     cont241:
     cmp L_DI,8H
     jnz cont251
     jmp movml81
     cont251:
     cmp L_DI,9H
     jnz cont261
     jmp movml91
     cont261:
     cmp L_DI,0AH
     jnz cont271
     jmp movmlA1
     cont271:
     cmp L_DI,0BH
     jnz cont281
     jmp movmlB1
     cont281:
     cmp L_DI,0CH
     jnz cont291
     jmp movmlC1
     cont291:
     cmp L_DI,0DH
     jnz cont301
     jmp movmlD1
     cont301:
     cmp L_DI,0EH
     jnz cont311
     jmp movmlE1
     cont311:
     cmp L_DI,0FH
     jnz cont321
     jmp movmlF1
     cont321:       ; ;
    
;     ;RegisterIndirect_Addressing_Mode _DI
                     
               
    CHECKmlBX1:    
    
    ;; [BX] 
     CMP [SI],4acH 
     jz conte11
    conte11:           ;
     cmp L_BX,0H
     jnz conte21
     jmp movml001
     conte21:                   
     cmp L_BX,1H
     jnz conte31
     jmp movml11
     conte31:
     cmp L_BX,2H
     jnz conte41
     jmp movml21
     conte41:
     cmp L_BX,3H
     jnz conte51
     jmp movml31
     conte51:
     cmp L_BX,4H
     jnz conte61
     jmp movml41
     conte61:
     cmp L_BX,5H
     jnz conte71
     jmp movml51
     conte71:
     cmp L_BX,6H
     jnz conte81
     jmp movml61
     conte81:
     cmp L_BX,7H
     jnz conte91
     jmp movml71
     conte91:
     cmp L_BX,8H
     jnz conte101
     jmp movml81
     conte101:
     cmp L_BX,9H
     jnz conte111
     jmp movml91
     conte111:
     cmp L_BX,0AH
     jnz conte121
     jmp movmlA1
     conte121:
     cmp L_BX,0BH
     jnz conte131
     jmp movmlB1
     conte131:
     cmp L_BX,0CH
     jnz conte141
     jmp movmlC1
    conte141:
     cmp L_BX,0DH
     jnz conte151
     jmp movmlD1
     conte151:
     cmp L_BX,0EH
     jnz conte161
     jmp movmlE1
     conte161:
    cmp L_BX,0FH
    jnz conte171
      jmp movmlF1
      conte171:
    
;     ;RegisterIndirect_Addressing_Mode _BX            
 
    
    end1:
            
    RET

endP put_Operand 

END ex_MAIN
