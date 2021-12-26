

;;fire ball status 
;;xor -> colors 
.286
.model small
.stack 64
.data



.code

main proc far

    mov ax,@data
    mov ds,ax
    
    ;clearScreen
    call BIRDGAME
    
    finish:
    clearScreen

    
     
    hlt
endp 

;; Draws the Bird 
BIRDGAME PROC
    
    
    ;drawPaddle
    Draw_IMG_with_color paddle_x,paddle_y,paddleImg,paddleColor,paddleSize
    Draw_IMG_with_color right_paddle_x,right_paddle_y,right_paddleImg,right_paddleColor,right_paddleSize

    movePaddle

    checkTime

    randomBirdColor birdStatus,birdColor,colorIndex
    setBirdPointsWithTheCorrespondingColor colorIndex,birdPoints,pointsOfColors

    randomBirdColor right_birdStatus,right_birdColor,right_colorIndex
    setBirdPointsWithTheCorrespondingColor right_colorIndex,right_birdPoints,pointsOfColors

    ;clearScreen 

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
    
    
    RET
BIRDGAME ENDP
end main