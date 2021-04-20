;   实验2-2 非压缩BCD码加法
;
;       非压缩型BCD码加法运算，一共4组数据，
;   结果存储在 RESULT 中，无输出，需使用调
;   试工具查看 DS:0000 - DS:001F
;   注：调试工具中高低位相反了
DATAS SEGMENT
    BCD1 DW 0304H, 0505H, 0102H, 0902H
    BCD2 DW 0506H, 0203H, 0105H, 0101H
    RESULT DW 4 DUP(?)
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS

START:
    MOV     AX, DATAS
    MOV     DS, AX
    XOR     AX, AX
    MOV     CX, 08H         ;计算循环计数
    MOV     BX, 00H         ;计算顺序计数

CALT:
    MOV     AX, BCD1[BX]
    ADC     AX, BCD2[BX]
    AAA                     ;非压缩型BCD码调整
    MOV     RESULT[BX], AX
    INC     BX
    LOOP    CALT
FIN:
    MOV     AH, 4CH
    INT     21H

CODES ENDS
END START
