module flopr(clk, rst, d, q);
  input clk;
  input rst;
  input [31:0]d;
  output reg [31:0]q;
  always @(negedge clk)
  begin
    if (rst)
      q <= d;
    else
      q <= 0;
  end
endmodule