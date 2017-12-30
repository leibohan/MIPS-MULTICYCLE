module EXT(Imm16, EXTOp, Imm32);
  input [15:0]Imm16;
  input [1:0]EXTOp;
  output reg [31:0]Imm32;
  
  always@(EXTOp or Imm16)
  begin
    case (EXTOp)
      2'b00:
        Imm32 = {16'b0, Imm16};
      2'b01:
        Imm32 = Imm16[15]?{16'hFFFF, Imm16}:{16'b0, Imm16};
      2'b10:
        Imm32 = {Imm16, 16'b0};
      default:
        ;
    endcase
  end
endmodule
