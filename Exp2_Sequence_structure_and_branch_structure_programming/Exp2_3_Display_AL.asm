;   实验2-3 十六进制数输出AL存储器内容
;
;       输出存储在 AL 存储器中的内容，以十六
;   进制数据显示方式输出，可以在第 20 行设定
;   AL 存储器内容
DATAS SEGMENT
    HEXNUM1 DB ?        ;保存高位
    HEXNUM2 DB ?        ;保存低位
    HEXNUM  DB ?        ;子程序传入
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS

START:
    MOV     AX, DATAS
    MOV     DS, AX      ;初始化DS
    XOR     AX, AX
    XOR     BX, BX
    MOV     AL, 6BH     ;AL给任意两位16进制数
    PUSH    AX          ;保存现场
    AND     AL, 0FH     ;屏蔽高四位
    MOV     BL, AL      ;将AL低四位给BL
    POP     AX
    AND     AL, 0F0H    ;屏蔽低四位
    MOV     CL, 4
    ROR     AL, CL      ;右移4位AL，现在AL是高位，BL是低位
    MOV     HEXNUM1, AL ;保存AL
    MOV     HEXNUM2, BL ;保存BL
    MOV     AL, HEXNUM1 ;导出高位进行输出
    MOV     HEXNUM, AL
    CALL    HEXOUT
    MOV     AL, HEXNUM2 ;导出低位进行输出
    MOV     HEXNUM, AL
    CALL    HEXOUT
    MOV     AH, 4CH     ;运行结束，退出程序
	INT     21H

HEXOUT PROC             ;16进制数转ASCII并输出子程序
    MOV     AL, HEXNUM  ;获取输入数据
    CMP     AL, 09H     ;判断是数字还是字母
    JNB     ISALPHABET
    JMP     ISNUMERIC
ISNUMERIC:
    ADC     AL, 2FH     ;是数字，加上 2FH 得到 ASCII
    JMP     DISPLAY
ISALPHABET:
    ADC     AL, 37H     ;是字母，加上 37H 得到 ASCII
    JMP     DISPLAY
DISPLAY:
    MOV     DL, AL      ;输出
    MOV     AH, 02H
    INT     21H
    RET                 ;返回
HEXOUT ENDP
CODES ENDS
END START
