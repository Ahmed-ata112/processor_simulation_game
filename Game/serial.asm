sendByte proc                   
        mov dx , 3FDH                           ;Line Status Register
        whileHolding: 
            In al , dx                          ;Read Line Status , to guarantee that the holder register is empty
            test al , 00100000b                 ;If zero then it's not empty, otherwise:
            JZ whileHolding      
        mov dx , 3F8H                           ;Transmit data register
        mov al, byteToSend
        out dx , al
        ret
sendByte endp 

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

ReceiveByte Proc ; return byte in (byteReceived). 
    NoThingReceived:
	MOV DX,3FDh     ;;LineStatus
	IN AL,DX
	TEST AL,1
	JZ NoThingReceived
	MOV DX,3F8h
	IN AL,DX
	MOV byteReceived,AL
	RET
ReceiveByte endp 







