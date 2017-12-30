module mux(s, y, d0, d1, d2, d3, d4, d5, d6, d7);
  parameter num_of_ways = 4, length = 32, siglen = 1;
  input [siglen-1:0]s;
  input [length:1]d0;
  input [length:1]d1;
  input [length:1]d2;
  input [length:1]d3;
  input [length:1]d4;
  input [length:1]d5;
  input [length:1]d6;
  input [length:1]d7;
  output reg [length:1]y;
  always@(s or d0 or d2 or d3 or d1 or d4 or d5 or d6 or d7)
  begin
    case (s)
      0:
        y <= d0;
      1:
        y <= d1;
      2:
        y <= d2;
      3:
        y <= d3;
      4:
        y <= d4;
      5:
        y <= d5;
      6:
        y <= d6;
      7:
        y <= d7;
    endcase
  end
endmodule