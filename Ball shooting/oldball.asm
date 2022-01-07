
clearScreen macro

   ; set video mode
    mov ah,0
    mov al,13h
    int 10h
    
endm clearScreen

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
    exit:

endm checkTimeInterval

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

.model small
	.stack 64
	.data  
    time_aux db 0  ;variable used when checking if the time has changed
    BirdImg db 1,0,73,2,0,73,10,0,73,11,0,73,2,1,73,10,1,73,1,2,73,2,2,73,3,2,73,4,2,73,8,2,73,9,2,73,10,2,73,11,2,73,1,3,73,2,3,73,3,3,73,4,3,73,5,3,73,7,3,73,8,3,73,9,3,73,10,3,73,11,3,73,0,4,73,1,4,73,2,4,73,3,4,73,5,4,73,6,4,73
        db 7,4,73,9,4,73,10,4,73,11,4,73,12,4,73,0,5,73,2,5,73,3,5,73,4,5,73,5,5,73,6,5,73,7,5,73,8,5,73,9,5,73,10,5,73,12,5,73,0,6,73,3,6,73,4,6,73,5,6,73,6,6,73,7,6,73,8,6,73,9,6,73,12,6,73,4,7,73,8,7,73,3,8,73,4,8,73,8,8,73
        db 9,8,73,3,9,73,9,9,73
    BirdSize dw 10  

    right_BirdImg db 1,0,73,2,0,73,10,0,73,11,0,73,2,1,73,10,1,73,1,2,73,2,2,73,3,2,73,4,2,73,8,2,73,9,2,73,10,2,73,11,2,73,1,3,73,2,3,73,3,3,73,4,3,73,5,3,73,7,3,73,8,3,73,9,3,73,10,3,73,11,3,73,0,4,73,1,4,73,2,4,73,3,4,73,5,4,73,6,4,73
        db 7,4,73,9,4,73,10,4,73,11,4,73,12,4,73,0,5,73,2,5,73,3,5,73,4,5,73,5,5,73,6,5,73,7,5,73,8,5,73,9,5,73,10,5,73,12,5,73,0,6,73,3,6,73,4,6,73,5,6,73,6,6,73,7,6,73,8,6,73,9,6,73,12,6,73,4,7,73,8,7,73,3,8,73,4,8,73,8,8,73
        db 9,8,73,3,9,73,9,9,73
    right_BirdSize dw 10 
    paddleImg db 6,0,73,7,0,73,12,0,73,13,0,73,6,1,73,7,1,73,12,1,73,13,1,73,6,2,73,7,2,73,12,2,73,13,2,73,6,3,73,7,3,73,12,3,73,13,3,73,6,4,73,7,4,73,12,4,73,13,4,73,6,5,73,7,5,73,12,5,73,13,5,73,0,6,73,1,6,73,2,6,73,3,6,73,4,6,73,5,6,73
    db 6,6,73,7,6,73,8,6,73,9,6,73,10,6,73,11,6,73,12,6,73,13,6,73,14,6,73,15,6,73,16,6,73,17,6,73,18,6,73,19,6,73,0,7,73,1,7,73,2,7,73,3,7,73,4,7,73,5,7,73,6,7,73,7,7,73,8,7,73,9,7,73,10,7,73,11,7,73,12,7,73,13,7,73,14,7,73,15,7,73
    db 16,7,73,17,7,73,18,7,73,19,7,73,0,8,73,1,8,73,18,8,73,19,8,73,0,9,73,1,9,73,18,9,73,19,9,73,0,10,73,1,10,73,2,10,73,3,10,73,4,10,73,5,10,73,6,10,73,7,10,73,8,10,73,9,10,73,10,10,73,11,10,73,12,10,73,13,10,73,14,10,73,15,10,73
    db 16,10,73,17,10,73,18,10,73,19,10,73,0,11,73,1,11,73,2,11,73,3,11,73,4,11,73,5,11,73,6,11,73,7,11,73,8,11,73,9,11,73,10,11,73,11,11,73,12,11,73,13,11,73,14,11,73,15,11,73,16,11,73,17,11,73,18,11,73,19,11,73
    paddleSize dw 12 ;;That is the height


    right_paddleImg db 6,0,73,7,0,73,12,0,73,13,0,73,6,1,73,7,1,73,12,1,73,13,1,73,6,2,73,7,2,73,12,2,73,13,2,73,6,3,73,7,3,73,12,3,73,13,3,73,6,4,73,7,4,73,12,4,73,13,4,73,6,5,73,7,5,73,12,5,73,13,5,73,0,6,73,1,6,73,2,6,73,3,6,73,4,6,73,5,6,73
    db 6,6,73,7,6,73,8,6,73,9,6,73,10,6,73,11,6,73,12,6,73,13,6,73,14,6,73,15,6,73,16,6,73,17,6,73,18,6,73,19,6,73,0,7,73,1,7,73,2,7,73,3,7,73,4,7,73,5,7,73,6,7,73,7,7,73,8,7,73,9,7,73,10,7,73,11,7,73,12,7,73,13,7,73,14,7,73,15,7,73
    db 16,7,73,17,7,73,18,7,73,19,7,73,0,8,73,1,8,73,18,8,73,19,8,73,0,9,73,1,9,73,18,9,73,19,9,73,0,10,73,1,10,73,2,10,73,3,10,73,4,10,73,5,10,73,6,10,73,7,10,73,8,10,73,9,10,73,10,10,73,11,10,73,12,10,73,13,10,73,14,10,73,15,10,73,16,10,73,17,10,73
    db 18,10,73,19,10,73,0,11,73,1,11,73,2,11,73,3,11,73,4,11,73,5,11,73,6,11,73,7,11,73,8,11,73,9,11,73,10,11,73,11,11,73,12,11,73,13,11,73,14,11,73,15,11,73,16,11,73,17,11,73,18,11,73,19,11,73
    right_paddleSize dw 12 ;;That is the height


    BallImg db 3,0,73,4,0,73,5,0,73,1,1,73,2,1,73,6,1,73,7,1,73,1,2,73,2,2,73,6,2,73,7,2,73,0,3,73,3,3,73,5,3,73,8,3,73,0,4,73,4,4,73,8,4,73,0,5,73,3,5,73,5,5,73,8,5,73,1,6,73,2,6,73,6,6,73,7,6,73,1,7,73,2,7,73,6,7,73,7,7,73
        db 3,8,73,4,8,73,5,8,73
    BallSize dw 9 
    
    balls label byte
		ball_0 db 0 ;;green
		ball_1 db 0 ;;magenta
		ball_2 db 0 ;;red
		ball_3 db 0 ;;blue
		ball_4 db 0 ;;yellow
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


.code 
main proc far
    mov ax,@data
    mov ds,ax 

    clearScreen
    
draw:
    Draw_IMG_with_color paddle_x,paddle_y,paddleImg,paddleColor,paddleSize
    Draw_IMG_with_color right_paddle_x,right_paddle_y,right_paddleImg,right_paddleColor,right_paddleSize

    movePaddle paddle_x,paddle_velocity_x,paddle_y,paddle_velocity_y,paddleUp,paddleDown,paddleRight,paddleLeft,135,0
    movePaddle right_paddle_x,right_paddle_velocity_x,right_paddle_y,right_paddle_velocity_y,right_paddleUp,right_paddleDown,right_paddleRight,right_paddleLeft,295,165

    checkTime
    randomBirdColor birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,birdPoints,pointsOfColors

    ;randomBirdColor right_birdStatus,right_birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,right_birdPoints,pointsOfColors

    clearScreen 

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
    jmp draw
    endp
    end main
    
