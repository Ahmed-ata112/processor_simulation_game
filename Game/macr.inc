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


    DisplayString_AT_position_and_move_cursor choose_hidden_char2 032Ah
    Read_KEY
    mov right_forbidden_char,al
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

WAIT_10_seconds_TIME MACRO 
    local L1
    ;; waits for 10 seconds
    mov dx,9680
    mov cx,98
    mov ah,86h
    int 15h
ENDM WAIT_10_seconds_TIME

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
    WAIT_10_seconds_TIME  ;; WAITS FOR 10 SECONDS
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









