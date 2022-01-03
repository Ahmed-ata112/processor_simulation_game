^q::
SetCapsLockState,ON
SetKeyDelay 500


Send,
(
ALI
)
  
Send,{Enter}


Send,
(
100
)
  
Send,{Enter}



Send,
(
MAI
)
  
Send,{Enter}


Send,
(
76
)
  
Send,{Enter}


Send {f2}

Send {f2}

Send {f2}

Send {f2}

Send,
(
A
)
  

Send,
(
E
)

Send,
(
15898358ACFBD65E4A587D5C2F57012569A752253D69552102593201478523698500

)
Send,{Enter}

sleep 15000

Send,
(
MOV AX,4
)
Send {f2}

Send,
(
MOV AL,5E
)
Send {f1}

Send, {f6}
Send,
(
MOV AX,6
)
Send, {Enter}

Send,
(
INC BX
)
Send, {f1}

Send,
(
INC AX
)
Send, {f1}

Send, {f7}

Send,
(
A
)
Send, {Enter}

Send,
(
MUL BX
)
Send, {f1}



Send, {f8}

Send,
(
OR CX,0FFFF
)
Send, {f1}

Send, {f9}

Send,
(
0110
)

Send,
(
MOV CX,0110
)
Send,{f1}










