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

















