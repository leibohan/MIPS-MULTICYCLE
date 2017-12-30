`include "./instruction_def.v"
`include "./encode_control_define.v"

module ctrl(clk, rst, instruction, PCWr, PCWrCond, CondSrc, PCSrc, WBSel, WDSel, RFWr, DMWr, be, IMRead, EXTOp, ALUOp, ALUSrcA, ALUSrcB, IRWr, ue);
  input clk;
  input rst;
  input [31:0]instruction;
  
  output reg PCWr;
  output reg PCWrCond;
  output reg [1:0]CondSrc;
  output reg [1:0]PCSrc;
  output reg [1:0]WBSel;
  output reg [2:0]WDSel;
  output reg RFWr;
  output reg DMWr;
  output reg [3:0]be;
  output reg IMRead;
  output reg[1:0]EXTOp;
  output reg[3:0]ALUOp;
  output reg[1:0]ALUSrcA;
  output reg[2:0]ALUSrcB;
  output reg IRWr;
  output reg ue;
  
  reg [5:0]OPCode;
  reg [4:0]rs;
  reg [4:0]rt;
  reg [4:0]rd;
  reg [4:0]shamt;
  reg [15:0]imm;
  reg [5:0]FUNCT;
  
  always@(*)
  begin
    OPCode = instruction[31:26];
    rs = instruction[25:21];
    rt = instruction[20:16];
    rd = instruction[15:11];
    shamt = instruction[10:6];
    imm = instruction[15:0];
    FUNCT = instruction[5:0];
  end
  
  reg [4:0]state;
  
  initial
  begin
    state = 4'b0;
    PCWr = 1;
    RFWr = 0;
    IRWr = 0;
    be = 4'b0;
  end
  
  reg[4:0] i;
  
  always@(posedge clk)
  begin
    case (state)
      5'b0: if (rst == 0) state = 5'h1;
      5'b1: 
      begin
        case(OPCode)
          6'b000000: 
          begin
            if(FUNCT == `JR_FUNCT) state = 5'h9;
            else if (FUNCT == `JALR_FUNCT) state = 5'ha;
            else state = 5'h6;
          end
          `J_OP: state = 5'h9;
          `JAL_OP: state = 5'ha;
          `LW_OP,`LH_OP,`LHU_OP,`LB_OP,`LBU_OP,`SW_OP,`SH_OP,`SB_OP: state = 5'h2;
          //`ADDI_OP,`ADDIU_OP,`SLTI_OP,`SLTIU_OP,`ANDI_OP,`ORI_OP,`XORI_OP: state =5'h14;
          `LUI_OP: state = 5'h8;
          `ADDI_OP: state = 5'hb;
          `ADDIU_OP: state = 5'hc;
          `SLTI_OP: state = 5'hd;
          `SLTIU_OP: state = 5'he;
          `ANDI_OP: state = 5'hf;
          `ORI_OP: state = 5'h10;
          `XORI_OP: state = 5'h11;
          /*`BLTZ_OP:
            case(rt)
              5'h0: state = 5'h12;
              5'h1: state = 5'h13;
              default:;
            endcase*/
          `BNE_OP, `BEQ_OP, `BLEZ_OP, `BGTZ_OP, `BLTZ_OP, `BGEZ_OP: state = 5'h13;
        endcase
      end
      5'h2:
        case(OPCode[5:3])
          3'b100: state = 5'h3;
          3'b101: state = 5'h5;
        endcase
      5'h3: state = 5'h4;
      5'h4, 5'h5, 5'h7, 5'h8, 5'h12, 5'h13: state = 5'h0;
      5'h6: state = 5'h7;
      5'ha: state = 5'h9; 
      5'h9, 5'hb, 5'hc, 5'hd, 5'he, 5'hf, 5'h10, 5'h11: state = 5'h14;
      default: state = 5'h0;
    endcase
    $display("state serial num is %d", state);
  end
        
  always@(state)
    case (state)
      5'h0:
      begin
        IMRead = 1'b1;
        IRWr = 1'b1;
        ALUSrcA = 2'b0;
        ALUSrcB = 3'b1;
        PCSrc = 2'b00;
        ALUOp = `ALU_ADD;
        PCWr = 1;
        RFWr = 0;
        DMWr = 0;
      end
      5'h1:
      begin
        IRWr = 0;
        ALUSrcA = 2'b0;
        ALUSrcB = 3'b11;
        ALUOp = `ALU_ADD;
        EXTOp = 01;
        PCWr = 0;
        PCSrc = 2'b01;
        PCWrCond = 0;
      end
      5'h2:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'b10;
        ALUOp = `ALU_ADD;
      end
      5'h3:
      begin
        be = 4'b0;
        for (i = instruction[1:0]; i < 4; i = i + 1)
          be[i] = (OPCode[1:0] >= i - instruction[1:0]);
        ue = OPCode[2];
      end
      5'h4:
      begin
        RFWr = 1'b1;
        WBSel = 2'b0;
        WDSel = 3'b1;
      end
      5'h5:
      begin
        be = 4'b0;
        for (i = instruction[1:0]; i < 4; i = i + 1)
          be[i] = (OPCode[1:0] >= i - instruction[1:0]);
        DMWr = 1'b1;
      end
      5'h6:
      begin
        PCWr = 0;
        ALUSrcB = 3'b0;
        case (FUNCT)
          `SLL_FUNCT, `SRA_FUNCT, `SRL_FUNCT: ALUSrcA = 2'd3;
          default: ALUSrcA = 2'b1;
        endcase
        case(FUNCT)
          `ADD_FUNCT,`ADDU_FUNCT: ALUOp = `ALU_ADD;
          `SUB_FUNCT: ALUOp = `ALU_SUB;
          `SUBU_FUNCT: ALUOp = `ALU_SUBU;
          `AND_FUNCT: ALUOp = `ALU_AND;
          `OR_FUNCT: ALUOp = `ALU_OR;
          `NOR_FUNCT: ALUOp = `ALU_NOR;
          `XOR_FUNCT: ALUOp = `ALU_XOR;
          
          `SLT_FUNCT: ALUOp = `ALU_SLT;
          `SLTU_FUNCT: ALUOp = `ALU_SLTU;
          
          `SLL_FUNCT, `SLLV_FUNCT: ALUOp = `ALU_SLL;
          `SRA_FUNCT, `SRAV_FUNCT: ALUOp = `ALU_SRA;
          `SRL_FUNCT, `SRLV_FUNCT: ALUOp = `ALU_SRL;
          default: ALUOp = `ALU_ADD;
        endcase
      end
      5'h7:
      begin
        WBSel = 2'b1;
        WDSel = 3'b0;
        RFWr = 1;
      end
      5'h8:
      begin
        PCWr = 0;
        EXTOp = 10;
        WBSel = 2'b0;
        WDSel = 3'd4;
        RFWr = 1;
      end
      5'h9:
      begin
        RFWr = 0;
        ALUOp = `ALU_ADD;
        ALUSrcA = 2'b0;
        ALUSrcB = 3'h4;
        PCWr = 1;   
        if(OPCode == 6'h0)
          PCSrc = 2'b11;
        else
          PCSrc = 2'b10;
      end
      5'ha:
      begin
        PCWr = 0;
        RFWr = 1;
        WBSel = 2'h2;
        WDSel = 3'h5;
      end
      5'hb:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_ADD;
      end
      5'hc:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_ADD;
      end
      5'hd:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_SLT;
      end
      5'he:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_SLTU;
      end
      5'hf:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_AND;
      end
      5'h10:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_OR;
      end
      5'h11:
      begin
        PCWr = 0;
        ALUSrcA = 2'b1;
        ALUSrcB = 3'd2;
        EXTOp = 01;
        ALUOp = `ALU_XOR;
      end
      5'h12:
      begin
        PCWr = 0;
        RFWr = 1;
        WBSel = 2'b1;
        WDSel = 3'b0;
      end
      5'h13:
      begin
        PCWr = 0;
        ALUSrcA = 2'd1;
        PCWrCond = 1;
        PCSrc = 2'b1;
        case (OPCode)
          `BNE_OP:
          begin
            ALUSrcB = 3'd0;
            ALUOp = `ALU_SUB;
            CondSrc = 2'b10;
          end
          `BEQ_OP:
          begin
            ALUSrcB = 3'd0;
            ALUOp = `ALU_SUB;
            CondSrc = 2'b0;
          end
          `BLEZ_OP:
          begin
            ALUSrcB = 3'd4;
            ALUOp = `ALU_ASUB;
            CondSrc = 2'b11;
          end
          `BGTZ_OP:
          begin
            ALUSrcB = 3'd4;
            ALUOp = `ALU_ASUB;
            CondSrc = 2'b01;
          end
          `BGEZ_OP:
          case (rt)
            `BGEZ_FUNCT:
            begin
            ALUSrcB = 3'd4;
              ALUOp = `ALU_SUB;
              CondSrc = 2'b11;
            end
            `BLTZ_FUNCT:
            begin
            ALUSrcB = 3'd4;
              ALUOp = `ALU_SUB;
              CondSrc = 2'b01;
            end
            default:;
          endcase
          default:;
        endcase
      end
      5'h14:
      begin
        PCWr = 0;
        WBSel = 2'b0;
        WDSel = 3'b0;
        RFWr = 1;
      end        
      default: ;
    endcase
endmodule
