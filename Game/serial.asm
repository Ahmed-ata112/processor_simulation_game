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







