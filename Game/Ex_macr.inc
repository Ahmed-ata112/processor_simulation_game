;; Hany && Mena

DisplayString MACRO STR                     ;DIV CL
            mov ah,9h                      
            mov dx,offset STR               ;MUL CL
            int 21h                         
ENDM DisplayString                          
HASHING MACRO STR ,HASH                      ;CLC
    local moving111                         ;SHL
    mov SI,offset STR                       ;SAR
    mov DI, offset HASH                     ;ROR
    mov al,'$' ;; to check END              ;RCL
    MOV [DI],0H                             ;RCR
                                            ;ROL
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H
    ADD BX,CX 
    
    MOV [DI],BX 
    
    moving111:
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H
    ADD BX,CX  
    ADD BX,CX
    ADD BX,CX
    MOV [DI],BX
    INC SI	
	cmp al,[SI]
	jnz moving111
            
ENDM HASHING 


;; HASHING operand
HASHING_op MACRO STR, HASH
    local moving111        
    mov SI,offset STR
    mov DI, offset HASH
    mov al,'$' ;; to check END
    MOV [DI],0H 
                  
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H      ;; first time
    ADD BX,CX 
    
    MOV [DI],BX 
    
    
    MOV BX,[DI]
    MOV CL,[SI]     ;; second time
    MOV CH,00H
    ADD BX,CX 
    
    MOV [DI],BX
    
        
moving111:
    MOV BX,[DI]
    MOV CL,[SI]
    MOV CH,00H
    ADD BX,CX  
    ADD BX,CX
    ADD BX,CX
    MOV [DI],BX
    INC SI	
	cmp al,[SI]
	jnz moving111
            
ENDM HASHING_op

split_operands MACRO source, des1, des2 ; to split the two operand (des1->first oper && des2->second oper)   
	mov SI,offset source
	mov DI,offset des1
	mov al,','
    MOV AH,'$'
    moving1:	
	MOVSB
    CMP AH,[SI]
    JE FIN
    cmp al,[SI]
	jnz moving1
	
	inc SI ;; to skip (,)
	mov DI,offset des2
	mov al,'$'
    moving2:	
	MOVSB
	cmp al,[SI]
	jnz moving2

	FIN:
	dec di ; to remove enter
    mov [DI],AH

ENDM split_operands                                                                                         
Convert_OP_TO_HEXA MACRO OPERAND 
    local l1, l2, numb, SKIP_NUM, end_of_op,FINISHED

    ;;STORES THE RESULT in AX
    mov cx,0
    mov dx,0
    MOV DI, offset OPERAND
    l1: 
        cmp [DI],'$'
        je end_of_op
        inc cx  ;;counter  (LENTGH OF STRING)
        mov dl, [DI] ;; store it to proccedd
        cmp dl,'A'
        jb numb
        cmp dl, 'F'
        ja numb
        ;; from A-F
        sub dl,55       ;; convertd A-F to 10-16
        jmp SKIP_NUM
        numb:
        ;; from 1 - 9 
        sub dl,'0'
        SKIP_NUM:
        push dx     ;; STORE IN STACK TO TAKE IT BACK 
        inc di  ;; next Char
        jmp l1
    end_of_op:

    mov bx,1
    mov di,0 ; to store result 
     
    CMP CX,0 ;;STRING WAS EMPTY
    JE FINISHED
    
     l2:
    ; pop and multi then add to dx
    pop ax
    mul bx  ;; MULTIPLY AX BY THE SUITABLE WEIGHT
    add di,ax
    mov ax,bx   
    ;; INCREASE THE WEIGHT
    mov bx,16 ;;in AX   
    mul bx
    mov bx,ax  ;;get it in BX
    loop l2 
    FINISHED:
    mov ax,di   ;; STORE THE RESULT 
ENDM Convert_OP_TO_HEXA                                                                                        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; done

