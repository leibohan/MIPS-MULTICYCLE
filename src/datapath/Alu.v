`include "./encode_control_define.v"

module Alu(rlt,Zero,A,B,ALUOP,Over);

	input  [31:0] 		A;		//运算数据1
	input  [31:0]		B;		//运算数据2
	input  [3:0]		ALUOP;		//运算器控制信号
	
	output reg[31:0]		rlt;		//运算器输出结果
	output reg Zero;			//结果是否为零
	output reg Over;
	
	reg[6:0] i;
	
	initial								//初始化数据
	begin
		Zero = 0;
		Over = 0;
		rlt = 0;
	end	
	
	always@(A or B or ALUOP)
	begin
		case (ALUOP)
		  `ALU_ADD: rlt = A + B;
		  `ALU_SUB,`ALU_SUBU: rlt = A - B;
		  `ALU_ASUB: rlt = B - A;
		  `ALU_AND: rlt = A & B;
		  `ALU_OR: rlt = A | B;
		  `ALU_NOR: rlt = ~(A | B);
		  `ALU_XOR: rlt = A ^ B;
		  
		  `ALU_SLL: rlt = B << A[4:0];
		  `ALU_SRL: rlt = B >> A[4:0];
		  `ALU_SRA: rlt = B >> A[4:0] | {32{B[31]}} << (32-A[4:0]);
		  //begin
		  //  for (i = 0; i < 32 - A; i = i + 1)
		  //    rlt[i] = B[i+A];
		  //  for (i = 32 - A; i < 32; i = i + 1)
		  //    rlt[i] = B[31];
		  //end
		  
		  `ALU_SLT: rlt = (A<B || A[31] == 1 && B[31] == 0) ? 32'b1:32'b0;
		  `ALU_SLTU: rlt = A < B?32'b1:32'b0;

		  default: rlt = 0;
		endcase
		case (ALUOP)
		  `ALU_SUBU: Over = A<B;
		  `ALU_SUB: Over = A<B || A[31] == 1 && B[31] == 0;
		  `ALU_ASUB: Over = A>B || A[31] == 0 && B[31] == 1;
		  default: Over = 0;
		endcase
	end
  
endmodule