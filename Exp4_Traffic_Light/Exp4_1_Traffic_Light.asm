STACKS SEGMENT STACK
    DB 256 DUP(?)
STACKS ENDS

CODE SEGMENT
    ASSUME CS:CODE, SS:STACKS

START:
    MOV DX, 0206H	  ;8255A控制字寄存器地址 0000 0010 0000 0110B=0206H
    MOV AX, 80H	      ;8255A控制字 1000 0000B =80H ,A口输出, A口方式0
    OUT DX, AX		  ;将控制字写入8255A的控制端口

    MOV DX, 0200H	  ;A口地址 0000 0010 = 0200h
    MOV AX, 0FFH	  ;0ffH = 1111 1111
    OUT DX, AX		  ;初始化

;东西通行，南北禁行
FLASH: 
    MOV AX, 0BEH	  ;10111110，东西方向绿灯，南北方向红灯
    OUT DX, AX		  ;将数据输出到A口
    CALL DELAY10S	  ;保持延时10s

    ;东西黄灯闪烁
    MOV CX, 3         ;闪烁计数

EWYFLASH: 
    MOV AX, 0BDH	  ;10111101，东西方向黄灯灯，南北方向红灯
    OUT DX, AX
    CALL DELAY05S	  ;等待大致0.5s
    MOV AX, 0BFH	  ;10111111，东西全关，南北方向红灯
    OUT DX, AX
    CALL DELAY05S	  ;等待大致0.5s
    LOOP EWYFLASH

	;南北通行，东西禁行
    MOV AX, 0EBH	  ;11101011，南北方向是绿灯，东西方向红灯
    OUT DX, AX
    CALL DELAY10S
	  
	;南北黄灯闪烁
    MOV CX, 3

SNYFLASH:
    MOV AX, 0dbh	  ;11011011 南北方向黄灯，东西方向红灯
    OUT DX, AX
    CALL DELAY05S
    MOV AX, 0fbh	  ;11111011	南北方向全关，东西方向红灯
    OUT DX, AX
    CALL DELAY05S
    LOOP SNYFLASH

    JMP FLASH         ;循环执行

DELAY10S PROC near
    PUSH CX
    MOV BX, 500
DL1:
    MOV CX, 5882	  ;循环大约 20 ms, 一共 500 * 20 = 10000ms = 10s
DL2:
    LOOP DL2
    DEC bx
    JNZ DL1
    POP cx
    RET
DELAY10S ENDP

DELAY05S PROC near
    PUSH CX
    MOV BX, 25
DL01:
    MOV CX, 5882      ;循环大约 20 ms, 一共 25 * 20 = 500ms = 0.5s
DL02:
    LOOP DL02
    DEC BX
    JNZ DL01
    POP CX
    RET
DELAY05S ENDP

CODE ENDS
END START