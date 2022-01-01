check_if_in_array macro arr, arr_len, element_size , op ,result
 local L1 ,finish,found
 lea si,arr
 mov bh,arr_len  ;; number of elements in array
 
 L1:  
  mov cx,element_size
  lea di,op ; store the string we search for
  repe CMPSB    
 
  cmp cx,0 ;; CX =0 if the 2 current words equall 
  je found ;try the next pair 
  
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

check_if_in_array endm



is_brackets_with_number_in_it macro op, result
    local not_good,good,finish ,L1,check_A_F
    ;; [213] or [a4e]
    lea si,op
    
    cmp [si],'['
    jne not_good
    
    inc si
    
    
    cmp [si],']'
    je not_good
    
    
    
    
    L1:
        cmp [si],'0'
        jb not_good
        cmp [si],'9'
        ja check_A_F
        jmp OK_letter
        
        check_A_F:
        cmp [si],'A'
        jb not_good
        cmp [si],'F'
        ja not_good
        
        OK_letter:
        inc si
        cmp [si],']'  ;; closing bracket
        jne L1
        
    good:
    mov result,1
    jmp finish
    
    not_good:
    mov result,0

    finish:


is_brackets_with_number_in_it endm

 
 
 
 

.MODEL SMALL
.STACK 64
.DATA

op1 db '[BL]'
op2 db 'ax'

valid_addressing_mode_regs db '[BX]','[SI]','[DI]'    
result4 db 0ffh


.code
MAIN PROC far
    MOV AX,@DATA
	MOV DS,AX
	mov es,ax  
    
   check_if_in_array valid_addressing_mode_regs, 3, 4, op1, result4
                                                 
      
  ; is_brackets_with_number_in_it op1,result4         
        
	     
MAIN ENDP
END MAIN






