;;MENNA
SizeMismatchValidation MACRO op1,op2,result    

check_op_size_mismatch op1,op2,result
cmp result,0
je finish
check_op_size_mismatch op2,op1,result       
finish:       
       
ENDM SizeMismatchValidation

;; Menna
check_op_size_mismatch MACRO op1, op2, result
    Local valid,NOTvalid,end,CheckL   
    cmp op1+1,'H'                  ;op1=_H 
    jne CheckL
    ;; reach here if the first has (-H)
    ;; Check if the other reg is large -X , -I , -P  -> NOT VALID
    cmp op2+1,'X'                  ;op2=_X
    je  NOTvalid
    cmp op2+1,'I'                  ;_H,SI/_H,DI
    je NOTvalid
    cmp op2+1,'P'                  ;_H,BP/_H,SP
    je NOTvalid
    
    CheckL:  
    cmp op1+1,'L'                  ;op1=_L
    jne valid                      ; if both don't have neither H or L as suffix -> They are Valid 
    ;; reach here if the first has (-L)
    ;; Check if the other reg is large -X , -I , -P  -> NOT VALID
    cmp op2+1,'X'                  ;op2=_X
    je  NOTvalid
    cmp op2+1,'I'                  ;_L,SI/_L,DI
    je NOTvalid
    cmp op2+1,'P'                  ;_L,BP/_L,SP
    je NOTvalid 
    valid:
    mov result,1 
    jmp end

    NOTvalid:
    mov result,0
    end:

ENDM check_op_size_mismatch

    ;;  Hany
Check_memorytomemory MACRO des1, des2, Result_2  ;; check if it iss memory to memory --  Result_2 = 0 if it is not valid and 1 for valid  
    Local no_bracket
    mov SI,offset des1
    mov Di,offset des2
    cmp [SI],BYTE ptr '['
    jnz no_bracket
    cmp [Di], BYTE ptr '['
    jnz no_bracket
    mov Si,offset Result_2
    mov [Si], BYTE ptr 0
    jmp return
    no_bracket:
    mov [Si],BYTE ptr 1
    return:
        
ENDM Check_memorytomemory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  Invalid register name OR ADDRESING
check_reg_name macro operand, RES

HASHING_op operand HASH_Operand

MOV SI,offset HASH_Operand 
    ;; AX
    CMP [SI],24dH
    JNZ CHECKBX7
    jmp END252
    CHECKBX7:
    ;; BX
    CMP [SI],252H
     JNZ CHECKCX7
     jmp END252
    CHECKCX7:
    ;; CX 
    CMP [SI],257H
    JNZ CHECKCX77
     jmp END252
    CHECKCX77:
    ;; DX                                  
    CMP [SI],25cH
     JNZ CHECKSI7
    jmp END252
    CHECKSI7:
    ;; SI   
    CMP [SI],27aH
     JNZ CHECKDI8
    jmp END252
    CHECKDI8:
    ;; DI   
    CMP [SI],22fH
     JNZ CHECKSP8
    jmp END252
    CHECKSP8:
    ;; SP   
    CMP [SI],28fH
     JNZ CHECKBP8
    jmp END252
    CHECKBP8:
    ;; BP   
    CMP [SI],23aH
     JNZ CHECKAL8
    jmp END252
    CHECKAL8:
    ;; AL    
    CMP [SI],229H
     JNZ CHECKBL8
    jmp END252
    CHECKBL8:
    ;; BL    
    CMP [SI],22eH
     JNZ CHECKCL8
    jmp END252
    CHECKCL8:
    ;; CL   
    CMP [SI],233H
     JNZ CHECKDL7
    jmp END252
    CHECKDL7:
    ;; DL   
    CMP [SI],238H      
     JNZ CHECKAH7
    jmp END252
    CHECKAH7:
    ;; AH  
    CMP [SI],21dH
     JNZ CHECKBH7
    jmp END252
    CHECKBH7:
    ;; BH   
    CMP [SI],222H
     JNZ CHECKCH7
    jmp END252
    CHECKCH7:
    ;; CH   
    CMP [SI],227H
     JNZ CHECKDH7
    jmp END252
    CHECKDH7:
    ;; DH  
    CMP [SI],22cH 
     JNZ CHECK007
    jmp END252
    CHECK007:
;[SI]
    CMP [SI],4b2H 
JNZ CHECK0017
    jmp END252
    CHECK0017:
; [DI]
         CMP [SI],485H
JNZ CHECK0027
    jmp END252
    CHECK0027:
    ;; [BX] 
     CMP [SI],4acH 
JNZ CHECK00277
    jmp END252
    CHECK00277:
    MOV  RES,0
    END252:
ENDM


; ;   Ata
; check_if_in_array macro arr, arr_len, element_size, op, result
;     local L1 ,finish,found,skip
;     lea si,arr
;     mov bh,arr_len  ;; number of elements in array
    
;     L1:  
;     mov cx,0 
;     mov cl,element_size
;     lea di,op ; store the string we search for
;     repe CMPSB    
    
;     cmp cx,0 ;; CX =0 if the 2 current words equall 
;     jne skip ;try the next pair 
;     ;;
;     dec si
;     dec di
;     mov al,[si]
;     cmp al,[di]
;     je found 
;     inc si
;     skip:
;     add si,cx ;to skip current word if it doesn't match
    
;     dec bh
;     jnz L1 
    
    
;     ;; finsished loop and not found
;     mov result,0
;     jmp finish
;     ;;valid one -> element in array
;     found:    
;     mov result,1
;     finish:

; check_if_in_array endm


include macr.inc
; include valid_in.inc
include Ex_macr.inc
.286
.model small
.stack 64
.data 
Command_valid db 1                                    
validRegNamesArr db  'AX','BX','CX','DX'
                 db  'AH','AL','BH','BL','CH','CL','DH','DL'
                 db  'CS','IP','SS','SP'
                 db  'BP','SI','DI','DS','ES'

validRegNamesArrSize db  21d 

HASH_Operand DW 0H 

A_arr_len db 3
A_element_size db 4

valid_addressing_mode_regs db '[BX]','[SI]','[DI]'

command_splited db 5 dup('$') ;';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
    Operand1 db 5 dup('$')
    Operand2 db 5 dup('$')
    Two_Operands_Together_splited db 12 dup('$')

	command LABEL BYTE ; named the next it the same name 
	commandSize db 30
    actualcommand_Size db 0 ;the actual size of input at the current time
    THE_COMMAND db 30 dup('$')

    v1 db 'valid$'
    v2 db 'not valid$'


.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations
	ReadString command

    call Check_valid
    mov al,Command_valid
    cmp al,0H
    je n11122
    DisplayString v1
    jmp fin5
    n11122:
    DisplayString v2


    fin5:

    

	MOV AH,4CH
	INT 21H ;GO BACK TO DOS ;to end the program
MAIN ENDP

split_command               PROC
    mov SI, offset THE_COMMAND
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




Check_valid PROC
; mov ax,1h
; mov Command_valid,al
CALL split_command
split_operands Two_Operands_Together_splited Operand1 Operand2
SizeMismatchValidation Operand1 Operand2 Command_valid
MOV AL,Command_valid
CMP AL,0    ; 0 -> INVALID   1-> VALID
JNE C54321
JMP CONT54321
C54321:
Check_memorytomemory Operand1 Operand2 Command_valid 
MOV AL,Command_valid
CMP AL,0    ; 0 -> INVALID   1-> VALID
JNE C543212
JMP CONT54321
C543212:

check_reg_name Operand1 Command_valid
MOV AL,Command_valid
CMP AL,0    ; 0 -> INVALID   1-> VALID
JNE C54321235
JMP CONT54321
C54321235:

check_reg_name Operand2 Command_valid
MOV AL,Command_valid
CMP AL,0    ; 0 -> INVALID   1-> VALID
JNE C5432123
JMP CONT54321
C5432123:


CONT54321:
	  ret
Check_valid  ENDP

END MAIN

