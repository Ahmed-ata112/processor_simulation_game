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



;;Mena
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
check_Operand MACRO  HASH_Operand ,Operand_Value ,Operand__ ,__sizeIndex     
    LOCAL CHECKBX, CHECKCX, CHECKDX, CHECKSI, CHECKDI ,CHECKSP ,CHECKBP, CHECKAL , CHECKBL, CHECKCL, CHECKDL, CHECKAH,CHECKBH,CHECKCH,CHECKDH,CHECK00,CHECK01,CHECK02,CHECK03,CHECK04,CHECK05,CHECK06,CHECK07,CHECK08,CHECK09,CHECKA,CHECKB,CHECKC,CHECKD,CHECKE,CHECKF,CHECKmlSI,CHECKmlBI,CHECKmlBX,movml00,movml1,movml2,movml3,movml4,movml5,movml6,movml7,movml9,movmlA,movml8,movmlB,movmlC,movmlD,movmlE,movmlF,CHECKdata,CHECKmlDI,end

    MOV SI,offset HASH_Operand 
     
    ;; AX
    
    CMP [SI],24dH
    JNZ CHECKBX
    
    mov ax,_AX;; CODE       
    mov Operand_Value,ax
    mov __sizeIndex,1h 
    jmp end

    CHECKBX:
    
    
    ;; BX
    
    CMP [SI],252H
     JNZ CHECKCX
    
    mov ax,_BX;; CODE                                               
     mov Operand_Value,ax 
     mov __sizeIndex,1h
    jmp end

    CHECKCX:
    
    ;; CX 
    
    CMP [SI],257H
    jz continue1
     jmp CHECKDX
    continue1:
    mov ax,_CX;; CODE
     mov Operand_Value,ax 
     mov __sizeIndex,1h                   
    jmp end
    CHECKDX:
    
    ;; DX   
                                    
    CMP [SI],25cH
     JNZ CHECKSI
    
    mov ax,_DX;; CODE
     mov Operand_Value,ax
     mov __sizeIndex,1h
    jmp end
    CHECKSI:
    
    ;; SI   
    
    CMP [SI],27aH
     JNZ CHECKDI
    
    mov ax,_SI;; CODE
     mov Operand_Value,ax
     mov __sizeIndex,1h
    jmp end
    CHECKDI:
    
    ;;  ja
    ;; jbe + jmp
    ;; DI   
    
    CMP [SI],22fH
     JNZ CHECKSP
    
    mov ax,_DI;; CODE
     mov Operand_Value,ax
     mov __sizeIndex,1h
    jmp end
    CHECKSP:
    
    ;; SP   
    
    CMP [SI],28fH
     JNZ CHECKBP
    
    mov ax,_SP;; CODE
     mov Operand_Value,ax 
     mov __sizeIndex,1h
    jmp end
    CHECKBP:
    
    ;; BP   
    
    CMP [SI],23aH
     JNZ CHECKAL
    
    mov ax,_BP;; CODE
     mov Operand_Value,ax
     mov __sizeIndex,1h
    jmp end
    CHECKAL:
    
    ;; AL    
    
    CMP [SI],229H
     JNZ CHECKBL
    
    mov ax,_AX;; CODE
    mov Ah,00H
    mov Operand_Value,ax
    ;mov sizeIndex,0h
    jmp end
    CHECKBL:
    
    ;; BL    
    
    CMP [SI],22eH
     JNZ CHECKCL
    
    mov ax,_BX;; CODE
    MOV AH,00H 
     mov Operand_Value,ax 
       ;mov sizeIndex,0h
    jmp end
    CHECKCL:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL
   
    mov ax,_CX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKDL:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH
    
    mov ax,_DX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKAH:
    
    
    ;; AH  
    
    CMP [SI],21dH
     JNZ CHECKBH
    
    mov ax,_AX;; CODE
    MOV AL,AH
    MOV AH,00H                              
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKBH:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH
    
    mov ax,_BX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKCH:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH
    
    mov ax,_CX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECKDH:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK00
     
    mov ax,_DX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp end
    CHECK00:
    
    ;; 00  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TO CHECK
    
    CMP [SI],3feH 
    JNZ CHECK01
    movml00: 
    mov aL,_00
    MOV AH,_01                                          
    mov Operand_Value,ax
    jmp end
    CHECK01:
    
;     ;; 01  
    
    CMP [SI],401H 
    JNZ CHECK02
     movml1:
    mov aL,_01
    MOV AH,_02
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp end
    CHECK02:
    
;     ;; 02  
    
    CMP [SI],404H 
     JNZ CHECK03
      movml2:
    mov aL,_02
    MOV AH,_03 
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp end
    CHECK03:
    
;     ;; 03  
    
    CMP [SI],407H 
     JNZ CHECK04
      movml3:
    mov aL,_03
    MOV AH,_04
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
     jmp end
    CHECK04:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK05
       movml4:
    mov aL,_04
    MOV AH,_05
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end    
    CHECK05:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK06
      movml5:
    mov aL,_05
    MOV AH,_06 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end    
    CHECK06:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK07
      movml6:
    mov aL,_06
    MOV AH,_07 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end    
    CHECK07:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK08
      movml7:
    mov aL,_07
    MOV AH,_08 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end   
    CHECK08:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK09
      movml8:
    mov aL,_08
    MOV AH,_09
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end       
    CHECK09:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA
      movml9:
    mov aL,_09
    MOV AH,_A 
     mov Operand_Value,ax 
  ;mov sizeIndex,0h
 jmp end    
    CHECKA:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB
      movmlA:
    mov aL,_A
    MOV AH,_B 
     mov Operand_Value,aX
  ;mov sizeIndex,0h
 jmp end     
    CHECKB:
    
;     ;; B  
    
    CMP [SI],3a4H 
     JNZ CHECKC
      movmlB:
    mov aL,_B
    MOV AH,_C 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp end     
    CHECKC:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD
      movmlC:
    mov aL,_C
    MOV AH,_D
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end     
    CHECKD:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE
      movmlD:
    mov aL,_D
    MOV AH,_E
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp end     
    CHECKE:
    
;     ;; E  
   
     CMP [SI],3adH 
      JNZ CHECKF
       movmlE:
     mov aL,_E
     MOV AH,_F
      mov Operand_Value,ax
        ;mov sizeIndex,0h 
  jmp end         
     CHECKF:
   
     ;; F  
   
     CMP [SI],3b0H 
     JNZ CHECKmlSI 
     movmlF:
     mov aL,_F
     MOV AH,_00
     mov Operand_Value,ax
       ;mov sizeIndex,0h 
     jmp end 
         
     CHECKmlSI:
    
                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
         ;                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
      ;[SI]
    CMP [SI],4b2H 
    JNZ CHECKmlDI   
    
    ;;
     cmp _SI,0H
     jz movml00                  
     cmp _SI,1H
     jz movml1
     cmp _SI,2H
     jz movml2
     cmp _SI,3H
     jz movml3
     cmp _SI,4H
     jz movml4
     cmp _SI,5H
     jz movml5
     cmp _SI,6H
     jz movml6
     cmp _SI,7H
     jz movml7
     cmp _SI,8H
     jz movml8
     cmp _SI,9H
     jz movml9
     cmp _SI,0AH
     jz movmlA
     cmp _SI,0BH
     jz movmlB
     cmp _SI,0CH
     jz movmlC
     cmp _SI,0DH
     jz movmlD
     cmp _SI,0EH
     jz movmlE
     cmp _SI,0FH
     jz movmlF
    ; ;
    
     ;RegisterIndirect_Addressing_Mode _SI 
         jmp end              
     CHECKmlDI:
        ; ;; [DI]
         CMP [SI],485H   
     JNZ CHECKmlBX 
         ;
     cmp _DI,0H
     jz movml00                  
     cmp _DI,1H
     jz movml1
     cmp _DI,2H
     jz movml2
     cmp _DI,3H
     jz movml3
     cmp _DI,4H
     jz movml4
     cmp _DI,5H
     jz movml5
     cmp _DI,6H
     jz movml6
     cmp _DI,7H
     jz movml7
     cmp _DI,8H
     jz movml8
     cmp _DI,9H
     jz movml9
     cmp _DI,0AH
     jz movmlA
     cmp _DI,0BH
     jz movmlB
     cmp _DI,0CH
     jz movmlC
     cmp _DI,0DH
     jz movmlD
     cmp _DI,0EH
     jz movmlE
     cmp _DI,0FH
     jz movmlF
    ; ;
    
     ;RegisterIndirect_Addressing_Mode _DI
                     
               
     CHECKmlBX:
         ;; [BX] 
     CMP [SI],4acH 
     JNZ CHECKdata     
         ;
     cmp _BX,0H
     jz movml00                  
     cmp _BX,1H
     jz movml1
     cmp _BX,2H
     jz movml2
     cmp _BX,3H
     jz movml3
     cmp _BX,4H
     jz movml4
     cmp _BX,5H
     jz movml5
     cmp _BX,6H
     jz movml6
     cmp _BX,7H
     jz movml7
     cmp _BX,8H
     jz movml8
     cmp _BX,9H
     jz movml9
     cmp _BX,0AH
     jz movmlA
     cmp _BX,0BH
     jz movmlB
     cmp _BX,0CH
     jz movmlC
     cmp _BX,0DH
     jz movmlD
     cmp _BX,0EH
     jz movmlE
    cmp _BX,0FH
      jz movmlF
   
    
    ; ;RegisterIndirect_Addressing_Mode _BX                                               
   CHECKdata:
    Convert_OP_TO_HEXA Operand__ 
    mov Operand_Value,ax
 
    end:
            
    

ENDM check_Operand                   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
                                                                                         
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

put_Operand MACRO  HASH_Operand, Operand_Value, __sizeIndex
    LOCAL CHECKBX,CHECKCX,CHECKDX, CHECKSI,CHECKDI ,CHECKSP ,CHECKBP,CHECKAL ,CHECKBL,CHECKCL,,CHECKDL,CHECKAH,CHECKBH,CHECKCH,CHECKDH,CHECK00,CHECK01,CHECK02,CHECK03,CHECK04,CHECK05,CHECK06,CHECK07,CHECK08,CHECK09,CHECKA,CHECKB,CHECKC,CHECKD,CHECKE,CHECKF,CHECKmlSI,CHECKmlBI,CHECKmlBX,movml00,movml1,movml2,movml3,movml4,movml5,movml6,movml7,movml9,movmlA,movml8,movmlB,movmlC,movmlD,movmlE,movmlF,CHECKdata ,CHECKmlDI,end

    MOV SI,offset HASH_Operand 
    mov cl,__sizeIndex
    mov ch,1h
     
    ;; AX
    
    CMP [SI],24dH
    JNZ CHECKBX
    
    mov ax,Operand_Value;; CODE
    mov _AX,ax 
    jmp end

    CHECKBX:
    
    
    ;; BX
    
    CMP [SI],252H
     JNZ CHECKCX
    
    mov ax,Operand_Value;; CODE
     mov _BX,ax
    jmp end

    CHECKCX:
    
    ;; CX 
    
    CMP [SI],257H
     JNZ CHECKDX
    
    mov ax,Operand_Value;; CODE
     mov _CX,ax                    
    jmp end
    CHECKDX:
                                                                           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; DX   
                                    
    CMP [SI],25cH
     JNZ CHECKSI
    
    mov ax,Operand_Value;; CODE
     mov _DX,ax
    jmp end
    CHECKSI:
    
    ;; SI   
    
    CMP [SI],27aH
     JNZ CHECKDI
    
    mov ax,Operand_Value;; CODE
     mov _SI,ax
    jmp end
    CHECKDI:
    
    ;; DI   
    
    CMP [SI],22fH
     JNZ CHECKSP
    
    mov ax,Operand_Value;; CODE
     mov _DI,ax
    jmp end
    CHECKSP:
    
    ;; SP   
    
    CMP [SI],28fH
     JNZ CHECKBP
    
    mov ax,Operand_Value;; CODE
     mov _SP,ax
    jmp end
    CHECKBP:
    
    ;; BP   
    
    CMP [SI],23aH
     JNZ CHECKAL
    
    mov ax,Operand_Value;; CODE
     mov _BP,ax
    jmp end
    CHECKAL:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; AL   
    
    CMP [SI],229H
     JNZ CHECKBL
    
    mov ax,Operand_Value;; CODE 
    mov bx,_AX
    mov bl,al
     mov _AX,bx
    jmp end
    CHECKBL:
    
    ;; BL    
    
    CMP [SI],22eH
     JNZ CHECKCL
    
    mov ax,Operand_Value;; CODE 
         mov bx,_BX
    mov bl,al
     mov _bX,bx
    jmp end
    CHECKCL:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL
   
    mov ax,Operand_Value;; CODE
     mov bx,_CX
    mov bl,al
     mov _CX,bx
    jmp end
    CHECKDL:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH
    
    mov ax,Operand_Value;; CODE
        mov bx,_DX
    mov bl,al
     mov _DX,bx
    jmp end
    CHECKAH:
    
    
    ;; AH   
    
    CMP [SI],21dH
     JNZ CHECKBH
    
    mov ax,Operand_Value;; CODE
    mov bx,_AX
    mov bh,al
     mov _AX,bx
    jmp end
    CHECKBH:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH
    
    mov ax,Operand_Value;; CODE
        mov bx,_BX
    mov bh,al
     mov _BX,bx
    jmp end
    CHECKCH:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH
    
    mov ax,Operand_Value;; CODE
        mov bx,_CX
    mov bh,al
     mov _CX,bx
    jmp end
    CHECKDH:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK00
     
    mov ax,Operand_Value;; CODE
        mov bx,_DX
    mov bh,al
     mov _DX,bx
    jmp end
    CHECK00:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; 00  
    
     CMP [SI],3feH 
     JNZ CHECK01
     movml00:                                                       
                                                                     
     mov ax,Operand_Value;; CODE
     mov _00,al 
     cmp cl,ch
     jne end
     mov _01,ah
     jmp end
     CHECK01:
    
;     ;; 01  
    
     CMP [SI],401H 
     JNZ CHECK02
      movml1:
     mov ax,Operand_Value;; CODE
      mov _01,al
      cmp cl,ch
     jne end
     mov _02,ah 
     jmp end
     CHECK02:
    
;     ;; 02  
    
     CMP [SI],404H 
      JNZ CHECK03
       movml2:
     mov ax,Operand_Value;; CODE 
      mov _02,al
            cmp cl,ch
     jne end
     mov _03,ah 
     jmp end
     CHECK03:
   
;     ;; 03  
    
     CMP [SI],407H 
      JNZ CHECK04
       movml3:
     mov ax,Operand_Value;; CODE
      mov _03,al 
            cmp cl,ch
     jne end
     mov _04,ah
      jmp end
     CHECK04:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK05
       movml4:
    mov ax,Operand_Value;; CODE
     mov _04,al 
      cmp cl,ch
     jne end
     mov _05,ah
 jmp end    
    CHECK05:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK06
      movml5:
    mov ax,Operand_Value;; CODE 
     mov _05,ax
      cmp cl,ch
     jne end
     mov _06,ah
 jmp end    
    CHECK06:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK07
      movml6:
    mov ax,Operand_Value;; CODE 
     mov _06,ax
      cmp cl,ch
     jne end
     mov _07,ah
 jmp end    
    CHECK07:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK08
      movml7:
    mov ax,Operand_Value;; CODE 
     mov _07,al
      cmp cl,ch
     jne end
     mov _08,ah
 jmp end   
    CHECK08:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK09
      movml8:
    mov ax,Operand_Value;; CODE
     mov _08,al
      cmp cl,ch
     jne end
     mov _09,ah 
 jmp end       
    CHECK09:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA
      movml9:
    mov ax,Operand_Value;; CODE 
     mov _09,al
      cmp cl,ch
     jne end
     mov _A,ah
 jmp end    
    CHECKA:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB
      movmlA:
    mov ax,Operand_Value;; CODE 
     mov _A,al
      cmp cl,ch
     jne end
     mov _B,ah
 jmp end     
    CHECKB:
    
;     ;; B  
    
    CMP [SI],3a4H 
     JNZ CHECKC
      movmlB:
    mov ax,Operand_Value;; CODE 
     mov _B,al
      cmp cl,ch
     jne end
     mov _C,ah
 jmp end     
    CHECKC:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD
      movmlC:
    mov ax,Operand_Value;; CODE
     mov _C,al
      cmp cl,ch
     jne end
     mov _D,ah 
 jmp end     
    CHECKD:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE
      movmlD:
    mov ax,Operand_Value;; CODE
     mov _D,al
      cmp cl,ch
     jne end
     mov _E,ah 
 jmp end     
    CHECKE:
    
;     ;; E  
    
    CMP [SI],3adH 
     JNZ CHECKF
      movmlE:
    mov ax,Operand_Value;; CODE
     mov _E,al
      cmp cl,ch
     jne end
     mov _F,ah 
 jmp end         
    CHECKF:
    
;     ;; F  
    
    CMP [SI],3b0H 
    JNZ CHECKmlSI 
    movmlF:
    mov ax,Operand_Value;; CODE
    mov _F,al
      cmp cl,ch
     jne end
     mov _00,ah 
    jmp end 
          
    CHECKmlSI:
    
    
;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      
    
    
    ;[SI]
    CMP [SI],4b2H 
    JNZ CHECKmlDI   
    
    ;;
     cmp _SI,0H
     jz movml00                  
     cmp _SI,1H
     jz movml1
     cmp _SI,2H
     jz movml2
     cmp _SI,3H
     jz movml3
     cmp _SI,4H
     jz movml4
     cmp _SI,5H
     jz movml5
     cmp _SI,6H
     jz movml6
     cmp _SI,7H
     jz movml7
     cmp _SI,8H
     jz movml8
     cmp _SI,9H
     jz movml9
     cmp _SI,0AH
     jz movmlA
     cmp _SI,0BH
     jz movmlB
     cmp _SI,0CH
     jz movmlC
     cmp _SI,0DH
     jz movmlD
     cmp _SI,0EH
     jz movmlE
     cmp _SI,0FH
     jz movmlF
    ; ;
    
;     ;RegisterIndirect_Addressing_Mode _SI 
    
    jmp end              
    CHECKmlDI:
    
    ; ;; [DI]
         CMP [SI],485H   
     JNZ CHECKmlBX 
         ;
     cmp _DI,0H
     jz movml00                  
     cmp _DI,1H
     jz movml1
     cmp _DI,2H
     jz movml2
     cmp _DI,3H
     jz movml3
     cmp _DI,4H
     jz movml4
     cmp _DI,5H
     jz movml5
     cmp _DI,6H
     jz movml6
     cmp _DI,7H
     jz movml7
     cmp _DI,8H
     jz movml8
     cmp _DI,9H
     jz movml9
     cmp _DI,0AH
     jz movmlA
     cmp _DI,0BH
     jz movmlB
     cmp _DI,0CH
     jz movmlC
     cmp _DI,0DH
     jz movmlD
     cmp _DI,0EH
     jz movmlE
     cmp _DI,0FH
     jz movmlF
    ; ;
    
;     ;RegisterIndirect_Addressing_Mode _DI
                     
               
    CHECKmlBX:    
    
    ;; [BX] 
     CMP [SI],4acH 
     JNZ CHECKdata     
         ;
     cmp _BX,0H
     jz movml00                  
     cmp _BX,1H
     jz movml1
     cmp _BX,2H
     jz movml2
     cmp _BX,3H
     jz movml3
     cmp _BX,4H
     jz movml4
     cmp _BX,5H
     jz movml5
     cmp _BX,6H
     jz movml6
     cmp _BX,7H
     jz movml7
     cmp _BX,8H
     jz movml8
     cmp _BX,9H
     jz movml9
     cmp _BX,0AH
     jz movmlA
     cmp _BX,0BH
     jz movmlB
     cmp _BX,0CH
     jz movmlC
     cmp _BX,0DH
     jz movmlD
     cmp _BX,0EH
     jz movmlE
    cmp _BX,0FH
      jz movmlF
    
;     ;RegisterIndirect_Addressing_Mode _BX            
 
    
    end:
            
    

endm put_Operand 





