DisplayString MACRO STR
            mov ah,9h
            mov dx,offset STR
            int 21h
ENDM DisplayString   

MoveCursorTo MACRO pos
    push ax
    push dx
    mov ah,2h
    mov dx,pos
    int 10h
    pop dx
    pop ax
ENDM MoveCursorTo

ReadString MACRO PromptMessage
    mov ah, 0AH                  ;Read from keyboard
	mov dx, offset PromptMessage
	int 21h
ENDM ReadString
ReadNumberdec_in_ax MACRO 
    local l1, l2, enter_pressed_1
    ;; Read number and put in ax
    mov cx,0
    l1:
    mov ah, 00   ;get key pressed (waits)
	int 16h      ; ah -> scan code  ;; al-> ascii code if found
    ;; enter key is ScanCode 1C
    cmp ah,1ch
    je enter_pressed_1
    inc cl
	mov dl,al
	mov ah,2     ;; to display the the char into screen (echo)
	int 21h
    sub dl,'0'
    push dx
    jmp l1
    enter_pressed_1:


    mov bx,1
    mov di,0 ; to store resu
     l2:
    ; pop and multi then add to dx
    pop ax
    mul bx
    add di,ax
    mov ax,bx
    mov bx,10
    mul bx
    mov bx,ax
    loop l2
    mov ax,di

ENDM ReadNumberdec_in_ax



DisplayString_AT_position_TEXTMODE MACRO STR, pos
    ;assumes Text mode
    ;returns The cursor to its initial position before it ends
    ;pos is row-col
    mov ah,3
    int 10h ;; get cursor in dh-dl  
    mov si , dx ; save it To set it back at the end
    mov bh,0       ;page number

    mov dx,pos
    mov ah,2
    mov bh,0
    int 10h ;; mov cursor 

    mov ah,9h
    mov dx,offset STR
    int 21h ;; print string

    mov dx,si ; get the initial Cursor position
    mov ah,2
    mov bh,0
    int 10h ;; mov cursor 
ENDM DisplayString_AT_position_TEXTMODE  


UPDATE_notification_bar MACRO new_msg
    ;; updates the notification bar with a new message
    ;; put the second int the first
    ;; TODO: Should be done using Scrolling
    mov SI,offset Second_msg_in_notification_bar
    mov DI,offset First_msg_in_notification_bar
    mov cx,80d
    REP MOVSb;Copies the first 80 bytes from si to di
    ;;put new message in the first
    mov SI,offset new_msg
    mov DI,offset Second_msg_in_notification_bar
    mov cx,80d
    REP MOVSb;Copies the 80 bytes from SI to DI
    ;; prints The two messages in The notification bar
    DisplayString_AT_position_TEXTMODE First_msg_in_notification_bar , 1705h
    DisplayString_AT_position_TEXTMODE Second_msg_in_notification_bar ,1805h ;print in the next row
endm UPDATE_notification_bar

UPDATE_notification_bar2 MACRO new_msg
    ;; updates the notification bar with a new message
    ;; done using Scrolling
    ;scroll the screen
    mov ax, 0701h                ;Scroll Screen AH=06 (Scroll), AL=1 one line
	mov bh, 0Eh                   ;Normal attributes -> 07 ;; 0E-> yellow text
	mov cx, 1700h                  ;from row 17h col 0
	mov dx, 1850H                ;To end of screen
	int 10h                      ;Clear the first line


    DisplayString_AT_position_TEXTMODE new_msg ,1705h ;print in the next row
endm UPDATE_notification_bar2


;;There should be another clear with scrolling 
;; impelement it if needed
CLR_Screen_with_text_mode macro
    mov ah, 0                    ;Change video mode (Text MODE)
	mov al, 03h
	int 10h
endm CLR_Screen_with_text_mode
CLR_Screen_with_Scrolling macro
  	mov ax, 0600h                ;Scroll Screen AH=06 (Scroll), AL=0 Entire Page
	mov bh, 07                   ;Normal attributes
	mov cx, 0                    ;from 0, 0
	mov dx, 184FH                ;To 18h, 4fh
	int 10h                      ;Clear Screen
endm CLR_Screen_with_Scrolling


Display_with_Color macro offset_str , len , color
    ;;display the string given an offset to it
    local lp
    mov si, offset_str
    mov di, len
    mov bl,color

    mov bh,0
    lp:
        mov cx,1 ; # of prints
        mov al, [si]
        mov ah, 9  
        mov bh,0
        int 10h
        mov ah,3
        int 10h ;; get cursor in dh-dl  
        inc dx     ;; to move it
        mov ah,2
        int 10h    ; set cursor position 

        inc si
        dec di
    jnz lp
Endm Display_with_Color

Display_with_Color_at_pos macro pos ,str , len  ,color 
    local lp
    ;;display the string given an offset to it
    ;; only supports Foreground
    mov si, offset str
    mov di, len
    mov bl, color
    mov bh,0

    mov ah,3
    int 10h ;; get cursor in dh-dl  
    push dx ;; to restore it at the end
    
    mov dx,pos
    mov ah,2
    int 10h    ; set cursor position 

    lp:
    mov cx,1 ; # of prints
        mov al, [si]
        mov ah, 9  
        mov bh,0
        int 10h
        mov ah,3
        int 10h ;; get cursor in dh-dl  
        inc dx     ;; to move it
        mov ah,2
        int 10h    ; set cursor position 

        inc si
        dec di
        jnz lp

    pop dx
    mov ah,2
    int 10h    ; Restore The cursor position (not changed)
Endm Display_with_Color_at_pos

ChangeVideoMode macro M ;-> 03h text ----  13h video  
        mov ah, 00h
        mov al, M
        int 10h
endm ChangeVideoMode







READ_KEY macro            ;waits until a key is pressed in the keyboard buffer: AH:SC AL:ASCII
        mov ah, 0
        int 16h
endm READ_KEY








