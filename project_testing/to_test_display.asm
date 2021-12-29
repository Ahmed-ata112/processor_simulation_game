 ChangeVideoMode macro M ;-> 03h text ----  13h video  
        mov ah, 00h
        mov al, M
        int 10h
 endm ChangeVideoMode
 
 
.model small
.stack 64
.data
   reg dw 0aeFh 
   pos dw 0101h 
   ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'
.code
main proc far
  mov ax, @data
  mov ds, ax
      
      
  ;;VIDEO MODE    
      
      
      
      
      
      
      
      
      
  ;; 124 -> display its hexa    
  ;/16 then mod -> XLAT
  ; loop 4 times or 2 times   
  
      ;
;   
;   mov bh,0
;    mov dx,pos
;    mov ah,2
;    int 10h    ; set cursor position where you are gonna print  
;
;  
;  mov DI,offset ASC_TBL
;  mov cx, 4
;  mov ax,0a00fh
;  deconstruct_it:
;  
;   mov dx,0
;   mov bx,16
;   div bx
;   ;;dx -> rest ax, res
;   mov bx,dx
;   mov bx, [Di][bx] ;; convert to to the ssuitabble ascii code
;   push bx ;; to pop and print it at the end
;  
;   loop deconstruct_it
;  
;   mov cx,4
;   mov bh,0 ;;page
;   Print_chars:
;    pop ax ;al contains the char to print   
;    mov ah, 0eh           ;0eh = 14 
;
;    ;xor bh, bh            ;Page number zero
;    mov bl, 0ch           ;Color is red
;    int 10h ; print char -> auto advances cursor
;   loop  Print_chars
;   
;  
;  

  MOV AH,4CH
  INT 21H ;GO BACK TO DOS ;to end the program
main endp



end main
