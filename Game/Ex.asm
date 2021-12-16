;; H-> command , first
;; M -> second; 

check_command MACRO command Result;; command is a string that contain the command-- Result -> 1 means sucess -- -> 0 failed

;; determine the command

cmp
jnz
;; checing validation

;; split two operands
;;des 1 -- des 2
;; call macro-> move

cmp
;;call macro-> add



ENDM check_command

move MACRO des1 des2 _Ax _BX _CX 

;; Es
;; second  reg, memory -> 
;
;
; move ES
;; first 
;
;
;mov variable es
;.................
;; reg cehck
;;ax                                ;;mov [_al],
    ; l h

;;memory
;;[]

;;reg
;; location num

;exec

ENDM move
;............
.MODEL SMALL
.STACK 64
.DATA


.code
MAIN PROC far
    MOV AX,@DATA
	MOV DS,AX
	mov es,ax  
          
	     
MAIN ENDP
END MAIN
