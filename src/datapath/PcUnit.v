module PcUnit(PC,PcReSet,PCWr,PCWrCond,Cond,clk,Address);

	input   PcReSet;
	input   PCWr;
	input PCWrCond;
	input Cond;
	input   clk;
	input   [31:0] Address;
	
	output reg[31:0] PC;
	
	always@(negedge clk or posedge PcReSet)
	begin
	  if (PcReSet)
	    PC <= 32'h0000_3000;
	  else
	    if (PCWr || (PCWrCond && Cond))
	      PC = Address;
	    else;
	end
endmodule