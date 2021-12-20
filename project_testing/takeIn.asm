 DisplayString MACRO STR
            mov ah,9h
            mov dx,offset STR
            int 21h
ENDM DisplayString  


.model small
.stack 64
.data
    command db 30 dup('$')
    command_Size db 0 ; to store the aactual size of input at the current time
    finished_taking_input db 0 ; just a flag to indicate we finished entering the string
.code
main proc far
    mov ax, @data
    mov ds, ax


    MAINLOOP:


    ; Clear screen
    mov ah,0
    mov al,13h
    int 10h

    
    DisplayString command
    ;; Check if a char is pressed -> yes? -> is backspace? 
    mov finished_taking_input,0
    call GetCommand

    cmp finished_taking_input,1
    je DONE_TAKING_INPUT
    

    mov cx,64000
    ll11: loop ll11

 mov cx,64000
    ll121: loop ll121

 mov cx,64000
    ll113: loop ll113

    jmp MAINLOOP


   DONE_TAKING_INPUT:


   MOV AH,4CH
    INT 21H ;GO BACK TO DOS ;to end the program
main endp


;description
GetCommand PROC
    mov ah,1
    int 16h ;-> looks at the buffer
    jz FinishedTakingChar ;nothing is clicked

    mov ah,0
    int 16h ;-> get key pressed AH:SC -- AL:Ascii
        ;;; backspace -> SC:0Eh
        ;; Enter -> 1C
    
    cmp ah,1Ch ;; check if enter is pressed
    jne CHECK_IF_BACKSLASH
    mov finished_taking_input,1
    jmp FinishedTakingChar

    CHECK_IF_BACKSLASH:
    cmp ah,0eh
    jne NOT_BACKSPACE
    ;if size>0 then delete the last char and dec string
    
    cmp command_Size,0
    je FinishedTakingChar
    mov di,offset command 
    mov bl,command_Size 
    dec bl
    xor bh,bh
    add di,bx
    mov [di], '$'   
    dec command_Size
    jmp FinishedTakingChar 
    NOT_BACKSPACE:
    ;then store The char and print it then inc the size
    mov di,offset command 
    mov bl,command_Size
    xor bh,bh
    add di,bx
    mov [di],al ;;the char is moved to the end of string
    inc command_Size
    FinishedTakingChar:
    ret
GetCommand ENDP



end main
