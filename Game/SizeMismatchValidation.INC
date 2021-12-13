SizeMismatchValidation MACRO op1,op2,result    

CheckOP op1,op2,result
cmp result,0
je finish
CheckOP op2,op1,result       
finish:       
       
       ENDM SizeMismatchValidation

CheckOP MACRO op1, op2, result
 Local valid,NOTvalid,end,CheckL   
       cmp op1+1,'H'                  ;op1=_H
       jne CheckL
       cmp op2+1,'X'                  ;op2=_X
       je  NOTvalid
       cmp op2+1,'I'                  ;_H,SI/_H,DI
       je NOTvalid
       cmp op2+1,'P'                  ;_H,BP/_H,SP
       je NOTvalid
       
       CheckL:  
       cmp op1+1,'L'                  ;op1=_L
       jne valid
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
    
    ENDM CheckOP