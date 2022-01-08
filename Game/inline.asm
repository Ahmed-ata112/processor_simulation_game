set MACRO ; work on dx ; L-> X  H->Y
mov bh,0h
mov ah,2
int 10h
    
ENDM set

get  MACRO 
mov ah,3h
mov bh,0h
int 10h 
ENDM get

Displaychar macro str
mov ah,2
mov dl,str
int 21h
endm Displaychar



include MACR.INC
.MODEL large
.STACK 64
.DATA

nl db 10,13,'$'
_sign DB ':'
VALUE db 'A'
FirstNameData db 'Ahmed$$$$$$$$$$$$$$$'
SecondNameData db 'Hany$$$$$$$$$$$$$$$$'

Flag_exit DB 0

messege_sent LABEL BYTE ; named the next it the same name 
messege_sentSize db 140
actualmessege_sent_Size db 0 ;the actual size of input at the current time
THE_messege_sent db 140 dup('$')
finished_taking_input db 0 ; just a flag to indicate we finished entering the string
x2 db 7 
.code

Draw_chat proc

mov dh,16H
mov dl,0H
set
DisplayString FirstNameData
Displaychar _sign

mov dh,18H
mov dl,0H
set
DisplayString SecondNameData
Displaychar _sign

ret
Draw_chat endp

intialize proc


mov dx,3fbh 			
mov al,10000000b		
out dx,al				

mov dx,3f8h			
mov al,0ch			
out dx,al

mov dx,3f9h
mov al,00h
out dx,al

mov dx,3fbh
mov al,00011011b

out dx,al

ret

intialize endp

send proc
        
		mov dx , 3FDH		
AGAIN:  	In al , dx 			
  		test al , 00100000b
  		JZ AGAIN                               


  		mov dx , 3F8H		
  		mov  al,VALUE
  		out dx , al

ret
send endp

receiver proc

    mov dx , 3FDH		; Line Status Register
	  in al , dx 
  	test al , 1
  	JZ CHK
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
  	in al , dx
    cmp al,0FEH;->;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  char to deternmine chatting
    je CHK
    cmp al,0FFH
    jne contkoko93
    mov dh,18h
    mov dl,7
    set
    mov al,' '
    mov cl, 30
    mov ch,0
    Loop_space:
    Displaychar al
    loop Loop_space
    mov dh,18h
    mov dl,7
    set
    jmp CHK
    contkoko93:
    mov VALUE , al
    Displaychar VALUE
    CHK:
    ret
    receiver endp

Mess PROC
     mov bl,actualmessege_sent_Size
    add bl,7
    mov dl,bl
mov ah,1
int 16h ;-> looks at the buffer
jnz out_range
jmp FinishedTakingChar_mess ;nothing is clicked
out_range:
    mov dh,16h
    set

    mov ah,0 ; get the char from the buffer
    int 16h

    ;check for enter
    cmp ah,28
    jne not_finished_yet ;THE_messege_sent IS THE DATA TO BE SENT
    
 
    CMP actualmessege_sent_Size,0
    JNE EMPTY_MESS
    JMP FinishedTakingChar_mess
    EMPTY_MESS:
    xor ch,ch
    MOV Cl,actualmessege_sent_Size
    MOV SI,OFFSET THE_messege_sent


    mov ah,0FEH ;->;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  char to deternmine chatting
    mov Value,ah
    Call send
    mov Value ,0FFh
    Call send
                   
    SENT_LOOP:
    mov Value,ah
    Call send
    MOV AL,[SI]
    mov VALUE,al
    CALL send
    INC SI
    LOOP SENT_LOOP
    
    ; send new line
  
    MOV AL,'$'
    MOV DI, offset THE_messege_sent
    MOV CX,30
    REP STOSB
  
    mov dh,16h
    mov dl,7
    set
    mov al,' '
    mov cl, actualmessege_sent_Size
    mov ch,0
    Loop_space1:
    Displaychar al
    loop Loop_space1
     mov actualmessege_sent_Size,0
    jmp FinishedTakingChar_mess
    
    not_finished_yet:

    ; CHECK_IF_ENTER F3 TO EXIT:
    cmp ah,61 ;; check if F3 is pressed
    jne NO_EXIT
    mov Flag_exit,1

    MOV AL,'$'
    MOV DI, offset THE_messege_sent
    MOV CX,30
    mov actualmessege_sent_Size,0
    REP STOSB

    jmp FinishedTakingChar_mess
    NO_EXIT:

    cmp ah,0eh      ;;backk
    JE ADD_TO_THE_messege_sent_ERR
    jMP ADD_TO_THE_messege_sent  ;;NOT ANY OFTHE THREE CASES
    ADD_TO_THE_messege_sent_ERR:
    CMP actualmessege_sent_Size,0
    JNE EMPTY_MESS1
    JMP FinishedTakingChar_mess
    EMPTY_MESS1:
    ;if size>0 then delete the last char and dec string
    ; READ_KEY
    cmp actualmessege_sent_Size,0
    JNE DEL_ERR
    jMP FinishedTakingChar_mess
    DEL_ERR:
    mov di,offset THE_messege_sent 
    mov bl,actualmessege_sent_Size 
    dec bl
    xor bh,bh
    add di,bx
    mov byte ptr [di], '$'   
    dec actualmessege_sent_Size
    get
    DEC dl
    set
    Displaychar ' '
    ;over ride on space
   dec dl
    set
    jmp FinishedTakingChar_mess
    
    ADD_TO_THE_messege_sent:
    ; READ_KEY
    ;then store The char and print it then inc the size
    cmp actualmessege_sent_Size,29  ;; command is full  -> in order to not delete $ at the end
    je FinishedTakingChar_mess
    mov di,offset THE_messege_sent 
    mov bl,actualmessege_sent_Size
    xor bh,bh
    add di,bx
    mov [di],al ;;the char is moved to the end of string
    inc actualmessege_sent_Size
    Displaychar al
   
    FinishedTakingChar_mess:
  
    

;;receiving 

    mov dl,x2
    mov dh,18h
    set
    


    mov dl,x2
    mov dh,18h
    set
    
    call receiver
  
          
    get
    mov x2,dl

    ret
Mess ENDP

main proc far
MOV AX,@DATA
	MOV DS,AX
	mov es,ax ; for string operation

call intialize
MOV Flag_exit,0H
mov al,4 ;video mode
mov ah,0
int 10h
call Draw_chat

chat_loop:
CALL Mess
cmp Flag_exit,1
jne cont_mess

ret
cont_mess:


jmp chat_loop
main endp
end main
