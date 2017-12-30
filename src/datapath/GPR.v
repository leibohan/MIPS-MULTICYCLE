
module GPR(DataOut1,DataOut2,clk,WData,WE,WeSel,ReSel1,ReSel2);
	input clk;
	input WE;
	input [4:0] WeSel,ReSel1,ReSel2;
	input [31:0] WData;
	
	output [31:0] DataOut1,DataOut2;
		  
	reg [31:0] Gpr[31:0];
	reg[5:0]i;
	
  initial
	begin
	  for (i = 0; i < 32; i = i + 1)
	    Gpr[i] <= 32'b0;
	end

	always@(posedge clk)
	begin
	  if (WE == 1)
			Gpr[WeSel] = WData;
			$display("v0:%h v1:%h a0:%h a1:%h a2:%h a3:%h 29:%h 31:%h", Gpr[2], Gpr[3], Gpr[4], Gpr[5], Gpr[6], Gpr[7], Gpr[29], Gpr[31]);
			$display("t0:%h t1:%h t2:%h t3:%h t4:%h t5:%h t6:%h t7:%h ", Gpr[8], Gpr[9], Gpr[10], Gpr[11], Gpr[12], Gpr[13], Gpr[14], Gpr[15]);
	end
	assign DataOut1 = (ReSel1==0)?0:Gpr[ReSel1];
	assign DataOut2 = (ReSel2==0)?0:Gpr[ReSel2];
		
endmodule