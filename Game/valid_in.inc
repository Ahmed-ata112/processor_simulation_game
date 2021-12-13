;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; just a File to Contain All the Validation Macros To use it later;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




SizeMismatchValidation MACRO op1,op2,result    

check_op_size_mismatch op1,op2,result
cmp result,0
je finish
check_op_size_mismatch op2,op1,result       
finish:       
       
ENDM SizeMismatchValidation

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





    check_if_in_array macro arr, arr_len, element_size , op ,result
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

    check_if_in_array endm


split_operands MACRO source des1 des2 ; to split the two operand (des1->first oper && des2->second oper) 
	    
	mov SI,offset source
	mov DI,offset des1
	mov al,','
moving1:	
	MOVSB
	cmp al,[SI]
	jnz moving1
	
	inc SI ;; to skip (,)
	mov DI,offset des2
	mov al,'$'
moving2:	
	MOVSB
	cmp al,[SI]
	jnz moving2
	
	dec di ; to remove enter
    mov [DI],al

ENDM split_operands

	Check_memorytomemory MACRO des1 des2 Result_2  ;; check if it iss memory to memory --  Result_2 = 1 if it is not valid and 0 for valid  
	    
	cmp [des1],'['
	jnz no_bracket
	cmp [des2],'['
	jnz no_bracket
	mov [Result_2],1
	jmp return
	no_bracket:
	mov [Result_2],0
    return:
	    
	ENDM Check_memorytomemory




















