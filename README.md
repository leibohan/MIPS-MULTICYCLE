# MIPS多周期作业说明

### 简介 这是雷伯涵制作的多周期MIPS处理器，这里主要对state含义作简要说明

#### 支持指令集 
|序号|命令名称|OPCode|语法|
|---|:-----|:---:|:-----------| 
|01|ADD|00|0x00, rs, rt, rd, 0, 0x20| 
02|ADDU|00|0x00, rs, rt, rd, 0, 0x21|
|03|ADDI|08|0x00, rs, rd, imm|
|04|ADDIU|09|0x00, rs, rd, imm|
|05|SUB|00|0x00, rs, rt, rd, 0, 0x22|
|06|SUBU|00|0x00, rs, rt, rd, 0, 0x23|
|07|SLT|00|0x00, rs, rt, rd, 0, 0x2a|
|08|SLTU|00|0x00, rs, rt, rd, 0, 0x2b|
|09|SLTI|0a|0x00, rs, rd, imm|
|10|SLTIU|0b|0x00, rs, rd, imm|
|11|AND|00|0x00, rs, rt, rd, 0, 0x24|
|12|ANDI|0c|0x00, rs, rd, imm|
|13|OR|00|0x00, rs, rt, rd, 0, 0x25|
|14|ORI|0d|0x00, rs, rd, imm|
|15|XOR|00|0x00, rs, rt, rd, 0, 0x26|
|16|XORI|0e|0x00, rs, rd, imm|
|17|LUI|0f|0x00, 00, rd, imm|
|18|NOR|00|0x00, rs, rt, rd, 0, 0x27|
|19|SLL|00|0x00, xx, rt, rd, shamt, 0x00|
|20|SLLV|00|0x00, rs, rt, rd, 0, 0x02|
|21|SRL|00|0x00, xx, rt, rd, shamt, 0x03|
|22|SRLV|00|0x00, rs, rt, rd, 0, 0x04|
|23|SRA|00|0x00, xx, rt, rd, shamt, 0x06|
|24|SRAV|00|0x00, rs, rt, rd, 0, 0x07|
|25|LB|20|0x00, rs, rd, Offset|
|26|LH|21|0x00, rs, rd, Offset|
|27|LW|23|0x00, rs, rt, Offset|
|28|LBU|24|0x00, rs, rt, Offset|
|29|LHU|25|0x00, rs, rt, Offset|
|30|SB|28|0x00, rs, rt, Offset|
|31|SH|29|0x00, rs, rt, Offset|
|32|SW|2b|0x00, rs, rt, Offset|
|33|BLTZ|01|0x00, rs, 00, Offset|
|34|BGEZ|01|0x00, rs, 01, Offset|
|35|BEQ|04|0x00, rs, rt, Offset|
|36|BNE|05|0x00, rs, rt, Offset|
|37|BLEZ|06|0x00, rs, rt, Offset|
|38|BGTZ|07|0x00, rs, rt, Offset|
|39|JR|00|0x00, rs, 0x0000, 0x08|
|40|JALR|00|0x00, rs, 00, 1f, 0x09|
|41|J|02|0x02, target|
|42|JAL|03|0x03, target|

#### 各state含义

表中各内容来自于

|state序号|前后连接及功能|PCWrite|PCWriteCond|Cond来源|PC来源|IRWrite|WB来源|WD来源|RFWr|ALUA来源|ALUB来源|DMem位使能|DMWr|ALUOP|EXTOP|
|:-----:|:---------------------------|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|initial|最开始出现，其后为0|1|XX|XXX|0|X|X|X|X|X|X|X|X|X|X|
|0|在每条指令取指时出现，其后必定为1|1|0|XX|000|1|X|X|0|00|001|XXXX|0|0000|XX|
|1|由0跳转来|0|0|XX|XXX|0|X|X|0|10|01|XXXX|0|0000|01|
|2|由1跳转来，所有l/s型指令|0|0|XX|XXX|0|X|X|00|010|0|由Ins[27:26]判定|0|0000|01|
|3|由2跳转来,l系列指令（表中省略了Ins[28]决定的ue）|0|0|XX|XXX|0|XX|XXX|0|XX|XXX|由Ins[27:26]判定|0|XXXX|01|
|4|由3跳转来,将内存取出数据写回|0|0|XX|XXX|0|XX|XXX|0|XX|XXX|由Ins[28:26]判定|0|XXXX|01|
|5|由2跳转来,s系列指令|0|0|XX|XXX|0|XX|XXX|0|XX|XXX|由Ins[28:26]判定|1|XXXX|XX|
|6|由1跳转来.除JR、JALR外所有R型指令|0|0|XX|XXX|0|XX|XXX|0|01|000|XXXX|0|取决于FUNCT|XX|
|7|由6跳转来,R型指令计算结果写回|0|0|XX|XXX|0|01|000|1|XX|XXX|XXXX|0|0000|01|
|8|由1跳转来,LUI指令直接扩位，然后返回0|0|0|XX|XXX|0|00|100|1|XX|XXX|XXXX|0|XXXX|10|
|9|所有J系列指令最终跳转，之后返回0下次取指|1|0|XX|001/100|0|XX|XXX|0|XX|XXX|XXXX|0|XXXX|01|
|a|由1跳转来,JR、JALR将目前地址计入31号$ra|0|0|XX|XXX|0|10|101|1|XX|XXX|XXXX|0|XXXX|01|
|b|由1跳转来,ADDI|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|0000|01|
|c|由1跳转来,ADDIU|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|0000|01|
|d|由1跳转来,SLTI|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|1110|01|
|e|由1跳转来,SLTIU|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|1111|01|
|f|由1跳转来,ANDI|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|0101|01|
|10|由1跳转来,ORI|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|0100|01|
|11|由1跳转来,XORI|0|0|XX|XXX|0|XX|XXX|0|01|010|XXXX|0|0111|01|
|13|由1跳转来的一切B分支指令，其后无论分支与否返回0|0|1|根据OPCode及rt位置决定|1|0|XX|XXX|0|10|000|XXXX|0|根据OPCode及rt位置决定|XX|
|14|I型指令之后的写回环节。其后返回0|0|0|XX|XXX|0|01|001|1|XX|XXX|XXXX|0|0000|00|

##### WD来源含义
|0|1|2|3|4|5|
|-----------|-----------|-----------|-----------|-----------|-----------|
|ALUOut|DMR|{31'b0, ALUOut[31]}|{31'b0, ~ALUOut[31]}|Imm32|PC|

##### WB来源含义
|0|1|2|
|-----------|-----------|-----------|
|rt|rd|5'b11111|

##### PC来源含义
|0|1|2|3|4|
|-----------|-----------|-----------|-----------|-----------|
|AluResult|ALUOut|{PC[31:28]|instruction[25:0], 2'b0}|ReadA|

##### ALUA来源含义
|0|1|2|3|
|-----------|-----------|-----------|-----------|
|PC|ReadA|32'b0|{27'b0, shamt}|

##### ALUB来源含义
|0|1|2|3|4|5|6|
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
|ReadB|32'h4|Imm32|{Imm32[29:0]|2'b0}|32'b0|{27'b0, shamt}|

##### Cond来源含义
|0|1|2|3|
|-----------|-----------|-----------|-----------|
|Zero|AluResult[31]|~Zero|~AluResult[31]|

### 其它各文件说明
波形图中包括clk, instruction, PC, state序号信息，直到死循环为止。 屏幕输出为这一期间的屏幕打印信息，包括相关寄存器与相关内存、PC、二进制格式的instruction. Python程序是一个把txt文件写入IM的小工具，输出文件是另一个txt文件。 src文件夹内为全部代码。
