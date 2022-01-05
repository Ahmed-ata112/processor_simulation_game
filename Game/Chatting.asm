Displaychar macro str
mov ah,2
mov dl,str
int 21h
endm Displaychar
include MACR.INC
.MODEL large
.STACK 64
.DATA


_LINE DB '-'
_sign DB ':'
VALUE db 'A'
FirstNameData db 'Ahmed$$$$$$$$$$$$$$$'
SecondNameData db 'Mena$$$$$$$$$$$$$$$$'

Flag_exit DB 0

messege_sent LABEL BYTE ; named the next it the same name 
messege_sentSize db 140
actualmessege_sent_Size db 0 ;the actual size of input at the current time
THE_messege_sent db 140 dup('$')
finished_taking_input db 0 ; just a flag to indicate we finished entering the string



; messege_sent db 140 DUP('$')
; messege_recieved db 140 DUP('$')

x1 db 0AH ; sending
y1 db 1H

x2 db 0AH ; recieving
y2 db 0CH




.code

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

Draw_chat proc

mov dh,0H
mov dl,0H
set
DisplayString FirstNameData
Displaychar _sign

mov dh,0BH
mov dl,0H
set
DisplayString SecondNameData
Displaychar _sign

mov dh,14H
mov dl,0H
set

MOV CX,50H

LINE1:
Displaychar _LINE
loop LINE1

mov dh,0AH
mov dl,0H
set

MOV CX,50H

LINE:
Displaychar _LINE
loop LINE


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


; receiver proc near
    
;     mov dx , 3FDH
;     CHK: in al , dx
;     test al , 1
;     JZ loo 

;     mov dx , 03F8H
;     in al , dx
;     mov VALUE , al
;     ret
;     receiver endp

main proc far
MOV AX,@DATA
	MOV DS,AX
	mov es,ax

call intialize
MOV Flag_exit,0H
CLR_Screen_with_Scrolling_TEXT_MODE
call Draw_chat

chat_loop:






jmp chat_loop


; mov dh,y1
; mov dl,x1
; set

;  mov ah,6       
;  mov al,1            
;  mov bh,7                
;  mov ch,0       
;  mov cl,0        
;  mov dh,12     
;  mov dl,79      
;  int 10h

; loo:

; mov ah,1
; int 16h
; jz receive
; mov ah,0
; int 16h

; mov VALUE,al
; mov dh,y1
; mov dl,x1
; set
; call send



; mov dl,VALUE
; mov ah,2
; int 21h

; get
; mov x1,dl
; mov y1,dh


; cmp y1,12
;     jz scroll_up_send
;     jmp receive
;    scroll_up_send:       
;     mov ah,6 ; function 6
;     mov al,1 ; scroll by 1 line
;     mov bh,7 ; normal video attribute
;     mov ch,00 ; upper left Y
;     mov cl,00 ; upper left X
;     mov dh,12 ; lower right Y
;     mov dl,79 ; lower right X
;     int 10h
;     mov dh,11
;     mov dl,0
;     set
;     jmp here

; receive:



; mov dh,y2
; mov dl,x2
; set
; here:
; call receiver

; mov dl,VALUE
; mov ah,2
; int 21h


; get
; mov x2,dl
; mov y2,dh

; cmp y2,24
;     jz scroll_up_receive
;     jmp loo
;    scroll_up_receive:       
;     mov ah,6 ; function 6
;     mov al,1 ; scroll by 1 line
;     mov bh,7 ; normal video attribute
;     mov ch,12 ; upper left Y
;     mov cl,0 ; upper left X
;     mov dh,24 ; lower right Y
;     mov dl,79 ; lower right X
;     int 10h
;     mov dh,23
;     mov dl,0

;     set


; jmp loo


           






main endp

GetMess PROC
mov ah,1
int 16h ;-> looks at the buffer
jz FinishedTakingChar ;nothing is clicked

    mov ah,0
    int 16h

    ;check for enter
    cmp ah,28
    jne not_finished_yet ;THE_messege_sent IS THE DATA TO BE SENT

    MOV CX,actualmessege_sent_Size
    MOV SI,OFFSET THE_messege_sent
    SENT_LOOP:
    MOV AL,[SI]
    mov VALUE,al
    CALL send
    INC SI
    LOOP SENT_LOOP

    MOV AL,'$'
    MOV DI, offset THE_messege_sent
    MOV CX,140
    REP STOSB


    not_finished_yet

    ; CHECK_IF_ENTER F3 TO EXIT:
    cmp ah,61 ;; check if F3 is pressed
    jne NO_EXIT
    mov Flag_exit,1

    MOV AL,'$'
    MOV DI, offset THE_messege_sent
    MOV CX,140
    REP STOSB

    jmp FinishedTakingChar
    NO_EXIT:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; mov dh,y1
    ; mov dl,x1
    ; set

    ; cmp al,20H  ;;a space 
    ; jb CHECK_IF_ENTER11 
    ; cmp al, ']'
    ; ja CHECK_IF_ENTER11
    ; JMP ADD_TO_COMMAND   ;;its a valid one 


    CHECK_IF_F2IS_PRESSED:
    cmp ah,60 ;; check if F2 is pressed
    jne CHECK_IF_BACKSLASH11
    mov finished_taking_input,1
    CMP GAME_LEVEL, 2
    JNE ADD_TO_COMMAND
    MOV EXECUTE_REVESED, 1
    jmp ADD_TO_COMMAND  ;; TO ADD THE ENTER

    CHECK_IF_BACKSLASH11:
    cmp ah,0eh      ;;backk
    jne FinishedTakingChar  ;;NOT ANY OFTHE THREE CASES
    ;if size>0 then delete the last char and dec string
    READ_KEY
    cmp actualcommand_Size,0
    je FinishedTakingChar
    mov di,offset THE_COMMAND 
    mov bl,actualcommand_Size 
    dec bl
    xor bh,bh
    add di,bx
    mov byte ptr [di], '$'   
    dec actualcommand_Size
    jmp FinishedTakingChar 
    ADD_TO_COMMAND:
    READ_KEY
    ;then store The char and print it then inc the size
   cmp actualcommand_Size,15  ;; command is full  -> in order to not delete $ at the end
    je FinishedTakingChar
    mov di,offset THE_COMMAND 
    mov bl,actualcommand_Size
    xor bh,bh
    add di,bx
    mov [di],al ;;the char is moved to the end of string
    inc actualcommand_Size
    FinishedTakingChar:
    ret
GetMess ENDP





end main



