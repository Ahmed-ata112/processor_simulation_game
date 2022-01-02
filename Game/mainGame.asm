	include macr.inc
    include ex_macr.inc
	.286
	.model small
	.stack 64
	.data  

    include arrs.inc        ; Contains all the arrays of images
	nl db 10,13,'$'
	Enter_Name_message0 db 'Press Enter key to continue ', '$'
	Enter_Name_message db 'Please enter Your Name: ', '$' 
	Enter_SECOND_Name_message db 'Please enter second Name: ', '$' 
	Enter_Name_message2 db 'Name MUST start with a letter (No digits or special characters)$'
	Enter_Points_message db 'Please enter Initial Points: ', '$'  
	Enter_other_Points_message db 'Second player, Please enter Initial Points: ', '$'  
	Press_any_Key_message db 'press any key to continue...$'
	MAIN_Screen_message1 db 'To Start Chatting press F1','$'
	MAIN_Screen_message2 db 'To Start Game press F2$'  
	MAIN_Screen_message3 db 'To end Program press ESC$'   
    STATUS_BAR_MSG db '_______________________________________________________________________________$'
	INSTRUCTIONS_msg db 'SOME INSTRUCTIONS OF THE GAME... blA bla bla ... $'
	Sent_CHAT_INV_msg db 'You sent a chat Invitation','$'
	Sent_Game_INV_msg db 'You sent a Game Invitation','$'
	level1_msg db 'LEVEL 1 -- PRESS F1$' 
	level2_msg db 'LEVEL 2 -- PRESS F2$' 
	choose_hidden_char db 'Choose A Forbidden char: $'
	choose_hidden_char2 db 'Choose SECOND Forbidden char: $'
	forbidden_char db '?'       ;; The hiddden char chosen by current player
	right_forbidden_char db 'R'
    contains_forbidden db 0
	MY_REGs_msg db 'MY REGS$'
	HIS_REGs_msg db 'HIS REGS$'
	AX_msg db 'AX: $'
	BX_msg db 'BX: $'
	CX_msg db 'CX: $'
	DX_msg db 'DX: $'
	SI_msg db 'SI: $'
	DI_msg db 'DI: $'
	SP_msg db 'SP: $'
	BP_msg db 'BP: $'
	
	separator_ db ': $'
	
	is_player_1_ready_for_game db 0
	is_player_2_ready_for_game db 0
	is_player_1_ready_for_chat db 0
	is_player_2_ready_for_chat db 0
    My_Initial_points dw 0
	Game_Level db 0
    Game_Turn db 1 ;; 1 for left player     2 for right 
    
  

    FirstName LABEL BYTE ; named the next it the same name 
	FirstNameSize db 20
	ActualFirstNameSize db ?
	FirstNameData db 20 dup('$')

    SecondName LABEL BYTE ; named the next it the same name 
	SecondNameSize db 20
	ActualSecondNameSize db ?
	SecondNameData db 20 dup('$')

	;;;;;;;;;-----------------positions----------;;;;
     ;;for the left
		ax_rec_l dw 0104h
		cx_rec_l dw 0504h
		bx_rec_l dw 0304h
		dx_rec_l dw 0704h
		si_rec_l dw 0904h
		di_rec_l dw 0B04h
		sp_rec_l dw 0D04h
		Bp_rec_l dw 0F04h
		;; Ds LeftSide
		DS_0_left dw 030Bh
		DS_1_left dw 040Bh
		DS_2_left dw 050Bh
		DS_3_left dw 060Bh
		DS_4_left dw 070Bh
		DS_5_left dw 080Bh
		DS_6_left dw 090Bh
		DS_7_left dw 0A0Bh
		;; second column
		DS_8_left dw 030eh
		DS_9_left dw 040eh
		DS_A_left dw 050eh
		DS_B_left dw 060eh
		DS_C_left dw 070eh
		DS_D_left dw 080eh
		DS_E_left dw 090eh
		DS_F_left dw 0A0eh

     ;; command line left side and points BOX
         CL_row_left dw 1201h
         Points_BOX_left dw 0E0Ch

     ;; Balls
		first_ball_left dw 0213h;
		second_ball_left dw 0613h;
		third_ball_left dw 0a13h;
		forth_ball_left dw 0e13h;
		fifth_ball_left dw 1213h;

     ;;for the right
		ax_rec_r dw 011Ah
		cx_rec_r dw 051Ah
		bx_rec_r dw 031Ah
		dx_rec_r dw 071Ah
		si_rec_r dw 091Ah
		di_rec_r dw 0B1Ah
		sp_rec_r dw 0D1Ah
		Bp_rec_r dw 0F1Ah
		;; Ds RightSide
		DS_firstCol_right dw 0321h
		DS_secondCol_right dw 0324h

		DS_0_right dw 0321h
		DS_1_right dw 0421h
		DS_2_right dw 0521h
		DS_3_right dw 0621h
		DS_4_right dw 0721h
		DS_5_right dw 0821h
		DS_6_right dw 0921h
		DS_7_right dw 0A21h
     ;; s_right column
		DS_8_right dw 0324h
		DS_9_right dw 0424h
		DS_A_right dw 0524h
		DS_B_right dw 0624h
		DS_C_right dw 0724h
		DS_D_right dw 0824h
		DS_E_right dw 0924h
		DS_F_right dw 0A24h
     ;; command line left side
     CL_row_Right dw 1217h
     Points_BOX_right dw 0E22h
        ; EX_MAIN -> COMMAND REG, _AX
        ;; Values in regs
        ;; L -> _   gAME_TURN 1 2       XCHG
        ;;IF(1) - > SWAP L,_

		_AX dw 0 
		_BX dw 0
		_CX dw 0 
		_DX dw 0
		_SI dw 0
		_DI dw 0
		_SP dw 0
		_BP dw 0
		;DATA Segment
		_00 db 0
		_01 db 0
		_02 db 0
		_03 db 0
		_04 db 0
		_05 db 0
		_06 db 0
		_07 db 0
		_08 db 0
		_09 db 0
		_A db 0
		_B db 0
		_C db 0
		_D db 0
		_E db 0
		_F db 0
        _CARRY DB 0

		L_AX dw 0 
		L_BX dw 0
		L_CX dw 0 
		L_DX dw 0
		L_SI dw 0
		L_DI dw 0
		L_SP dw 0
		L_BP dw 0
		;;DATA Segment
		L_00 db 0
		L_01 db 0
		L_02 db 0
		L_03 db 0
		L_04 db 0
		L_05 db 0
		L_06 db 0
		L_07 db 0
		L_08 db 0
		L_09 db 0
		L_A db 0
		L_B db 0
		L_C db 0
		L_D db 0
		L_E db 0
		L_F db 0

     ;; balls values
        balls label byte
		ball_0 db 0 ;;green
		ball_1 db 0 ;;magenta
		ball_2 db 0 ;;red
		ball_3 db 0 ;;blue
		ball_4 db 0 ;;yellow


     ;; Values in regs
		R_AX dw 0 
		R_BX dw 0
		R_CX dw 0 
		R_DX dw 0
		R_SI dw 0
		R_DI dw 0
		R_SP dw 0
		R_BP dw 0
		;;DATA Segment
		R_00 db 0
		R_01 db 0
		R_02 db 0
		R_03 db 0
		R_04 db 0
		R_05 db 0
		R_06 db 0
		R_07 db 0
		R_08 db 0
		R_09 db 0
		R_A db 0
		R_B db 0
		R_C db 0
		R_D db 0
		R_E db 0
		R_F db 0
        L_CARRY DB 0
        R_CARRY DB 0
	ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'


	;;For The Graphics

    ;;;;;;---------------SARAHHHHHHHHHHHHHHH;;;;;;;;;;;;;;;;;;;;;;;
    time_aux db 0



    birdX dw 0
    birdY dw 0Ah
    BirdWidth dw 13
    birdVelocity dw 4




    right_birdX dw 147
    right_birdY dw 0Ah
    right_BirdWidth dw 13
    right_birdVelocity dw 4



    paddle_Width dw 20 
    paddle_x dw 5
    paddle_y dw 185 ;at the bottom of the 320*200 pixels screen
    paddle_velocity_x dw 10
    paddle_velocity_y dw 5
    paddleColor db 1011b
    paddleUp db 72 ; scan code of up arrow
    paddleDown db 80 ; scan code of down arrow
    paddleRight db 77 ; scan code of right arrow
    paddleLeft db 75 ; scan code of left arrow



    right_paddle_Width dw 20 
    right_paddle_x dw 170
    right_paddle_y dw 185 ;at the bottom of the 320*200 pixels screen
    right_paddle_velocity_x dw 10
    right_paddle_velocity_y dw 5
    right_paddleColor db 1101b
    right_paddleUp db 71 ; scan code of 7 when num lock is turned off
    right_paddleDown db 73 ; scan code of 9 when num lock is turned off
    right_paddleRight db 81 ; scan code of 1 when num lock is turned off
    right_paddleLeft db 79 ;  scan code of 3 when num lock is turned off



    ballWidth dw 9
    fireballColor db 0fh

    ;left fireball
    fireBall_x dw ?
    fireBall_y dw 190
    fireBall_velocity_y dw 20
    ifFireIsPressed db 0
    fireScanCode db 53
    ;right fireball
    right_fireBall_x dw ?
    right_fireBall_y dw 190
    right_fireBall_velocity_y dw 20
    right_ifFireIsPressed db 0
    right_fireScanCode db  04eh

            ;green, light magenta, red, blue, yellow
    colors db  47,           36, 41,  54,    43
            
                    ;green, light magenta, red, blue, yellow
    pointsOfColors db       1,            2,   3,    4,      5  

    numOfShotBalls db 0,0,0,0,0

    colorIndex db 0
    birdColor db 47
    birdStatus db 1
    birdPoints db 1

    right_colorIndex db 0
    right_birdColor db 47
    right_birdStatus db 1
    right_birdPoints db 1


    playerPoints dw 0
    right_playerPoints dw 0


    gameStatus db 1
    prevTime db 0 ;variable used when checking if the time has changed
    timeInterval db 8 ;the shooting game apears/disappears every time interval

;;;;-------------Comand Line Input------------;;;;;;
    command LABEL BYTE ; named the next it the same name 
	commandSize db 30
    actualcommand_Size db 0 ;the actual size of input at the current time
    THE_COMMAND db 30 dup('$')
    finished_taking_input db 0 ; just a flag to indicate we finished entering the string
    
    
    L_command LABEL BYTE ; named the next it the same name 
	L_commandSize db 30
	Actual_L_commandSize db ?
	L_commandData db 30 dup('$')

    R_command LABEL BYTE ; named the next it the same name 
	R_commandSize db 30
	Actual_R_commandSize db ?
	R_commandData db 30 dup('$')
        
    command_splited db 5 dup('$') ;';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
    Operand1 db 5 dup('$')
    Operand2 db 5 dup('$')
    Two_Operands_Together_splited db 12 dup('$')


    
    Operand2_Value dw 0H 
    Operand1_Value dw 0H
    sizeIndex db 0                                                                             
                                        
                                        
                                            ;MOV [00],AX DONE
    HASH_Operand DW 0H
    Operand_Value DW 0H
    Operand DB 5 dup('$')
                                         ;MOV [00],Al DONE
    HASH_comand DW 0H                    ;MOV AX,[00] DONE
    HASH_Operand2 DW 0H                  ;MOV Al,[00] DONE
    HASH_Operand1 DW 0H                 ; ADD AX,[00] DONE

    target_value dw 105eh
    
    playersStatus db 0 ;; 0 -> nothing , 1 -> left palyer lost/right player won , 2 -> right player lost/left player won

    POWERUP1_MSG DB 'YOU CHOSED POWER-UP 1$'  
    POWERUP1_MSG2 DB 'PLEASE ENTER COMMAND TO EXECUTE$'
 
    POWERUP2_MSG DB 'YOU CHOSED POWER-UP 2$'  
    POWERUP2_MSG2 DB 'PLEASE ENTER COMMAND TO EXECUTE$'
    POWERUP3_MSG DB 'YOU CHOSED POWER-UP 3$'  
    POWERUP3_MSG2 DB 'ENTER FORBIDDEN CHAR (ONLY ONCE)$'
    
    POWERUP5_MSG DB 'YOU CHOSED POWER-UP 5$'  
    POWERUP5_MSG2 DB 'ENTER NEW TARGET VALUE (ONLY ONCE)$'

    EXIT_MSG DB 'YOU EXIT THE GAME$'
    EXIT_MSG2 DB 'PLAYER 1 POINTS: $'
    EXIT_MSG3 DB 'PLAYER 2 POINTS: $'
    EXIT_MSG4 DB 'THE WINNER OF THE GAME IS: $'


    IS_USED_POWERUP3 db 0 ;;TO INDICATE IF USED BEFORE
    right_IS_USED_POWERUP3 db 0 ;;TO INDICATE IF USED BEFORE
   
    IS_USED_POWERUP4 db 0 ;;TO INDICATE IF USED BEFORE
    right_IS_USED_POWERUP4 db 0 ;;TO INDICATE IF USED BEFORE
    IS_USED_POWERUP6 db 0 ;;TO INDICATE IF USED BEFORE
    right_IS_USED_POWERUP6 db 0 ;;TO INDICATE IF USED BEFORE

.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations
	;ChangeVideoMode 13h ;;clears screen and starts Video mode	
	;call START_GAME
	DisplayAgain:
	CLR_Screen_with_Scrolling_TEXT_MODE 
	
    call NAME_VALIDATION
    DisplayString_AT_position_not_moving_cursor Enter_Points_message 0518h ; show mes
    MoveCursorTo 0621h
    ReadNumberhexa_in_ax ;; Read points and put it in ax ;; TODO: See if you want this in hexa
    mov My_Initial_points,ax ;; initialize initial points
    ;; Todo: get min and initialize the points
    mov playerPoints,ax

    ;;PLAYER 2
    call NAME_VALIDATION2
    DisplayString_AT_position_not_moving_cursor Enter_other_Points_message 0A18h ; show mes
    MoveCursorTo 0B21h
    ReadNumberhexa_in_ax ;; Read points and put it in ax ;; TODO: See if you want this in hexa
    mov right_playerPoints,ax

    FIX_POINTS_MIN


	; now enter the main Screen
	DisplayString nl
	DisplayString_AT_position_not_moving_cursor Press_any_Key_message 1018h 
	Read_KEY

	MAIN_LOOP:

		Main_Screen:
			;; it shouldn't wait untill the user enters the KeY
			;; 2 loops in the main
			;; The first is to check if the user clicked any key
			;; the second to check  
			;; enter -> scancode 1C  
			;; esc -> SC 01
			;; F2 -> 3C   
			;; F1 -> 3B
			CLR_Screen_with_Scrolling_TEXT_MODE
            DEAW_STATUS_BAR
			DisplayString_AT_position_not_moving_cursor MAIN_Screen_message1 ,0C16h
			DisplayString_AT_position_not_moving_cursor MAIN_Screen_message2 ,0D16h
			DisplayString_AT_position_not_moving_cursor MAIN_Screen_message3 ,0E16h
			check_key_pressed1:
				mov ah, 1
				int 16h           ;Get key pressed (do not wait for a key - AH:scancode, AL:ASCII)

				jnz _continue ;; something is clicked
				jmp no_thing_clicked
				_continue:
				
				;; check the type of the key
				cmp ah,1h ; esc
				jne check_f1 
				jmp QUIT_THIS_GAME
				check_f1:
				cmp ah,3bh ;f1
				jne check_f2
				;in case of F1
				UPDATE_notification_bar Sent_CHAT_INV_msg
				mov is_player_1_ready_for_chat,1 ;; make me ready and see if the other is ready to
				cmp is_player_1_ready_for_chat,1
				;;je LETS_Chat 	;;Player 2 is Ready TOO
				mov is_player_2_ready_for_chat,1 ;; TODO: temproraly in PHASE 1 -> Pressing Twice Starts THE Chat Room


				jmp remove_key_from_buffer
				
				check_f2:
				cmp ah,3ch ; F2
				jne remove_key_from_buffer
				;in case of F2
				UPDATE_notification_bar Sent_Game_INV_msg
				mov is_player_1_ready_for_game,1 ;; make me ready and see if the other is ready to
				cmp is_player_2_ready_for_game,1
				je LETS_PLAY 	;;Player 2 is Ready TOO
				mov is_player_2_ready_for_game,1 ;; TODO: temproraly in PHASE 1 -> Pressing Twice Starts THE GAME

				remove_key_from_buffer:
				;; delete The key from buffer
				empitify_buffer
				no_thing_clicked:
				;; the second loop is here but nothing to display now
			jmp check_key_pressed1
			
			LETS_PLAY:
			empitify_buffer			;; To make Sure That no bat chars are saved in Buffer
			CALL GAME_WELCOME_PAGES 	;; For level selection and continue To GAME
			CALL START_My_GAME
			jmp QUIT_THIS_GAME

			LETS_Chat:
				empitify_buffer   ;; To make Sure That no bat chars are saved in Buffer
				CAll CHAT_ROOM 		;;should BE THE CHAT.ASM but just For now 
			jmp QUIT_THIS_GAME

		QUIT_THIS_GAME:
		MOV AH,4CH
		INT 21H ;GO BACK TO DOS ;to end the program
	main endp


	include Ex.asm

	;To validate The input NAME
NAME_VALIDATION PROC
		DisplayString_AT_position_not_moving_cursor Enter_Name_message 0318h 
		MoveCursorTo 0421h
		ReadString FirstName
		
		cmp FirstNameData,'A'   ;check if first character is letter ;;we only allow range (A-Z and a-z)
		jl  TRY_AGAIN_INPUT       
		cmp FirstNameData,'z'
		jg  TRY_AGAIN_INPUT
		cmp FirstNameData,'`'
		jg  NAME_IS_VALID
		cmp FirstNameData,'['
		jl  NAME_IS_VALID
		TRY_AGAIN_INPUT:            ; if first character isn't a letter, clear screen and display a message to user
		DisplayString_AT_position_not_moving_cursor Enter_Name_message2 0a04h
		DisplayString_AT_position_not_moving_cursor Press_any_Key_message 0b04h 
		mov al,'$'
		mov di,offset FirstNameData  ;DI points to the target
		mov cx,0                     ;count
		mov cl,ActualFirstNameSize	 ; no need to reset The whole String
		rep stosb                    ;copy $ into FirstNameData to reset it to all $
		Read_KEY
		jmp DisplayAgain             ;Display first screen again

		NAME_IS_VALID:
		ret
	NAME_VALIDATION ENDP

NAME_VALIDATION2 PROC
        RENTER_FAFA:
        mov ax, 0600h                ;Scroll Screen AH=07(Scroll DOWN), AL=1 one line
        mov bh, 07h                   ;Normal attributes -> 07 ;; 0E-> yellow text
        mov cx, 0800H                  ;from row 17h col 0
        mov dx, 1850H                ;To end of screen
        int 10h                      ;Clear the first line



		DisplayString_AT_position_not_moving_cursor Enter_SECOND_Name_message 0818h 
		MoveCursorTo 0921h
		ReadString SecondName
		
		cmp SecondNameData,'A'   ;check if first character is letter ;;we only allow range (A-Z and a-z)
		jl  TRY_AGAIN_INPUT2       
		cmp SecondNameData,'z'
		jg  TRY_AGAIN_INPUT2
		cmp SecondNameData,'`'
		jg  NAME2_IS_VALID
		cmp SecondNameData,'['
		jl  NAME2_IS_VALID
		TRY_AGAIN_INPUT2:            ; if first character isn't a letter, clear screen and display a message to user
		DisplayString_AT_position_not_moving_cursor Enter_Name_message2 0C04h
		DisplayString_AT_position_not_moving_cursor Press_any_Key_message 0b04h 
		mov al,'$'
		mov di,offset SecondNameData  ;DI points to the target
		mov cx,0                     ;count
		mov cl,ActualSecondNameSize	 ; no need to reset The whole String
		rep stosb                    ;copy $ into FirstNameData to reset it to all $
		Read_KEY
		jmp RENTER_FAFA             ;Display first screen again

		NAME2_IS_VALID:
		ret
	NAME_VALIDATION2 ENDP


dis2dig proc
	; displays 2 digit number in AX
	mov bl, 10
    XOR BH,BH
	div bl
	mov dh, ah
	
	mov ah, 0
	
    XOR BH,BH
	div bl
	mov dl, ah
	
	add dl, '0'
	add dh, '0'
	
	MOV AL,DL  ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
	MOV AL,DH  ;al contains the char to print   
    mov ah, 0eh           ;0eh = 14 
    mov bl, 0ch           ;Color is red
    int 10h ; print char -> auto advances cursor
	ret
    dis2dig endp
;THE GAME AND LEVEL SELECTION
GAME_WELCOME_PAGES PROC

	ChangeVideoMode 3h ;;clears screen and starts Video mode	

	DisplayString_AT_position_not_moving_cursor level1_msg 0a20h
	DisplayString_AT_position_not_moving_cursor level2_msg 0c20h

	;;LEVEL SELECTION  -> keep looping till a F1 or F2 Is Pressed
	LEVEL_SELECTION 	; just you choose the the level
	LEVEL_PROCESSING	; according to the chosen -> you do that shit
	INSTRUCTIONS_PAGE	;just to show The instructions of THE game for 10 seconds
	;; let the Game begin
	;; just to stop the program
	;sis: jmp sis
	ret
GAME_WELCOME_PAGES ENDP


;description
CHAT_ROOM PROC
	ret
CHAT_ROOM ENDP


;would add another Your_Game ig i the one who recieved the invitation
START_My_GAME PROC

	ChangeVideoMode 13h   ;; CLEARS tHE SCREEN and start video mode

    mov Game_turn,1 ;; player left starts the Game
	GAME_LOOP:
	CLR_Screen_with_Scrolling_GRAPHICS_MODE   ;; CLEARS tHE SCREEN  
	;; WE DRAW THE BACKGROUND - THE Values - 
	call DRAW_BACKGROUND     ;;Draws The BackGround Image
    call UPDATE_VALUES_Displayed  ;; Update values displayed with ones in variables
	call BIRDGAME
    call CHECK_POWERUPS
    call GetCommand
    Update_the_Commands         ;; to be displayed in its place (L or R)
    CMP finished_taking_input,1           
    je hhhheeeeeeee
    Jmp NOT_FINISHED_INPUT_YET
    hhhheeeeeeee:
    ;; THE PLAYER FINSHED TYPING
    ;; WE WILL UPDATE chosen players Regs
    EXECUTE_THECOMMAND_AT_SIDE game_turn
    Reset_Command   
    MOV finished_taking_input,0    ;;to reset it
    ;;swap turns
    SWAP_TURNS

   

    NOT_FINISHED_INPUT_YET:
    CALL checkValuesInRegisters
    CALL checkIfAnyPlayerLost
    
    CMP playersStatus,1 ;; LEFT LOST
    JNE CHECK_IF_RIGHT_LOST
    JMP QUIT_GAME_LOOP
    CHECK_IF_RIGHT_LOST:
    CMP playersStatus,2 ;; Right LOST
    JNE no_ONE_LOST_YET
    JMP QUIT_GAME_LOOP
    no_ONE_LOST_YET:

    Wait_centi_seconds 1
	JMP GAME_LOOP

	QUIT_GAME_LOOP:

    ChangeVideoMode 3H
    DisplayString_AT_position_and_move_cursor EXIT_MSG 0409H

    DisplayString_AT_position_and_move_cursor EXIT_MSG2 0609H
    DISPLAY_num_in_HEX_ 0709h 4  playerPoints
    DisplayString_AT_position_and_move_cursor EXIT_MSG3 0621H
    DISPLAY_num_in_HEX_ 0721h 4 right_playerPoints
    CMP playersStatus,1 ;; RIGHT WINS
    JNE CHECK_IF_THE_OTHER_WINS
    DisplayString_AT_position_and_move_cursor EXIT_MSG4 0F1AH
    DisplayString SecondNameData
    JMP WAIT_TIME_A
    CHECK_IF_THE_OTHER_WINS:
    CMP playersStatus,2
    JNE WAIT_TIME_A
    DisplayString_AT_position_and_move_cursor EXIT_MSG4 0F1AH
    DisplayString FirstNameData
    WAIT_TIME_A:
    WAIT_10_seconds_TIME
    


	RET
START_My_GAME ENDP



UPDATE_VALUES_Displayed PROC 
        ;; 
        ;; The Code could be massive but if no problems -> WHY NOT??
        DISPLAY_num_in_HEX_ ax_rec_l, 4 ,L_Ax    
        DISPLAY_num_in_HEX_ bx_rec_l, 4 ,L_Bx    
        DISPLAY_num_in_HEX_ cx_rec_l, 4 ,L_Cx    
        DISPLAY_num_in_HEX_ dx_rec_l, 4 ,L_Dx    
        DISPLAY_num_in_HEX_ si_rec_l, 4 ,L_SI    
        DISPLAY_num_in_HEX_ di_rec_l, 4 ,L_DI    
        DISPLAY_num_in_HEX_ bp_rec_l, 4 ,L_BP    
        DISPLAY_num_in_HEX_ sp_rec_l, 4 ,L_SP   

        xor ah,ah
        mov al, L_00 ;; its a byte
        DISPLAY_num_in_HEX_ DS_0_left, 2 ,ax  
        xor ah,ah
        mov al, L_01 ;; its a byte
        DISPLAY_num_in_HEX_ DS_1_left, 2 ,ax  
        xor ah,ah
        mov al, L_02 ;; its a byte
        DISPLAY_num_in_HEX_ DS_2_left, 2 ,ax  
        xor ah,ah
        mov al, L_03 ;; its a byte
        DISPLAY_num_in_HEX_ DS_3_left, 2 ,ax  
        xor ah,ah
        mov al, L_04 ;; its a byte
        DISPLAY_num_in_HEX_ DS_4_left, 2 ,ax  
        xor ah,ah
        mov al, L_05 ;; its a byte
        DISPLAY_num_in_HEX_ DS_5_left, 2 ,ax  
        xor ah,ah
        mov al, L_06 ;; its a byte
        DISPLAY_num_in_HEX_ DS_6_left, 2 ,ax  
        xor ah,ah
        mov al, L_07 ;; its a byte
        DISPLAY_num_in_HEX_ DS_7_left, 2 ,ax  
        xor ah,ah
        mov al, L_08 ;; its a byte
        DISPLAY_num_in_HEX_ DS_8_left, 2 ,ax  
        xor ah,ah
        mov al, L_09 ;; its a byte
        DISPLAY_num_in_HEX_ DS_9_left, 2 ,ax  
        xor ah,ah
        mov al, L_A ;; its a byte
        DISPLAY_num_in_HEX_ DS_A_left, 2 ,ax  
        xor ah,ah
        mov al, L_B ;; its a byte
        DISPLAY_num_in_HEX_ DS_B_left, 2 ,ax  
        xor ah,ah
        mov al, L_C ;; its a byte
        DISPLAY_num_in_HEX_ DS_C_left, 2 ,ax  
        xor ah,ah
        mov al, L_D ;; its a byte
        DISPLAY_num_in_HEX_ DS_D_left, 2 ,ax  
        xor ah,ah
        mov al, L_E ;; its a byte
        DISPLAY_num_in_HEX_ DS_E_left, 2 ,ax  
        xor ah,ah
        mov al, L_F ;; its a byte
        DISPLAY_num_in_HEX_ DS_F_left, 2 ,ax  

        ;; The Balls
        xor ah,ah
        mov al, ball_0 ;; its a byte
        DISPLAY_num_in_HEX_ first_ball_left, 2 ,ax  
        xor ah,ah
        mov al, ball_1 ;; its a byte
        DISPLAY_num_in_HEX_ second_ball_left, 2 ,ax  
        xor ah,ah
        mov al, ball_2 ;; its a byte
        DISPLAY_num_in_HEX_ third_ball_left, 2 ,ax  
        xor ah,ah
        mov al, ball_3 ;; its a byte
        DISPLAY_num_in_HEX_ forth_ball_left, 2 ,ax  
        xor ah,ah
        mov al, ball_4 ;; its a byte
        DISPLAY_num_in_HEX_ fifth_ball_left, 2 ,ax  
     



        ;; TODO : CHANGE THE REG TO THE OTHER SIDE REGS
        DISPLAY_num_in_HEX_ ax_rec_r, 4 ,R_Ax    
        DISPLAY_num_in_HEX_ bx_rec_r, 4 ,R_Bx    
        DISPLAY_num_in_HEX_ cx_rec_r, 4 ,R_Cx    
        DISPLAY_num_in_HEX_ dx_rec_r, 4 ,R_Dx    
        DISPLAY_num_in_HEX_ si_rec_r, 4 ,R_SI    
        DISPLAY_num_in_HEX_ di_rec_r, 4 ,R_DI    
        DISPLAY_num_in_HEX_ bp_rec_r, 4 ,R_BP    
        DISPLAY_num_in_HEX_ sp_rec_r, 4 ,R_SP   




        xor ah,ah
        mov al, R_00 ;; its a byte
        DISPLAY_num_in_HEX_ DS_0_right, 2 ,ax  
        xor ah,ah
        mov al, R_01 ;; its a byte
        DISPLAY_num_in_HEX_ DS_1_right, 2 ,ax  
        xor ah,ah
        mov al, R_02 ;; its a byte
        DISPLAY_num_in_HEX_ DS_2_right, 2 ,ax  
        xor ah,ah
        mov al, R_03 ;; its a byte
        DISPLAY_num_in_HEX_ DS_3_right, 2 ,ax  
        xor ah,ah
        mov al, R_04 ;; its a byte
        DISPLAY_num_in_HEX_ DS_4_right, 2 ,ax  
        xor ah,ah
        mov al, R_05 ;; its a byte
        DISPLAY_num_in_HEX_ DS_5_right, 2 ,ax  
        xor ah,ah
        mov al, R_06 ;; its a byte
        DISPLAY_num_in_HEX_ DS_6_right, 2 ,ax  
        xor ah,ah
        mov al, R_07 ;; its a byte
        DISPLAY_num_in_HEX_ DS_7_right, 2 ,ax  
        xor ah,ah
        mov al, R_08 ;; its a byte
        DISPLAY_num_in_HEX_ DS_8_right, 2 ,ax  
        xor ah,ah
        mov al, R_09 ;; its a byte
        DISPLAY_num_in_HEX_ DS_9_right, 2 ,ax  
        xor ah,ah
        mov al, R_A ;; its a byte
        DISPLAY_num_in_HEX_ DS_A_right, 2 ,ax  
        xor ah,ah
        mov al, R_B ;; its a byte
        DISPLAY_num_in_HEX_ DS_B_right, 2 ,ax  
        xor ah,ah
        mov al, R_C ;; its a byte
        DISPLAY_num_in_HEX_ DS_C_right, 2 ,ax  
        xor ah,ah
        mov al, R_D ;; its a byte
        DISPLAY_num_in_HEX_ DS_D_right, 2 ,ax  
        xor ah,ah
        mov al, R_E ;; its a byte
        DISPLAY_num_in_HEX_ DS_E_right, 2 ,ax  
        xor ah,ah
        mov al, R_F ;; its a byte
        DISPLAY_num_in_HEX_ DS_F_right, 2 ,ax  


        ;;points
        DISPLAY_num_in_HEX_ Points_BOX_left, 4 ,playerPoints  
        DISPLAY_num_in_HEX_ Points_BOX_right, 4 ,right_playerPoints  
        
        ;;Command 
        DisplayString_AT_position_and_move_cursor FirstNameData CL_row_left
        mov dx,CL_row_left
        add dl, ActualFirstNameSize ;;to move cursor
        MoveCursorTo dx
        DisplayString separator_ 
        DisplayString L_commandData

        DisplayString_AT_position_and_move_cursor SecondNameData CL_row_RIGHT
        mov dx,CL_row_RIGHT
        add dl, ActualSecondNameSize ;;to move cursor
        MoveCursorTo dx
        DisplayString separator_ 
        DisplayString R_commandData
        


        ret
UPDATE_VALUES_Displayed ENDP


;To Draw The background
DRAW_BACKGROUND PROC  
    mov ah, 0ch
	mov bx,  offset backGround_left
	KeepDrawingLeft:
			drawPixelWithOffset [bx], [bx+1], [bx+2],  0,  0
			add bx, 3
			cmp bx, offset back_leftSize
	JNE KeepDrawingLeft

        mov ah, 0ch
	mov bx,  offset backGround_right
	KeepDrawingright:
			drawPixelWithOffset [bx], [bx+1], [bx+2],  160,  0
			add bx, 3
			cmp bx, offset back_rightSize
	JNE KeepDrawingright



        ret
DRAW_BACKGROUND ENDP


;; Draws the Bird 
BIRDGAME PROC

    Draw_IMG_with_color paddle_x,paddle_y,paddleImg,paddleColor,paddleSize
    Draw_IMG_with_color right_paddle_x,right_paddle_y,right_paddleImg,right_paddleColor,right_paddleSize

    movePaddle paddle_x,paddle_velocity_x,paddle_y,paddle_velocity_y,paddleUp,paddleDown,paddleRight,paddleLeft,135,0
    movePaddle right_paddle_x,right_paddle_velocity_x,right_paddle_y,right_paddle_velocity_y,right_paddleUp,right_paddleDown,right_paddleRight,right_paddleLeft,295,165

    ;checkTime

    randomBirdColor birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,birdPoints,pointsOfColors

    ;randomBirdColor right_birdStatus,right_birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,right_birdPoints,pointsOfColors

    ;clearScreen 

    cmp gamestatus,0
    jne skipSkipDrawingBirds
    jmp skipDrawingBirds
    skipSkipDrawingBirds:


    ;left bird
    Draw_IMG_with_color birdX,birdY,BirdImg,birdcolor,BirdSize


    ;right bird
    ;moveBird 304,180,right_birdVelocity,right_birdX
    Draw_IMG_with_color right_birdX,right_birdY,right_BirdImg,birdcolor,right_BirdSize
    moveBird 135,0,birdVelocity,birdX
   
    skipDrawingBirds:

    checkForFire fireScanCode,paddle_x,paddle_width,BallSize,fireBall_x,fireBall_y,ifFireIsPressed,paddle_y
 
    cmp ifFireIsPressed,0
    jne skipCheckRight
    jmp checkRight
    skipCheckRight:
    moveFireBall fireBall_velocity_y,fireBall_y,ifFireIsPressed
    Draw_IMG_with_color fireBall_x,fireBall_y,BallImg,fireballColor,BallSize
    compareBirdWithBall birdX,fireBall_x,fireBall_y,BirdSize,0,birdStatus,playerPoints,birdPoints,colorIndex
    checkRight: 

    checkForFire right_fireScancode,right_paddle_x,right_paddle_width,BallSize,right_fireBall_x,right_fireBall_y,right_ifFireIsPressed,right_paddle_y

    cmp right_ifFireIsPressed,0
    jne skipJmp
    jmp midDraw
    skipJmp:

    moveFireBall right_fireBall_velocity_y,right_fireBall_y,right_ifFireIsPressed
    Draw_IMG_with_color right_fireBall_x,right_fireBall_y,BallImg,fireballColor,BallSize
    compareBirdWithBall right_birdX,right_fireBall_x,right_fireBall_y,right_BirdSize,160,birdStatus,right_playerPoints,right_birdPoints,colorIndex

midDraw:
    checkTimeInterval gamestatus, prevTime, timeInterval
    RET
BIRDGAME ENDP

GetCommand PROC
    mov ah,1
    int 16h ;-> looks at the buffer
    jz FinishedTakingChar ;nothing is clicked

    cmp al,20H  ;;a space 
    jb CHECK_IF_ENTER11 
    cmp al, ']'
    ja CHECK_IF_ENTER11
    JMP ADD_TO_COMMAND   ;;its a valid one 
    
    
    CHECK_IF_ENTER11:
    cmp ah,1Ch ;; check if enter is pressed
    jne CHECK_IF_BACKSLASH11
    mov finished_taking_input,1
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
GetCommand ENDP


CHECK_FORBIDDEN_CHARS proc 
    ;; if turn=1 mov to L_command else R_command
    cmp Game_turn,1 ;;first player
    jne check_p22
    mov al,right_forbidden_char
    jmp check_p33
    check_p22: ;;the other is playing
    mov al,forbidden_char
    check_p33:
    ;; checks if command have that char
    mov di,offset THE_COMMAND  
    xor ch,ch
    mov cl,actualcommand_Size
    repne scasb ;;searches for al
    cmp cx,0
    jne bad_char
    dec di
    cmp byte ptr [di],al
    je  bad_char
    mov contains_forbidden,0
    ret
    

    bad_char:
    mov contains_forbidden,1
    ret
    
CHECK_FORBIDDEN_CHARS ENDp 


exchangeValuesInRegisters proc 
   ; cmp game_turn,2  ;;send it in al
    CMP al,2
    JE RTRTRTRT
    jMP exchangeRightPlayerRegisters
        RTRTRTRT:
        mov ax,L_AX
        xchg  _AX,ax
        mov L_AX,ax

        mov ax,L_BX
        xchg  _BX,ax
        mov L_BX,ax

        mov ax,L_CX
        xchg  _CX,ax
        mov L_CX,ax

        mov ax,L_DX
        xchg  _DX,ax
        mov L_DX,ax

        mov ax,L_SI
        xchg  _SI,ax
        mov L_SI,ax

        mov ax,L_DI
        xchg  _DI,ax
        mov L_DI,ax
        
        mov ax,L_SP
        xchg  _SP,ax
        mov L_SP,ax
        
        mov ax,L_BP
        xchg  _BP,ax
        mov L_BP,ax
        
        

        mov ah,L_00
        xchg  _00,ah
        mov L_00,ah

        mov ah,L_01
        xchg  _01,ah
        mov L_01,ah
        
        mov ah,L_02
        xchg  _02,ah
        mov L_02,ah
        
        mov ah,L_03
        xchg  _03,ah  
        mov L_03,ah
          
        mov ah,L_04
        xchg  _04,ah
        mov L_04,ah
        
        mov ah,L_05
        xchg  _05,ah
        mov L_05,ah
        
        mov ah,L_06
        xchg  _06,ah
        mov L_06,ah
        
        mov ah,L_07
        xchg  _07,ah
        mov L_07,ah
        
        mov ah,L_08
        xchg  _08,ah
        mov L_08,ah
        
        mov ah,L_09             
        xchg  _09,ah
        mov L_09,ah
        
        mov ah,L_A 
        xchg  _A,ah
        mov L_A,ah
        
        mov ah,L_B 
        xchg  _B,ah
        mov L_B,ah
        
        mov ah,L_C 
        xchg  _C,ah
        mov L_C,ah
        
        mov ah,L_D 
        xchg  _D,ah
        mov L_D,ah
        
        mov ah,L_E 
        xchg  _E,ah
        mov L_E,ah
        
        mov ah,L_F 
        xchg  _F,ah
        mov L_F,ah
        
        mov ah,L_CARRY 
        xchg  _CARRY,ah
        mov L_CARRY,ah

        
        
       jmp ouououlou
exchangeRightPlayerRegisters:

        mov ax,R_AX
        xchg  _AX,ax
        mov R_AX,ax

        mov ax,R_BX
        xchg  _BX,ax
        mov R_BX,ax

        mov ax,R_CX
        xchg  _CX,ax
        mov R_CX,ax

        mov ax,R_DX
        xchg  _DX,ax
        mov R_DX,ax

        mov ax,R_SI
        xchg  _SI,ax
        mov R_SI,ax

        mov ax,R_DI
        xchg  _DI,ax
        mov R_DI,ax
        
        mov ax,R_SP
        xchg  _SP,ax
        mov R_SP,ax
        
        mov ax,R_BP
        xchg  _BP,ax
        mov R_BP,ax
        
        

        mov ah,R_00
        xchg  _00,ah
        mov R_00,ah

        mov ah,R_01
        xchg  _01,ah
        mov R_01,ah
        
        mov ah,R_02
        xchg  _02,ah
        mov R_02,ah
        
        mov ah,R_03
        xchg  _03,ah  
        mov R_03,ah
          
        mov ah,R_04
        xchg  _04,ah
        mov R_04,ah
        
        mov ah,R_05
        xchg  _05,ah
        mov R_05,ah
        
        mov ah,R_06
        xchg  _06,ah
        mov R_06,ah
        
        mov ah,R_07
        xchg  _07,ah
        mov R_07,ah
        
        mov ah,R_08
        xchg  _08,ah
        mov R_08,ah
        
        mov ah,R_09             
        xchg  _09,ah
        mov R_09,ah
        
        mov ah,R_A 
        xchg  _A,ah
        mov R_A,ah
        
        mov ah,R_B 
        xchg  _B,ah
        mov R_B,ah
        
        mov ah,R_C 
        xchg  _C,ah
        mov R_C,ah
        
        mov ah,R_D 
        xchg  _D,ah
        mov R_D,ah
        
        mov ah,R_E 
        xchg  _E,ah
        mov R_E,ah
        
        mov ah,R_F 
        xchg  _F,ah
        mov R_F,ah

        mov ah,R_CARRY 
        xchg  _CARRY,ah
        mov R_CARRY,ah

ouououlou:
ret
endp exchangeValuesInRegisters



checkValuesInRegisters proc

    mov ax,target_value

    cmp R_AX,ax
    je leftPlayerWins

    cmp R_BX,ax
    je leftPlayerWins
    
    cmp R_CX,ax
    je leftPlayerWins
    
    cmp R_DX,ax
    je leftPlayerWins
    
    cmp R_SI,ax
    je leftPlayerWins
    
    cmp R_DI,ax
    je leftPlayerWins
    
    cmp R_SP,ax
    je leftPlayerWins
    
    cmp R_BP,ax
    jne checkLeftPlayer


    leftPlayerWins:
    mov playersStatus,2 ;; RIGHT LOST LEFT WINS
    jmp exitCheckValuesInRegisters

checkLeftPlayer:
	cmp L_AX,ax
    je rightPlayerWins  
	
    cmp L_BX,ax
    je rightPlayerWins 
	
    cmp L_CX,ax
    je rightPlayerWins  
	
    cmp L_DX,ax
    je rightPlayerWins 
	
    cmp L_SI,ax
    je rightPlayerWins 
	
    cmp L_DI,ax
    je rightPlayerWins 
	
    cmp L_SP,ax
    je rightPlayerWins 
	
    cmp L_BP,ax
    jne exitCheckValuesInRegisters
rightPlayerWins:
    mov playersStatus,1 
    exitCheckValuesInRegisters:
    ret
checkValuesInRegisters endp 

checkIfAnyPlayerLost proc 

    cmp playerPoints,0
    jg checkIfRightPlayerLost
    mov playersStatus,1

checkIfRightPlayerLost:
    cmp right_playerPoints,0
    jg exitCheckIfAnyPlayerLost
    mov playersStatus,2

    exitCheckIfAnyPlayerLost:
ret
checkIfAnyPlayerLost endp 


;description
CHECK_POWERUPS PROC
     mov ah,1
    int 16h ;-> looks at the buffer
    jnz xserdc
    jmp FinishedCheckingPowerUps ;nothing is clicked
    xserdc:
    ;; f5 to f9 are the POWERUps
    ;; f5 ->sc63
    cmp ah,63       ;F5
    jne check_if_F6
    ;execute on your Procecceor
    READ_KEY
    CALL powerUp_1
    JMP FinishedCheckingPowerUps
    check_if_F6:
    cmp ah,64       ;F6
    jne check_if_F7

    READ_KEY
    CALL powerUp_2
    JMP FinishedCheckingPowerUps
    
    check_if_F7:
    cmp ah,65       ;F7
    jne check_if_F8
    READ_KEY ;;READ the f7

    cmp game_turn,1
    jne check_if_the_other_game_turn
    cmp IS_USED_POWERUP3,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_3
    JMP FinishedCheckingPowerUps
    check_if_the_other_game_turn:
    cmp right_IS_USED_POWERUP3,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_3
    JMP FinishedCheckingPowerUps


check_if_F8:
    cmp ah,66       ;F8
    jne check_if_F9
    READ_KEY ;;READ the f8

    cmp game_turn,1
    jne check_if_the_other_game_turn2
    cmp IS_USED_POWERUP4,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_4
    JMP FinishedCheckingPowerUps
    check_if_the_other_game_turn2:
    cmp right_IS_USED_POWERUP4,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_4
    JMP FinishedCheckingPowerUps
    check_if_F9:
    cmp ah,67       ;F9
    jne check_if_F10
    READ_KEY ;;READ the f9
    cmp game_level,2
    jne FinishedCheckingPowerUps
    cmp game_turn,1
    jne check_if_the_other_game_turn3
    cmp IS_USED_POWERUP6,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_6
    JMP FinishedCheckingPowerUps
    check_if_the_other_game_turn3:
    cmp right_IS_USED_POWERUP6,1
    je FinishedCheckingPowerUps ;;no more tries
    CALL powerUp_6
    JMP FinishedCheckingPowerUps

    check_if_F10:

    FinishedCheckingPowerUps:
    ret
CHECK_POWERUPS ENDP



;execute a command at your proceccor
powerUp_1 PROC
    cmp game_turn,1
    JE RTRTRTRTASAS
    JMP exec_on_other1
    RTRTRTRTASAS:
    cmp playerPoints,5 ;;consumes 3 points
    JNB EDCESDAD
    JMP NOT_POWERUP_1
    EDCESDAD:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP1_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP1_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadString COMMAND
    EXECUTE_THECOMMAND_AT_SIDE 2
    SUB playerPoints,5
    Reset_Command
    JMP NOT_POWERUP_1
    exec_on_other1:
    cmp right_playerPoints,5 ;;consumes 3 points
    JNB ASDASDASD
    JMP NOT_POWERUP_1
    ASDASDASD:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP1_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP1_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadString COMMAND
    EXECUTE_THECOMMAND_AT_SIDE 1
    SUB right_playerPoints,5
    Reset_Command
 NOT_POWERUP_1:
    RET
powerUp_1 endP  

powerUp_2 PROC
    cmp game_turn,1
    JE RTRTRTRTASASAS
    JMP exec_on_other2
    RTRTRTRTASASAS:
    cmp playerPoints,3 ;;consumes 3 points
    JNB SARAH112
    JMP NOT_POWERUP_2
    SARAH112:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadString COMMAND
    EXECUTE_THECOMMAND_AT_SIDE 2
    EXECUTE_THECOMMAND_AT_SIDE 1
    SUB playerPoints,3
    Reset_Command
    JMP NOT_POWERUP_2

    exec_on_other2:
    cmp right_playerPoints,3 ;;consumes 3 points
    JNB RETSARAHTER
    JMP NOT_POWERUP_2
    RETSARAHTER:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadString COMMAND
    EXECUTE_THECOMMAND_AT_SIDE 2
    EXECUTE_THECOMMAND_AT_SIDE 1
    SUB right_playerPoints,3
    Reset_Command
 NOT_POWERUP_2:
    RET
powerUp_2 endP  


powerUp_3 PROC
    cmp game_turn,1
    jne exec_on_other3
    cmp playerPoints,8 ;;consumes 3 points
    JNB SARAH1112
    JMP NOT_POWERUP_3
    SARAH1112:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP3_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP3_MSG2, 0c05h
    READ_KEY
    MOV forbidden_char ,AL
    MoveCursorTo 0E14h  ;;MIGHT CAUSE A PROBLEM
    mov dl,al
	mov ah,2     ;; to display the the char into screen (echo)
	int 21h
    READ_KEY
    sub playerPoints,8
    mov IS_USED_POWERUP3,1

    JMP NOT_POWERUP_3
    exec_on_other3:
    cmp right_playerPoints,8 ;;consumes 3 points
    JNB RETSARAHTERR
    JMP NOT_POWERUP_3
    RETSARAHTERR:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP3_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP3_MSG2, 0c05h
    READ_KEY
    MoveCursorTo 0E14h  ;;MIGHT CAUSE A PROBLEM
    mov dl,al
	mov ah,2     ;; to display the the char into screen (echo)
	int 21h
    READ_KEY
    MOV right_forbidden_char ,AL
    sub RIGHT_playerPoints,8
    mov right_IS_USED_POWERUP3,1
    NOT_POWERUP_3:
    RET
powerUp_3 endP  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
powerUp_4 PROC
    cmp game_turn,1 ;checks if it's left player's turn 
    jne checkIfItsRightPlayerTurn_powerUp_4
    cmp playerPoints,30
    jnb  skipme1
    jmp exitPowerUp_4
    skipme1:
    sub playerPoints,30
    MOV IS_USED_POWERUP4,1
    jmp clearAllRegisters


checkIfItsRightPlayerTurn_powerUp_4:

    cmp right_playerPoints,30
    jnb  SKIPME2
    jmp exitPowerUp_4
    SKIPME2:
    MOV right_IS_USED_POWERUP4,1
    sub RIGHT_playerPoints,30
clearAllRegisters:

    mov L_AX,0
    mov L_BX,0
    mov L_CX,0
    mov L_DX,0
    mov L_SI,0
    mov L_DI,0
    mov L_SP,0
    mov L_BP,0
    mov R_AX,0
    mov R_BX,0
    mov R_CX,0
    mov R_DX,0
    mov R_SI,0
    mov R_DI,0
    mov R_SP,0
    mov R_BP,0
exitPowerUp_4:
ret
powerUp_4 endp



powerUp_6 proc 
    cmp game_turn,1
    jne checkIfItsRightPlayerTurn_powerUp_6
    cmp playerPoints,7
    JNB SKIPSARAH1
    jmp exitPowerUp_6
    SKIPSARAH1:
    jmp changeTargetValue

checkIfItsRightPlayerTurn_powerUp_6:
    cmp right_playerPoints,7
    JNB SKIPSARAH2
    jmp exitPowerUp_6
    SKIPSARAH2:


changeTargetValue:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP5_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP5_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadNumberhexa_in_ax ;;reads new target value
    cmp L_AX,ax
    je exitPowerUp_6
    cmp L_BX,ax
    je exitPowerUp_6
    cmp L_CX,ax
    je exitPowerUp_6
    cmp L_DX,ax
    je exitPowerUp_6
    cmp L_SI,ax
    je exitPowerUp_6
    cmp L_DI,ax
    je exitPowerUp_6
    cmp L_SP,ax
    je exitPowerUp_6
    cmp L_BP,ax
    je exitPowerUp_6
    cmp R_AX,ax
    je exitPowerUp_6
    cmp R_BX,ax
    je exitPowerUp_6
    cmp R_CX,ax
    je exitPowerUp_6
    cmp R_DX,ax
    je exitPowerUp_6
    cmp R_SI,ax
    je exitPowerUp_6
    cmp R_DI,ax
    je exitPowerUp_6
    cmp R_SP,ax
    je exitPowerUp_6
    cmp R_BP,ax
    je exitPowerUp_6
    mov target_value,ax

    CMP GAME_TURN,1
    JNE other_player_is_playing
    sub playerPoints,7
    mov IS_USED_POWERUP6,1
    jmp exitPowerUp_6
    other_player_is_playing:
    mov right_IS_USED_POWERUP6,1
    sub right_playerPoints,7
exitPowerUp_6:
    RET
powerUp_6 endp



end main
