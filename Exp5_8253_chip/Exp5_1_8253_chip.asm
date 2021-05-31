; 此代码只可在实验箱上运行
STACKS SEGMENT STACK
    DB 256 DUP(?)
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE, SS:STACKS

START:
    MOV     DX, 06C6H       ; 控制线地址
    MOV     AL, 00110110B   ; 初始化定时器0，模式3，先写低位再写高位
    OUT     DX, AL

    MOV     AX, 1000        ; 定时器0初值
    MOV     DX, 06C0H       ; 定时器0数据地址
    MOV     DX, AL
    MOV     AL, AH
    MOV     DX, AL

    MOV     DX, 06C6H
    MOV     AL, 01110110H   ; 初始化定时器1，模式2，先写低位再写高位
    OUT     DX, AL

    MOV     AX, 100         ; 定时器1初值
    MOV     DX, 06C2H       ; 定时器1数据地址
    MOV     DX, AL
    MOV     AL, AH
    MOV     DX, AL
CODE ENDS
END START
