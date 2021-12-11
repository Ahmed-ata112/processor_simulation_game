	include macr.inc
	;.286
	.model small
	.stack 64
	.data
	Enter_Name_message db 'Please enter Your Name: ', '$'
	Enter_Points_message db 'Please enter Initial Points: ', '$'  
	Press_any_Key_message db 'press any key to continue...$'
	MAIN_Screen_message1 db 'To Start Chatting press F1','$'
	MAIN_Screen_message2 db 'To Start Game press F2$'  
	MAIN_Screen_message3 db 'To end Program press ESC$'   
	First_msg_in_notification_bar db 80 dup('$')
	Second_msg_in_notification_bar db 80 dup('$')

	duummy1 db 'F1 is pressed','$'
	duummy2 db 'F2 is pressed','$'

	nl db 10,13
    My_Initial_points dw ?

    FirstName LABEL BYTE ; named the next it the same name 
	FirstNameSize db 30
	ActualFirstNameSize db ?
	FirstNameData db 30 dup('$')





	.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations
	
    DisplayString Enter_Name_message
    ReadString FirstName

    DisplayString nl    ;print newline

    DisplayString Enter_Points_message ; show mes

    ReadNumberdec_in_ax ;; Read points and put it in ax
    mov My_Initial_points,ax ;; initialize initial points

	; now enter the main Screen
	DisplayString nl
	DisplayString Press_any_Key_message
	mov ah,0
	int 16h

	Main_Screen:
		CLR_Screen_with_text_mode
		DisplayString_AT_position_TEXTMODE MAIN_Screen_message1 ,0C16h
		DisplayString_AT_position_TEXTMODE MAIN_Screen_message2 ,0D16h
		DisplayString_AT_position_TEXTMODE MAIN_Screen_message3 ,0E16h

		MAIN_LOOP:
			;; it shouldn't wait untill the user enters the KeY
			;; 2 loops in the main
			;; The first is to check if the user clicked any key
			;; the second to check  
			;; enter -> scancode 1C  
			;; esc -> SC 01
			;; F2 -> 3C   
			;; F1 -> 3B
			;UPDATE_notification_bar2 duummy1
			;UPDATE_notification_bar2 duummy2
			;UPDATE_notification_bar2 duummy1
			check_key_pressed1: mov ah, 1
			int 16h                      ;Get key pressed (do not wait for a key - AH:scancode, AL:ASCII)
			jnz .continue ;; something is clicked
			jmp no_thing_clicked
			.continue:
			
			
			;; check the type of the key
			cmp ah,01 ; esc
			jne continue2 
			jmp QUIT_THIS_GAME
			continue2:
			cmp ah,3bh ;f1
			jne check_f2
			;in case of F1
			UPDATE_notification_bar2 duummy1
			
			
			check_f2:
			cmp ah,3ch ; F2
			jne no_valid_key
			;in case of F2
			UPDATE_notification_bar2 duummy2
			
			no_valid_key:
			;; delete it from buffer
			mov ah,07
			int 21h
			no_thing_clicked:

			;; the second loop is here but nothing to display now



			jmp check_key_pressed1
			
			







	QUIT_THIS_GAME:
	MOV AH,4CH
    INT 21H ;GO BACK TO DOS ;to end the program
	main endp
	
	end main
