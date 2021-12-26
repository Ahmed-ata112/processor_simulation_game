
DRAW_Bird macro  ball_x,ball_y,ball_size,color                 
		local DRAW_BALL_HORIZONTAL
		MOV CX,BALL_X                    ;set the initial column (X)
		MOV DX,BALL_Y                    ;set the initial line (Y)
		
		DRAW_BALL_HORIZONTAL:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,color				 ;choose green as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,BALL_X
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,BALL_X 				 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,BALL_Y
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
		
		
endm	DRAW_Bird 




DRAW_FIRE_BALL macro  xCo,yCo,size         
local DRAW_BALL_HORIZONTAL
		MOV CX,xCo                    ;set the initial column (X)
		MOV DX,yCo                    ;set the initial line (Y)
		
		DRAW_BALL_HORIZONTAL:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,6h 					 ;choose red as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,xCo
			CMP AX,size
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,xCo 				 ;the CX register goes back to the initial column
			inc DX       				;decreses cx ;we advance one line
			
			MOV AX,DX             		 ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,yCo
			CMP AX,size
			JNG DRAW_BALL_HORIZONTAL
		
		
endm	DRAW_FIRE_BALL 



clearScreen macro

   ; set video mode
    mov ah,0
    mov al,13h
    int 10h
    ;choose background color
    ; mov ah,0bh
    ; mov bh,1Eh
    ; mov bl,0fh
    ; int 10h    

    ; mov ax, 0600h                ;Scroll Screen AH=06 (Scroll), AL=0 Entire Page
	; mov bh, 0Eh              ;Normal attributes
	; mov cx, 0                    ;from 0, 0
	; mov dx, 1828H                ;To 18h, 28h ;;end of screen
	; int 10h                      ;Clear Screen
endm clearScreen



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
    cmp yCoordinate,10
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



checkXBoundaries macro
        MOV AX,WINDOW_WIDTH
        sub ax,8 ;subtract ball width
		cmp ball_x,ax ;check if the x coordinate of the ball is stil within the range
        jae finish ;jump to finish lable in main if it's done passing the whole width
endm checkXBoundaries      



drawPaddle macro
local drawP
    mov cx,paddle_x ;set initial column (x)
    mov dx,paddle_y ;set initial row (y)
drawP:
            MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,5h 					 ;choose purple as color
			MOV BH,00h 					 ;set the page number 
			INT 10h   
            INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - paddle_left > paddle_width  (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,paddle_x
			CMP AX,paddle_width
			JNG drawP

            MOV CX,paddle_x 			 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - paddle_y > paddle_height (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,paddle_y
			CMP AX,paddle_height
			JNG drawP



    mov cx,right_paddle_x ;set initial column (x)
    mov dx,right_paddle_y ;set initial row (y)
drawP2:
            MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,9h 					 ;choose purple as color
			MOV BH,00h 					 ;set the page number 
			INT 10h   
            INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - paddle_left > paddle_width  (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,right_paddle_x
			CMP AX,right_paddle_width
			JNG drawP2

            MOV CX,right_paddle_x 			 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - paddle_y > paddle_height (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,right_paddle_y
			CMP AX,right_paddle_height
			JNG drawP2

endm drawPaddle


movePaddle macro 
    local exitMacro,checkLeft,semiExitMacro,vvvv,checkRightPaddleRightControl,checkRightPaddleLeftControl
    ;check if any key is being pressed (if not, exit this macro) [int ah 01/16]
    ;zf =0 -> a key is pressed  
    mov ah,1
    int 16h
    jz exitMacro ;exists the macro since no key is pressed
    ;if a key is being pressed -> check which one it is
    ; cmp ah,77
    ; je vvvv


    ; cmp ah,75 ;1B -> scan code of left arrow
    ; je vvvv 
     
    ; cmp al,'a'
    ; je vvvv 
 

    ; cmp al,'d'
    ; jne exitMacro 
    
    ;if
    vvvv:
    mov ah,0 
    int 16h
    ; ah -> scan code  al -> ascii

    ;right arrow-> move right   left arrow-> move left
    cmp ah,77 ;77 -> scan code of right arrow
    jne checkLeft ;checks if it's the left arrow
    mov ax,paddle_velocity
    mov bx,paddle_x
    add bx,ax
    cmp bx,128
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
    cmp bx,288
    ja exitmacro
    add right_paddle_x,ax ;increases the paddle x-coordinate with the corresponding velocity --> moves it to the right
    jmp exitMacro

 checkRightPaddleLeftControl: ;-> a is pressed
    cmp al,'a' ;77 -> scan code of right arrow
    jne exitMacro ;checks if it's the left arrow
    mov ax,right_paddle_velocity
    mov bx,right_paddle_x
    sub bx,ax
    cmp bx,165
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
    mov bx,fireBall_size
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
    mov bx,right_fireBall_size
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
    sub ax,5
    cmp ax,fireBall_x

    ja notInTheRangeOfTheBird
    ;not in the same row --> behind it
    add ax,BALL_SIZE
    add ax,5
    cmp ax,fireBall_x
    ;checks if the fire ball is in the same row as the flying ball, with some error -> ball size
    jb notInTheRangeOfTheBird
    mov ah,birdPoints
    add playerPoints,ah
    mov ball_x,startOfBird
    mov birdStatus,0
    notInTheRangeOfTheBird:

endm compareBirdWithBall

randomBirdColor macro birdStatus,birdColor,colorIndex
local exitMacro
    cmp birdStatus,0
    jne exitMacro
    ;dx has the seconds and 1/100 seconds from the previous "check time" macro
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



;;fire ball status 
;;xor -> colors 
.286
.model small
.stack 64
.data

time_aux db 0  ;variable used when checking if the time has changed
ball_x dw 0 ;x position (column) of the ball
ball_y dw 0Ah  ;y position (row) of the ball
ball_size dw 0Ah ;size of the ball
ball_velocity_x dw 2h ;x velocity of the ball (horizontal axis) 
WINDOW_WIDTH DW 140h  

right_ball_x dw 160  ;x position (column) of the ball
right_ball_y dw 0Ah  ;y position (row) of the ball
right_ball_size dw 0Ah ;size of the ball
right_ball_velocity_x dw 2h ;x velocity of the ball (horizontal axis) 
;WINDOW_WIDTH DW 140h  

paddle_x dw 5
paddle_y dw 192 ;at the bottom of the 320*200 pixels screen
paddle_width dw 20h
paddle_height dw 08h
paddle_velocity dw 10

right_paddle_x dw 165
right_paddle_y dw 192 ;at the bottom of the 320*200 pixels screen
right_paddle_width dw 20h
right_paddle_height dw 08h
right_paddle_velocity dw 10



fireBall_x dw ?
fireBall_y dw 190
fireBall_velocity_y dw 20
fireBall_size dw 5
ifFireIsPressed db 0



right_fireBall_x dw ?
right_fireBall_y dw 190
right_fireBall_velocity_y dw 20
right_fireBall_size dw 5
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


playerPoints db 0
right_playerPoints db 0


.code

main proc far

    mov ax,@data
    mov ds,ax
    
    clearScreen

    draw:

    drawPaddle
    movePaddle

    checkTime

    randomBirdColor birdStatus,birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,birdPoints,pointsOfColors

    randomBirdColor right_birdStatus,right_birdColor,right_colorIndex
    setBirdPointsWithTheCorrespondingColor right_colorIndex,right_birdPoints,pointsOfColors

    clearScreen 
    ;left bird
    moveBird 150,10,ball_velocity_x,ball_x;; the 140'th column is the limit 
    DRAW_Bird ball_x,ball_y,BALL_SIZE,birdColor;;draws left bird

    ;right bird
    moveBird 310,160,right_ball_velocity_x,right_ball_x
    DRAW_Bird right_ball_x,right_ball_y,right_ball_size,right_birdColor

    checkForFire ifFireIsPressed
 
    cmp ifFireIsPressed,0
    je checkRight

    moveFireBall fireBall_velocity_y,fireBall_y,ifFireIsPressed
    DRAW_FIRE_BALL fireBall_x,fireBall_y,fireBall_size
    compareBirdWithBall ball_x,fireBall_x,fireBall_y,BALL_SIZE,0,birdStatus,playerPoints,birdPoints

    checkRight: cmp right_ifFireIsPressed,0
    je midDraw

    moveFireBall right_fireBall_velocity_y,right_fireBall_y,right_ifFireIsPressed
    DRAW_FIRE_BALL right_fireBall_x,right_fireBall_y,right_fireBall_size
    compareBirdWithBall right_ball_x,right_fireBall_x,right_fireBall_y,BALL_SIZE,140,right_birdStatus,right_playerPoints,right_birdPoints

midDraw: ;for jumping out of boundaries error
    ; cmp playerpoints,10
    ; jae finish
    ; cmp right_Points,20
    ; jae finish
    jmp draw
    finish:
    ;clearScreen

    
     
    hlt
endp 
end main