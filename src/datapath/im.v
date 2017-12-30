module im_4k( addr, dout ) ;
    input   [11:2]  addr ;  // address bus
    output  [31:0]  dout ;  // 32-bit memory output
    
	  reg[31:0] OPCode;
	  reg[31:0]  IMem[1023:0];
	
	initial
	begin
	  IMem[0] = 32'h34021234;
	  IMem[1] = 32'h3c039876;
	  IMem[2] = 32'h20443456;
	  IMem[3] = 32'h2465fc00;
	  IMem[4] = 32'h3846abcd;
	  IMem[5] = 32'h2c850034;
	  IMem[6] = 32'h2c45ffff;
	  IMem[7] = 32'h30c77654;
	  IMem[8] = 32'h28681234;
	  IMem[9] = 32'h00624023;
	  IMem[10] = 32'h01034826;
	  IMem[11] = 32'h01285021;
	  IMem[12] = 32'h01425020;
	  IMem[13] = 32'h01435822;
	  IMem[14] = 32'h016a6027;
	  IMem[15] = 32'h016a6825;
	  IMem[16] = 32'h016a7024;
	  IMem[17] = 32'h01ac982a;
	  IMem[18] = 32'h01aca02b;
	  IMem[19] = 32'h000840c0;
	  IMem[20] = 32'h00084c02;
	  IMem[21] = 32'h00085743;
	  IMem[22] = 32'h240b3410;
	  IMem[23] = 32'h01686004;
	  IMem[24] = 32'h01686806;
	  IMem[25] = 32'h01687007;
	  IMem[26] = 32'h00432021;
	  IMem[27] = 32'h201d0000;
	  IMem[28] = 32'hafa40000;
	  IMem[29] = 32'hafa40004;
	  IMem[30] = 32'hafa40008;
	  IMem[31] = 32'ha7a80004;
	  IMem[32] = 32'ha7a9000a;
	  IMem[33] = 32'ha3aa0007;
	  IMem[34] = 32'ha3a80009;
	  IMem[35] = 32'ha3a90008;
	  IMem[36] = 32'h8fa80000;
	  IMem[37] = 32'hafa8000c;
	  IMem[38] = 32'h87a90002;
	  IMem[39] = 32'hafa90010;
	  IMem[40] = 32'h97a90002;
	  IMem[41] = 32'hafa90014;
	  IMem[42] = 32'h83aa0003;
	  IMem[43] = 32'hafaa0018;
	  IMem[44] = 32'h93aa0003;
	  IMem[45] = 32'hafaa001c;
	  IMem[46] = 32'h93aa0001;
	  IMem[47] = 32'hafaa0020;
	  IMem[48] = 32'h201d0040;
	  IMem[49] = 32'hafa00000;
	  IMem[50] = 32'h00081024;
	  IMem[51] = 32'h15090001;
	  IMem[52] = 32'h24420001;
	  IMem[53] = 32'h1d000001;
	  IMem[54] = 32'h24420001;
	  IMem[55] = 32'h19000001;
	  IMem[56] = 32'h24420001;
	  IMem[57] = 32'h05200001;
	  IMem[58] = 32'h24420001;
	  IMem[59] = 32'h05010001;
	  IMem[60] = 32'h24420001;
	  IMem[61] = 32'h112a0001;
	  IMem[62] = 32'h24420001;
	  IMem[63] = 32'hafa20000;
	  IMem[64] = 32'h201d0040;
	  IMem[65] = 32'h8fa20000;
	  IMem[66] = 32'h08000c44;
	  IMem[67] = 32'h00481021;
	  IMem[68] = 32'h24420001;
	  IMem[69] = 32'h0c000c48;
	  IMem[70] = 32'h00a22821;
	  IMem[71] = 32'h08000c47;
	  IMem[72] = 32'h201d0000;
	  IMem[73] = 32'hafbf0028;
	  IMem[74] = 32'h34425500;
	  IMem[75] = 32'h20093148;
	  IMem[76] = 32'h0120f809;
	  IMem[77] = 32'h201d0040;
	  IMem[78] = 32'hafa20000;
	  IMem[79] = 32'h201d0000;
	  IMem[80] = 32'h8fbf0028;
	  IMem[81] = 32'h03e00008;
	  IMem[82] = 32'h201d0000;
	  IMem[83] = 32'hafbf002c;
	  IMem[84] = 32'h34420050;
	  IMem[85] = 32'h03e00008;
	 end

	
	always@(addr)
	begin
		OPCode = IMem[addr[11:2]];
	end
	assign dout = OPCode;
endmodule
