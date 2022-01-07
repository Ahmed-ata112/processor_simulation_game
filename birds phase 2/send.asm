
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
endm Draw_IMG_with_color


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


RecWord MACRO REG2
    call receiveByteproc
    mov bl, byteReceived
    call sendByteproc
    call receiveByteproc
    mov bh, byteReceived
    LEA SI,REG2
    MOV [SI],BL ;FIRST BYTE
    INC SI
    MOV [SI],BH ;SECOND BYTE
    call sendByteproc

ENDM

SendWord macro REG
    mov SI, OFFSET REG
    MOV AL,[SI]
    mov byteToSend,al
    call sendByteproc
    ;;rec to relax
    call receiveByteproc
    ;;Receive it
    INC SI ;;THE OTHER BYTE
    MOV AL,[SI]
    mov byteToSend,aL
    call sendByteproc

    call receiveByteproc
endm SendWord

.model small
	.stack 64
	.data  
    time_aux db 0  ;variable used when checking if the time has changed
    paddleImg db 6,0,73,7,0,73,12,0,73,13,0,73,6,1,73,7,1,73,12,1,73,13,1,73,6,2,73,7,2,73,12,2,73,13,2,73,6,3,73,7,3,73,12,3,73,13,3,73,6,4,73,7,4,73,12,4,73,13,4,73,6,5,73,7,5,73,12,5,73,13,5,73,0,6,73,1,6,73,2,6,73,3,6,73,4,6,73,5,6,73
    db 6,6,73,7,6,73,8,6,73,9,6,73,10,6,73,11,6,73,12,6,73,13,6,73,14,6,73,15,6,73,16,6,73,17,6,73,18,6,73,19,6,73,0,7,73,1,7,73,2,7,73,3,7,73,4,7,73,5,7,73,6,7,73,7,7,73,8,7,73,9,7,73,10,7,73,11,7,73,12,7,73,13,7,73,14,7,73,15,7,73
    db 16,7,73,17,7,73,18,7,73,19,7,73,0,8,73,1,8,73,18,8,73,19,8,73,0,9,73,1,9,73,18,9,73,19,9,73,0,10,73,1,10,73,2,10,73,3,10,73,4,10,73,5,10,73,6,10,73,7,10,73,8,10,73,9,10,73,10,10,73,11,10,73,12,10,73,13,10,73,14,10,73,15,10,73
    db 16,10,73,17,10,73,18,10,73,19,10,73,0,11,73,1,11,73,2,11,73,3,11,73,4,11,73,5,11,73,6,11,73,7,11,73,8,11,73,9,11,73,10,11,73,11,11,73,12,11,73,13,11,73,14,11,73,15,11,73,16,11,73,17,11,73,18,11,73,19,11,73
    paddleSize dw 12 ;;That is the height

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


    gameStatus db 1
    prevTime db 0 ;variable used when checking if the time has changed
    timeInterval db 8 ;the shooting game apears/disappears every time interval
    byteToSend db ?
    byteReceived db ?
    .code 
main proc far
    mov ax,@data
    mov ds,ax 
    call init_comm
    clearScreen
    
draw:
    Draw_IMG_with_color paddle_x,paddle_y,paddleImg,paddleColor,paddleSize
    Draw_IMG_with_color right_paddle_x,right_paddle_y,paddleImg,right_paddleColor,paddleSize
    movePaddle paddle_x,paddle_velocity_x,paddle_y,paddle_velocity_y,paddleUp,paddleDown,paddleRight,paddleLeft,135,0
    movePaddle right_paddle_x,right_paddle_velocity_x,right_paddle_y,right_paddle_velocity_y,right_paddleUp,right_paddleDown,right_paddleRight,right_paddleLeft,295,165
    checkTime
 
    clearScreen 
    mov byteToSend,'R'
    call SendUpdatedCoordinates

    jmp draw
endp

init_comm PROC
    ;Set Divisor Latch Access Bit
    mov dx,3fbh ; Line Control Register
    mov al,10000000b ;Set Divisor Latch Access Bit
    out dx,al ;Out it

    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h
    mov al,0ch
    out dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al
    ; 
    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b        ;0:Access to Receiver buffer, Transmitter buffer
                            ;0:Set Break disabled
                            ;011:Even Parity
                            ;0:One Stop Bit
                            ;11:8bits
    out dx,al
    ret

init_comm ENDP

SendUpdatedCoordinates proc 

    call receiveByteproc
    SendWord paddle_x
    SendWord paddle_y
    ; SendWord fireBall_x
    ; SendWord fireBall_y
    ; SendWord ifFireIsPressed
    ; SendWord colorIndex
    ; SendWord gameStatus
    ; SendWord playerPoints
    ; SendWord right_playerPoints
    
    ret
SendUpdatedCoordinates endp
    
ReceiveUpdatedCoordinates proc 
    cmp al,'R'
    je cntinueRecandSwap 
    ret
    cntinueRecandSwap:
    call sendByteproc
    RecWord right_paddle_x
    RecWord right_paddle_y
    ; RecWord right_fireBall_x
    ; RecWord right_fireBall_y
    ; RecWord right_ifFireIsPressed
    ; RecWord colorIndex
    ; RecWord gameStatus
    ; RecWord right_playerPoints
    ; RecWord playerPoints
    
    ret
ReceiveUpdatedCoordinates endp

ReceiveByteproc Proc ; return byte in (byteReceived). 
    NoThingReceived:
	MOV DX,3FDh     ;;LineStatus
	IN AL,DX
	TEST AL,1
	JZ NoThingReceived
	MOV DX,3F8h
	IN AL,DX
	MOV byteReceived,AL
	RET
ReceiveByteproc endp

sendByteproc proc                   
        mov dx , 3FDH                           ;Line Status Register
        whileHolding: 
        In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
        test al , 00100000b                 ;If zero then it's not empty, otherwise:
        JZ whileHolding      
        mov dx , 3F8H                           ;Transmit data register
        mov al, byteToSend
        out dx , al
        ret
sendByteproc endp 


    end main