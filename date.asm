DATASEG SEGMENT
    INPUT   DB "WHAT IS THE DATE(input DD-MM-YYYY)?",'$'
    OUTPUT  DB '-','$'
    YEAR    DB 4 DUP(?),'$'     ;YYYY
    MONTH   DB 2 DUP(?),'$'     ;MM
    DAY     DB 2 DUP(?),'$'     ;DD
    BUFFER  DB 16,?,16 DUP(0)   ;预定义20字节的空间，待输入完成以后，自动获得输出的字符个数
    CRLF    DB 0AH,0DH,'$'         ;回车换行
DATASEG ENDS
 
STACKSEG SEGMENT
    DB 16 DUP(0)
STACKSEG ENDS
 
CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG,SS:STACKSEG
START:
    MOV AX,DATASEG
    MOV DS,AX

    ;打印提示输入信息
    LEA DX,INPUT
    MOV AH,09H
    INT 21H 

    LEA DX,CRLF
    MOV AH,09H
    INT 21H

    CALL GETNUM

    ;YYYY赋值
    MOV AL,BUFFER+8
    MOV YEAR,AL
    MOV AL,BUFFER+9
    MOV YEAR+1,AL
    MOV AL,BUFFER+10
    MOV YEAR+2,AL
    MOV AL,BUFFER+11
    MOV YEAR+3,AL

    ;MM赋值
    MOV AL,BUFFER+5
    MOV MONTH,AL
    MOV AL,BUFFER+6
    MOV MONTH+1,AL

    ;DD赋值
    MOV AL,BUFFER+2
    MOV DAY,AL
    MOV AL,BUFFER+3
    MOV DAY+1,AL

    LEA DX,CRLF
    MOV AH,09H
    INT 21H
  
    CALL DISPP
    JMP OK

GETNUM:
    ;字符串输入
    LEA DX,BUFFER
    MOV AH,0AH
    INT 21H
    RET

DISPP:
    ;字符串输出
    LEA DX,YEAR
    MOV AH,09H							 
    INT 21H

    ;打印分隔符
    LEA DX,OUTPUT
    MOV AH,09H							 
    INT 21H

    ;字符串输出
    LEA DX,MONTH
    MOV AH,09H							 
    INT 21H

    ;打印分隔符
    LEA DX,OUTPUT
    MOV AH,09H							 
    INT 21H

    ;字符串输出
    LEA DX,DAY
    MOV AH,09H							 
    INT 21H

    RET

OK: 
    ;返回DOS系统
    MOV AH,4CH
    INT 21H

CODESEG ENDS
    END START