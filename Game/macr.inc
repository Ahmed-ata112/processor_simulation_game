DisplayString MACRO STR
            xor bx,bx
            mov ah,9h
            mov dx,offset STR
            int 21h
ENDM DisplayString   


FIX_POINTS_MIN MACRO 
    MOV AX,playerPoints
    CMP AX,right_playerPoints
    JB FIRST_IS_LESS
    MOV AX,right_playerPoints
    MOV playerPoints,AX
    JMP FININ
    FIRST_IS_LESS:
    MOV right_playerPoints,AX



    FININ:

ENDM FIX_POINTS_MIN




EXECUTE_THECOMMAND_AT_SIDE MACRO turn
    local skip_excuting_the_command
    call CHECK_FORBIDDEN_CHARS    ;; returns value in contains_forbidden
    cmp contains_forbidden,1    ;; the command had a forbidden char
    je skip_excuting_the_command
    mov al, turn       ;;send Game_turn to determine which player to execute commands on
    CALL exchangeValuesInRegisters
    CALL EX_MAIN
    mov al, turn       ;;send Game_turn to determine which player to execute commands on
    CALL exchangeValuesInRegisters
    skip_excuting_the_command:
ENDM EXECUTE_THECOMMAND_AT_SIDE


MoveCursorTo MACRO pos
    XOR bx,bx
    mov ah,2h
    mov dx,pos
    int 10h
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

Reset_Command macro
    xor CX,CX
    mov CX, 30
    mov di , offset THE_COMMAND
    mov al, '$'
    rep stosb 
    MOV actualcommand_Size,0


    xor CX,CX
    mov CX, 30
    mov di , offset L_commandData
    mov al, '$'
    rep stosb 
    MOV Actual_L_commandSize,0


    xor CX,CX
    mov CX, 30
    mov di , offset r_commandData
    mov al, '$'
    rep stosb 
    MOV Actual_r_commandSize,0
    



endm Reset_Command


Update_the_Commands MACRO 
    local check_p2,check_p3
    ;; if turn=1 mov to L_command else R_command
    cmp Game_turn,1 ;;first player
    jne check_p2
    xor ch,ch
    mov cl,commandSize
    mov Actual_L_commandSize,cl
    mov si,offset THE_COMMAND
    mov di ,offset L_commandData
    rep movsb
    check_p2:
    cmp Game_turn,2 ;;second player
    jne check_p3
    xor ch,ch
    mov cl,commandSize
    mov Actual_R_commandSize,cl
    mov si , offset THE_COMMAND
    mov di , offset R_commandData
    rep movsb
    check_p3:
ENDM Update_the_Commands

SWAP_TURNS MACRO 
    local l1, l2

    cmp Game_turn,1
    jne l1
    mov Game_turn,2
    jmp l2
    l1:
    mov Game_turn,1
    l2:
ENDM SWAP_TURNS
DisplayString_AT_position_not_moving_cursor MACRO STR, pos
    ;assumes Text mode
    ;returns The cursor to its initial position before it ends
    ;pos is row-col
    mov ah,3
    int 10h ;; get cursor in dh-dl  
    mov si , dx ; save it To set it back at the end
    

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
    mov ax, 0701h                ;Scroll Screen AH=07(Scroll DOWN), AL=1 one line
	mov bh, 0Eh                   ;Normal attributes -> 07 ;; 0E-> yellow text
	mov cx, 1700h                  ;from row 17h col 0
	mov dx, 1850H                ;To end of screen
	int 10h                      ;Clear the first line

    MoveCursorTo 1700H
	
	; read time
	
	mov ah, 2ch
	int 21h

	
	mov al, ch
	mov ah, 0
	call dis2dig
	
	
    MOV AL,':'  ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
	
	mov ah, 0
	mov al, cl
	
	call dis2dig
	
	MOV AL,':'  ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
	MOV AL,' '  ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
	
    DisplayString_AT_position_not_moving_cursor new_msg ,1707h ;print in the next row
endm UPDATE_notification_bar

DEAW_STATUS_BAR MACRO 
    DisplayString_AT_position_not_moving_cursor STATUS_BAR_MSG ,1600h ;print in the next row
    
ENDM


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
    mov forbidden_char,al
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


    SKIP_ASSIGNMENT:
    DisplayString_AT_position_and_move_cursor Press_any_Key_message 1004h 
    Read_KEY

    INSTRUCTIONS_PAGE
    ;; while its showing send the chars and Regs if needed
    mov al,forbidden_char
    mov byteToSend,al
    call sendByteproc
    call receiveByteproc
    mov al, byteReceived
    mov  right_forbidden_char,al   
    


    

   Exchange_Regs L_Ax R_AX
   Exchange_Regs L_Bx R_BX
   Exchange_Regs L_Cx R_CX
   Exchange_Regs L_Dx R_DX
   Exchange_Regs L_SI R_SI
   Exchange_Regs L_DI R_DI
   Exchange_Regs L_SP R_SP
   Exchange_Regs L_BP R_BP
endm LEVEL_PROCESSING

Exchange_Regs MACRO REG ,REG2
    ;;sends one and receive the other
    mov ax,REG
    mov byteToSend,al
    call sendByteproc
    ;;Receive it
    call receiveByteproc
    mov bl, byteReceived

    mov ax,REG
    mov byteToSend,ah
    call sendByteproc
    ;;Receive it
    call receiveByteproc
    mov bh, byteReceived
    mov REG2,bx
ENDM Exchange_Regs

RecWord MACRO REG2
    call receiveByteproc
    mov bl, byteReceived
    call sendByteproc
    call receiveByteproc
    mov bh, byteReceived
    LEA SI,REG2
    MOV [SI],BL ;FIRST BYTE
    INC SI
    MOV [SI],BH ;SECOND BYTE
    call sendByteproc

ENDM

SendWord macro REG
    mov SI, OFFSET REG
    MOV AL,[SI]
    mov byteToSend,al
    call sendByteproc
    ;;rec to relax
    call receiveByteproc
    ;;Receive it
    INC SI ;;THE OTHER BYTE
    MOV AL,[SI]
    mov byteToSend,aL
    call sendByteproc

    call receiveByteproc
endm SendWord
WAIT_10_seconds_TIME MACRO 
    ;; waits for 10 seconds
    mov dx,9680
    mov cx,98
    mov ah,86h
    int 15h
ENDM WAIT_10_seconds_TIME

WAIT_5_seconds_TIME MACRO 
    ;; waits for 10 seconds
    mov dx,4b40h
    mov cx,4ch
    mov ah,86h
    int 15h
ENDM WAIT_5_seconds_TIME

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
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg 0100h
    ;DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg1 0200h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg2 0300h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg3 0400h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg5 0600h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg6 0700h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg7 0800h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg8 0900h

    CMP GAME_LEVEL,2
    JNE NOT_TODAY_BITC
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg4 0500h
    DisplayString_AT_position_and_move_cursor INSTRUCTIONS_msg9 0A00h
    NOT_TODAY_BITC:
    ;;should display different messages 
    WAIT_5_seconds_TIME  ;; WAITS FOR 5 SECONDS
    ;;Send And Receive The Forbidden Char
    
  

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
local finish,clearGame
    mov ax,x_coordinate
    mov bx,x_velocity
    add bx,ax ;;adds the velocity to the coordinate
    cmp bx,limit
    ja clearGame
    mov x_coordinate,bx
    mov right_birdX,bx
   
    jmp finish

clearGame:
    mov gamestatus,0
    mov x_coordinate,start
    mov right_birdX,start
   
    finish:
    add right_birdX,160
endm moveBird


moveFireBall macro velocity,yCoordinate,ifPressed
local finish
    mov ax,velocity
    sub ax,Ballsize
    sub yCoordinate,ax
    cmp yCoordinate,5
    jg finish
    mov ifPressed,0
    finish:
endm moveFireBall





movePaddle macro paddle_x,paddle_velocity_x,paddle_y,paddle_velocity_y,upControl,downControl,rightControl,leftControl,rightlimit,leftlimit 
    local exitMacro,checkLeft,checkUp,checkDown
    ;check if any key is being pressed (if not, exit this macro) [int ah 01/16]
    ;zf =0 -> a key is pressed  
    mov ah,1
    int 16h
    jz exitMacro ;exists the macro since no key is pressed
    
    

;checks right control
    cmp ah,rightControl ;77 -> scan code of right arrow
    jne checkLeft ;checks if it's the left arrow

    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii
    mov ax,paddle_velocity_x
    mov bx,paddle_x
    add bx,ax
    cmp bx,rightlimit
    ja exitmacro
    add paddle_x,ax ;increases the paddle x-coordinate with the corresponding velocity --> moves it to the right
    jmp exitMacro
checkLeft:
    cmp ah,leftControl ;75 -> scan code of left arrow
    jne checkUp ;if
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii
    mov ax,paddle_velocity_x
    mov bx,paddle_x
    sub bx,ax
    cmp bx,leftlimit
    jle exitMacro
    sub paddle_x,ax ;decreases the paddle x-coordinate with the corresponding velocity --> moves it to the left
    jmp exitMacro
checkUp:
    cmp ah,upControl ;72 -> scan code of up arrow
    jne checkDown ;if
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii
    mov ax,paddle_velocity_y
    mov bx,paddle_y
    sub bx,ax
    cmp bx,20
    jle exitMacro
    sub paddle_y,ax ;decreases the paddle y-coordinate with the corresponding velocity --> moves it to the left
    jmp exitMacro

checkDown:
    cmp ah,downControl ;80 -> scan code of down arrow
    jne exitMacro
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii
    mov ax,paddle_velocity_y
    mov bx,paddle_y
    add bx,ax
    cmp bx,188
    jae exitMacro
    add paddle_y,ax ;decreases the paddle x-coordinate with the corresponding velocity --> moves it to the left

exitMacro:
  
endm movePaddle


checkForFire macro fireScanCode,paddle_x,paddle_width,Ballsize,fireBall_x,fireBall_y,ifFireIsPressed,paddle_y
    local exitMacro,ro7Henak,rightPaddleFire
    ;check if any key is being pressed (if not, exit this macro) [int ah 01/16]

    mov ah,1
    int 16h
    jz exitMacro
    cmp ah,fireScanCode ;80 -> scan code of down arrow
    jne exitMacro

    ;if a key is being pressed -> check which one it is
    
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii
    cmp ifFireIsPressed,1
    je exitMacro        ;;already one is present

    ;we reached here, meaning the key pressed is down arrow
   
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
    mov ax,paddle_y
    mov fireBall_y,ax
    mov ifFireIsPressed,1
   
    exitMacro:

endm checkForFire

compareBirdWithBall macro ball_x,fireBall_x,fireBall_y,BALL_SIZE,startOfBird,birdStatus,playerPoints,birdPoints,colorIndex
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
    mov si,offset balls
    mov bl,colorIndex
    mov bh,0
    add si,bx
    inc byte ptr [si]
    mov gamestatus,0
    mov birdX,0
    mov right_birdX,160
    notInTheRangeOfTheBird:

endm compareBirdWithBall



randomBirdColor macro birdColor,colorIndex
local exitMacro
    cmp birdStatus,0
    jne exitMacro
    ; cmp right_birdStatus,0
    ; jne exitmacro
    
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

checkTimeInterval macro gameStatus,prevTime,timeInterval
local exit
    mov ah,2ch ;get the system time
    int 21h    ;ch=hour  cl=minute  dh=seconds  dl=1/100seconds 

    mov al,dh
    mov ah,0
    mov bx,0
    mov bl,timeInterval
    div bl
    cmp ah,0 ; --> checks if the current time is divisible by 10
    jne exit ; --> if not, does nothing
    cmp dh,prevTime  ; --> if it is, then checks if it's the same second as before
                     ; the proccessor is fast and it checks the same second many times and causes undesirable toggling

    je exit
    mov prevTime,dh ; reaching here meaning it's not the same previous second, so we TOGGLE the state of the game

    cmp gameStatus,0
    ;jne changeToOne ;--> if the game status isn't 1 (is 0), change it to one
    jne exit
    mov gameStatus,1
    ; mov ax,birdX
    ; xchg right_birdX,ax
    ; xchg ax,birdx
    ;jmp exit

    ; changeToOne:
    ; mov gameStatus,1


    exit:

endm checkTimeInterval


Draw_blank_line MACRO 

    mov ax, 0700h                ;Scroll Screen AH=07(Scroll DOWN), AL=1 one line
	mov bh, 00                   ;Normal attributes -> 07 ;; 0E-> yellow text
	mov cx, 0700h                  ;from row 17h col 0
	mov dx, 1250H                ;To end of screen
	int 10h                      ;Clear the first line

ENDM Draw_blank_line




;;MENNA
SizeMismatchValidation MACRO op1,op2,result    
;;;;;;;;;;;;;;;;;;;;;
CMP op1,'['
JNE SYAED
JMP finish
SYAED:
CMP op2,'['
JNE SYAED2
JMP finish
SYAED2:
mov bx,0
mov cx,0  ;count
SkipZero:
cmp op2+bx,'0'
je ahaha
jmp count_data
ahaha:
inc bx ;skip zero
jmp SkipZero

cmp op2+bx,'$' ; opernad=0
jne ahh
jmp finish
ahh:

count_data:
jne q321
jmp finish
q321:
inc bx
inc cx
cmp op2+bx,'$'
jne count_data
cmp cx,3
jge _2bytes
mov ax,1 ;1byte
jmp start
_2bytes:
cmp cx,5
jl dfdf
jmp INvalid
dfdf:
mov ax,2
start:
check_op_size_mismatch op1,op2,result
cmp result,0
jne q9
jmp finish
q9:
check_op_size_mismatch op2,op1,result 
jmp finish 
;;;;;;;;;;;;;;;;;;;;
INvalid:
mov Command_valid,0
finish:       
       
ENDM SizeMismatchValidation

;; Menna
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
    cmp ax,2
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
    cmp ax,2
    je NOTvalid

    valid:
    mov result,1 
    jmp end

    NOTvalid:
    mov result,0
    end:

ENDM check_op_size_mismatch

    ;;  Hany
Check_memorytomemory MACRO des1, des2, Result_2  ;; check if it iss memory to memory --  Result_2 = 0 if it is not valid and 1 for valid  
    Local no_bracket
    mov SI,offset des1
    mov Di,offset des2
    cmp [SI],BYTE ptr '['
    jnz no_bracket
    cmp [Di], BYTE ptr '['
    jnz no_bracket
    mov Si,offset Result_2
    mov [Si], BYTE ptr 0
    jmp return
    no_bracket:
    mov [Si],BYTE ptr 1
    return:
        
ENDM Check_memorytomemory



check_if_in_array macro arr, arr_len, element_size, op, result
    local L1 ,finish,found,skip
    lea si,arr
    mov bh,arr_len  ;; number of elements in array
    
    L1:  
    mov cx,0 
    mov cl,element_size
    lea di,op ; store the string we search for
    repe CMPSB    
    
    cmp cx,0 ;; CX =0 if the 2 current words equall 
    jne skip ;try the next pair 
    ;;
    dec si
    dec di
    mov al,[si]
    cmp al,[di]
    je found 
    inc si
    skip:
    add si,cx ;to skip current word if it doesn't match
    
    dec bh
    jnz L1 
    
    
    ;; finsished loop and not found
    mov result,0
    jmp finish
    ;;valid one -> element in array
    found:    
    mov result,1
    finish:

endm check_if_in_array



sendByte macro happyByte                    ;The byte to be sent.
    local whileHolding
        mov dx , 3FDH                           ;Line Status Register
        whileHolding: 
            In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
            test al , 00100000b                 ;If zero then it's not empty, otherwise:
            JZ whileHolding      
        mov dx , 3F8H                           ;Transmit data register
        mov al, happybyte
        out dx , al
endm sendByte


receiveByte macro freshByte         ;The byte to be received would be in freshByte, the Restart tells it where to go in case data isn't ready to be received.       
    local whileNotDataReady, Reset
        mov dx , 3FDH                           ;Line Status Register
        whileNotDataReady:
            in al, dx
            test al, 1                          ;In fact is 00000001b
            JZ  Reset                         ;Not ready, otherwise: 
            mov dx, 3F8H
            in al, dx
            mov freshByte, al
            Reset:
    Mov al, 0ffh                        ;In case not ready put 0ffh in al (flag)
    endm receiveByte
    
receiveByteG macro freshByte         ;The byte to be received would be in freshByte, the Restart tells it where to go in case data isn't ready to be received.       
        local whileDataNotReady
        mov dx , 3FDH                           ;Line Status Register
        whileDataNotReady:
            in al, dx
            test al, 1                          ;In fact is 00000001b
            JZ  whileDataNotReady                ;Not ready, otherwise: 
            mov dx, 3F8H
            in al, dx
            mov freshByte, al
    endm receiveByteG


checkIftoSend MACRO 
    mov dx , 3FDH                           ;Line Status Register
    In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
    test al , 00100000b                 ;If zero then it's not available
ENDM checkIftoSend


checkIfToRec MACRO 
    MOV DX,3FDh     ;;LineStatus
	IN AL,DX
	TEST AL,1   ;jz after it to know if something is pending to be received
ENDM checkIfToRec










