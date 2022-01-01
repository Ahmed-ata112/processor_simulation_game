ReadString MACRO PromptMessage
    mov ah, 0AH                  ;Read from keyboard
	mov dx, offset PromptMessage
	int 21h
ENDM ReadString
include valid_in.inc
.model small
.stack 64
.data 
Command_valid db 1                                    
validRegNamesArr db  'AX','BX','CX','DX'
                 db  'AH','AL','BH','BL','CH','CL','DH','DL'
                 db  'CS','IP','SS','SP'
                 db  'BP','SI','DI','DS','ES'

validRegNamesArrSize db  21d 

valid_addressing_mode_regs db '[BX]','[SI]','[DI]'



command LABEL BYTE ; named the next it the same name 
	commandSize db 30
    actualcommand_Size db 0 ;the actual size of input at the current time
    THE_COMMAND db 30 dup('$')


.code
	main proc far
	mov ax, @data
	mov ds, ax
	mov ES,AX ;; for string operations

    ReadString command

    hlt
    MAIN ENDP

    END MAIN