	include macr.inc
	;.286
	.model small
	.stack 64
	.data  
	nl db 10,13,'$'
	Enter_Name_message0 db 'Press Enter key to continue ', '$'
	Enter_Name_message db 'Please enter Your Name: ', '$' 
	Enter_Name_message2 db 'Name MUST start with a letter (No digits or special characters)$'
	Enter_Points_message db 'Please enter Initial Points: ', '$'  
	Press_any_Key_message db 'press any key to continue...$'
	MAIN_Screen_message1 db 'To Start Chatting press F1','$'
	MAIN_Screen_message2 db 'To Start Game press F2$'  
	MAIN_Screen_message3 db 'To end Program press ESC$'   
	First_msg_in_notification_bar db 80 dup('$')
	Second_msg_in_notification_bar db 80 dup('$')

	Sent_CHAT_INV_msg db 'You sent a chat Invitation','$'
	Sent_Game_INV_msg db 'You sent a Game Invitation','$'
	
	level1_msg db 'LEVEL 1 -- PRESS F1$' 
	level2_msg db 'LEVEL 2 -- PRESS F2$' 
	
	choose_hidden_char db 'Choose a hidden char: $'
	you_cannot_write_msg db 'You Cannot write char: $'
	hidden_char db 0		;; The hiddden char chosen by current player
	other_hidden_char db 'V' 
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
	
	
	
	is_player_1_ready_for_game db 0
	is_player_2_ready_for_game db 0
	is_player_1_ready_for_chat db 0
	is_player_2_ready_for_chat db 0
    My_Initial_points dw ?
	Game_Level db 0

    FirstName LABEL BYTE ; named the next it the same name 
	FirstNameSize db 16
	ActualFirstNameSize db ?
	FirstNameData db 17 dup('$')

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

     ;; command line left side
     CL_row_left dw 1201h

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


     ;; Values in regs
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
		ball_0 db 0
		ball_1 db 0
		ball_2 db 0
		ball_3 db 0
		ball_4 db 0


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

	ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'



	.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations
	;ChangeVideoMode 13h ;;clears screen and starts Video mode	
	
	DisplayAgain:
	CLR_Screen_with_Scrolling_TEXT_MODE 
	
    call NAME_VALIDATION
    FirstIsLetter:               ;jmp here if first character is a letter

    DisplayString_AT_position_not_moving_cursor Enter_Points_message 0818h ; show mes
    MoveCursorTo 0921h
    ReadNumberdec_in_ax ;; Read points and put it in ax ;; TODO: See if you want this in hexa
    mov My_Initial_points,ax ;; initialize initial points

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
				UPDATE_notification_bar2 Sent_CHAT_INV_msg
				mov is_player_1_ready_for_chat,1 ;; make me ready and see if the other is ready to
				cmp is_player_1_ready_for_chat,1
				;;je LETS_Chat 	;;Player 2 is Ready TOO
				mov is_player_2_ready_for_chat,1 ;; TODO: temproraly in PHASE 1 -> Pressing Twice Starts THE Chat Room


				jmp remove_key_from_buffer
				
				check_f2:
				cmp ah,3ch ; F2
				jne remove_key_from_buffer
				;in case of F2
				UPDATE_notification_bar2 Sent_Game_INV_msg
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
			CALL GAME_WELCOME_PAGE 	;; For level selection and continue To GAME
			jmp QUIT_THIS_GAME

			LETS_Chat:
				empitify_buffer   ;; To make Sure That no bat chars are saved in Buffer
				CAll CHAT_ROOM 		;;should BE THE CHAT.ASM but just For now 
			jmp QUIT_THIS_GAME

		QUIT_THIS_GAME:
		MOV AH,4CH
		INT 21H ;GO BACK TO DOS ;to end the program
	main endp
	

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

;THE GAME AND LEVEL SELECTION
GAME_WELCOME_PAGE PROC

		ChangeVideoMode 3h ;;clears screen and starts Video mode	

		DisplayString_AT_position_not_moving_cursor level1_msg 0a20h
		DisplayString_AT_position_not_moving_cursor level2_msg 0c20h

		;;LEVEL SELECTION  -> keep looping till a F1 or F2 Is Pressed
		LEVEL_SELECTION 	; just you choose the the level
		LEVEL_PROCESSING	; according to the chosen -> you do that shit
		INSTRUCTIONS_PAGE	;just to show The instructions of THE game for some 5 seconds

		;; just to stop the program
		;sis: jmp sis

	ret
GAME_WELCOME_PAGE ENDP


;description
CHAT_ROOM PROC
	ret
CHAT_ROOM ENDP


	end main
