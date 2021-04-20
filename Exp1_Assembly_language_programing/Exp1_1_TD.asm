;   实验1-1 测试TD调试工具
;
;       用于测试TD调试工具，DATA中数据并未被使用，
;   实际功能为输出 `123456789:` ，从 "1" 开始的
;   连续的 10 个 ASCII 码字符
DATA SEGMENT
    AA DB '1'
    BB DB '2'
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

START:
    MOV AX, DATA
    MOV DS, AX      ;给DS赋初值，把DATA的段基址赋给DS
    MOV CX, 10      ;循环计数
    MOV AL, 31H
NEXT:
    PUSH AX         ;子程序调用前的现场保护
    MOV DL, AL
    MOV AH, 02H     ;调用2号功能(子程序，需要堆栈保护现场)
    INT 21H         ;DOS中断
    POP AX
    INC AL
    LOOP NEXT
    MOV AH, 4CH
    INT 21H
CODE ENDS
END START