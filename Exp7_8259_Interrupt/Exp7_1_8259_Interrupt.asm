SSTACK SEGMENT STACK
	DW 32 DUP(?)
SSTACK ENDS
 
CODE SEGMENT
	ASSUME CS:CODE
START: 	
    PUSH DS
	MOV AX, 0000H
	MOV DS, AX
	MOV AX, OFFSET MIR7		;取中断入口地址
	MOV SI, 003CH			;中断矢量地址
	MOV [SI], AX			;填IRQ7的偏移矢量
	MOV AX, CS				;段地址
	MOV SI, 003EH
	MOV [SI], AX			;填IRQ7的段地址矢量
	CLI                     ;中断屏蔽clear interrupt
	POP DS
	;初始化主片8259
	MOV AL, 11H				;0001 0001 级联，边沿触发，要ICW4
	OUT 20H, AL				;ICW1
	MOV AL, 08H				;0000 1000 中断类型号从8开始
	OUT 21H, AL				;ICW2
	MOV AL, 04H				;0000 0100 
	OUT 21H, AL				;ICW3
	MOV AL, 01H				;0000 0001 非缓冲方式，8086/8088配置
	OUT 21H, AL				;ICW4
	MOV AL, 6FH				;OCW1 0110 1111 IR7,IR4引脚的中断开放
	OUT 21H, AL
	STI                     ;恢复中断 set interrupt

AA1:	
    NOP                     ;空指令
	JMP AA1					;无限循环
 
MIR7:	
    STI                         
	CALL DELAY              ;延时
	MOV AX, 0037H           ;37H
	INT 10H					;显示字符7
	MOV AX, 0020H                
	INT 10H
	MOV AL, 20H
	OUT 20H, AL				;中断结束命令
	IRET		
DELAY:	
    PUSH CX
	MOV CX, 0F00H
AA0:	
	PUSH AX
	POP  AX
	LOOP AA0
	POP CX
	RET		
CODE ENDS
END START