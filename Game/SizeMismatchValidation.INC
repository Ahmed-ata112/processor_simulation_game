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