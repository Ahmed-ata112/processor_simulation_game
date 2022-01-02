; ;;MENNA
; SizeMismatchValidation MACRO op1,op2,result    
; ;;;;;;;;;;;;;;;;;;;;;
; mov bx,0
; mov cx,0  ;count
; cmp op2,'0'
; jne count_data
; inc bx ;skip zero
; count_data:
; jne q321
; jmp finish
; q321:
; inc bx
; inc cx
; cmp op2+bx,'$'
; jne count_data
; cmp cx,3
; jge _2bytes
; mov ax,1 ;1byte
; jmp start
; _2bytes:
; cmp cx,5
; jl dfdf
; jmp INvalid
; dfdf:
; mov ax,2
; start:
; check_op_size_mismatch op1,op2,result
; cmp result,0
; jne q9
; jmp finish
; q9:
; check_op_size_mismatch op2,op1,result 
; jmp finish
; ;;;;;;;;;;;;;;;;;;;;
; INvalid:
; mov Command_valid,0
; finish:       
       
; ENDM SizeMismatchValidation

; ;; Menna
; check_op_size_mismatch MACRO op1, op2, result
;     Local valid,NOTvalid,end,CheckL   
;     cmp op1+1,'H'                  ;op1=_H 
;     jne CheckL
;     ;; reach here if the first has (-H)
;     ;; Check if the other reg is large -X , -I , -P  -> NOT VALID
;     cmp op2+1,'X'                  ;op2=_X
;     je  NOTvalid
;     cmp op2+1,'I'                  ;_H,SI/_H,DI
;     je NOTvalid
;     cmp op2+1,'P'                  ;_H,BP/_H,SP
;     je NOTvalid
;     cmp ax,2
;     je NOTvalid
    
;     CheckL:  
;     cmp op1+1,'L'                  ;op1=_L
;     jne valid                      ; if both don't have neither H or L as suffix -> They are Valid 
;     ;; reach here if the first has (-L)
;     ;; Check if the other reg is large -X , -I , -P  -> NOT VALID
;     cmp op2+1,'X'                  ;op2=_X
;     je  NOTvalid
;     cmp op2+1,'I'                  ;_L,SI/_L,DI
;     je NOTvalid
;     cmp op2+1,'P'                  ;_L,BP/_L,SP
;     je NOTvalid
;     cmp ax,2
;     je NOTvalid

;     valid:
;     mov result,1 
;     jmp end

;     NOTvalid:
;     mov result,0
;     end:

; ENDM check_op_size_mismatch

;     ;;  Hany
; Check_memorytomemory MACRO des1, des2, Result_2  ;; check if it iss memory to memory --  Result_2 = 0 if it is not valid and 1 for valid  
;     Local no_bracket
;     mov SI,offset des1
;     mov Di,offset des2
;     cmp [SI],BYTE ptr '['
;     jnz no_bracket
;     cmp [Di], BYTE ptr '['
;     jnz no_bracket
;     mov Si,offset Result_2
;     mov [Si], BYTE ptr 0
;     jmp return
;     no_bracket:
;     mov [Si],BYTE ptr 1
;     return:
        
; ENDM Check_memorytomemory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  Invalid register name OR ADDRESING
; ; check_reg_name macro operand, RES
; ; Local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,T,END252
; ; HASHING_op operand HASH_Operand

; ; MOV SI,offset HASH_Operand 
; ;     ;; AX
; ;     CMP [SI],24dH
; ;     JNZ A
; ;     jmp END252
; ;     A:
; ;     ;; BX
; ;     CMP [SI],252H
; ;      JNZ B
; ;      jmp END252
; ;     B:
; ;     ;; CX 
; ;     CMP [SI],257H
; ;     JNZ C
; ;      jmp END252
; ;     C:
; ;     ;; DX                                  
; ;     CMP [SI],25cH
; ;      JNZ D
; ;     jmp END252
; ;     D:
; ;     ;; SI   
; ;     CMP [SI],27aH
; ;      JNZ E
; ;     jmp END252
; ;     E:
; ;     ;; DI   
; ;     CMP [SI],22fH
; ;      JNZ F
; ;     jmp END252
; ;     F:
; ;     ;; SP   
; ;     CMP [SI],28fH
; ;      JNZ G
; ;     jmp END252
; ;     G:
; ;     ;; BP   
; ;     CMP [SI],23aH
; ;      JNZ H
; ;     jmp END252
; ;     H:
; ;     ;; AL    
; ;     CMP [SI],229H
; ;      JNZ I
; ;     jmp END252
; ;     I:
; ;     ;; BL    
; ;     CMP [SI],22eH
; ;      JNZ J
; ;     jmp END252
; ;     J:
; ;     ;; CL   
; ;     CMP [SI],233H
; ;      JNZ K
; ;     jmp END252
; ;     K:
; ;     ;; DL   
; ;     CMP [SI],238H      
; ;      JNZ L
; ;     jmp END252
; ;     L:
; ;     ;; AH  
; ;     CMP [SI],21dH
; ;      JNZ T
; ;     jmp END252
; ;     T:
; ;     ;; BH   
; ;     CMP [SI],222H
; ;      JNZ M
; ;     jmp END252
; ;     M:
; ;     ;; CH   
; ;     CMP [SI],227H
; ;      JNZ N
; ;     jmp END252
; ;     N:
; ;     ;; DH  
; ;     CMP [SI],22cH 
; ;      JNZ O
; ;     jmp END252
; ;     O:
; ; ;[SI]
; ;     CMP [SI],4b2H 
; ; JNZ P
; ;     jmp END252
; ;     P:
; ; ; [DI]
; ;          CMP [SI],485H
; ; JNZ Q
; ;     jmp END252
; ;     Q:
; ;     ;; [BX] 
; ;      CMP [SI],4acH 
; ; JNZ R
; ;     jmp END252
; ;     R:
; ;     MOV  RES,0
; ;     END252:
; ; ENDM


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

; endm check_if_in_array


; include macr.inc
; ; include valid_in.inc
; include Ex_macr.inc
; .286
; .model small
; .stack 64
; .data 
; Command_valid db 1                                    
; validRegNamesArr db  'AX','BX','CX','DX'
;                  db  'AH','AL','BH','BL','CH','CL','DH','DL'
;                  db  'CS','IP','SS','SP'
;                  db  'BP','SI','DI','DS','ES'

; validRegNamesArrSize db  21d 

; HASH_Operand DW 0H 

; A_arr_len db 3
; A_element_size db 4

; valid_addressing_mode_regs db '[BX]','[SI]','[DI]','[00]','[01]','[02]','[03]', '[04]', '[05]', '[06]', '[07]', '[08]', '[09]', '[0A]', '[0B]', '[0C]', '[0D]', '[0E]','[0F]'

; command_splited db 5 dup('$') ;';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
;     Operand1 db 5 dup('$')
;     Operand2 db 5 dup('$')
;     Two_Operands_Together_splited db 12 dup('$')

; 	command LABEL BYTE ; named the next it the same name 
; 	commandSize db 30
;     actualcommand_Size db 0 ;the actual size of input at the current time
;     THE_COMMAND db 30 dup('$')

;     v1 db 'valid$'
;     v2 db 'not valid$'


; .code
; 	main proc far
; 	mov ax, @data
; 	mov ds, ax
; 	mov ES,AX ;; for string operations
;     ; MOV AX,FFFF
; 	ReadString command

;     call Check_valid
;     mov al,Command_valid
;     cmp al,0H
;     je n11122
;     DisplayString v1
;     jmp fin5
;     n11122:
;     DisplayString v2


;     fin5:

    

; 	MOV AH,4CH
; 	INT 21H ;GO BACK TO DOS ;to end the program
; MAIN ENDP

; split_command               PROC
;     mov SI, offset THE_COMMAND
;     mov DI, offset command_splited
;     mov al,' ' ;; to check space
; moving11:	
; 	MOVSB
; 	cmp al,[SI]
; 	jnz moving11
; ;; Mena	
; 	mov DI, offset Two_Operands_Together_splited
; 	mov al,'$' ;; to check end 
; 	inc SI     ;; to skip space
; moving22:
;     MOVSB
;     cmp al,[SI]
;     jnz moving22	

;     ret

; split_command               ENDP



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check_valid PROC
; ; mov ax,1h
; ; mov Command_valid,al
; CALL split_command
; split_operands Two_Operands_Together_splited Operand1 Operand2

; cmp Operand2,'$' ;if empty, assume Command_valid is 0 initally
; jne validationnn


; validationnn:
; cmp Operand1,'[' ; memory locaion operand (type 1)
; je  Valid_Memory_Location1
; cmp Operand1, 'A'
; jnl h09
; jmp check_op2
; h09:
; cmp Operand1,'Z'
; jng q5
; jmp End_End       ; it is not a valid reg name, else it is a register
; q5:
; jmp Reg_Operand1
; ; if operand is memory location
; Valid_Memory_Location1:
; check_if_in_array valid_addressing_mode_regs 19 4 Operand1 Command_valid
; cmp Command_valid,0
; jne q55
; jmp End_End
; q55:
; jmp check_op2

; Reg_Operand1:
; check_if_in_array validRegNamesArr 21 2 Operand1 Command_valid ;check if operand1 is not one of the array element, it's INVALID
; cmp Command_valid,0
; jne q7
; jmp End_End   ;jmp to end
; q7:

; check_op2:  
; cmp Operand2,'[' ; memory locaion operand (type 1)
; je  Valid_Memory_Location2
; cmp Operand2, 'A'
; jl  Rest
; cmp Operand2,'Z'
; jng q77
; jmp End_End       ; it is not a valid reg name, else it is a register
; q77:
; Valid_Memory_Location2:
; check_if_in_array valid_addressing_mode_regs 19 4 Operand2 Command_valid
; cmp Command_valid,0
; jne q78
; jmp End_End
; q78:
; Reg_Operand2:
; check_if_in_array validRegNamesArr 21 2 Operand2 Command_valid ;check if operand1 is not one of the array element, it's INVALID
; jmp End_End

; Rest:
; SizeMismatchValidation Operand1 Operand2 Command_valid
; cmp Command_valid,0
; jne q123
; jmp End_End 
; q123:
; Check_memorytomemory  Operand1 Operand2 Command_valid
; cmp Command_valid,0
; je End_End 

; End_End:
; ret
; endp  Check_valid

; checkOperandsRegistersNames macro FirstOperandData,SecondOperandData,result     
;       local finish                          
;       check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualfirstOperandSize, FirstOperandData,result
;       cmp result,0
;       je finish
;       check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualSecondOperandSize, SecondOperandData,result
;       finish:                          
; endm checkOperandsRegistersNames    























; ; SizeMismatchValidation Operand1 Operand2 Command_valid
; ; MOV AL,Command_valid
; ; CMP AL,0    ; 0 -> INVALID   1-> VALID
; ; JNE C54321
; ; JMP CONT54321
; ; C54321:
; ;  Check_memorytomemory Operand1 Operand2 Command_valid 
; ;  MOV AL,Command_valid
; ;  CMP AL,0    ; 0 -> INVALID   1-> VALID
; ;  JNE C543212
; ;  JMP CONT54321
; ;  C543212:
; ;  check_reg_name Operand1 Command_valid
; ;  MOV AL,Command_valid
; ;  CMP AL,0    ; 0 -> INVALID   1-> VALID
; ;  JNE C54321235
; ;  JMP CONT54321
; ;  C54321235:
; ;  check_reg_name Operand2 Command_valid
; ;  MOV AL,Command_valid
; ;  CMP AL,0    ; 0 -> INVALID   1-> VALID
; ;  JNE C5432123
; ;  JMP CONT54321
; ; C5432123:


; ; CONT54321:
; ; 	  ret
; ; Check_valid  ENDP

; END MAIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MENNA
SizeMismatchValidation MACRO op1,op2,result    
;;;;;;;;;;;;;;;;;;;;;
mov bx,0
mov cx,0  ;count
SkipZero:
cmp op2+bx,'0'
je ahaha
jmp count_data
ahaha:
inc bx ;skip zero
jmp SkipZero

cmp op2+bx,'$' ; opernad=0
jne ahh
jmp finish
ahh:

count_data:
jne q321
jmp finish
q321:
inc bx
inc cx
cmp op2+bx,'$'
jne count_data
cmp cx,3
jge _2bytes
mov ax,1 ;1byte
jmp start
_2bytes:
cmp cx,5
jl dfdf
jmp INvalid
dfdf:
mov ax,2
start:
check_op_size_mismatch op1,op2,result
cmp result,0
jne q9
jmp finish
q9:
check_op_size_mismatch op2,op1,result 
jmp finish 
;;;;;;;;;;;;;;;;;;;;
INvalid:
mov Command_valid,0
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
    cmp ax,2
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
    cmp ax,2
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
; check_reg_name macro operand, RES
; Local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,T,END252
; HASHING_op operand HASH_Operand

; MOV SI,offset HASH_Operand 
;     ;; AX
;     CMP [SI],24dH
;     JNZ A
;     jmp END252
;     A:
;     ;; BX
;     CMP [SI],252H
;      JNZ B
;      jmp END252
;     B:
;     ;; CX 
;     CMP [SI],257H
;     JNZ C
;      jmp END252
;     C:
;     ;; DX                                  
;     CMP [SI],25cH
;      JNZ D
;     jmp END252
;     D:
;     ;; SI   
;     CMP [SI],27aH
;      JNZ E
;     jmp END252
;     E:
;     ;; DI   
;     CMP [SI],22fH
;      JNZ F
;     jmp END252
;     F:
;     ;; SP   
;     CMP [SI],28fH
;      JNZ G
;     jmp END252
;     G:
;     ;; BP   
;     CMP [SI],23aH
;      JNZ H
;     jmp END252
;     H:
;     ;; AL    
;     CMP [SI],229H
;      JNZ I
;     jmp END252
;     I:
;     ;; BL    
;     CMP [SI],22eH
;      JNZ J
;     jmp END252
;     J:
;     ;; CL   
;     CMP [SI],233H
;      JNZ K
;     jmp END252
;     K:
;     ;; DL   
;     CMP [SI],238H      
;      JNZ L
;     jmp END252
;     L:
;     ;; AH  
;     CMP [SI],21dH
;      JNZ T
;     jmp END252
;     T:
;     ;; BH   
;     CMP [SI],222H
;      JNZ M
;     jmp END252
;     M:
;     ;; CH   
;     CMP [SI],227H
;      JNZ N
;     jmp END252
;     N:
;     ;; DH  
;     CMP [SI],22cH 
;      JNZ O
;     jmp END252
;     O:
; ;[SI]
;     CMP [SI],4b2H 
; JNZ P
;     jmp END252
;     P:
; ; [DI]
;          CMP [SI],485H
; JNZ Q
;     jmp END252
;     Q:
;     ;; [BX] 
;      CMP [SI],4acH 
; JNZ R
;     jmp END252
;     R:
;     MOV  RES,0
;     END252:
; ENDM


;   Ata
check_if_in_array macro arr, arr_len, element_size, op, result
    local L1 ,finish,found,skip
    lea si,arr
    mov bh,arr_len  ;; number of elements in array
    
    L1:  
    mov cx,0 
    mov cl,element_size
    lea di,op ; store the string we search for
    repe CMPSB    
    
    cmp cx,0 ;; CX =0 if the 2 current words equall 
    jne skip ;try the next pair 
    ;;
    dec si
    dec di
    mov al,[si]
    cmp al,[di]
    je found 
    inc si
    skip:
    add si,cx ;to skip current word if it doesn't match
    
    dec bh
    jnz L1 
    
    
    ;; finsished loop and not found
    mov result,0
    jmp finish
    ;;valid one -> element in array
    found:    
    mov result,1
    finish:

endm check_if_in_array


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

valid_addressing_mode_regs db '[BX]','[SI]','[DI]','[00]','[01]','[02]','[03]', '[04]', '[05]', '[06]', '[07]', '[08]', '[09]', '[0A]', '[0B]', '[0C]', '[0D]', '[0E]','[0F]'

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Check_valid PROC
; mov ax,1h
; mov Command_valid,al
CALL split_command
split_operands Two_Operands_Together_splited Operand1 Operand2

cmp Operand2,'$' ;if empty, assume Command_valid is 0 initally
jne validationnn


validationnn:
cmp Operand1,'[' ; memory locaion operand (type 1)
je  Valid_Memory_Location1
cmp Operand1, 'A'
jnl h09
jmp check_op2
h09:
cmp Operand1,'Z'
jng q5
jmp End_End       ; it is not a valid reg name, else it is a register
q5:
jmp Reg_Operand1
; if operand is memory location
Valid_Memory_Location1:
check_if_in_array valid_addressing_mode_regs 19 4 Operand1 Command_valid
cmp Command_valid,0
jne q55
jmp End_End
q55:
jmp check_op2

Reg_Operand1:
check_if_in_array validRegNamesArr 21 2 Operand1 Command_valid ;check if operand1 is not one of the array element, it's INVALID
cmp Command_valid,0
jne q7
jmp End_End   ;jmp to end
q7:

check_op2:  
cmp Operand2,'[' ; memory locaion operand (type 1)
je  Valid_Memory_Location2
cmp Operand2, 'A'
jl  Rest
cmp Operand2,'Z'
jng q77
jmp End_End       ; it is not a valid reg name, else it is a register
q77:
Valid_Memory_Location2:
check_if_in_array valid_addressing_mode_regs 19 4 Operand2 Command_valid
cmp Command_valid,0
; jne q78
JNE Rest
jmp End_End
; q78:
Reg_Operand2:
check_if_in_array validRegNamesArr 21 2 Operand2 Command_valid ;check if operand1 is not one of the array element, it's INVALID
jmp End_End

Rest:
SizeMismatchValidation Operand1 Operand2 Command_valid
cmp Command_valid,0
jne q123
jmp End_End 
q123:
Check_memorytomemory  Operand1 Operand2 Command_valid
cmp Command_valid,0
je End_End 

End_End:
ret
endp  Check_valid

checkOperandsRegistersNames macro FirstOperandData,SecondOperandData,result     
      local finish                          
      check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualfirstOperandSize, FirstOperandData,result
      cmp result,0
      je finish
      check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualSecondOperandSize, SecondOperandData,result
      finish:                          
endm checkOperandsRegistersNames    























; SizeMismatchValidation Operand1 Operand2 Command_valid
; MOV AL,Command_valid
; CMP AL,0    ; 0 -> INVALID   1-> VALID
; JNE C54321
; JMP CONT54321
; C54321:
;  Check_memorytomemory Operand1 Operand2 Command_valid 
;  MOV AL,Command_valid
;  CMP AL,0    ; 0 -> INVALID   1-> VALID
;  JNE C543212
;  JMP CONT54321
;  C543212:
;  check_reg_name Operand1 Command_valid
;  MOV AL,Command_valid
;  CMP AL,0    ; 0 -> INVALID   1-> VALID
;  JNE C54321235
;  JMP CONT54321
;  C54321235:
;  check_reg_name Operand2 Command_valid
;  MOV AL,Command_valid
;  CMP AL,0    ; 0 -> INVALID   1-> VALID
;  JNE C5432123
;  JMP CONT54321
; C5432123:


; CONT54321:
; 	  ret
; Check_valid  ENDP

END MAIN


