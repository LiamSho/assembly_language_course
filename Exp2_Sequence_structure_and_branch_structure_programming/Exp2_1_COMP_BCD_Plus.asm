;   实验2-1 压缩BCD码加法
;
;       压缩型BCD码加法运算，一共4组数据，
;   结果存储在 RESULT 中，无输出，需使用
;   调试工具查看 DS:0000 - DS:000B
DATAS SEGMENT
    BCD1 DB 34H, 55H, 12H, 92H
    BCD2 DB 56H, 23H, 15H, 11H
    RESULT DB 4 DUP(?)
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS

START:
    MOV     AX, DATAS
    MOV     DS, AX
    XOR     AX, AX
    MOV     CX, 04H         ;计算循环计数
    MOV     BX, 00H         ;计算顺序计数

CALT:
    MOV     AL, BCD1[BX]
    ADC     AL, BCD2[BX]
    DAA                     ;压缩型BCD码调整
    MOV     RESULT[BX], AL
    INC     BX
    LOOP    CALT
FIN:
    MOV     AH, 4CH
    INT     21H

CODES ENDS
END START
