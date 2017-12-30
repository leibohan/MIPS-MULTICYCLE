//Instruction Register
module IR(instruction, IRWr, addin, clk);
  input IRWr;
  input [31:0]addin;
  input clk;
  output reg[31:0]instruction;
  always@(negedge clk)
  begin
    if (IRWr) instruction <= addin;
  end
endmodule