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

 sendByte macro happyByte                    ;The byte to be sent.
        local whileHolding
        mov dx , 3FDH                           ;Line Status Register
        whileHolding: 
            In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
            test al , 00100000b                 ;If zero then it's not empty, otherwise:
            JZ whileHolding      
        mov dx , 3F8H                           ;Transmit data register
        mov al, happybyte
        out dx , al
    endm sendByte


receiveByte macro freshByte         ;The byte to be received would be in freshByte, the Restart tells it where to go in case data isn't ready to be received.       
        local whileNotDataReady, Reset
        mov dx , 3FDH                           ;Line Status Register
        whileNotDataReady:
            in al, dx
            test al, 1                          ;In fact is 00000001b
            JZ  Reset                         ;Not ready, otherwise: 
            mov dx, 3F8H
            in al, dx
            mov freshByte, al
            Reset:
            Mov al, 0ffh                        ;In case not ready put 0ffh in al (flag)
    endm receiveByte
    
receiveByteG macro freshByte         ;The byte to be received would be in freshByte, the Restart tells it where to go in case data isn't ready to be received.       
        local whileDataNotReady
        mov dx , 3FDH                           ;Line Status Register
        whileDataNotReady:
            in al, dx
            test al, 1                          ;In fact is 00000001b
            JZ  whileDataNotReady                ;Not ready, otherwise: 
            mov dx, 3F8H
            in al, dx
            mov freshByte, al
    endm receiveByteG


checkIftoSend MACRO 
    mov dx , 3FDH                           ;Line Status Register
    In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
    test al , 00100000b                 ;If zero then it's not available
ENDM checkIftoSend


checkIfToRec MACRO 
    MOV DX,3FDh     ;;LineStatus
	IN AL,DX
	TEST AL,1   ;jz after it to know if something is pending to be received
ENDM checkIfToRec

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







