
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



clearScreen macro

   ; set video mode
    mov ah,0
    mov al,13h
    int 10h
   
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
right_paddle_x dw 147
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


playerPoints db 0
right_playerPoints db 0


.code

main proc far

    mov ax,@data
    mov ds,ax
    
    clearScreen

    draw:
    
    ;drawPaddle
    Draw_IMG_with_color paddle_x,paddle_y,paddleImg,paddleColor,paddleSize
    Draw_IMG_with_color right_paddle_x,right_paddle_y,right_paddleImg,right_paddleColor,right_paddleSize

    movePaddle

    checkTime

    randomBirdColor birdStatus,birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,birdPoints,pointsOfColors

    randomBirdColor right_birdStatus,right_birdColor,right_colorIndex
    setBirdPointsWithTheCorrespondingColor right_colorIndex,right_birdPoints,pointsOfColors

    clearScreen 

    ;left bird
    Draw_IMG_with_color birdX,birdY,BirdImg,birdcolor,BirdSize
    moveBird 148,0,birdVelocity,birdX


    ;right bird
    Draw_IMG_with_color right_birdX,right_birdY,right_BirdImg,right_birdcolor,right_BirdSize
    moveBird 304,160,right_birdVelocity,right_birdX


    checkForFire ifFireIsPressed
 
    cmp ifFireIsPressed,0
    je checkRight

    moveFireBall fireBall_velocity_y,fireBall_y,ifFireIsPressed
    Draw_IMG_with_color fireBall_x,fireBall_y,BallImg,fireballColor,BallSize
    compareBirdWithBall birdX,fireBall_x,fireBall_y,BirdSize,0,birdStatus,playerPoints,birdPoints

    checkRight: cmp right_ifFireIsPressed,0
    je midDraw

    moveFireBall right_fireBall_velocity_y,right_fireBall_y,right_ifFireIsPressed
    Draw_IMG_with_color right_fireBall_x,right_fireBall_y,BallImg,fireballColor,BallSize
    compareBirdWithBall right_birdX,right_fireBall_x,right_fireBall_y,right_BirdSize,160,right_birdStatus,playerPoints,birdPoints

midDraw: ;for jumping out of boundaries error
    ; cmp playerpoints,10
    ; jae finish
    ; cmp right_playerPoints,20
    ; jae finish
    jmp draw
    finish:
    clearScreen

    
     
    hlt
endp 
end main