include macr.inc
    include ex_macr.inc
	.286
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
	INSTRUCTIONS_msg db 'SOME INSTRUCTIONS OF THE GAME... blA bla bla ... $'
	

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
	
	separator_ db 'e: $'
	
	is_player_1_ready_for_game db 0
	is_player_2_ready_for_game db 0
	is_player_1_ready_for_chat db 0
	is_player_2_ready_for_chat db 0
    My_Initial_points dw 0
	Game_Level db 0
    
  

    FirstName LABEL BYTE ; named the next it the same name 
	FirstNameSize db 20
	ActualFirstNameSize db ?
	FirstNameData db 20 dup('$')

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
        L_CARRY DB 0

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


	;;For The Graphics

    time_aux db 0  ;variable used when checking if the time has changed


    BirdImg db 1,0,73,2,0,73,10,0,73,11,0,73,2,1,73,10,1,73,1,2,73,2,2,73,3,2,73,4,2,73,8,2,73,9,2,73,10,2,73,11,2,73,1,3,73,2,3,73,3,3,73,4,3,73,5,3,73,7,3,73,8,3,73,9,3,73,10,3,73,11,3,73,0,4,73,1,4,73,2,4,73,3,4,73,5,4,73,6,4,73
            db 7,4,73,9,4,73,10,4,73,11,4,73,12,4,73,0,5,73,2,5,73,3,5,73,4,5,73,5,5,73,6,5,73,7,5,73,8,5,73,9,5,73,10,5,73,12,5,73,0,6,73,3,6,73,4,6,73,5,6,73,6,6,73,7,6,73,8,6,73,9,6,73,12,6,73,4,7,73,8,7,73,3,8,73,4,8,73,8,8,73
            db 9,8,73,3,9,73,9,9,73
    BirdSize dw 10 
    birdX dw 0
    birdY dw 0Ah
    BirdWidth dw 13
    birdVelocity dw 2



    right_BirdImg db 1,0,73,2,0,73,10,0,73,11,0,73,2,1,73,10,1,73,1,2,73,2,2,73,3,2,73,4,2,73,8,2,73,9,2,73,10,2,73,11,2,73,1,3,73,2,3,73,3,3,73,4,3,73,5,3,73,7,3,73,8,3,73,9,3,73,10,3,73,11,3,73,0,4,73,1,4,73,2,4,73,3,4,73,5,4,73,6,4,73
            db 7,4,73,9,4,73,10,4,73,11,4,73,12,4,73,0,5,73,2,5,73,3,5,73,4,5,73,5,5,73,6,5,73,7,5,73,8,5,73,9,5,73,10,5,73,12,5,73,0,6,73,3,6,73,4,6,73,5,6,73,6,6,73,7,6,73,8,6,73,9,6,73,12,6,73,4,7,73,8,7,73,3,8,73,4,8,73,8,8,73
            db 9,8,73,3,9,73,9,9,73
    right_BirdSize dw 10 
    right_birdX dw 147
    right_birdY dw 0Ah
    right_BirdWidth dw 13
    right_birdVelocity dw 2


    paddleImg db 6,0,73,7,0,73,12,0,73,13,0,73,6,1,73,7,1,73,12,1,73,13,1,73,6,2,73,7,2,73,12,2,73,13,2,73,6,3,73,7,3,73,12,3,73,13,3,73,6,4,73,7,4,73,12,4,73,13,4,73,6,5,73,7,5,73,12,5,73,13,5,73,0,6,73,1,6,73,2,6,73,3,6,73,4,6,73,5,6,73
        db 6,6,73,7,6,73,8,6,73,9,6,73,10,6,73,11,6,73,12,6,73,13,6,73,14,6,73,15,6,73,16,6,73,17,6,73,18,6,73,19,6,73,0,7,73,1,7,73,2,7,73,3,7,73,4,7,73,5,7,73,6,7,73,7,7,73,8,7,73,9,7,73,10,7,73,11,7,73,12,7,73,13,7,73,14,7,73,15,7,73
        db 16,7,73,17,7,73,18,7,73,19,7,73,0,8,73,1,8,73,18,8,73,19,8,73,0,9,73,1,9,73,18,9,73,19,9,73,0,10,73,1,10,73,2,10,73,3,10,73,4,10,73,5,10,73,6,10,73,7,10,73,8,10,73,9,10,73,10,10,73,11,10,73,12,10,73,13,10,73,14,10,73,15,10,73,16,10,73,17,10,73
        db 18,10,73,19,10,73,0,11,73,1,11,73,2,11,73,3,11,73,4,11,73,5,11,73,6,11,73,7,11,73,8,11,73,9,11,73,10,11,73,11,11,73,12,11,73,13,11,73,14,11,73,15,11,73,16,11,73,17,11,73,18,11,73,19,11,73
    paddleSize dw 12 ;;That is the height
    paddle_Width dw 20 
    paddle_x dw 5
    paddle_y dw 185 ;at the bottom of the 320*200 pixels screen
    paddle_velocity dw 10
    paddleColor db 1


    right_paddleImg db 6,0,73,7,0,73,12,0,73,13,0,73,6,1,73,7,1,73,12,1,73,13,1,73,6,2,73,7,2,73,12,2,73,13,2,73,6,3,73,7,3,73,12,3,73,13,3,73,6,4,73,7,4,73,12,4,73,13,4,73,6,5,73,7,5,73,12,5,73,13,5,73,0,6,73,1,6,73,2,6,73,3,6,73,4,6,73,5,6,73
        db 6,6,73,7,6,73,8,6,73,9,6,73,10,6,73,11,6,73,12,6,73,13,6,73,14,6,73,15,6,73,16,6,73,17,6,73,18,6,73,19,6,73,0,7,73,1,7,73,2,7,73,3,7,73,4,7,73,5,7,73,6,7,73,7,7,73,8,7,73,9,7,73,10,7,73,11,7,73,12,7,73,13,7,73,14,7,73,15,7,73
        db 16,7,73,17,7,73,18,7,73,19,7,73,0,8,73,1,8,73,18,8,73,19,8,73,0,9,73,1,9,73,18,9,73,19,9,73,0,10,73,1,10,73,2,10,73,3,10,73,4,10,73,5,10,73,6,10,73,7,10,73,8,10,73,9,10,73,10,10,73,11,10,73,12,10,73,13,10,73,14,10,73,15,10,73,16,10,73,17,10,73
        db 18,10,73,19,10,73,0,11,73,1,11,73,2,11,73,3,11,73,4,11,73,5,11,73,6,11,73,7,11,73,8,11,73,9,11,73,10,11,73,11,11,73,12,11,73,13,11,73,14,11,73,15,11,73,16,11,73,17,11,73,18,11,73,19,11,73
    right_paddleSize dw 12 ;;That is the height
    right_paddle_Width dw 20 
    right_paddle_x dw 160
    right_paddle_y dw 185 ;at the bottom of the 320*200 pixels screen
    right_paddle_velocity dw 10
    right_paddleColor db 0Eh

    BallImg db 3,0,73,4,0,73,5,0,73,1,1,73,2,1,73,6,1,73,7,1,73,1,2,73,2,2,73,6,2,73,7,2,73,0,3,73,3,3,73,5,3,73,8,3,73,0,4,73,4,4,73,8,4,73,0,5,73,3,5,73,5,5,73,8,5,73,1,6,73,2,6,73,6,6,73,7,6,73,1,7,73,2,7,73,6,7,73,7,7,73
            db 3,8,73,4,8,73,5,8,73
    BallSize dw 9 
    ballWidth dw 9
    fireballColor db 1100b

    ;left fireball
    fireBall_x dw ?
    fireBall_y dw 190
    fireBall_velocity_y dw 20
    ifFireIsPressed db 0

    ;right fireball
    right_fireBall_x dw ?
    right_fireBall_y dw 190
    right_fireBall_velocity_y dw 20
    right_ifFireIsPressed db 0


            ;green, light magenta, red, blue, yellow
    colors db  02h,           0dh, 04h,  01h,    0Eh
            
                    ;green, light magenta, red, blue, yellow
    pointsOfColors db       1,            2,   3,    4,      5  

    colorIndex db 0
    birdColor db 2
    birdStatus db 1
    birdPoints db 1

    right_colorIndex db 0
    right_birdColor db 2
    right_birdStatus db 1
    right_birdPoints db 1
    playerPoints dw 0
    right_playerPoints dw 0 ;; TODO: print them

;;;;-------------Comand Line Input------------;;;;;;
    THE_COMMAND db 30 dup('$')
    command_Size db 0 ; to store the aactual size of input at the current time
    forbidden_char db 'A'
    finished_taking_input db 0 ; just a flag to indicate we finished entering the string
    
    
    L_command LABEL BYTE ; named the next it the same name 
	L_commandSize db 20
	Actual_L_commandSize db ?
	L_commandData db 20 dup('$')
        
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
.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations

    ChangeVideoMode 13h


	MAIN_LOOP:
	ReadString L_command
    ChangeVideoMode 13h
    call ex_MAIN ;; L_COMMANDDATA
    Reset_Command
	call UPDATE_VALUES_Displayed	

    jmp MAIN_LOOP


		QUIT_THIS_GAME:
		MOV AH,4CH
		INT 21H ;GO BACK TO DOS ;to end the program
	main endp
	


;THE GAME AND LEVEL SELECTION

    
ex_MAIN PROC 

    MOV DL,'N'
    MOV SI, OFFSET L_commandData
    CMP DL, [SI]
    JNE C50
    JMP  EN
    C50:


    MOV DL,'C'
    CMP DL, [SI]
    JNE C501
    MOV AL,0
    MOV L_CARRY,AL
    JMP  EN
    C501:


	  ;DisplayString command
    ;Convert_OP_TO_HEXA Operand1
    CALL split_command
    split_operands Two_Operands_Together_splited Operand1 Operand2
    HASHING command_splited HASH_comand    
    HASHING_op Operand1 HASH_Operand1
    HASHING_op Operand2 HASH_Operand2 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    


    MOV AX,HASH_Operand2

    MOV HASH_Operand,AX


    MOV SI,offset Operand2
    MOV DI, offset Operand
    MOV CX,5
    REP MOVSB

    CALL check_Operand

    MOV AX, Operand_Value
    MOV Operand2_Value,AX 


    MOV AX,HASH_Operand1

    MOV HASH_Operand,AX




    MOV SI,offset Operand1
    MOV DI, offset Operand
    MOV CX,5
    REP MOVSB

    CALL check_Operand     ;; 0 for byte, 1 for word

    MOV AX, Operand_Value
    MOV Operand1_Value,AX 
    
    
    CALL check_command          
    EN:

    ;OPERAND1 , 2

    MOV AL,'$'
    MOV DI, offset command_splited
    MOV CX,5
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Operand1
    MOV CX,5
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Operand2
    MOV CX,5
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Two_Operands_Together_splited
    MOV CX,12
    REP STOSB

    MOV AX,0H

    MOV Operand2_Value,AX
    MOV Operand1_Value,AX
    MOV sizeIndex ,AL
    MOV HASH_Operand,AX
    MOV Operand_Value,AX

    MOV AL,'$'
    MOV DI, offset Operand
    MOV CX,5
    REP STOSB


    MOV HASH_comand,AX
    MOV HASH_Operand2,AX
    MOV HASH_Operand1,AX
    


    



	  ret
ex_MAIN  ENDP     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 

;; split operand and store it in split_command 
;; split operands and store it in Two_Operands_Together_splited
split_command               PROC
    mov SI, offset L_commandData
    mov DI, offset command_splited
    mov al,' ' ;; to check space
moving11:	
	MOVSB
	cmp al,[SI]
	jnz moving11
;; Mena	
	mov DI, offset Two_Operands_Together_splited
	mov al,'$' ;; to check end 
	inc SI     ;; to skip space
moving22:
    MOVSB
    cmp al,[SI]
    jnz moving22	

    ret

split_command               ENDP 

check_command                PROC 

    MOV SI,offset HASH_comand 
    MOV DI,offset command_splited  
      
     
    ;; ADD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    CMP [SI],29CH
    jz asdasd
    Jmp CHECK1 
    asdasd:    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADD AX,BX
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand
    
    CHECK1:
    
    
    ;; ADC
    
    CMP [SI],299H


     JNZ CHECK2
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    ADD AX,BX
    MOV BH,00H
    MOV BL,L_CARRY
    ADD AX,BX
     

    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    CHECK2:
    
    ;; SUB  
    
    CMP [SI],311H
     JNZ CHECK3
    
    ;; CODE                    
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SUB AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    
    CHECK3:
    
    ;; SBB   
    
    CMP [SI],2D8H
     JNZ CHECK4
    
    ;; CODE
    
    
    
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    SUB AX,BX
    MOV BH,00H
    MOV BL,L_CARRY
    SUB AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    
    
    CHECK4:
    
    ;; DIV   
    
    CMP [SI],2EDH
     JNZ CHECK5
    
    ;; CODE
    
                                                             
                                                                   
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE1
    MOV AX,L_AX
    MOV DX,L_DX                                  ;;;;;;    div error div overflow
    DIV BX
                                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,24DH
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV HASH_Operand1,25CH
     
                                                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,DX

    CALL put_Operand
    JMP CONT
                                                                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BYTE1:
    MOV AX,L_AX                                                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DIV BL
    
    MOV HASH_Operand1,24DH
                                                                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand
    CONT:
    
    CHECK5:
    
    ;; MUL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    CMP [SI],317H
     JNZ CHECK6
    
      ;; CODE
      
    
    MOV BX,Operand1_Value
    
    MOV  CL,sizeIndex
    
    CMP CL,1
    JNE BYTE11
    MOV AX,L_AX
    MUL BX
    
    
    MOV HASH_Operand1,24DH
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    MOV HASH_Operand1,25CH
     
                                                             
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,DX

    CALL put_Operand    
    JMP CONT
    
    BYTE11:
    MOV AX,L_AX 
    MUL BL
    
     MOV HASH_Operand1,24DH
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    CONT1:
    
    CHECK6:
    
    ;; MOV   
    
    CMP [SI],323H
     JNZ CHECK7
    
    ;; CODE
    MOV AX,Operand2_Value
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    CHECK7:
    
    ;; XOR   
    
    CMP [SI],343H
     JNZ CHECK8
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    XOR AX,BX
    
     
    
MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX


    MOV AL,0
    MOV L_CARRY,AL

    CALL put_Operand        
    CHECK8:
    
    ;; AND   
    
    CMP [SI],2BAH
     JNZ CHECK9
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    AND AX,BX
    
     
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AL,0
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK9:
    
    ;; OR    
    
    CMP [SI],232H
     JNZ CHECK10
    
    ;; CODE
    MOV AX,Operand1_Value
    MOV BX,Operand2_Value
    
    OR AX,BX
    
     
    
    MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX


    MOV AL,0
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK10:
    
    ;; NOP   
    
    CMP [SI],315H
     JNZ CHECK11
   
    ;; CODE
    
    CHECK11:
    
    ;; SHR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CL CX CH  
    
    CMP [SI],31AH                                                                                           ;   xxxx xxxx xxxx xxxx
     JNZ CHECK15
     
     ;; CODE 
     MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SHR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    
    
    
    CHECK15:
    
    
    ;; INC   
    
    CMP [SI],2D7H
     JNZ CHECK12
    
    ;; CODE
    MOV AX,Operand1_Value
    
    INC AX
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK12:
    
    ;; DEC   
    
    CMP [SI],2A8H
     JNZ CHECK13
    
    ;; CODE
    MOV AX,Operand1_Value
    
    DEC AX
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    CALL put_Operand    
    
    CHECK13:
    
    ;; CLC   
    
    CMP [SI],2B9H
    CHECK14:
    
    ;; SHL   
    
    CMP [SI],308H 
     JNZ CHECK16
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SHL AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX


    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK16:
    
    ;; SAR   
    
    CMP [SI],305H 
     JNZ CHECK17
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     SAR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK17:
    
    ;; ROR   
    
    CMP [SI],32BH 
     JNZ CHECK18
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK18:
    
    ;; RCL   ;...........................
    
    CMP [SI],2F5H 
     JNZ CHECK19
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value

    MOV BH,00H
    MOV BL,L_CARRY
    SHR BL,1


     RCL AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK19: 
    
    ;; RCR   ;.............................
    
    CMP [SI],307H 
     JNZ CHECK20
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value

    MOV BH,00H
    MOV BL,L_CARRY
    SHR BL,1

     RCR AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK20: 
    
    ;; ROL   
    
    CMP [SI],319H 
     JNZ CHECK21
    
    ;; CODE 
    MOV AX,Operand1_Value
     MOV CX,Operand2_Value
     ROL AX,CL
     
     
     MOV BX,HASH_Operand1 
     MOV HASH_Operand,BX
    MOV Operand_Value,AX

    MOV AX,0
    RCL AL,1
    MOV L_CARRY,AL

    CALL put_Operand    
    
    CHECK21:  
    RET
check_command                ENDP  


check_Operand proc      

    MOV SI,offset HASH_Operand 
     
    ;; AX
    
    CMP [SI],24dH
    JNZ CHECKBX
    
    mov ax,L_AX;; CODE       
    mov Operand_Value,ax
    mov sizeIndex,1h 
    jmp END2

    CHECKBX:
    
    
    ;; BX
    
    CMP [SI],252H
     JNZ CHECKCX
    
    mov ax,L_BX;; CODE                                               
     mov Operand_Value,ax 
     mov sizeIndex,1h
    jmp END2

    CHECKCX:
    
    ;; CX 
    
    CMP [SI],257H
    jz continue1
     jmp CHECKDX
    continue1:
    mov ax,L_CX;; CODE
     mov Operand_Value,ax 
     mov sizeIndex,1h                   
    jmp END2
    CHECKDX:
    
    ;; DX   
                                    
    CMP [SI],25cH
     JNZ CHECKSI
    
    mov ax,L_DX;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp END2
    CHECKSI:
    
    ;; SI   
    
    CMP [SI],27aH
     JNZ CHECKDI
    
    mov ax,L_SI;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp END2
    CHECKDI:
    
    ;;  ja
    ;; jbe + jmp
    ;; DI   
    
    CMP [SI],22fH
     JNZ CHECKSP
    
    mov ax,L_DI;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp END2
    CHECKSP:
    
    ;; SP   
    
    CMP [SI],28fH
     JNZ CHECKBP
    
    mov ax,L_SP;; CODE
     mov Operand_Value,ax 
     mov sizeIndex,1h
    jmp END2
    CHECKBP:
    
    ;; BP   
    
    CMP [SI],23aH
     JNZ CHECKAL
    
    mov ax,L_BP;; CODE
     mov Operand_Value,ax
     mov sizeIndex,1h
    jmp END2
    CHECKAL:
    
    ;; AL    
    
    CMP [SI],229H
     JNZ CHECKBL
    
    mov ax,L_AX;; CODE
    mov Ah,00H
    mov Operand_Value,ax
    ;mov sizeIndex,0h
    jmp END2
    CHECKBL:
    
    ;; BL    
    
    CMP [SI],22eH
     JNZ CHECKCL
    
    mov ax,L_BX;; CODE
    MOV AH,00H 
     mov Operand_Value,ax 
       ;mov sizeIndex,0h
    jmp END2
    CHECKCL:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL
   
    mov ax,L_CX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECKDL:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH
    
    mov ax,L_DX;; CODE
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECKAH:
    
    
    ;; AH  
    
    CMP [SI],21dH
     JNZ CHECKBH
    
    mov ax,L_AX;; CODE
    MOV AL,AH
    MOV AH,00H                              
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECKBH:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH
    
    mov ax,L_BX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECKCH:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH
    
    mov ax,L_CX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECKDH:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK00
     
    mov ax,L_DX;; CODE
    MOV AL,AH
    MOV AH,00H
     mov Operand_Value,ax
       ;mov sizeIndex,0h
    jmp END2
    CHECK00:
    
    ;; 00  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TO CHECK
    
    CMP [SI],3feH 
    JNZ CHECK01
    movml00: 
    mov aL,L_00
    MOV AH,L_01                                          
    mov Operand_Value,ax
    jmp END2
    CHECK01:
    
;     ;; 01  
    
    CMP [SI],401H 
    JNZ CHECK02
     movml1:
    mov aL,L_01
    MOV AH,L_02
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp END2
    CHECK02:
    
;     ;; 02  
    
    CMP [SI],404H 
     JNZ CHECK03
      movml2:
    mov aL,L_02
    MOV AH,L_03 
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
    jmp END2
    CHECK03:
    
;     ;; 03  
    
    CMP [SI],407H 
     JNZ CHECK04
      movml3:
    mov aL,L_03
    MOV AH,L_04
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
     jmp END2
    CHECK04:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK05
       movml4:
    mov aL,L_04
    MOV AH,L_05
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp END2    
    CHECK05:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK06
      movml5:
    mov aL,L_05
    MOV AH,L_06 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp END2    
    CHECK06:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK07
      movml6:
    mov aL,L_06
    MOV AH,L_07 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp END2    
    CHECK07:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK08
      movml7:
    mov aL,L_07
    MOV AH,L_08 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp END2   
    CHECK08:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK09
      movml8:
    mov aL,L_08
    MOV AH,L_09
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp END2       
    CHECK09:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA
      movml9:
    mov aL,L_09
    MOV AH,L_A 
     mov Operand_Value,ax 
  ;mov sizeIndex,0h
 jmp END2    
    CHECKA:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB
      movmlA:
    mov aL,L_A
    MOV AH,L_B 
     mov Operand_Value,aX
  ;mov sizeIndex,0h
 jmp END2     
    CHECKB:
    
;     ;; B  
    
    CMP [SI],3a4H 
     JNZ CHECKC
      movmlB:
    mov aL,L_B
    MOV AH,L_C 
     mov Operand_Value,ax
  ;mov sizeIndex,0h
 jmp END2     
    CHECKC:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD
      movmlC:
    mov aL,L_C
    MOV AH,L_D
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp END2     
    CHECKD:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE
      movmlD:
    mov aL,L_D
    MOV AH,L_E
     mov Operand_Value,ax
  ;mov sizeIndex,0h 
 jmp END2     
    CHECKE:
    
;     ;; E  
   
     CMP [SI],3adH 
      JNZ CHECKF
       movmlE:
     mov aL,L_E
     MOV AH,L_F
      mov Operand_Value,ax
        ;mov sizeIndex,0h 
  jmp END2         
     CHECKF:
   
     ;; F  
   
     CMP [SI],3b0H 
     JNZ CHECKmlSI 
     movmlF:
     mov aL,L_F
     MOV AH,L_00
     mov Operand_Value,ax
       ;mov sizeIndex,0h 
     jmp END2 
         
     CHECKmlSI:
    
                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
         ;                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TO CHECK
    
      ;[SI]
    CMP [SI],4b2H 
    jz as1
     jmp CHECKmlDI
     as1:   
    
    ;;
     cmp L_SI,0H

     jnz escape1
     jmp movml00 
     escape1:

     cmp L_SI,1H
     jnz escape2
     jmp movml1 
     escape2:
      
     cmp L_SI,2H

     jnz escape3
     jmp movml2 
     escape3:


     cmp L_SI,3H

     jnz escape4
     jmp movml3 
     escape4:

      
     cmp L_SI,4H
     jnz escape5
     jmp movml4 
     escape5:
      
     cmp L_SI,5H

    jnz escape6
     jmp movml5
     escape6:

     cmp L_SI,6H
jnz escape7
     jmp movml6
     escape7:

     cmp L_SI,7H

jnz escape8
     jmp movml7
     escape8:

     cmp L_SI,8H


jnz escape9
     jmp movml8
     escape9:

     cmp L_SI,9H


     jnz escape10
     jmp movml9
     escape10:

     cmp L_SI,0AH

    jnz escape11
     jmp movmlA
     escape11:

     cmp L_SI,0BH

    jnz escape12
     jmp movmlB
     escape12:

     cmp L_SI,0CH
jnz escape13
     jmp movmlc
     escape13:     
     
     cmp L_SI,0DH
jnz escape14
     jmp movmlE
     escape14:     
     cmp L_SI,0EH

    jnz escape15
     jmp movmlE
     escape15:

     cmp L_SI,0FH
     jnz escape16
     jmp movmlF
     escape16:



    ; ;
    
     ;RegisterIndirect_Addressing_Mode _SI 
         jmp end2             
     CHECKmlDI:
        ; ;; [DI]
         CMP [SI],485H  
         jz escape17
     jmp CHECKmlBX
     escape17:

    

     cmp L_DI,0H
   jnz escape18
     jmp movml00
     escape18:

                     
     cmp L_DI,1H
     jnz escape19
     jmp movml1
     escape19:
    
     cmp L_DI,2H
       jnz escape20
     jmp movml2
     escape20:

     cmp L_DI,3H
      jnz escape21
     jmp movml3
     escape21:

     cmp L_DI,4H
       jnz escape22
     jmp movml4
     escape22:
   
     cmp L_DI,5H
     jnz escape23
     jmp movml5
     escape23:
    
     cmp L_DI,6H
      jnz escape24
     jmp movml6
     escape24:
 
     cmp L_DI,7H
      jnz escape25
     jmp movml7
     escape25:
    
     cmp L_DI,8H
     jnz escape26
     jmp movml8
     escape26:
   
     cmp L_DI,9H
      jnz escape27
     jmp movml9
     escape27:
    
     cmp L_DI,0AH
        jnz escape28
     jmp movmlA
     escape28:
     
     cmp L_DI,0BH
        jnz escape29
     jmp movmlB
     escape29:
     
     cmp L_DI,0CH
        jnz escape30
     jmp movmlC
     escape30:
  
     cmp L_DI,0DH
        jnz escape31
     jmp movmlD
     escape31:
  
     cmp L_DI,0EH
      jnz escape32
     jmp movmlE
     escape32:
     
     cmp L_DI,0FH
      jnz escape33
     jmp movmlF
     escape33:
 
    ; ;
    
     ;RegisterIndirect_Addressing_Mode _DI
                     
               
     CHECKmlBX:
         ;; [BX] 
     CMP [SI],4acH 
      jz escape34
     jmp CHECKdata
     escape34:
        
         ;
     cmp L_BX,0H
     jnz escape35
     jmp movml00
     escape35:
                    
     cmp L_BX,1H
     jnz escape36
     jmp movml1
     escape36:
     
     cmp L_BX,2H
     jnz escape37
     jmp movml2
     escape37:
   
     cmp L_BX,3H
      jnz escape38
     jmp movml3
     escape38:
    
     cmp L_BX,4H
      jnz escape39
     jmp movml4
     escape39:

     cmp L_BX,5H
      jnz escape40
     jmp movml5
     escape40:

     cmp L_BX,6H
     jnz escape41
     jmp movml6
     escape41:

     cmp L_BX,7H
     jnz escape42
     jmp movml7
     escape42:
  
     cmp L_BX,8H
     jnz escape43
     jmp movml8
     escape43:
   
     cmp L_BX,9H
      jnz escape44
     jmp movml9
     escape44:

     cmp L_BX,0AH
    jnz escape45
     jmp movmlA
     escape45:
  
     cmp L_BX,0BH
     jnz escape46
     jmp movmlB
     escape46:
   
     cmp L_BX,0CH
     jnz escape47
     jmp movmlC
     escape47:
 
     cmp L_BX,0DH
      jnz escape48
     jmp movmlD
     escape48:

     cmp L_BX,0EH
      jnz escape49
     jmp movmlE
     escape49:
  
    cmp L_BX,0FH
     jnz escape50
     jmp movmlF
     escape50:
   
   
    
    ; ;RegisterIndirect_Addressing_Mode _BX                                               
   CHECKdata:
    Convert_OP_TO_HEXA Operand sizeIndex
    mov Operand_Value,ax
 
    end2:
            
    ret

check_Operand ENDp


put_Operand PROC

    MOV SI,offset HASH_Operand 
    mov cl,sizeIndex
    mov ch,1h
     
    ;; AX
    
    CMP [SI],24dH
    jz con1
    Jmp CHECKBX1
    con1:    
    mov ax,Operand_Value;; CODE
    mov L_AX,ax 
    jmp end1

    CHECKBX1:
    
    
    ;; BX
    
    CMP [SI],252H
    jz con2

     Jmp CHECKCX1
    con2:
    mov ax,Operand_Value;; CODE
     mov L_BX,ax
    jmp end1

    CHECKCX1:
    
    ;; CX 
    
    CMP [SI],257H
    jz con3
     Jmp CHECKDX1
    con3:
    mov ax,Operand_Value;; CODE
     mov L_CX,ax                    
    jmp end1
    CHECKDX1:
                                                                           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; DX   
                                    
    CMP [SI],25cH
    jz con4
    jmp CHECKSI1
    con4:
    mov ax,Operand_Value;; CODE
     mov L_DX,ax
    jmp end1
    CHECKSI1:
    
    ;; SI   
    
    CMP [SI],27aH
    jz con5
     Jmp CHECKDI1
    con5:
    mov ax,Operand_Value;; CODE
     mov L_SI,ax
    jmp end1
    CHECKDI1:
    
    ;; DI   
    
    CMP [SI],22fH
    jz con6
     Jmp CHECKSP1
    con6:
    mov ax,Operand_Value;; CODE
     mov L_DI,ax
    jmp end1
    CHECKSP1:
    
    ;; SP   
    
    CMP [SI],28fH
    jz con7
     Jmp CHECKBP1
    con7:
    mov ax,Operand_Value;; CODE
     mov L_SP,ax
    jmp end1
    CHECKBP1:
    
    ;; BP   
    
    CMP [SI],23aH
    jz con8
    Jmp CHECKAL1
    con8:
    mov ax,Operand_Value;; CODE
     mov L_BP,ax
    jmp end1
    CHECKAL1:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; AL   
    
    CMP [SI],229H
     jz con9
     Jmp CHECKBL1
    con9:
    mov ax,Operand_Value;; CODE 
    mov bx,L_AX
    mov bl,al
     mov L_AX,bx
    jmp end1
    CHECKBL1:
    
    ;; BL    
    
    CMP [SI],22eH
    jz con10
     Jmp CHECKCL1
    con10:
    mov ax,Operand_Value;; CODE 
    mov bx,L_BX
    mov bl,al
    mov L_bX,bx
    jmp end1
    CHECKCL1:
    
    ;; CL   
    
    CMP [SI],233H
     JNZ CHECKDL1
   
    mov ax,Operand_Value;; CODE
     mov bx,L_CX
    mov bl,al
     mov L_CX,bx
    jmp end1
    CHECKDL1:
    
    ;; DL   
    
    CMP [SI],238H      
     JNZ CHECKAH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_DX
    mov bl,al
     mov L_DX,bx
    jmp end1
    CHECKAH1:
    
    
    ;; AH   
    
    CMP [SI],21dH
     JNZ CHECKBH1
    
    mov ax,Operand_Value;; CODE
    mov bx,L_AX
    mov bh,al
     mov L_AX,bx
    jmp end1
    CHECKBH1:
    
    ;; BH   
    
    CMP [SI],222H
     JNZ CHECKCH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_BX
    mov bh,al
     mov L_BX,bx
    jmp end1
    CHECKCH1:
    
    ;; CH   
    
    CMP [SI],227H
     JNZ CHECKDH1
    
    mov ax,Operand_Value;; CODE
        mov bx,L_CX
    mov bh,al
     mov L_CX,bx
    jmp end1
    CHECKDH1:
    
    ;; DH  
    
    CMP [SI],22cH 
     JNZ CHECK001
     
    mov ax,Operand_Value;; CODE
        mov bx,L_DX
    mov bh,al
     mov L_DX,bx
    jmp end1
    CHECK001:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; 00  
    
     CMP [SI],3feH 
     JNZ CHECK011
     movml001:                                                       
                                                                     
     mov ax,Operand_Value;; CODE
     mov L_00,al 
     cmp cl,ch
   je escape63
     jmp end1
     escape63:
     mov L_01,ah
     jmp end1
     CHECK011:
    
;     ;; 01  
    
     CMP [SI],401H 
     JNZ CHECK021
      movml11:
     mov ax,Operand_Value;; CODE
      mov L_01,al
      cmp cl,ch
     je escape65
     jmp end1
     escape65:
     mov L_02,ah 
     jmp end1
     CHECK021:
    
;     ;; 02  
    
     CMP [SI],404H 
      JNZ CHECK031
       movml21:
     mov ax,Operand_Value;; CODE 
      mov L_02,al
            cmp cl,ch
     je escape66
     jmp end1
     escape66:
     mov L_03,ah 
     jmp end1
     CHECK031:
   
;     ;; 03  
    
     CMP [SI],407H 
      JNZ CHECK041
       movml31:
     mov ax,Operand_Value;; CODE
      mov L_03,al 
            cmp cl,ch
    je escape51
     jmp end1
     escape51:
   
     mov L_04,ah
      jmp end1
     CHECK041:
    
;     ;; 04  
    
    CMP [SI],40aH 
     JNZ CHECK051
       movml41:
    mov ax,Operand_Value;; CODE
     mov L_04,al 
      cmp cl,ch
     je escape52
     jmp end1
     escape52:
     mov L_05,ah
 jmp end1    
    CHECK051:
    
;     ;; 05  
    
    CMP [SI],40dH 
     JNZ CHECK061
      movml51:
    mov ax,Operand_Value;; CODE 
     mov L_05,al
      cmp cl,ch
     je escape53
     jmp end1
     escape53:
     mov L_06,ah
 jmp end1    
    CHECK061:
    
;     ;; 06  
    
    CMP [SI],410H 
     JNZ CHECK071
      movml61:
    mov ax,Operand_Value;; CODE 
     mov L_06,al
      cmp cl,ch
     je escape54
     jmp end1
     escape54:
     mov L_07,ah
 jmp end1    
    CHECK071:
    
;     ;; 07  
    
    CMP [SI],413H 
     JNZ CHECK081
      movml71:
    mov ax,Operand_Value;; CODE 
     mov L_07,al
      cmp cl,ch
    je escape55
     jmp end1
     escape55:
     mov L_08,ah
 jmp end1   
    CHECK081:
    
;     ;; 08  
    
    CMP [SI],416H 
     JNZ CHECK091
      movml81:
    mov ax,Operand_Value;; CODE
     mov L_08,al
      cmp cl,ch
     je escape56
     jmp end1
     escape56:
     mov L_09,ah 
 jmp end1       
    CHECK091:
    
;     ;; 09  
    
    CMP [SI],419H 
     JNZ CHECKA1
      movml91:
    mov ax,Operand_Value;; CODE 
     mov L_09,al
      cmp cl,ch
    je escape57
     jmp end1
     escape57:
     mov L_A,ah
 jmp end1    
    CHECKA1:
    
;     ;; A  
    
    CMP [SI],3a1H 
     JNZ CHECKB1
      movmlA1:
    mov ax,Operand_Value;; CODE 
     mov L_A,al
      cmp cl,ch
    je escape58
     jmp end1
     escape58:
     mov L_B,ah
 jmp end1     
    CHECKB1:
    
;     ;; B  
    
    CMP [SI],3a4H 
    jz asdasd1
     Jmp CHECKC1
    asdasd1:
    movmlB1:
    mov ax,Operand_Value;; CODE 
     mov L_B,al
      cmp cl,ch
      je dede1
     jmp end1
     dede1:
     mov L_C,ah
 jmp end1     
    CHECKC1:
    
;     ;; C  
    
    CMP [SI],3a7H 
     JNZ CHECKD1
      movmlC1:
    mov ax,Operand_Value;; CODE
     mov L_C,al
      cmp cl,ch
    je escape59
     jmp end1
     escape59:
     mov L_D,ah 
 jmp end1     
    CHECKD1:
    
;     ;; D  
    
    CMP [SI],3aaH 
     JNZ CHECKE1
      movmlD1:
    mov ax,Operand_Value;; CODE
     mov L_D,al
      cmp cl,ch
    je escape60
     jmp end1
     escape60:
     mov L_E,ah 
 jmp end1    
    CHECKE1:
    
;     ;; E  
    
    CMP [SI],3adH 
     JNZ CHECKF1
      movmlE1:
    mov ax,Operand_Value;; CODE
     mov L_E,al
      cmp cl,ch
    je escape61
     jmp end1
     escape61:
     mov L_F,ah 
 jmp end1         
    CHECKF1:
    
;     ;; F  
    
    CMP [SI],3b0H 
    JNZ CHECKmlSI1 
    movmlF1:
    mov ax,Operand_Value;; CODE
    mov L_F,al
      cmp cl,ch
    je escape62
     jmp end1
     escape62:
     mov L_00,ah 
    jmp end1 
          
    CHECKmlSI1:
    
    
;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      
    
    
    ;[SI]
    CMP [SI],4b2H 
    jz con1101
    jmp CHECKmlDI1   
    con1101:
    ;;
     cmp L_SI,0H
     jnz cont11
     jmp movml001                  
    cont11:
     cmp L_SI,1H
     jnz cont21
     jmp movml11
     cont21:
     cmp L_SI,2H
     jnz cont31
     jmp movml21
     cont31:
     cmp L_SI,3H
     jnz cont41
     jmp movml31
     cont41:
     cmp L_SI,4H
     jnz cont51
     jmp movml41
     cont51:
     cmp L_SI,5H
     jnz cont61
     jmp movml51
     cont61:
     cmp L_SI,6H
     jnz cont71
     jmp movml61
     cont71:
     cmp L_SI,7H
     jnz cont81
     jmp movml71
     cont81:
     cmp L_SI,8H
     jnz cont91
     jmp movml81
     cont91:
     cmp L_SI,9H
     jnz cont101
     jmp movml91
     cont101:
     cmp L_SI,0AH
     jnz cont111
     jmp movmlA1
     cont111:
     cmp L_SI,0BH
     jnz cont121
     jmp movmlB1
     cont121:
     cmp L_SI,0CH
     jnz cont131
     jmp movmlC1
     cont131:
     cmp L_SI,0DH
     jnz cont141
     jmp movmlD1
     cont141:
     cmp L_SI,0EH
     jnz cont151
     jmp movmlE1
     cont151:
     cmp L_SI,0FH
     jnz cont161
     jmp movmlF1
     cont161:
    ; ;
    
;     ;RegisterIndirect_Addressing_Mode _SI 
    
    jmp end1              
    CHECKmlDI1:
    
    ; ;; [DI]
    CMP [SI],485H   
    jz erer1
     Jmp CHECKmlBX1 
        erer1:
     cmp L_DI,0H
     jnz cont171
     jmp movml001
     cont171:                  
     cmp L_DI,1H
     jnz cont181
     jmp movml11
     cont181:
     cmp L_DI,2H
     jnz cont191
     jmp movml21
     cont191:
     cmp L_DI,3H
     jnz cont201
     jmp movml31
     cont201:
     cmp L_DI,4H
     jnz cont211
     jmp movml41
     cont211:
     cmp L_DI,5H
     jnz cont221
     jmp movml51
     cont221:
     cmp L_DI,6H
     jnz cont231
     jmp movml61
     cont231:
     cmp L_DI,7H
     jnz cont241
     jmp movml71
     cont241:
     cmp L_DI,8H
     jnz cont251
     jmp movml81
     cont251:
     cmp L_DI,9H
     jnz cont261
     jmp movml91
     cont261:
     cmp L_DI,0AH
     jnz cont271
     jmp movmlA1
     cont271:
     cmp L_DI,0BH
     jnz cont281
     jmp movmlB1
     cont281:
     cmp L_DI,0CH
     jnz cont291
     jmp movmlC1
     cont291:
     cmp L_DI,0DH
     jnz cont301
     jmp movmlD1
     cont301:
     cmp L_DI,0EH
     jnz cont311
     jmp movmlE1
     cont311:
     cmp L_DI,0FH
     jnz cont321
     jmp movmlF1
     cont321:       ; ;
    
;     ;RegisterIndirect_Addressing_Mode _DI
                     
               
    CHECKmlBX1:    
    
    ;; [BX] 
     CMP [SI],4acH 
     jz conte11
    conte11:           ;
     cmp L_BX,0H
     jnz conte21
     jmp movml001
     conte21:                   
     cmp L_BX,1H
     jnz conte31
     jmp movml11
     conte31:
     cmp L_BX,2H
     jnz conte41
     jmp movml21
     conte41:
     cmp L_BX,3H
     jnz conte51
     jmp movml31
     conte51:
     cmp L_BX,4H
     jnz conte61
     jmp movml41
     conte61:
     cmp L_BX,5H
     jnz conte71
     jmp movml51
     conte71:
     cmp L_BX,6H
     jnz conte81
     jmp movml61
     conte81:
     cmp L_BX,7H
     jnz conte91
     jmp movml71
     conte91:
     cmp L_BX,8H
     jnz conte101
     jmp movml81
     conte101:
     cmp L_BX,9H
     jnz conte111
     jmp movml91
     conte111:
     cmp L_BX,0AH
     jnz conte121
     jmp movmlA1
     conte121:
     cmp L_BX,0BH
     jnz conte131
     jmp movmlB1
     conte131:
     cmp L_BX,0CH
     jnz conte141
     jmp movmlC1
    conte141:
     cmp L_BX,0DH
     jnz conte151
     jmp movmlD1
     conte151:
     cmp L_BX,0EH
     jnz conte161
     jmp movmlE1
     conte161:
    cmp L_BX,0FH
    jnz conte171
      jmp movmlF1
      conte171:
    
;     ;RegisterIndirect_Addressing_Mode _BX            
 
    
    end1:
            
    RET

 put_Operand endP



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
        
        ;;1 AHMED
        INC_CURSOR ActualFirstNameSize
        DisplayString separator_ 
        ;INC_CURSOR 3
        ;;need to move cursor that 
        ;MoveCursorTo 0921h
        DisplayString THE_COMMAND
        ;DisplayString_AT_position_and_move_cursor FirstNameData CL_row_RIGHT
        
        ;;1 AHMED
        ;INC_CURSOR ActualFirstNameSize
        ;DisplayString separator_ 
        ;INC_CURSOR 3
        ;;need to move cursor that 
        ;DisplayString THE_COMMAND


        ret
UPDATE_VALUES_Displayed ENDP






end main