;; Hany-> command;
;; Mena -> second; 

EXTRN mainGame:_AX, _BX, _CX, _DX, _SI, _DI, _SP, _BP,_AL, _BL, _CL, _DL, _AH, _BH, _CH, _DH
EXTRN mainGame:command
EXTRN mainGame:_01,_02,_03,_04,_05,_06,_07,_08,_09,_A,_B,_C,_D,_E,_F
PUBLIC result

.MODEL SMALL
.STACK 64
.DATA

command_splited db 5 dup('$') 
Operand1 db 5 dup('$')
Operand2 db 5 dup('$')
Two_Operands_Together_splited db 10 dup('$') 
Operand2_Value db ?
               
HASH DW ?
HASH_Operand2 DW ?

command DB 'MUL AX,13'

.code 
DisplayString MACRO STR
            mov ah,9h
            mov dx,offset STR
            int 21h
ENDM DisplayString

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Hany
;; HASHING
HASHING MACRO STR HASH
            
    mov SI,offset STR
    mov DI, offset HASH
    mov al,'$' ;; to check END
    MOV [DI],0H 
                  
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H
    ADD BX,CX 
    
    MOV [DI],BX 
    
moving11:
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H
    ADD BX,CX  
    ADD BX,CX
    ADD BX,CX
    MOV [DI],BX
    INC SI	
	cmp al,[SI]
	jnz moving11
            
ENDM HASHING 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   



MAIN PROC far

    MOV AX,@DATA
	MOV DS,AX
	mov es,ax
	  
    CALL split_command
    split_operands Two_Operands_Together_splited Operand1 Operand2
    
    HASHING command_splited HASH
    HASHING command_splited HASH_Operand2
    
    CALL check_command
    CALL check_Operand2                 
     
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
moving1:	
	MOVSB
	cmp al,[SI]
	jnz moving1
;; Mena	
	mov DI, offset Two_Operands_Together_splited
	mov al,'$' ;; to check end
moving11:
    MOVSB
    cmp al,[SI]
    jnz moving11	

    ret

split_command               ENDP


check_command                PROC 

    MOV SI,offset HASH 
    MOV DI,offset command_splited
     
    ;; ADD
    
    CMP [SI],29CH
    JNZ CHECK1
    
    ;; CODE
    DisplayString command_splited 
    
    CHECK1:
    
    
    ;; ADC
    
    CMP [SI],299H
     JNZ CHECK2
    
    ;; CODE
    DisplayString command_splited
    
    CHECK2:
    
    ;; SUB  
    
    CMP [SI],311H
     JNZ CHECK3
    
    ;; CODE                    
    DisplayString command_splited
    
    CHECK3:
    
    ;; SBB   
    
    CMP [SI],2D8H
     JNZ CHECK4
    
    ;; CODE
    DisplayString command_splited
    
    CHECK4:
    
    ;; DIV   
    
    CMP [SI],2EDH
     JNZ CHECK5
    
    ;; CODE
    DisplayString command_splited
    
    CHECK5:
    
    ;; MUL   
    
    CMP [SI],317H
     JNZ CHECK6
    
    ;; CODE
    DisplayString command_splited
    
    CHECK6:
    
    ;; MOV   
    
    CMP [SI],323H
     JNZ CHECK7
    
    ;; CODE
    DisplayString command_splited
    
    CHECK7:
    
    ;; XOR   
    
    CMP [SI],343H
     JNZ CHECK8
    
    ;; CODE
    DisplayString command_splited
    
    CHECK8:
    
    ;; AND   
    
    CMP [SI],2BAH
     JNZ CHECK9
    
    ;; CODE
    DisplayString command_splited
    
    CHECK9:
    
    ;; OR    
    
    CMP [SI],232H
     JNZ CHECK10
    
    ;; CODE
    DisplayString command_splited
    
    CHECK10:
    
    ;; NOP   
    
    CMP [SI],315H
     JNZ CHECK11
   
    ;; CODE
    DisplayString command_splited
    
    CHECK11:
    
    ;; SHR   
    
    CMP [SI],31AH      
     JNZ CHECK15
    
    ;; CODE
    DisplayString command_splited
    
    CHECK15:
    
    
    ;; INC   
    
    CMP [SI],2D7H
     JNZ CHECK12
    
    ;; CODE
    DisplayString command_splited
    
    CHECK12:
    
    ;; DEC   
    
    CMP [SI],2A8H
     JNZ CHECK13
    
    ;; CODE
    DisplayString command_splited
    
    CHECK13:
    
    ;; CLC   
    
    CMP [SI],2B9H
     JNZ CHECK14
    
    ;; CODE
    DisplayString command_splited
    
    CHECK14:
    
    ;; SHL   
    
    CMP [SI],308H 
     JNZ CHECK16
    
    ;; CODE 
    DisplayString command_splited
    
    CHECK16:
            
    RET

check_command                ENDP  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END MAIN   


;;Mena

check_Operand2                PROC 

    MOV SI,offset HASH_Operand2 
    MOV DI,offset Operand2
     
    ;; AX
    
    CMP [SI],2ocH
    JNZ CHECKBX
    
    mov ax,_AX;; CODE
    DisplayString Operand2 
    jmp end

    CHECKBX:
    
    
    ;; BX
    
    CMP [SI],210H
     JNZ CHECKCX
    
    mov ax,_BX;; CODE
    DisplayString Operand2
    jmp end

    CHECKCX:
    
    ;; CX 
    
    CMP [SI],214H
     JNZ CHECKDX
    
    mov ax,_CX;; CODE                    
    DisplayString Operand2
    jmp end
    CHECKDX:
    
    ;; DX   
    
    CMP [SI],218H
     JNZ CHECKSI
    
    mov ax,_DX;; CODE
    DisplayString Operand2
    jmp end
    CHECKSI:
    
    ;; SI   
    
    CMP [SI],227H
     JNZ CHECKDI
    
    mov ax,_SI;; CODE
    DisplayString Operand2
    jmp end
    CHECKDI:
    
    ;; DI   
    
    CMP [SI],1ebH
     JNZ CHECKSP
    
    mov ax,_DI;; CODE
    DisplayString Operand2
    jmp end
    CHECKSP:
    
    ;; SP   
    
    CMP [SI],23cH
     JNZ CHECKBP
    
    mov ax,_SP;; CODE
    DisplayString Operand2
    jmp end
    CHECKBP:
    
    ;; BP   
    
    CMP [SI],1f8H
     JNZ CHECKAL
    
    mov ax,_BP;; CODE
    DisplayString Operand2
    jmp end
    CHECKAL:
    
    ;; AL   
    
    CMP [SI],1e8H
     JNZ CHECKBL
    CMP Operand2,'A'
     JNZ CHECKDH 
    
    mov ax,_AL;; CODE
    DisplayString Operand2
    jmp end
    CHECKBL:
    
    ;; BL    
    
    CMP [SI],1ecH
     JNZ CHECKCL
    
    mov ax,_BL;; CODE
    DisplayString Operand2
    jmp end
    CHECKCL:
    
    ;; CL   
    
    CMP [SI],1f0H
     JNZ CHECKDL
   
    mov ax,_CL;; CODE
    DisplayString Operand2
    jmp end
    CHECKDL:
    
    ;; DL   
    
    CMP [SI],1f4H      
     JNZ CHECKAH
    
    mov ax,_DL;; CODE
    DisplayString Operand2
    jmp end
    CHECKAH:
    
    
    ;; AH   
    
    CMP [SI],1dcH
     JNZ CHECKBH
    
    mov ax,_AH;; CODE
    DisplayString Operand2
    jmp end
    CHECKBH:
    
    ;; BH   
    
    CMP [SI],1e0H
     JNZ CHECKCH
    
    mov ax,_BH;; CODE
    DisplayString Operand2
    jmp end
    CHECKCH:
    
    ;; CH   
    
    CMP [SI],1e4H
     JNZ CHECKDH
    
    mov ax,_CH;; CODE
    DisplayString Operand2
    jmp end
    CHECKDH:
    
    ;; DH  
    
    CMP [SI],1e8H 
     JNZ CHECK01
     
    mov ax,_DH;; CODE
    DisplayString Operand2
    jmp end
    CHECK01:
    
    ;; 01  
    
    CMP [SI],3a6H 
    JNZ CHECK02
     movml1:
    mov ax,_01;; CODE 
 DisplayString Operand2
    jmp end
    CHECK02:
    
    ;; 02  
    
    CMP [SI],3a9H 
     JNZ CHECK03
      movml2:
    mov ax,_02;; CODE 
 DisplayString Operand2 
    jmp end
    CHECK03:
    
    ;; 03  
    
    CMP [SI],3acH 
     JNZ CHECK04
      movml3:
    mov ax,_03;; CODE 
 DisplayString Operand2
     jmp end
    CHECK04:
    
    ;; 04  
    
    CMP [SI],3afH 
     JNZ CHECK05
       movml4:
    mov ax,_04;; CODE 
 DisplayString Operand2
 jmp end    
    CHECK05:
    
    ;; 05  
    
    CMP [SI],3b2H 
     JNZ CHECK06
      movml5:
    mov ax,_05;; CODE 
 DisplayString Operand2
 jmp end    
    CHECK06:
    
    ;; 06  
    
    CMP [SI],3b5H 
     JNZ CHECK07
      movml6:
    mov ax,_06;; CODE 
 DisplayString Operand2
 jmp end    
    CHECK07:
    
    ;; 07  
    
    CMP [SI],3b8H 
     JNZ CHECK08
      movml7:
    mov ax,_07;; CODE 
 DisplayString Operand2 
 jmp end   
    CHECK08:
    
    ;; 08  
    
    CMP [SI],3bbH 
     JNZ CHECK09
      movml8:
    mov ax,_08;; CODE 
 DisplayString Operand2
 jmp end       
    CHECK09:
    
    ;; 09  
    
    CMP [SI],3beH 
     JNZ CHECKA
      movml9:
    mov ax,_09;; CODE 
 DisplayString Operand2
 jmp end    
    CHECKA:
    
    ;; A  
    
    CMP [SI],346H 
     JNZ CHECKB
      movmlA:
    mov ax,_A;; CODE 
 DisplayString Operand2
 jmp end     
    CHECKB:
    
    ;; B  
    
    CMP [SI],349H 
     JNZ CHECKC
      movmlB:
    mov ax,_B;; CODE 
 DisplayString Operand2
 jmp end     
    CHECKC:
    
    ;; C  
    
    CMP [SI],34cH 
     JNZ CHECKD
      movmlC:
    mov ax,_C;; CODE 
 DisplayString Operand2
 jmp end     
    CHECKD:
    
    ;; D  
    
    CMP [SI],34fH 
     JNZ CHECKE
      movmlD:
    mov ax,_D;; CODE 
 DisplayString Operand2
 jmp end     
    CHECKE:
    
    ;; E  
    
    CMP [SI],352H 
     JNZ CHECKF
      movmlE:
    mov ax,_E;; CODE 
 DisplayString Operand2
 jmp end         
    CHECKF:
    
    ;; F  
    
    CMP [SI],355H 
     JNZ CHECKmlSI 
      movmlF:
    mov ax,_F;; CODE 
 DisplayString Operand2
 jmp end          
    CHECKmlSI:
    
    ;; [SI] 
    
    CMP [SI],457H 
    JNZ CHECKmlDI
            
             
    cmp _SI,1
    jz movml1
    cmp _SI,2
    jz movml2
    cmp _SI,3
    jz movml3
    cmp _SI,4
    jz movml4
    cmp _SI,5
    jz movml5
    cmp _SI,6
    jz movml6
    cmp _SI,7
    jz movml7
    cmp _SI,8
    jz movml8
    cmp _SI,9
    jz movml9
    cmp _SI,A
    jz movmlA
    cmp _SI,B
    jz movmlB
    cmp _SI,C
    jz movmlC
    cmp _SI,D
    jz movmlD
    cmp _SI,E
    jz movmlE
    cmp _SI,F
    jz movmlF
    ;; CODE 
    
 DisplayString Operand2
 jmp end              
    CHECKmlDI:
    
    ;; [DI] 
    
    CMP [SI],42aH 
    JNZ CHECKmlSP
    
    cmp _DI,1
    jz movml1
    cmp _DI,2
    jz movml2
    cmp _DI,3
    jz movml3
    cmp _DI,4
    jz movml4
    cmp _DI,5
    jz movml5
    cmp _DI,6
    jz movml6
    cmp _DI,7
    jz movml7
    cmp _DI,8
    jz movml8
    cmp _DI,9
    jz movml9
    cmp _DI,A
    jz movmlA
    cmp _DI,B
    jz movmlB
    cmp _DI,C
    jz movmlC
    cmp _DI,D
    jz movmlD
    cmp _DI,E
    jz movmlE
    cmp _DI,F
    jz movmlF 
    ;; CODE 
 DisplayString Operand2
 jmp end               
    CHECKmlSP:
    
    ;; [SP] 
    
    CMP [SI],46cH 
     JNZ CHECKmlBP
    
    cmp _SP,1
    jz movml1
    cmp _SP,2
    jz movml2
    cmp _SP,3
    jz movml3
    cmp _SP,4
    jz movml4
    cmp _SP,5
    jz movml5
    cmp _SP,6
    jz movml6
    cmp _SP,7
    jz movml7
    cmp _SP,8
    jz movml8
    cmp _SP,9
    jz movml9
    cmp _SP,A
    jz movmlA
    cmp _SP,B
    jz movmlB
    cmp _SP,C
    jz movmlC
    cmp _SP,D
    jz movmlD
    cmp _SP,E
    jz movmlE
    cmp _SP,F
    jz movmlF
    ;; CODE 
 DisplayString Operand2    
    jmp end               
    CHECKmlBP:
    
    ;; [BP] 
    
    CMP [SI],439H 
     JNZ CHECKdata
    
    cmp _BP,1
    jz movml1
    cmp _BP,2
    jz movml2
    cmp _BP,3
    jz movml3
    cmp _BP,4
    jz movml4
    cmp _BP,5
    jz movml5
    cmp _BP,6
    jz movml6
    cmp _BP,7
    jz movml7
    cmp _BP,8
    jz movml8
    cmp _BP,9
    jz movml9
    cmp _BP,A
    jz movmlA
    cmp _BP,B
    jz movmlB
    cmp _BP,C
    jz movmlC
    cmp _BP,D
    jz movmlD
    cmp _BP,E
    jz movmlE
    cmp _BP,F
    jz movmlF
    ;; CODE 
 DisplayString Operand2                                 
    jmp end               
    CHECKdata:
    
    ;; data 
    
     
    JNZ end
    
    ;; CODE 
 DisplayString Operand2
 
    
            
    RET

check_command                ENDP

                                                    
                                                    
                                                    
                                                    
; ;.....................................
; check_command MACRO command result;; command is a string that contain the command-- Result -> 1 means sucess -- -> 0 failed

; ;; determine the command

; cmp
; jnz
; ;; checing validation

; ;; split two operands
; ;;des 1 -- des 2
; ;; call macro-> move

; cmp
; ;;call macro-> add



; ENDM check_command

; move MACRO des1 des2 _Ax _BX _CX 

; ;; Es
; ;; second  reg, memory -> 
; ;
; ;
; ; move ES
; ;; first 
; ;
; ;
; ;mov variable es
; ;.................
; ;; reg cehck
; ;;ax                                ;;mov [_al],
;     ; l h

; ;;memory
; ;;[]

; ;;reg
; ;; location num

; ;exec

; ENDM move
; ;............

