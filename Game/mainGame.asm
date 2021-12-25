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

    DisplayString_AT_position_TEXTMODE Enter_Points_message 0818h ; show mes
    MoveCursorTo 0921h
    ReadNumberdec_in_ax ;; Read points and put it in ax ;; TODO: See if you want this in hexa
    mov My_Initial_points,ax ;; initialize initial points

	; now enter the main Screen
	DisplayString nl
	DisplayString_AT_position_TEXTMODE Press_any_Key_message 1018h 
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
			DisplayString_AT_position_TEXTMODE MAIN_Screen_message1 ,0C16h
			DisplayString_AT_position_TEXTMODE MAIN_Screen_message2 ,0D16h
			DisplayString_AT_position_TEXTMODE MAIN_Screen_message3 ,0E16h
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
		DisplayString_AT_position_TEXTMODE Enter_Name_message 0318h 
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
		DisplayString_AT_position_TEXTMODE Enter_Name_message2 0a04h
		DisplayString_AT_position_TEXTMODE Press_any_Key_message 0b04h 
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

	ChangeVideoMode 13h ;;clears screen and starts Video mode	

		DisplayString_AT_position_TEXTMODE level1_msg 0a0bh
		DisplayString_AT_position_TEXTMODE level2_msg 0c0bh

		;;LEVEL SELECTION  -> keep looping till a F1 or F2 Is Pressed
		LEVEL_SELECTION 
		;; just to stop the program
		;sis: jmp sis

	ret
GAME_WELCOME_PAGE ENDP


;description
CHAT_ROOM PROC
	ret
CHAT_ROOM ENDP


	end main
