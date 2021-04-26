DATAS SEGMENT
    ARR DB 10 DUP(?)
    P1  DB ?
    P2  DB ?
    P3  DB ?
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS

START:
    MOV     AX, DATAS
    MOV     DS, AX
    CALL    INPUTP
    MOV     AH, 02H
    MOV     DL, 0DH
    INT     21H
    MOV     DL, 0AH
    INT     21H
    CALL    SORTP
    CALL    OUTPUTP
    MOV     AH, 4CH
    INT     21H

; 数据输入子程序
INPUTP PROC
    MOV     SI, 0
    XOR     BX, BX          ;清空BX，BX将用来存放计算后输入数据

RECORD_INPUT:
    MOV     AH, 1H          ;接收一个输入
    INT     21H
    CMP     AL, 20H         ;判断时候是空格
    JE      HANDLE_SPACE    ;输入空格则跳转处理

HANDLE_NUMBER:
    SUB     AL, 30H         ;输入不是空格，即为数字，减去30H从ASCII转换为数字
    CMP     BL, 0           ;BL与0比较
    JNE     GO_HIGHER       ;BL!=0，表示输入的数不是一个数据的开始，BL需乘以10
    MOV     BL, AL          ;BL=0，表示输入的数是一个数据的开始（最高位）
    JMP     RECORD_INPUT    ;BL录入一个新的数据的最高位，然后跳转至接收下一个输入

GO_HIGHER:
    MOV     CL, 10          ;BL!=0时，则当前数据为BL * 10 + AL
    XCHG    AL, BL          ;交换AL和BL，进行乘法
    MUL     CL              ;AL = AL * 10
    XCHG    AL, BL          ;把AL和BL换回来
    ADD     BL, AL          ;此时BL存储当前已输入数据
    JMP     RECORD_INPUT    ;跳转至接收下一个输入

HANDLE_SPACE:
    MOV     ARR[SI], BL     ;当输入为空格时，表示一个数据的输入结束，将其保存至ARR
    XOR     BL, BL          ;清空存储着当前数据的BL存储器
    INC     SI              ;循环变量加一
    CMP     SI, 0AH         ;循环变量与10比较，10为输入个数
    JE      INPUT_FINISH    ;循环变量等于10，结束循环，输入结束
    JMP     RECORD_INPUT    ;循环变量不等于10（小于10），接收下一个输入
    
INPUT_FINISH:
    RET

INPUTP ENDP

; 数据输出子程序
OUTPUTP PROC
    MOV     SI, 0           ;循环变量SI初始化
    MOV     BL, 10          ;被除数BL固定为10初始化

OUTPUT_READY:
    XOR     AX, AX
    MOV     P1, 0AH         ;P1，P2，P3分别为数据的最高位至最低位
    MOV     P2, 0AH         ;初始化为0AH，0AH是10进制不可能出现的数字
    MOV     P3, 0AH         ;输出时将判断，为0AH时不输出，这样输出时无前导0

    MOV     AL, ARR[SI]     ;从ARR获取一个数据，准备输出
    DIV     BL              ;AL除以10，AL存储商，AH存储余数
    MOV     P3, AH          ;将余数给P3，余数为输入数据的最低位

    MOV     DL, AL          ;将除法后的商给DL
    XOR     AX, AX          ;清空AX
    MOV     AL, DL          ;从DL将之前存入的AL取回，准备第二次除法
    DIV     BL              ;AL除以10，AL存储商，AH存储余数
    MOV     CL, AL          ;将商存入CL
    ADD     CL, AH          ;将商和余数求和存入AH
    CMP     CL, 0           ;将和与0比较
    JE      START_OUTPUT    ;如果和为0，表示当前输入为一位数，跳转至输出
    
    MOV     P2, AH          ;如果和不为0，代表至少为两位数，将余数存入P2，作为第二位数

    CMP     AL, 0           ;将除法的商与0比较
    JE      START_OUTPUT    ;如果商为0，代表数据是两位数，可直接输出了
    MOV     P1, AL          ;如果商不为0，代表是3位数，则将最高位存入P1
    JMP     START_OUTPUT    ;调用输出

START_OUTPUT:
    MOV     AH, 02H         ;AH选取2号功能，输出一个字符
    MOV     AL, P1          ;AL取P1，准备输出百位
    CMP     AL, 0AH         ;将百位与0AH比较
    JE      OUTPUT_2ND      ;如果相等，表示该数据不是三位数，不输出百位，跳转至输出十位

    ADD     AL, 30H         ;AL加30H将数字转换为对应的ASCII码
    MOV     DL, AL          ;待输出字符存入DL输出
    INT     21H

OUTPUT_2ND:
    MOV     AL, P2          ;AL取P2，准备输出十位
    CMP     AL, 0AH         ;将十位与0AH比较
    JE      OUTPUT_3RD      ;如果相等，表示该数据不是二位数，不输出十位，跳转至输出个位

    ADD     AL, 30H         ;AL加30H将数字转换为对应的ASCII码
    MOV     DL, AL          ;待输出字符存入DL输出
    INT     21H

OUTPUT_3RD:
    MOV     AL, P3          ;AL取P2，准备输出个位，个位是不会为0AH的
    ADD     AL, 30H         ;AL加30H将数字转换为对应的ASCII码
    MOV     DL, AL          ;待输出字符存入DL输出
    INT     21H

OUTPUT_FIN:
    MOV     DL, 20H         ;一个数据输出结束，在尾部添加一个空格作为间隔符
    INT     21H
    INC     SI              ;循环变量自加1
    CMP     SI, 0AH         ;检查循环变量
    JNE     OUTPUT_READY    ;如果循环变量小于10，表示未输出完，继续输出
    RET

OUTPUTP ENDP

; 排序子程序
SORTP PROC
    MOV     SI, 0           ;外循环变量初始化，对应 i = 0

LOOP1:
    MOV     DI, 0           ;内循环变量初始化，对应 j = 0

LOOP2:
    MOV     AL, ARR[DI]     ;获取两个数，对应 arr[j] arr[j+1]
    MOV     BL, ARR[DI+1]
    CMP     AL, BL          ;比较两个数，对应 arr[j] > arr[j+1]
    JA      WARP            ;大于成立，则调换两个数，对应 (arr[j] > arr[j+1]) == true
    JMP     LOOP_CONDITION  ;大于不成立，则不调换，继续判断循环条件

WARP:
    XCHG    AL, BL          ;交换两个数

RETURN:
    MOV     ARR[DI], AL     ;将交换后的数放回
    MOV     ARR[DI+1], BL

LOOP_CONDITION:
    MOV     DX, 9           ;循环条件判断
    SUB     DX, SI          ;内循环的循环条件计算，DX = length - i - 1
    INC     DI              ;内循环变量自加1，对应 j++
    CMP     DI, DX          ;内循环的循环条件判断，对应 j < length - i - 1
    JB      LOOP2           ;循环条件成立，进入下一个内循环
    INC     SI              ;内循环不成立的时候，计算外循环条件，外循环条件先自加1，对应 i++
    CMP     SI, 10          ;外循环的循环条件判断，对应 i < length
    JB      LOOP1           ;循环条件成立，进入下一个外循环，不成了表示排序结束
    
SORT_FIN:
    RET

SORTP ENDP

CODES ENDS
END START