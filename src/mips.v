module mips(clk, rst, PC, instruction);
  input clk;
  input rst;
  output wire[31:0]PC;
  output wire[31:0]instruction;
  
  reg [5:0]OPCode;
  reg [4:0]rs;
  reg [4:0]rt;
  reg [4:0]rd;
  reg [4:0]shamt;
  reg [15:0]imm;
  reg [31:0]DMR;
  
  always@(*)
  begin
    OPCode <= instruction[31:26];
    rs <= instruction[25:21];
    rt <= instruction[20:16];
    rd <= instruction[15:11];
    shamt <= instruction[10:6];
    imm <= instruction[15:0];
  end
  
  wire [31:0]ReadA;
  wire [31:0]ReadB;
  wire [31:0]WBData;
  wire RFWE;
  wire [4:0]WBSel;
  GPR RF(ReadA,ReadB,clk,WBData,RFWE,WBSel,rs,rt);
  
  wire [31:0]MemIn;
  wire [31:0]MemOut;
  wire [31:0]DMemAdd;
  wire [3:0]be;
  wire ue;
  dm_4k DMem(DMemAdd[11:2], be, MemIn, DMWr, clk, MemOut, !ue);
  
  wire [31:0]AluResult;
  wire [31:0]AluA;
  wire [31:0]AluB;
  wire [3:0]AluOP;
  wire Zero;
  wire Over;
  Alu alu(AluResult,Zero,AluA,AluB,AluOP,Over);
  
  reg [31:0]ALUOut;
  reg zero;
  reg ne;
  reg neg;
  reg pos;
  always@(negedge clk)
  begin
    #40
    ALUOut = AluResult;
    DMR = MemOut;
    zero = Zero;
    neg = AluResult[31];
    pos = ~AluResult[31];
    ne = ~Zero;
  end
  
  wire IRWr;
  wire[31:0]Instruction;
  IR insFetch(instruction, IRWr, Instruction, clk);
  
  wire [31:0]IMemAdd;
  im_4k IMem(IMemAdd[11:2],Instruction); 
  
  wire[15:0]Imm16;
  wire[31:0]Imm32;
  wire[1:0]EXTOP;
  EXT ext(Imm16, EXTOP, Imm32);
  
  wire [31:0]Address;
  wire PCWr;
  wire PCWrcond;
  wire Cond;
  PcUnit pc(PC,rst,PCWr,PCWrCond,Cond,clk,Address);
  
  wire [2:0]WBSrc;
  mux #(6,32,3) RFmux1(WBSrc, WBData, ALUOut, DMR, {31'b0, ALUOut[31]}, {31'b0, ~ALUOut[31]}, Imm32, PC);
  
  wire [1:0]WBSelSrc;
  mux #(3,5,2) RFmux2(WBSelSrc, WBSel, rt, rd, 5'b11111);
  
  wire [1:0]CondSrc;
  wire notZero;
  wire POS;
  assign notZero = ~Zero;
  assign POS = ~AluResult[31];
  mux #(4,1,2) Condmux(CondSrc, Cond, Zero, AluResult[31], notZero, POS);
  
  wire [1:0]PCSrc;
  mux #(4,32,2) PCmux(PCSrc, Address, AluResult, ALUOut, {PC[31:28], instruction[25:0], 2'b0}, ReadA);
  
  wire [1:0]ALUSrcA;
  mux #(4,32,2) ALUA(ALUSrcA, AluA, PC, ReadA, 32'b0, {27'b0, shamt});
  
  wire [2:0]ALUSrcB;
  mux #(6,32,3) ALUB(ALUSrcB, AluB, ReadB, 32'h4, Imm32, {Imm32[29:0], 2'b0}, 32'b0, {27'b0, shamt});
  
  assign DMemAdd = ALUOut;
  assign IMemAdd = PC;
  assign Imm16 = instruction[15:0];
  assign MemIn = ReadB;

  ctrl control(clk, rst, instruction, PCWr, PCWrCond, CondSrc, PCSrc, WBSelSrc, WBSrc, RFWE, DMWr, be, IMRead, EXTOP, AluOP, ALUSrcA, ALUSrcB, IRWr, ue);
  
endmodule
