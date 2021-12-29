DisplayString MACRO STR
            xor bx,bx
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
    mov di,0 ; to store result
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


INC_CURSOR MACRO N
    ;pos is row-col
    mov bh,0       ;page number
    mov ah,3
    int 10h ;; get cursor in dh-dl   
    add dl,N
    INC DL   
    mov bh,0       ;page number
    mov ah,2
    int 10h ;; mov cursor 

ENDM INC_CURSOR

DisplayString_AT_position_not_moving_cursor MACRO STR, pos
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
ENDM DisplayString_AT_position_not_moving_cursor  

DisplayString_AT_position_and_move_cursor MACRO STR, pos
    ;assumes Graphics mode
    ;returns The cursor to its initial position before it ends
    ;pos is row-col
    XOR BX,BX       ;page number
    mov dx,pos
    mov ah,2
    int 10h ;; mov cursor 

    DisplayString STR


ENDM DisplayString_AT_position_and_move_cursor  

UPDATE_notification_bar MACRO new_msg
    ;; updates the notification bar with a new message
    ;; done using Scrolling
    ;scroll the screen
    mov ax, 0701h                ;Scroll Screen AH=06 (Scroll), AL=1 one line
	mov bh, 0Eh                   ;Normal attributes -> 07 ;; 0E-> yellow text
	mov cx, 1700h                  ;from row 17h col 0
	mov dx, 1850H                ;To end of screen
	int 10h                      ;Clear the first line


    DisplayString_AT_position_not_moving_cursor new_msg ,1705h ;print in the next row
endm UPDATE_notification_bar


;;There should be another clear with scrolling 
;; impelement it if needed
CLR_Screen_with_text_mode macro
    mov ah, 0                    ;Change video mode (Text MODE)
	mov al, 03h
	int 10h
endm CLR_Screen_with_text_mode

;;had to split modes as the color to fill the space is different 07-TM and 00-GM
CLR_Screen_with_Scrolling_TEXT_MODE macro
  	mov ax, 0600h                ;Scroll Screen AH=06 (Scroll), AL=0 Entire Page
	mov bh, 07                   ;Normal attributes
	mov cx, 0                    ;from 0, 0
	mov dx, 184FH                ;To 18h, 4fh
	int 10h                      ;Clear Screen
endm CLR_Screen_with_Scrolling_TEXT_MODE

;;not TESTED -> TRY TO TEST THE LIMITS IF YOU WANNA TRY IT
CLR_Screen_with_Scrolling_GRAPHICS_MODE macro
  	mov ax, 0600h                ;Scroll Screen AH=06 (Scroll), AL=0 Entire Page
	mov bh, 00                   ;Normal attributes
	mov cx, 0                    ;from 0, 0
	mov dx, 1828H                ;To 18h, 28h ;;end of screen
	int 10h                      ;Clear Screen
endm CLR_Screen_with_Scrolling_GRAPHICS_MODE


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



LEVEL_SELECTION macro
;local something_clicked, check_key_pressed2 , something_clicked,check_f2_, buffer_not_empty_yett, remove_key_from_buffer2, LEVEL_IS_SELECTED
    check_key_pressed2:
				mov ah, 1
				int 16h           ;Get key pressed (do not wait for a key - AH:scancode, AL:ASCII)

				jnz something_clicked ;; something is clicked
				jmp check_key_pressed2
				something_clicked:
				
				;; check the type of the key
				cmp ah,3bh ;f1
				jne check_f2_
				;in case of F1
				mov Game_Level,1     ;;level 1 is selected
                jmp LEVEL_IS_SELECTED
				check_f2_:
				cmp ah,3ch ; F2
				jne remove_key_from_buffer2
				;in case of F2
				mov Game_Level,2    ;;level 2 is selected
                jmp LEVEL_IS_SELECTED
				remove_key_from_buffer2:
				;; delete The key from buffer
				buffer_not_empty_yett:
					mov ah,07
					int 21h
					mov ah, 1
					int 16h           ;Get key pressed (do not wait for a key - AH:scancode, AL:ASCII)
				jne buffer_not_empty_yett  ;; to make sure its empty
				;; the second loop is here but nothing to display now
			jmp check_key_pressed2
            LEVEL_IS_SELECTED:
            empitify_buffer  ;; Just To Be make Sure
endm LEVEL_SELECTION


empitify_buffer macro
local buffer_not_empty_yet, IT_IS_EMPTY
    buffer_not_empty_yet:
        mov ah, 1
        int 16h           ;Get key pressed (do not wait for a key - AH:scancode, AL:ASCII)
        jz IT_IS_EMPTY
        Read_KEY
        jmp buffer_not_empty_yet  ;; to make sure its empty
        IT_IS_EMPTY:
endm empitify_buffer


ReadNumberhexa_in_ax MACRO 
    local l1, l2, numb, finished, enter_pressed_1

    ;; Read number and put in ax
    mov cx,0
    mov dx,0
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
        ;sub dl,'0'
        cmp dl,'A'
        jb numb
        cmp dl, 'F'
        ja numb
        ;; from A-F
        sub dl,55
        jmp finished
        numb:
        ;; from 1 - 9 
        sub dl,'0'
        finished:
        push dx 
        cmp cl,4
        jne l1
    enter_pressed_1:


    mov bx,1
    mov di,0 ; to store resu
     l2:
    ; pop and multi then add to dx
    pop ax
    mul bx
    add di,ax
    mov ax,bx
    mov bx,16
    mul bx
    mov bx,ax
    loop l2
    mov ax,di

ENDM ReadNumberhexa_in_ax

DISPLAY_num_in_HEX_ macro pos ,count ,value 
    local deconstruct_it,Print_chars
    mov bh,0
    mov dx,pos
    mov ah,2
    int 10h    ; set cursor position where you are gonna print  



  mov DI,offset ASC_TBL
  mov cx, count
  mov ax,value
  deconstruct_it:
   mov dx,0
   mov bx,16
   div bx
   ;;dx -> rest ax, res
   mov bx,dx
   mov bx, [Di][bx] ;; convert to to the ssuitabble ascii code
   push bx ;; to pop and print it at the end
  
   loop deconstruct_it
  
   mov cx,count
   mov bh,0 ;;page
   Print_chars:
    pop ax ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
   loop  Print_chars

endm DISPLAY_num_in_HEX_
LEVEL_PROCESSING macro
    local SKIP_ASSIGNMENT,_continue
    ChangeVideoMode 3h ;;CLR Screen
    DisplayString_AT_position_and_move_cursor choose_hidden_char 0304h
    Read_KEY
    mov hidden_char,al
    mov dl,al
	mov ah,2     ;; to display the the char into screen (echo)
	int 21h

    ;; send and recieve The CHAR

    
    ;; AX: 1245
    cmp Game_Level,2
    je _continue
    jmp SKIP_ASSIGNMENT
    _continue:
    DisplayString_AT_position_and_move_cursor MY_REGs_msg 0404h
    DisplayString_AT_position_and_move_cursor AX_msg 0504h
    ReadNumberhexa_in_ax 
    mov L_AX,AX
    DisplayString_AT_position_and_move_cursor BX_msg 0604h
    ReadNumberhexa_in_ax 
    mov L_BX,AX
    DisplayString_AT_position_and_move_cursor CX_msg 0704h
    ReadNumberhexa_in_ax 
    mov L_CX,AX
    DisplayString_AT_position_and_move_cursor DX_msg 0804h
    ReadNumberhexa_in_ax 
    mov L_DX,AX
    DisplayString_AT_position_and_move_cursor SI_msg 0904h
    ReadNumberhexa_in_ax 
    mov L_SI,AX
    DisplayString_AT_position_and_move_cursor DI_msg 0a04h
    ReadNumberhexa_in_ax 
    mov L_DI,AX
    DisplayString_AT_position_and_move_cursor SP_msg 0b04h
    ReadNumberhexa_in_ax 
    mov L_SP,AX
    DisplayString_AT_position_and_move_cursor Bp_msg 0c04h
    ReadNumberhexa_in_ax 
    mov L_BP,AX

    
    DisplayString_AT_position_and_move_cursor HIS_REGs_msg 043Ah
    DisplayString_AT_position_and_move_cursor AX_msg 053Ah
    ReadNumberhexa_in_ax 
    mov R_AX,AX
    DisplayString_AT_position_and_move_cursor BX_msg 063Ah
    ReadNumberhexa_in_ax 
    mov R_BX,AX
    DisplayString_AT_position_and_move_cursor CX_msg 073Ah
    ReadNumberhexa_in_ax 
    mov R_CX,AX
    DisplayString_AT_position_and_move_cursor DX_msg 083Ah
    ReadNumberhexa_in_ax 
    mov R_DX,AX
    DisplayString_AT_position_and_move_cursor SI_msg 093Ah
    ReadNumberhexa_in_ax 
    mov R_SI,AX
    DisplayString_AT_position_and_move_cursor DI_msg 0a3Ah
    ReadNumberhexa_in_ax 
    mov R_DI,AX
    DisplayString_AT_position_and_move_cursor SP_msg 0b3Ah
    ReadNumberhexa_in_ax 
    mov R_SP,AX
    DisplayString_AT_position_and_move_cursor Bp_msg 0c3Ah
    ReadNumberhexa_in_ax 
    mov R_BP,AX

    SKIP_ASSIGNMENT:
    DisplayString_AT_position_and_move_cursor Press_any_Key_message 1004h 
    Read_KEY

endm LEVEL_PROCESSING

WAIT_seconds_TIME MACRO n_SECONDS
    local L1
    mov AH,2Ch
    int 21h ;; Get System Time
    mov bl,dh ;;current seconds
    add bl,n_seconds

    L1:
    mov AH,2Ch
    int 21h ;; Get System Time
    cmp dh,bl ;;didn't reach our time yet
    jne L1
ENDM WAIT_seconds_TIME

WAIT_One_centi_second_TIME MACRO 
    local L1
    mov AH,2Ch
    int 21h ;; Get System Time
    mov bl, dl ;;current seconds ; 0-99
    

    L1:
    mov AH,2Ch
    int 21h ;; Get System Time
    cmp dl,bl ;;didn't reach our time yet
    je L1
endm WAIT_One_centi_second_TIME


Wait_centi_seconds MACRO N
    local LL
    mov di,N 
    LL:
      WAIT_One_centi_second_TIME  
        dec di
    jnz LL   
ENDM Wait_centi_seconds

INSTRUCTIONS_PAGE macro
    ChangeVideoMode 3H
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg 0A14h
    ;;should display different messages 
    WAIT_seconds_TIME 3 ;; WAITS FOR 10 SECONDS
    ;;
endm INSTRUCTIONS_PAGE

;;Game Graphics

drawPixelWithOffset macro column, row, color, X_origin, Y_origin ;x, y, color...the last two parameters are the offset position of the pixel
        xor ch,ch
        xor dh,dh
        mov dl, row
        mov cl, column
        mov al, color
        ;Dynamics:
        add dx, Y_origin
        add cx, X_origin
        int 10h
endm drawPixelWithOffset

Draw_IMG macro p_x, p_y,imga, imgasize
	local KeepDrawing
	mov ah, 0ch
	mov bx,  offset imga
	KeepDrawing:
			drawPixelWithOffset [bx], [bx+1], [bx+2],  p_x,  p_y
			add bx, 3
			cmp bx, offset imgasize
	JNE KeepDrawing
	
ENDm Draw_IMG 

Draw_IMG_with_color macro p_x, p_y,imga,color ,imgasize
	local KeepDrawing
	mov ah, 0ch
	mov bx,  offset imga
	KeepDrawing:
			drawPixelWithOffset [bx], [bx+1], color,  p_x,  p_y
			add bx, 3
			cmp bx, offset imgasize
	JNE KeepDrawing
	
ENDm Draw_IMG 






Convert_OP_TO_HEXA MACRO OPERAND 
    local l1, l2, numb, SKIP_NUM, end_of_op

    ;; Read number and put in ax
    mov cx,0
    mov dx,0
    MOV DI, offset OPERAND
    l1:
        
        cmp [DI],'$'
        je end_of_op
        inc cl  ;;counter 
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
     l2:
    ; pop and multi then add to dx
    pop ax
    mul bx
    add di,ax
    mov ax,bx
    mov bx,16
    mul bx
    mov bx,ax
    loop l2
    mov ax,di

ENDM Convert_OP_TO_HEXA



;;;;;;;;;;;;;;;;;;;;;;;;--------------------------;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;SARAH;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



moveBird macro limit,start,x_velocity,x_coordinate
local finish
    mov ax,x_velocity
    add x_coordinate,ax
    cmp x_coordinate,limit
    jb finish
    mov x_coordinate,start
    
   finish:
endm moveBird



moveFireBall macro velocity,yCoordinate,ifPressed
local finish
    mov ax,velocity
    sub yCoordinate,ax
    cmp yCoordinate,15
    ja finish
    mov ifPressed,0
    finish:
endm moveFireBall



checkTime macro
 local check_time
 check_time:
    mov ah,2ch ;get the system time
    int 21h    ;ch=hour  cl=minute  dh=seconds  dl=1/100seconds
    
    cmp dl,time_aux  ;is the current time equal to the prev one?
    je check_time    ;if it's the same, check again
                     ;if different --> draw, move...               
    mov time_aux,dl  ;update time
endm checkTime 


movePaddle macro 
    local exitMacro,checkLeft,semiExitMacro,vvvv,checkRightPaddleRightControl,checkRightPaddleLeftControl
    ;check if any key is being pressed (if not, exit this macro) [int ah 01/16]
    ;zf =0 -> a key is pressed  
    mov ah,1
    int 16h
    jz exitMacro ;exists the macro since no key is pressed
    
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii

    ;right arrow-> move right   left arrow-> move left
    cmp ah,77 ;77 -> scan code of right arrow
    jne checkLeft ;checks if it's the left arrow
    mov ax,paddle_velocity
    mov bx,paddle_x
    add bx,ax
    cmp bx,135
    ja exitmacro
    add paddle_x,ax ;increases the paddle x-coordinate with the corresponding velocity --> moves it to the right
    jmp exitMacro
checkLeft:
    cmp ah,75 ;75 -> scan code of left arrow
    jne checkRightPaddleRightControl ;if
    mov ax,paddle_velocity
    mov bx,paddle_x
    sub bx,ax
    cmp bx,0
    jle exitMacro
    sub paddle_x,ax ;decreases the paddle x-coordinate with the corresponding velocity --> moves it to the left
    jmp exitMacro


checkRightPaddleRightControl: ;-> s is pressed

    cmp al,'d' ;77 -> scan code of right arrow
    jne checkRightPaddleLeftControl ;checks if it's the left arrow
    mov ax,right_paddle_velocity
    mov bx,right_paddle_x
    add bx,ax
    cmp bx,300
    ja exitmacro
    add right_paddle_x,ax ;increases the paddle x-coordinate with the corresponding velocity --> moves it to the right
    jmp exitMacro

 checkRightPaddleLeftControl: ;-> a is pressed
    cmp al,'a' ;77 -> scan code of right arrow
    jne exitMacro ;checks if it's the left arrow
    mov ax,right_paddle_velocity
    mov bx,right_paddle_x
    sub bx,ax
    cmp bx,160
    jb exitmacro
    sub right_paddle_x,ax
exitMacro:
  
endm movePaddle


checkForFire macro 
    local exitMacro,ro7Henak,rightPaddleFire
    ;check if any key is being pressed (if not, exit this macro) [int ah 01/16]
    mov ah,1
    int 16h
    jz exitMacro
    cmp ah,80 ;80 -> scan code of down arrow
    je ro7Henak

    cmp al,'s'
    jne exitmacro

    ;if a key is being pressed -> check which one it is
    ro7Henak:
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii

    ;we reached here, meaning the key pressed is down arrow
    cmp ah,80 ;80 -> scan code of down arrow
    jne rightPaddleFire
    ;we need to get the center x coordinate of the paddle, make the ball fire starting from that point 
    ;using the y coordinte of the paddle (192) to avoid the ball touching the paddle
    mov ax,paddle_x
    mov bx,paddle_width
    shr bx,1
    add ax,bx
    mov bx,Ballsize
    shr bx,2
    sub ax,bx
  
    mov fireBall_x,ax
    mov fireBall_y,190
    mov ifFireIsPressed,1
    jmp exitMacro

    rightPaddleFire:
    mov ax,right_paddle_x
    mov bx,right_paddle_width
    shr bx,1
    add ax,bx
    mov bx,BallSize
    shr bx,2
    sub ax,bx
  
    mov right_fireBall_x,ax
    mov right_fireBall_y,190
    mov right_ifFireIsPressed,1
    exitMacro:

endm checkForFire

compareBirdWithBall macro ball_x,fireBall_x,fireBall_y,BALL_SIZE,startOfBird,birdStatus,playerPoints,birdPoints
local notInTheRangeOfTheBird
    
    cmp fireBall_y,20
    ja notInTheRangeOfTheBird
    ;still haven't reached top of the screen

    mov ax,ball_x
    sub ax,8
    cmp ax,fireBall_x

    ja notInTheRangeOfTheBird
    ;not in the same row --> behind it
    add ax,BALL_SIZE
    add ax,8
    cmp ax,fireBall_x
    ;checks if the fire ball is in the same row as the flying ball, with some error -> ball size
    jb notInTheRangeOfTheBird
    mov al,birdPoints
    mov ah,0
    add playerPoints,ax
    
    mov ball_x,startOfBird
    mov birdStatus,0
    notInTheRangeOfTheBird:

endm compareBirdWithBall



randomBirdColor macro birdStatus,birdColor,colorIndex
local exitMacro
    cmp birdStatus,0
    jne exitMacro
    ;dx has the seconds and 1/100 seconds from the previous "check time" macro
    mov ah,2ch ;get the system time
    int 21h    ;ch=hour  cl=minute  dh=seconds  dl=1/100seconds
    
    mov  ax, dx
    xor  dx, dx
    mov  cx, 5    
    div  cx       ; here dx contains the remainder of the division - from 0 to 4
    mov di,dx
    mov colorIndex,dl
    mov ah,colors[di]  
    mov birdcolor,ah
    mov birdStatus,1
    exitMacro:
endm randomBirdColor


setBirdPointsWithTheCorrespondingColor macro colorIndex,birdPoints,pointsOfColorsArray
;moving colorIndex to bx first to avoid size mismatch
; bl-> color index [0..4], bh-> 0
mov bl,colorIndex
mov bh,0 

mov di,bx
mov al,pointsOfColorsArray[di]
mov birdPoints,al

endm setBirdPointsWithTheCorrespondingColor












