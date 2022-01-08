 public mainChat
 extrn FirstNameData:byte
 extrn SecondNameData:byte
 
  Displaychar macro str
  mov ah,2
  mov dl,str
  int 21h
  endm Displaychar

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


  include MACR.INC
  .MODEL SMALL
  .STACK 64
  .DATA

  nl db 10,13,'$'
  _LINE DB '-'
  _sign DB ':'
  VALUE db 'A'
  ;FirstNameData db 'Ahmed$$$$$$$$$$$$$$$'
  ;SecondNameData db 'Hany$$$$$$$$$$$$$$$$'
  exit_string db 'Press F3 To exit:$'
  exit_string1 db 'You will be returned to The main screen$'

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

  mov dh,016H
  mov dl,0H
  set

  DisplayString exit_string

  mov dh,017H
  mov dl,0H
  set

  DisplayString exit_string1

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
      cmp al,0FFH
      jne contkoko93
      mov Flag_exit,1
      jmp CHK
      contkoko93:
      mov VALUE , al
      Displaychar VALUE
      CHK:
      
      ret
      receiver endp

  Mess PROC
  mov ah,1
  int 16h ;-> looks at the buffer
  jnz out_range
  jmp FinishedTakingChar_mess ;nothing is clicked
  out_range:
      mov dh,y1
      mov dl,x1
      set

      mov ah,0 ; get the char from the buffer
      int 16h

      ;check for enter
      cmp ah,28
      jne not_finished_yet ;THE_messege_sent IS THE DATA TO BE SENT
      ; for new line
      DisplayString nl
      get
      mov x1,dl
      mov y1,dh
      CMP actualmessege_sent_Size,0
      JNE EMPTY_MESS
      JMP FinishedTakingChar_mess
      EMPTY_MESS:
      xor ch,ch
      MOV Cl,actualmessege_sent_Size
      MOV SI,OFFSET THE_messege_sent
      SENT_LOOP:
      MOV AL,[SI]
      mov VALUE,al
      CALL send
      INC SI
      LOOP SENT_LOOP

      ; send new line
      mov VALUE,10
      CALL send
      mov VALUE,13
      CALL send

      MOV AL,'$'
      MOV DI, offset THE_messege_sent
      MOV CX,140
      REP STOSB
      mov actualmessege_sent_Size,0
      jmp FinishedTakingChar_mess
      
      not_finished_yet:

      ; CHECK_IF_ENTER F3 TO EXIT:
      cmp ah,61 ;; check if F3 is pressed
      jne NO_EXIT
      mov Flag_exit,1

      ;send stop signal
      ; send new line
      mov VALUE,0FFH
      CALL send

      MOV AL,'$'
      MOV DI, offset THE_messege_sent
      MOV CX,140
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
      cmp x1,0
      je back_line
      DEC x1
      mov dh,y1
      mov dl,x1
      set
      Displaychar ' '
      ;over ride on space
      mov dh,y1
      mov dl,x1
      set
      jmp FinishedTakingChar_mess
      back_line:
      DEC y1
      MOV X1,79
      mov dh,y1
      mov dl,x1
      set
      Displaychar ' '
      ;over ride on space
      mov dh,y1
      mov dl,x1
      set
      jmp FinishedTakingChar_mess 
      ADD_TO_THE_messege_sent:
      ; READ_KEY
      ;then store The char and print it then inc the size
      cmp actualmessege_sent_Size,139  ;; command is full  -> in order to not delete $ at the end
      je FinishedTakingChar_mess
      mov di,offset THE_messege_sent 
      mov bl,actualmessege_sent_Size
      xor bh,bh
      add di,bx
      mov [di],al ;;the char is moved to the end of string
      inc actualmessege_sent_Size
      Displaychar al
      ;; to get last position
      get
      mov x1,dl
      mov y1,dh

      FinishedTakingChar_mess:
      ;; SEE IF I WANT TO SCROLL
      CMP y1,0AH
      JNE CONT_NO_SCROLL

      mov ah,6       ; function 6
      mov al,1        ; scroll by 1 line    
      mov bh,7       ; normal video attribute         
      mov ch,1       ; upper left Y
      mov cl,0H        ; upper left X
      mov dh,9     ; lower right Y
      mov dl,79      ; lower right X 
      int 10h           

      DEC y1
      MOV X1,0
      mov dh,y1
      mov dl,x1
      set

      CONT_NO_SCROLL:
  ;;receiving ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      mov dh,y2
      mov dl,x2
      set
      
      call receiver


      get
      mov x2,dl
      mov y2,dh

      ;FinishedrecChar_mess:
      ;; SEE IF I WANT TO SCROLL
      CMP y2,14H
      JNE CONT_NO_SCROLL1

      mov ah,6       ; function 6
      mov al,1       ; scroll by 1 line    
      mov bh,7       ; normal video attribute         
      mov ch,0CH     ; upper left Y
      mov cl,0H      ; upper left X
      mov dh,13H     ; lower right Y
      mov dl,79      ; lower right X 
      int 10h           

      DEC y2
      MOV X2,0
      mov dh,y2
      mov dl,x2
      set

      CONT_NO_SCROLL1:

      ; scan code for up arrow -> 38


      ret
  Mess ENDP


  ;description
  Reset_VARS PROC
    mov x1, 0AH ; sending
    mov y1, 1H
  
    mov x2, 0AH ; recieving
    mov y2, 0CH
    mov finished_taking_input , 0 ; just a flag to indicate we finished entering the string
    mov Flag_exit, 0

    mov actualmessege_sent_Size , 0 
    mov al,'$'
    mov cx,140
    mov di,offset THE_messege_sent
    rep stosb

    ret
  Reset_VARS ENDP

  mainChat proc far
  MOV AX,@DATA
    MOV DS,AX
    mov es,ax ; for string operation

  call intialize
  MOV Flag_exit,0H
  CLR_Screen_with_Scrolling_TEXT_MODE
  call Draw_chat

  chat_loop:

  cmp Flag_exit,1
  jne cont_mess
  CLR_Screen_with_Scrolling_TEXT_MODE

  call Reset_VARS

  ret
  cont_mess:



  call Mess

  jmp chat_loop

  mainChat endp

  end mainChat



