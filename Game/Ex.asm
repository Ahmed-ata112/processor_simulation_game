;; Hany-> command;
;; Mena -> second; 

;EXTRN mainGame:_AX, _BX, _CX, _DX, _SI, _DI, _SP, _BP
;EXTRN mainGame:command
;EXTRN mainGame:_01,_02,_03,_04,_05,_06,_07,_08,_09,_A,_B,_C,_D,_E,_F
;PUBLIC result

.MODEL SMALL
.STACK 64
.DATA

command_splited db 5 dup('$') 

HASH DB ?

command DB 'MOV AX,13'

.code 
DisplayString MACRO STR
            mov ah,9h
            mov dx,offset STR
            int 21h
ENDM DisplayString

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Hany
;; HASHING
HASHING MACRO STR
            
    mov SI,offset STR
    mov DI, offset HASH
    mov al,'$' ;; to check END
    MOV [DI],0H
moving11:
    MOV AH,[DI]
    ADD AH,[SI]
    MOV [DI],AH
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
    
    HASHING command_splited
    
    CALL check_command                 
     
    HLT
	     
MAIN ENDP     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hany

;; split operand and store it in split_command
split_command               PROC
    mov SI, offset command
    mov DI, offset command_splited
    mov al,' ' ;; to check space
moving1:	
	MOVSB
	cmp al,[SI]
	jnz moving1

    ret

split_command               ENDP


check_command                PROC 

    MOV SI,offset HASH 
    MOV DI,offset command_splited
     
    ;; ADD
    
    CMP [SI],0C9H
    JNZ CHECK1
    
    ;; CODE
    DisplayString command_splited 
    
    CHECK1:
    
    
    ;; ADC
    
    CMP [SI],0C8H
     JNZ CHECK2
    
    ;; CODE
    DisplayString command_splited
    
    CHECK2:
    
    ;; SUB  
    
    CMP [SI],0EAH
     JNZ CHECK3
    
    ;; CODE                    
    DisplayString command_splited
    
    CHECK3:
    
    ;; SBB   
    
    CMP [SI],0D7H
     JNZ CHECK4
    
    ;; CODE
    DisplayString command_splited
    
    CHECK4:
    
    ;; DIV   
    
    CMP [SI],0E3H
     JNZ CHECK5
    
    ;; CODE
    DisplayString command_splited
    
    CHECK5:
    
    ;; MUL   
    
    CMP [SI],0EEH
     JNZ CHECK6
    
    ;; CODE
    DisplayString command_splited
    
    CHECK6:
    
    ;; MOV   
    
    CMP [SI],0F2H
     JNZ CHECK7
    
    ;; CODE
    DisplayString command_splited
    
    CHECK7:
    
    ;; XOR   
    
    CMP [SI],0F9H
     JNZ CHECK8
    
    ;; CODE
    DisplayString command_splited
    
    CHECK8:
    
    ;; AND   
    
    CMP [SI],0D3H
     JNZ CHECK9
    
    ;; CODE
    DisplayString command_splited
    
    CHECK9:
    
    ;; OR    
    
    CMP [SI],0A1H
     JNZ CHECK10
    
    ;; CODE
    DisplayString command_splited
    
    CHECK10:
    
    ;; NOP   
    
    CMP [SI],0EDH
     JNZ CHECK11
     CMP [DI],'N'
    JNZ CHECK11
    
    ;; CODE
    DisplayString command_splited
    
    CHECK11:
    
    ;; SHR   
    
    CMP [SI],0EDH      
     JNZ CHECK15
    CMP [DI],'S'
    JNZ CHECK15
    
    ;; CODE
    DisplayString command_splited
    
    CHECK15:
    
    
    ;; INC   
    
    CMP [SI],0DAH
     JNZ CHECK12
    
    ;; CODE
    DisplayString command_splited
    
    CHECK12:
    
    ;; DEC   
    
    CMP [SI],0CCH
     JNZ CHECK13
    
    ;; CODE
    DisplayString command_splited
    
    CHECK13:
    
    ;; CLC   
    
    CMP [SI],0D2H
     JNZ CHECK14
    
    ;; CODE
    DisplayString command_splited
    
    CHECK14:
    
    ;; SHL   
    
    CMP [SI],0E7H 
     JNZ CHECK16
    
    ;; CODE 
    DisplayString command_splited
    
    CHECK16:
            
    RET

check_command                ENDP  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END MAIN   




                                                    
                                                    
                                                    
                                                    
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

