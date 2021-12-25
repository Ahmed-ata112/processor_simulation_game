
.model small
.stack 64
.data


.code
main proc far
    mov ax, @data
    mov ds, ax

    ; Clear screen
    mov ah,0
    mov al,3h
    int 10h



    mov ah, 0                    ;Change video mode (Graphical MODE)
    mov al, 13h                  ;Max memory size 16KByte
    ;AL:4 (320 * 200=64000 [2 bits for each pixel, 4 colours])
    ;AL:6 (640 * 200=128000[1 bit for each pixel, 2 colours B / W])
    int 10h


    mov cx, 0                    ;Column
    mov dx, 50                   ;Row
    mov al, 0fh                  ;Pixel color
    mov ah, 0ch                  ;Draw Pixel Command
    back: int 10h
    inc cx
    cmp cx, 320
    jnz back


    hlt
main endp



end main
