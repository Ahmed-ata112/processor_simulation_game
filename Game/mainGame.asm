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
	INSTRUCTIONS_msg db 'SOME INSTRUCTIONS OF THE GAME $'
    INSTRUCTIONS_msg1 db 'F3 FOR INLINE GAME CHAT $'
    INSTRUCTIONS_msg2 db 'F4 TO LEAVE THE GAME $'
    INSTRUCTIONS_msg3 db 'F1 TO EXECUTE A COMMAND ON YOUR OPPONENTS PROCESSOR $'
    INSTRUCTIONS_msg4 db 'F2 TO EXECUTE A COMMAND ON YOUR OWN PROCESSOR $'
    INSTRUCTIONS_msg5 db 'F5 TO EXECUTE A COMMAND ON YOUR OWN PROCESSOR -5 POINTS-$'
    INSTRUCTIONS_msg6 db 'F6 TO EXECUTE A COMMAND ON BOTH PROCESSORS -3 POINTS-$'
    INSTRUCTIONS_msg7 db 'F7 TO CHANGE THE FORBIDDEN CHARACTER ONLY ONCE -8 POINTS-$'
    INSTRUCTIONS_msg8 db 'F8 TO CLEAR ALL REGISTERS -30 POINTS (USED ONCE)$'
    INSTRUCTIONS_msg9 db 'F9 TO CHANGE THE TARGET VALUE -7 POINTS (USED ONCE)$'
	Sent_CHAT_INV_msg db 'You sent a chat Invitation','$'
	rec_CHAT_INV_msg db 'You recieved a chat Invitation','$'
	Sent_Game_INV_msg db 'You sent a Game Invitation','$'
	rec_Game_INV_msg db 'You recieved a Game Invitation','$'
	level1_msg db 'LEVEL 1 -- PRESS F1$' 
	level2_msg db 'LEVEL 2 -- PRESS F2$' 
	levelswait_msg db 'Please Wait while the other chooses the Level$' 
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

    myflag db 1 ;;to use it to indicate end of sending name and points

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
        l_CARRY_LEFT DW 0F09h
        forbidden_char_left DW 0110h
        TARGET_VALUE_BOX DW 0012H

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
        R_CARRY_RIGHT DW 0F1Fh
        forbidden_char_right DW 0126h
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
    timeInterval dB 8 ;the shooting game apears/disappears every time interval
  
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
    Operand1 db 10 dup('$')
    Operand2 db 10 dup('$')
    Two_Operands_Together_splited db 22 dup('$')


    
    Operand2_Value dw 0H 
    Operand1_Value dw 0H
    sizeIndex db 0                                                                             
                                        
                                        
                                            
    HASH_Operand DW 0H
    Operand_Value DW 0H
    Operand DB 10 dup('$')
                                         
    HASH_comand DW 0H                    
    HASH_Operand2 DW 0H                  
    HASH_Operand1 DW 0H   

    Not_CL_or_Value db  'AX','BX','CX','DX'
                    db  'AH','AL','BH','BL','CH','DH','DL'
                    db  'CS','IP','SS','SP'
                    db  'BP','SI','DI','DS','ES'

    IS_CL DB 'CL'

    Able_To_Shift_Flag  db ?  ; 1 is unable   0 is able
    Able_To_Shift_Flag1  db ?  ; 1 is unable   0 is able
                                        

    target_value dw 105eh
    
    playersStatus db 0 ;; 0 -> nothing , 1 -> left palyer lost/right player won , 2 -> right player lost/left player won

    POWERUP1_MSG DB 'YOU CHOSE POWER-UP 1$'  
    POWERUP1_MSG2 DB 'PLEASE ENTER COMMAND TO EXECUTE$'
 
    POWERUP2_MSG DB 'YOU CHOSE POWER-UP 2$'  
    POWERUP2_MSG2 DB 'PLEASE ENTER COMMAND TO EXECUTE$'
    POWERUP3_MSG DB 'YOU CHOSE POWER-UP 3$'  
    POWERUP3_MSG2 DB 'ENTER FORBIDDEN CHAR (ONLY ONCE)$'
    
    POWERUP5_MSG DB 'YOU CHOSE POWER-UP 5$'  
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
    EXECUTE_REVESED db 0 ;;IN LEVEL 2 IT INDECATES IF YOU CHOSED TO EXECUTE ON OTHER 



    ;;VALIDATION
    Command_valid db 1                                    
    validRegNamesArr db 'AX','BX','CX','DX'
                    db  'AH','AL','BH','BL','CH','CL','DH','DL'
                    db  'CS','IP','SS','SP'
                    db  'BP','SI','DI','DS','ES'

   validRegNamesArrSize db  21d
   valid_addressing_mode_regs db '[BX]','[SI]','[DI]','[00]'
        DB '[01]','[02]','[03]', '[04]', '[05]', '[06]', '[07]'
        DB '[08]', '[09]', '[0A]', '[0B]', '[0C]', '[0D]', '[0E]','[0F]'


        VALID_SHIFT DB 'SHL','SHR','SAR','ROR','RCL','RCR','ROL'
        ISSHIFTING DB 0
    ;;;;;;;;;;;;;;;
    ;;;; serial ;;;;;;
    ;;;;;;;;;;;;;;;
    byteToSend db 0
    byteReceived db 0
    TheOneWhoKnocks db 0
    isInlineChatting db 0

.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations
	;ChangeVideoMode 13h ;;clears screen and starts Video mode	
	;call START_GAME
    CALL init_comm
	DisplayAgain:
	CLR_Screen_with_Scrolling_TEXT_MODE 
	
   ; call sendandreceivepoints


    call NAME_VALIDATION

    DisplayString_AT_position_not_moving_cursor Enter_Points_message 0518h ; show mes
    MoveCursorTo 0621h
    ReadNumberhexa_in_ax ;; Read points and put it in ax ;; TODO: See if you want this in hexa
    mov My_Initial_points,ax ;; initialize initial points
    ;; Todo: get min and initialize the points
    mov playerPoints,ax
    call SendRecNames
    ;;PLAYER 2
    ;; send and rec the name
    call SendRecPoints      ;;EXCHANGE POINTS
    FIX_POINTS_MIN


	; now enter the main Screen
	DisplayString nl
	DisplayString_AT_position_not_moving_cursor Press_any_Key_message 1018h 
	Read_KEY



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
            jmp CheckIfOtherPlayerSent
            _continue:
            
            ;; check the type of the key
            cmp ah,1h ; esc
            jne check_f1 
            mov byteToSend,'E'
            call sendByteproc
            SendByte bl
            jmp QUIT_THIS_GAME
            check_f1:
            cmp ah,3bh ;f1
            jne check_f2
            ;in case of F1
            UPDATE_notification_bar Sent_CHAT_INV_msg
            ;;je LETS_Chat 	;;Player 2 is Ready TOO
            mov byteToSend,'C'
            call sendByteproc
            call ReceiveByteproc
                           ;Send C, if C was received by the other party then check if they would like accept the invitation
            cmp byteReceived, 'C'                    ; If the other party accepted the invitation then print a message,  wait for a key then go to chat.
            je ararararar
            jmp remove_key_from_buffer  
            ararararar: 
            jmp LETS_Chat       
            
            check_f2:
            cmp ah,3ch ; F2
            jne remove_key_from_buffer
            ;in case of F2
            UPDATE_notification_bar Sent_Game_INV_msg   ;; 
            mov byteToSend,'G'
            call sendByteproc
            call ReceiveByteproc
            cmp byteReceived, 'G'                  ;Send C, if C was received by the other party then check if they would like accept the invitation
            JNE remove_key_from_buffer   ;;declined
            mov TheOneWhoKnocks, 1 ;to indicate the player who sent the invitation
            mov Game_turn,1 ;; I starts the Game
            jmp LETS_PLAY       
            
            remove_key_from_buffer:
            ;; delete The key from buffer
            empitify_buffer
           ; jmp check_key_pressed1
            CheckIfOtherPlayerSent:
            ;;check Received
            ;; G -> Game invite     ;;; C -> Chat invite    ;; E esc
            receiveByte ah
            cmp ah,'E'      ;;escape
            je escapefromGame
            cmp ah,'G'
            je rec_game_invite
            cmp ah,'C'
            je rec_chat_invite
            jmp check_key_pressed1 ;;otherwise then what the fuck did you send
            escapefromGame:
            jmp QUIT_THIS_GAME
            rec_chat_invite:
            UPDATE_notification_bar rec_chat_INV_msg   ;; 
            ;je LETS_chat
            jmp check_key_pressed1
            rec_game_invite:
            UPDATE_notification_bar rec_Game_INV_msg   
            mov bl,0ffh
            Read_KEY
            cmp ah,3ch ;f2
            jne decline
            mov byteToSend,'G'
            call sendByteproc
            mov Game_turn,2 ;; player right starts the Game
            jmp LETS_PLAY
            decline:
            sendByte bl
            jmp check_key_pressed1

            


            NoThingRec:
        jmp check_key_pressed1
        
        LETS_PLAY:
        empitify_buffer			;; To make Sure That no bat chars are saved in Buffer
	    ChangeVideoMode 3h ;;clears screen and starts Video mode	
        
        
        
        call Level_select
        CALL GAME_WELCOME_PAGES 	;; For level selection and continue To GAME
        empitify_buffer			;; To make Sure That no bat chars are saved in Buffer
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
    include validate.asm
    include serial.asm
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


SendRecNames PROC near
      mov si,offset FirstName+1 ;;send from accual size
      mov di,offset SecondName+1
      ;inc cl ;; we will send actual size with us
      mov cx,21 ;; actual size and name
    KeepComm:
    sendByte [si]
    receiveByteG [di]
    inc si
    inc di
    loop KeepComm
SendRecNames ENDP

;description
SendRecPoints PROC
      mov si,offset playerpoints ;;send from accual size
      mov di,offset right_playerpoints
      ;inc cl ;; we will send actual size with us
      mov cx,2 ;;points are 2 Bytes
    KeepComm2:
    sendByte [si]
    receiveByteG [di]
    inc si
    inc di
    loop KeepComm2

    ret
SendRecPoints ENDP




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

	LEVEL_PROCESSING	; according to the chosen -> you do that shit
		;just to show The instructions of THE game for 10 seconds
	;; let the Game begin
	;; just to stop the program
	;sis: jmp sis
	ret
GAME_WELCOME_PAGES ENDP


;description
Level_select PROC
    cmp TheOneWhoKnocks,1 ;;the player wo sent the inv
        je MeTheOne
        jmp notMEAndFucku
        MeTheOne:
        DisplayString_AT_position_not_moving_cursor level1_msg 0a20h
	    DisplayString_AT_position_not_moving_cursor level2_msg 0c20h
	    LEVEL_SELECTION  ;-> keep looping till a F1 or F2 Is Pressed
        mov al,game_level
        mov byteToSend,al
        call sendByteproc
        ret
        notMEAndFucku:
        DisplayString_AT_position_not_moving_cursor  levelswait_msg 0a10h
        call receiveByteproc
        mov al,byteReceived
        mov game_level,al
    ret
Level_select ENDP

;description
CHAT_ROOM PROC
	ret
CHAT_ROOM ENDP




;would add another Your_Game ig i the one who recieved the invitation
START_My_GAME PROC

	ChangeVideoMode 13h   ;; CLEARS tHE SCREEN and start video mode
  
	GAME_LOOPP:
    CLR_Screen_with_Scrolling_GRAPHICS_MODE   ;; CLEARS tHE SCREEN  
    call READ_BUFFER_IF_NOT_USED
    MOV AH,1
    INT 16H
    cmp ah,3eh ; F4 ;;TODO: SEND A SIGNAL TO THE OTHER
    jne CheckIf_F3
    MOV byteToSend,4EH
    jmp QUIT_GAME_LOOPP
    CheckIf_F3:
    cmp ah,3dh
    jne NO_FOR_NOW_YET
    NOT isInlineChatting
    NO_FOR_NOW_YET:
    ;; WE DRAW THE BACKGROUND - THE Values - 
	call DRAW_BACKGROUND     ;;Draws The BackGround Image
    call UPDATE_VALUES_Displayed  ;; Update values displayed with ones in variables
    Update_the_Commands         ;; to be displayed in its place (L or R)
	
    call BIRDGAME
   
    
	
    cmp game_turn,1
    jne OtherisPlaying

    call PlayAsMain
    jmp Heyyyy
    OtherisPlaying:
    call PlayAsSec
    Heyyyy:
    Wait_centi_seconds 1




    CALL checkValuesInRegisters
    CALL checkIfAnyPlayerLost
    CMP playersStatus,1 ;; LEFT LOST
    JNE CHECK_IF_RIGHT_LOST
    JMP QUIT_GAME_LOOPP
    CHECK_IF_RIGHT_LOST:
    CMP playersStatus,2 ;; Right LOST
    JNE no_ONE_LOST_YET
    JMP QUIT_GAME_LOOPP
    no_ONE_LOST_YET:
	JMP GAME_LOOPP
	QUIT_GAME_LOOPP:
    call ExitandRestart

	RET
START_My_GAME ENDP



;description
ExitandRestart PROC
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
    CALL RESET_ALL_VARS
    JMP Main_Screen
    ret    
ExitandRestart ENDP

;would add another Your_Game ig i the one who recieved the invitation

;description
PlayAsMain PROC
  
	call CHECK_POWERUPS
    cmp isInlineChatting,0
    jne meChatting
    call GetCommand
    Update_the_Commands         ;; to be displayed in its place (L or R)
    meChatting:

    CMP finished_taking_input,1           
    je hhhheeeeeeee
    Jmp NOT_FINISHED_INPUT_YET
    hhhheeeeeeee:
    ;; THE PLAYER FINSHED TYPING
    ;; WE WILL UPDATE chosen players Regs
    mov Command_valid,1
    call Check_valid
    cmp Command_valid,0H ;;invalid
    jne execute_command_valid
    ;; command is not valid 
    ;;dec points
    DEC playerpoints
    jmp FINISHED_EXECUTING
    execute_command_valid:
    CMP EXECUTE_REVESED,1
    JNE EXECUTE_NORMALLY
    ;;EXECUTE ON 2
    EXECUTE_THECOMMAND_AT_SIDE 2 ;;EXECCUTE IN OPPONENT REGS
    MOV EXECUTE_REVESED,0
    JMP FINISHED_EXECUTING
    EXECUTE_NORMALLY:
    EXECUTE_THECOMMAND_AT_SIDE game_turn
    FINISHED_EXECUTING:
    Reset_Command  

    mov byteToSend,'R'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs
    MOV finished_taking_input,0    ;;to reset it
    ;;swap turns
    SWAP_TURNS
    NOT_FINISHED_INPUT_YET:
    
   
    ret    
PlayAsMain ENDP



;description
PlayAsSec PROC

    
	MOV DX,3FDh     ;;LineStatus
	IN AL,DX
	TEST AL,1
	JZ NoThingReceived22

    ;rec the first letter to know what to do
    MOV DX,3F8h
	IN AL,DX

    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecUpdatedRegs
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed

    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecUpdatedRegs_AFTER_POWERUPS

    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed

    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecUpdatedCommand
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed
    
    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecBirdGame
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed

    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecBirdGame
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed
    
   
    
    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL FireIsPressedThere
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed
    
   
    MOV BL,4FH      ;;IF CHANGED THEN I found the wanted  
    CALL RecBirdTrigger
    cmp bl, 4fh 
    jne NoThingReceived22 ;; consumed
    
    
    

    NoThingReceived22:
    ret
PlayAsSec ENDP

;description
;description
FireIsPressedThere PROC
    cmp al,'F'
    je cntinueRecandSwapF 
    ret
    cntinueRecandSwapF:
     cmp right_ifFireIsPressed,1
    jne asdasdddasdas        ;;already one is present
    ret
    asdasdddasdas:        

    ;we reached here, meaning the key pressed is down arrow
   
    ;we need to get the center x coordinate of the paddle, make the ball fire starting from that point 
    ;using the y coordinte of the paddle (192) to avoid the ball touching the paddle
    mov ax,right_paddle_x
    mov bx,right_paddle_width
    shr bx,1
    add ax,bx
    mov bx,Ballsize
    shr bx,2
    sub ax,bx
  
    mov right_fireBall_x,ax
    mov ax,right_paddle_y
    mov right_fireBall_y,ax
    mov right_ifFireIsPressed,1

    ret
FireIsPressedThere ENDP

RecBirdGame PROC
    cmp al,'S'
    je cntinueRecandSwaps 
    ret
    cntinueRecandSwaps:

    call sendByteproc       ;;SEND A REPLY you are ready to get data
    RecWord right_paddle_x
    RecWord right_paddle_y
    ADD right_paddle_x,176




    ; RecWord right_fireBall_x
    ; RecWord right_fireBall_y
    ; add right_fireBall_x,160

    RecWord right_playerPoints 
    
   ;RecByteH right_ifFireIsPressed
   
    ;;TODO: COLOR INDEX
    ;; balls 

    RET
RecBirdGame ENDP

RecBirdTrigger PROC
    cmp al,'T'
    je cntinueRecandSwapT 
    ret
    cntinueRecandSwapT:

    mov gameStatus,1

    RET
RecBirdTrigger ENDP


RecUpdatedRegs proc

    cmp al,'R'
    je cntinueRecandSwap 
    ret
    cntinueRecandSwap:

    call sendByteproc       ;;SEND A REPLY you are ready to get data
    RecWord L_Ax
    RecWord L_Bx
    RecWord L_Cx
    RecWord L_Dx
    RecWord L_SI
    RecWord L_DI
    RecWord L_SP
    RecWord L_BP
    
    RecWord L_00        ;;REC L_00 AND L_01 AND ETC
    RecWord L_02
    RecWord L_04
    RecWord L_06
    RecWord L_08
    RecWord L_A
    RecWord L_C
    RecWord L_E


    RecWord R_Ax
    RecWord R_Bx
    RecWord R_Cx
    RecWord R_Dx
    RecWord R_SI
    RecWord R_DI
    RecWord R_SP
    RecWord R_BP

    RecWord R_00        ;;REC L_00 AND L_01 AND ETC
    RecWord R_02
    RecWord R_04
    RecWord R_06
    RecWord R_08
    RecWord R_A
    RecWord R_C
    RecWord R_E
    RecWord right_playerPoints
    RecWord playerPoints

    RecWord target_value
    RecWord forbidden_char

    MOV AL,forbidden_char
    MOV AH,RIGHT_forbidden_char
    XCHG AH,AL
    MOV forbidden_char,AL
    MOV RIGHT_forbidden_char,AH
    
    Swap_Turns  ;;my game has started
    Reset_Command
    mov bl,0eah
    ret
RecUpdatedRegs ENDP


RecUpdatedRegs_AFTER_POWERUPS proc
    ;; NO SWAPING AFTER FINISHED
    cmp al,'P'
    je cntinueRecandP 
    ret
    cntinueRecandP:

    call sendByteproc       ;;SEND A REPLY you are ready to get data
    RecWord L_Ax
    RecWord L_Bx
    RecWord L_Cx
    RecWord L_Dx
    RecWord L_SI
    RecWord L_DI
    RecWord L_SP
    RecWord L_BP
    
    RecWord L_00        ;;REC L_00 AND L_01 AND ETC
    RecWord L_02
    RecWord L_04
    RecWord L_06
    RecWord L_08
    RecWord L_A
    RecWord L_C
    RecWord L_E


    RecWord R_Ax
    RecWord R_Bx
    RecWord R_Cx
    RecWord R_Dx
    RecWord R_SI
    RecWord R_DI
    RecWord R_SP
    RecWord R_BP

    RecWord R_00        ;;REC L_00 AND L_01 AND ETC
    RecWord R_02
    RecWord R_04
    RecWord R_06
    RecWord R_08
    RecWord R_A
    RecWord R_C
    RecWord R_E
    RecWord right_playerPoints
    RecWord playerPoints
    RecWord target_value
    RecWord forbidden_char
    MOV AL,forbidden_char
    MOV AH,RIGHT_forbidden_char
    XCHG AH,AL
    MOV forbidden_char,AL
    MOV RIGHT_forbidden_char,AH
    mov bl,0eah
    ret
RecUpdatedRegs_AFTER_POWERUPS ENDP

RecUpdatedCommand proc
    cmp al,'C'
    je cntinueRecandC 
    ret
    cntinueRecandC:
    call sendByteproc       ;;SEND A REPLY you are ready to get data
    lea DI, actualcommand_Size ;;start from here
    mov cx,8 ;;16 bytes to send
    LL1L:
    RecWordwithoffset DI
    inc DI
    inc DI
    Loop LL1L

    mov bl,0eah
ret
RecUpdatedCommand endp

SendBirdGame PROC
    call receiveByteproc
    sendWord paddle_x
    sendWord paddle_y
    
    ;sendWord fireBall_x
    ;sendWord fireBall_y

    sendWord playerPoints
   ; sendbyteH ifFireIsPressed
   
    ret
SendBirdGame ENDP

SendUpdatedRegs PROC
    ;; will send all the Regs available at that time
    call receiveByteproc
    SendWord R_AX
    SendWord R_BX
    SendWord R_CX
    SendWord R_DX
    SendWord R_SI
    SendWord R_DI
    SendWord R_SP
    SendWord R_BP
    
    SendWord R_00
    SendWord R_02
    SendWord R_04
    SendWord R_06
    SendWord R_08
    SendWord R_A
    SendWord R_C
    SendWord R_E


    SendWord L_AX
    SendWord L_BX
    SendWord L_CX
    SendWord L_DX
    SendWord L_SI
    SendWord L_DI
    SendWord L_SP
    SendWord L_BP
    SendWord L_00
    SendWord L_02
    SendWord L_04
    SendWord L_06
    SendWord L_08
    SendWord L_A
    SendWord L_C
    SendWord L_E
    SendWord playerPoints
    SendWord right_playerPoints
    ;; TARGET VALUE AND FORBIDDEN KEY
    SendWord target_value
    SendWord forbidden_char

    ret
SendUpdatedRegs ENDP

;description
sendCommand PROC
    call receiveByteproc
    
    lea DI, actualcommand_Size ;;start from here
    mov cx,8 ;;16 bytes to send
    LL1LL:
    SendWordwithoffs DI
    inc DI
    inc DI
    Loop LL1LL
    
    ret
sendCommand ENDP


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
        xor ah,ah
        mov al, L_cARRY ;; its a byte
        DISPLAY_num_in_HEX_ l_CARRY_LEFT, 1 ,ax  

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
        DISPLAY_num_in_HEX_ TARGET_VALUE_BOX, 4 ,TARGET_VALUE   




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

        xor ah,ah
        mov al, R_CARRY ;; its a byte
        DISPLAY_num_in_HEX_ R_CARRY_RIGHT, 1 ,ax 


        cmp game_level,2
        je dont_print_forbidden
        MoveCursorTo forbidden_char_LEFT
        xor ah,ah
        mov al, forbidden_char ;; its a byte 
         mov ah, 0eh           ;0eh = 14 
         mov bl, 0ch           ;Color is red
         int 10h ; print char -> auto advances cursor
        xor ah,ah
        mov al, right_forbidden_char ;; its a byte
        MoveCursorTo forbidden_char_RIGHT
        xor ah,ah
        mov al, right_forbidden_char ;; its a byte 
         mov ah, 0eh           ;0eh = 14 
         mov bl, 0ch           ;Color is red
         int 10h ; print char -> auto advances cursor

        Draw_IMG 125 5  forb_char forb_char_size
        Draw_IMG 301 5  forb_char forb_char_size

        dont_print_forbidden:

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

    movePaddle paddle_x,paddle_velocity_x,paddle_y,paddle_velocity_y,paddleUp,paddleDown,paddleRight,paddleLeft,127,0
    ;movePaddle right_paddle_x,right_paddle_velocity_x,right_paddle_y,right_paddle_velocity_y,right_paddleUp,right_paddleDown,right_paddleRight,right_paddleLeft,295,165

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
    moveBird 306,171,right_birdVelocity,right_birdX
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

    ;checkForFire right_fireScancode,right_paddle_x,right_paddle_width,BallSize,right_fireBall_x,right_fireBall_y,right_ifFireIsPressed,right_paddle_y

    cmp right_ifFireIsPressed,0
    jne skipJmp
    jmp midDraw
    skipJmp:

    moveFireBall right_fireBall_velocity_y,right_fireBall_y,right_ifFireIsPressed
    Draw_IMG_with_color right_fireBall_x,right_fireBall_y,BallImg,fireballColor,BallSize
    compareBirdWithBall right_birdX,right_fireBall_x,right_fireBall_y,right_BirdSize,160,birdStatus,right_playerPoints,right_birdPoints,colorIndex

midDraw:
    CMP TheOneWhoKnocks,0
    JE not_ME_FUCK_YOU
    checkTimeInterval gamestatus, prevTime, timeInterval
    not_ME_FUCK_YOU:
    RET
BIRDGAME ENDP

GetCommand PROC
    mov ah,1
    int 16h ;-> looks at the buffer
    JNZ ASDASDASDAS
    JMP FinishedTakingChar ;nothing is clicked
    ASDASDASDAS:
    cmp al,20H  ;;a space 
    jb CHECK_IF_ENTER11 
    cmp al, ']'
    ja CHECK_IF_ENTER11
    JMP ADD_TO_COMMAND   ;;its a valid one 
    
    
    CHECK_IF_ENTER11:
    cmp ah,59 ;; check if F1 is pressed
    jne CHECK_IF_F2IS_PRESSED
    mov finished_taking_input,1
    jmp ADD_TO_COMMAND  ;; TO ADD THE ENTER

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
    mov byteToSend,'C'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL sendCommand
   
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
    mov byteToSend,'C'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL sendCommand
    
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
    mov byteToSend,'P'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs

 NOT_POWERUP_1:
    RET
powerUp_1 endP  
powerUp_2 PROC
    cmp game_turn,1
    cmp playerPoints,3 ;;consumes 3 points
    JNB SARAH112
    JMP NOT_POWERUP_2
    SARAH112:
    Draw_blank_line
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG, 0B09h
    DisplayString_AT_position_not_moving_cursor POWERUP2_MSG2, 0c05h
    MoveCursorTo 0E09h
    ReadString COMMAND
    EXECUTE_THECOMMAND_AT_SIDE 1
    cmp contains_forbidden,1
    je dont_on_other
    EXECUTE_THECOMMAND_AT_SIDE 2
    dont_on_other:
    SUB playerPoints,3
    Reset_Command
    mov byteToSend,'P'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs
 NOT_POWERUP_2:
    RET
powerUp_2 endP  


powerUp_3 PROC
    cmp game_turn,1
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
     mov byteToSend,'P'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs
    mov IS_USED_POWERUP3,1
    NOT_POWERUP_3:
    RET
powerUp_3 endP  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
powerUp_4 PROC
    
    cmp playerPoints,30
    jnb  skipme1
    jmp exitPowerUp_4
    skipme1:
    sub playerPoints,30
    MOV IS_USED_POWERUP4,1
    jmp clearAllRegisters
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
    mov byteToSend,'P'
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs
exitPowerUp_4:
ret
powerUp_4 endp



powerUp_6 proc 
    
    cmp playerPoints,7
    JNB changeTargetValue
    jmp exitPowerUp_6
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
    sub playerPoints,7
    mov IS_USED_POWERUP6,1
     mov byteToSend,'P'     ;;TODO SEND TARGET VALUE AND FORBIDDEN CHAR
    call sendByteproc ;;SIGNAL TO MAKE HIM REALIZE 
    CALL SendUpdatedRegs
    
exitPowerUp_6:
    RET
powerUp_6 endp


;description
RESET_ALL_VARS PROC
    
    mov _Ax, 0
    mov _BX, 0
    mov _CX, 0
    mov _DX, 0
    mov _SI, 0
    mov _DI, 0
    mov _SP, 0
    mov _BP, 0
    mov _00, 0
    mov _01, 0
    mov _02, 0
    mov _03, 0
    mov _04, 0
    mov _05, 0
    mov _06, 0
    mov _07, 0
    mov _08, 0
    mov _09, 0
    mov _A, 0
    mov _B, 0
    mov _C, 0
    mov _D, 0
    mov _E, 0
    mov _F, 0
    mov _CARRY, 0


    mov L_Ax, 0
    mov L_BX, 0
    mov L_CX, 0
    mov L_DX, 0
    mov L_SI, 0
    mov L_DI, 0
    mov L_SP, 0
    mov L_BP, 0
    mov L_00, 0
    mov L_01, 0
    mov L_02, 0
    mov L_03, 0
    mov L_04, 0
    mov L_05, 0
    mov L_06, 0
    mov L_07, 0
    mov L_08, 0
    mov L_09, 0
    mov L_A, 0
    mov L_B, 0
    mov L_C, 0
    mov L_D, 0
    mov L_E, 0
    mov L_F, 0
    mov L_CARRY, 0

    mov R_Ax, 0
    mov R_BX, 0
    mov R_CX, 0
    mov R_DX, 0
    mov R_SI, 0
    mov R_DI, 0
    mov R_SP, 0
    mov R_BP, 0
    mov R_00, 0
    mov R_01, 0
    mov R_02, 0
    mov R_03, 0
    mov R_04, 0
    mov R_05, 0
    mov R_06, 0
    mov R_07, 0
    mov R_08, 0
    mov R_09, 0
    mov R_A, 0
    mov R_B, 0
    mov R_C, 0
    mov R_D, 0
    mov R_E, 0
    mov R_F, 0
    mov R_CARRY, 0

    MOV Game_Level , 0
    MOV Game_Turn , 1 ;; TO BE  
    
    
    MOV ball_0 ,0 ;;green
    MOV ball_1 ,0 ;;magenta
    MOV ball_2 ,0 ;;red
    MOV ball_3 ,0 ;;blue
    MOV ball_4 ,0 ;;yellow

    MOV paddle_x , 5
    MOV paddle_y , 185


    MOV right_paddle_x ,170
    MOV right_paddle_y ,185
    MOV DI,OFFSET numOfShotBalls
    MOV [DI],BYTE PTR 0
    MOV [DI+1],BYTE PTR 0
    MOV [DI+2],BYTE PTR 0
    MOV [DI+3],BYTE PTR 0
    MOV [DI+4],BYTE PTR 0

    MOV gameStatus , 1
    MOV prevTime , 0 ;variable used when checking if the time has changed
   
    MOV sizeIndex , 0

    MOV playersStatus, 0
    MOV target_value , 105eh


    MOV IS_USED_POWERUP3, 0 ;;TO INDICATE IF USED BEFORE
    MOV right_IS_USED_POWERUP3, 0 ;;TO INDICATE IF USED BEFORE 
    MOV IS_USED_POWERUP4, 0 ;;TO INDICATE IF USED BEFORE
    MOV right_IS_USED_POWERUP4, 0 ;;TO INDICATE IF USED BEFORE
    MOV IS_USED_POWERUP6, 0 ;;TO INDICATE IF USED BEFORE
    MOV right_IS_USED_POWERUP6, 0 ;;TO INDICATE IF USED BEFORE
    MOV EXECUTE_REVESED, 0 ;;IN LEVEL 2 IT INDECATES IF YOU CHOSED TO EXECUTE ON OTHER 


    RET
RESET_ALL_VARS ENDP



READ_BUFFER_IF_NOT_USED PROC
    MOV AH,1
    INT 16H
    jnz _continue1 ;; something is clicked
            RET
    _continue1:

    ;; AH-> SC   A;-ASCII
    JOMP1:
    cmp ah,3bh ;f1
    jne JOMP2 
    RET
    JOMP2:
    
    cmp ah,3ch ; F2
    jne JOMP3 
    RET
    JOMP3:
    cmp ah,3dh ; F3
    jne JOMP4 
    RET
    JOMP4:
    cmp ah,3eh ; F4
    jne JOMP5
    RET
    JOMP5:
    cmp ah,paddleUp
    jne checkNextttt
    ret
    checkNextttt:

    cmp ah,paddleDown
    jne checkNexttttt
    ret
    checkNexttttt:

    cmp ah,paddleRight
    jne checkNextttttt
    ret
    checkNextttttt:

    cmp ah,paddleLeft
    jne checkNexttttttt
    ret
    checkNexttttttt:

    cmp ah,right_paddleUp
    jne checkNexttttt1
    ret
    checkNexttttt1:

    cmp ah,right_paddleDown
    jne checkNextttttttttttttt
    ret
    checkNextttttttttttttt:

    cmp ah,right_paddleRight
    jne checkNexttttttttt
    ret
    checkNexttttttttt:

    cmp ah,right_paddleLeft
    jne checkNexttttttttttt
    ret
    checkNexttttttttttt:

    cmp ah,fireScanCode
    jne checkNextttttttttttt
    ret
    checkNextttttttttttt:


    cmp ah,right_fireScanCode
    jne checkNexttttttttttttt
    ret
    checkNexttttttttttttt:
    cmp ah,63       ;F5
    jne JOMP33
    RET
    JOMP33:
    cmp ah,64       ;F6
    jne JOMP44
    RET
    JOMP44:
    cmp ah,65       ;F7
    jne JOMP45
    RET
    JOMP45:
    cmp ah,66       ;F8
    jne JOMP46
    RET
    JOMP46:
    cmp ah,67       ;F9
    jne JOMP47
    RET
    JOMP47:

    cmp al,20H  ;;a space 
    jb checkitnn 
    cmp al, ']'
    ja checkitnn
    ret
    checkitnn:
    cmp ah,0eh      ;;backk
    jne checkitnn2
    ret
    checkitnn2:



    READ_KEY
    RET
READ_BUFFER_IF_NOT_USED ENDP

;description



end main
