
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Check_valid PROC
    CALL split_command

    ; cmp command_splited,'N' ;if empty, assume Command_valid is 0 initally
    ; jne validationnn
    ; RET
    ; validationnn:

    ; cmp command_splited,'C' ;if empty, assume Command_valid is 0 initally
    ; jne validationnn2
    ; RET
    ; validationnn2:

    
    split_operands Two_Operands_Together_splited Operand1 Operand2


    cmp Operand1,'[' ; memory locaion operand (type 1)
    je  Valid_Memory_Location1
    cmp Operand1, 'A'
    jnl h09
    jmp check_op2
    h09:
    cmp Operand1,'Z'
    jng q5
    jmp End_End       ; it is not a valid reg name, else it is a register
    q5:
    jmp Reg_Operand1
    ; if operand is memory location
    Valid_Memory_Location1:
    check_if_in_array valid_addressing_mode_regs 19 4 Operand1 Command_valid
    cmp Command_valid,0
    jne q55
    jmp End_End
    q55:
    jmp check_op2

    Reg_Operand1:
    check_if_in_array validRegNamesArr 21 2 Operand1 Command_valid ;check if operand1 is not one of the array element, it's INVALID
    cmp Command_valid,0
    jne q7
    jmp End_End   ;jmp to end
    q7:

    check_op2:  
    cmp Operand2,'[' ; memory locaion operand (type 1)
    je  Valid_Memory_Location2
    cmp Operand2, 'A'
    jl  Rest
    cmp Operand2,'Z'
    jng Reg_Operand2
    jmp End_End       ; it is not a valid reg name, else it is a register
    q77:
    Valid_Memory_Location2:
    check_if_in_array valid_addressing_mode_regs 19 4 Operand2 Command_valid
    cmp Command_valid,0
    ; jne q78
    JNE Rest
    jmp End_End
    ; q78:
    Reg_Operand2:
    check_if_in_array validRegNamesArr 21 2 Operand2 Command_valid ;check if operand1 is not one of the array element, it's INVALID
    CMP Command_valid,0
    JNE End_End6789
    jmp End_End
    End_End6789:

    Rest:
    SizeMismatchValidation Operand1 Operand2 Command_valid
    cmp Command_valid,0
    jne q123
    jmp End_End 
    q123:
    Check_memorytomemory  Operand1 Operand2 Command_valid
    cmp Command_valid,0
    je End_End 

    End_End:

    MOV AL,'$'
    MOV DI, offset command_splited
    MOV CX,5
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Operand1
    MOV CX,10
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Operand2
    MOV CX,10
    REP STOSB

    MOV AL,'$'
    MOV DI, offset Two_Operands_Together_splited
    MOV CX,22
    REP STOSB

    MOV AX,0H

    MOV Operand2_Value,AX
    MOV Operand1_Value,AX
    MOV sizeIndex ,AL
    MOV HASH_Operand,AX
    MOV Operand_Value,AX

    MOV AL,'$'
    MOV DI, offset Operand
    MOV CX,10
    REP STOSB


    MOV AX,0H
    MOV HASH_comand,AX
    MOV HASH_Operand2,AX
    MOV HASH_Operand1,AX


    ret
Check_valid endp

    checkOperandsRegistersNames macro FirstOperandData,SecondOperandData,result     
        local finish                          
        check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualfirstOperandSize, FirstOperandData,result
        cmp result,0
        je finish
        check_if_in_array  validRegNamesArr,validRegNamesArrSize,ActualSecondOperandSize, SecondOperandData,result
        finish:                          
    endm checkOperandsRegistersNames    
