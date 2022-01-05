.MODEL large
.STACK 64
.DATA

VALUE db 'A'
messege_sent db 
x1 db 0
y1 db 0

x2 db 0
y2 db 12


.code

set MACRO 
mov bh,0h
mov ah,2
;mov dx,0A0Ah
int 10h
    
ENDM

get  MACRO 
   mov ah,3h
mov bh,0h
int 10h 
ENDM


intialize proc


mov dx,3fbh 			
mov al,10000000b		
out dx,al				

mov dx,3f8h			
mov al,0ch			
out dx,al

mov dx,3f9h
mov al,00h
out dx,al

mov dx,3fbh
mov al,00011011b

out dx,al


ret

intialize ENDp

send proc

		mov dx , 3FDH		
AGAIN:  	In al , dx 			
  		test al , 00100000b
  		JZ AGAIN                               


  		mov dx , 3F8H		
  		mov  al,VALUE
  		out dx , al

ret
send endp


receiver proc near
    
    mov dx , 3FDH
    CHK: in al , dx
    test al , 1
    JZ loo 

    mov dx , 03F8H
    in al , dx
    mov VALUE , al
    ret
    receiver endp

main proc far
MOV AX,@DATA
	MOV DS,AX
	mov es,ax

call intialize


mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h

; mov ah,00h
; int 10h
mov dh,y1
mov dl,x1
set

 mov ah,6       
 mov al,1            
 mov bh,7                
 mov ch,0       
 mov cl,0        
 mov dh,12     
 mov dl,79      
 int 10h

loo:

mov ah,1
int 16h
jz receive
mov ah,0
int 16h
mov VALUE,al
mov dh,y1
mov dl,x1
set
call send



mov dl,VALUE
mov ah,2
int 21h

get
mov x1,dl
mov y1,dh


cmp y1,12
    jz scroll_up_send
    jmp receive
   scroll_up_send:       
    mov ah,6 ; function 6
    mov al,1 ; scroll by 1 line
    mov bh,7 ; normal video attribute
    mov ch,00 ; upper left Y
    mov cl,00 ; upper left X
    mov dh,12 ; lower right Y
    mov dl,79 ; lower right X
    int 10h
    mov dh,11
    mov dl,0
    set
    jmp here

receive:



mov dh,y2
mov dl,x2
set
here:
call receiver

mov dl,VALUE
mov ah,2
int 21h


get
mov x2,dl
mov y2,dh

cmp y2,24
    jz scroll_up_receive
    jmp loo
   scroll_up_receive:       
    mov ah,6 ; function 6
    mov al,1 ; scroll by 1 line
    mov bh,7 ; normal video attribute
    mov ch,12 ; upper left Y
    mov cl,0 ; upper left X
    mov dh,24 ; lower right Y
    mov dl,79 ; lower right X
    int 10h
    mov dh,23
    mov dl,0

    set


jmp loo


           






main endp

end main



