  ReadString MACRO PromptMessage
    mov ah, 0AH                  ;Read from keyboard
	mov dx, offset PromptMessage
	int 21h
  ENDM ReadString    



check_if_in_array macro arr, arr_len, element_size , op ,result
 local L1 ,finish,found,skip
 lea si,arr
 mov bh,arr_len  ;; number of elements in array
 
 L1:  
  mov cx,0 
  mov cl,element_size
  lea di,op ; store the string we search for
  repe CMPSB    
 
  cmp cx,0 ;; CX =0 if the 2 current words equall 
  jne skip ;try the next pair 
  ;;
  dec si
  dec di
  mov al,[si]
  cmp al,[di]
  je found 
  inc si
  skip:
  add si,cx ;to skip current word if it doesn't match
  
  dec bh
  jnz L1 
  
  
  ;; finsished loop and not found
  mov result,0
  jmp finish
  ;;valid one -> element in array
  found:    
  mov result,1
  finish:   

check_if_in_array endm 


checkOperandsRegistersNames macro FirstOperandData,SecondOperandData,result     
      local finish                          
      check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualfirstOperandSize, FirstOperandData,result
      cmp result,0
      je finish
      check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualSecondOperandSize, SecondOperandData,result
      finish:                          
      checkOperandsRegistersNames    endm