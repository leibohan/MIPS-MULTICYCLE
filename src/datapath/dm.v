module dm_4k( addr, be, dain, DMWr, clk, dout, ue) ;
  input   [11:2]  addr ;  // address bus
  input   [3:0]   be;    // byte enables
  input   [31:0]  dain ;   // 32-bit input data
  input           DMWr ;    // memory write enable
  input           clk ;   // clock
  output  reg[31:0]  dout ;  // 32-bit memory output	
  
  input ue;
  
  reg[11:0] i;
	reg [31:0]  DMem[1023:0];
	reg [31:0]din;
	reg [3:0] be1;
	
	initial
	  for (i = 0; i < 1024; i = i + 1)
	    DMem[i] = 32'b0;
	
	always@(posedge clk)
	begin
	  #10
		if(DMWr)
		begin
		  din = dain;
		  for (i = 0; i < 4; i = i + 1)
		  begin
		    if (!be[i]) din = din << 8;
		    else i = i + 4;
		  end
        if (be[0]) DMem[addr[11:2]][7:0] <= din[7:0];
        if (be[1]) DMem[addr[11:2]][15:8] <= din[15:8];
        if (be[2]) DMem[addr[11:2]][23:16] <= din[23:16];
        if (be[3]) DMem[addr[11:2]][31:24] <= din[31:24];
    end
		$display("DMem:");
		for (i = 6'b0; i <= 6'h1F; i = i + 1)
		  $display("%d: %h", i, DMem[i]);
/*		  din = DMem[addr[11:2]];
		  be1 = 4'b0;
		  be1 = be;
		  for (i = 0; i < 4; i = i + 1)
		  begin
		    if (!be[i]) 
		    begin
		      din = din >> 8;
		      be1 = be1 >> 1;
		    end
		    else i = i + 4;
		  end
    if (be1[0]) dout[7:0] = din[7:0];
    if (be1[1]) dout[15:8] = din[15:8];
    else dout[15:8] = ue?0:{8{din[7]}};
    if (be1[2]) dout[23:16] = din[23:16];
    else dout[23:16] = ue?0:be1[1]?{8{din[15]}}:{8{din[7]}};
    if (be1[3]) dout[31:24] = DMem[addr[11:2]][31:24];
    else dout[31:24] = ue?0:be1[1]?{8{din[15]}}:{8{din[7]}};*/
    case (be)
      4'b0001: dout = ue? {{24{DMem[addr[11:2]][7]}}, DMem[addr[11:2]][7:0]}:{24'b0, DMem[addr[11:2]][7:0]};
      4'b0010: dout = ue? {{24{DMem[addr[11:2]][15]}}, DMem[addr[11:2]][15:8]}:{24'b0, DMem[addr[11:2]][15:8]};
      4'b0100: dout = ue? {{24{DMem[addr[11:2]][23]}}, DMem[addr[11:2]][23:16]}:{24'b0, DMem[addr[11:2]][23:16]};
      4'b1000: dout = ue? {{24{DMem[addr[11:2]][31]}}, DMem[addr[11:2]][31:24]}:{24'b0, DMem[addr[11:2]][31:24]};
      4'b0011: dout = ue? {{16{DMem[addr[11:2]][15]}}, DMem[addr[11:2]][15:0]}:{16'b0, DMem[addr[11:2]][15:0]};
      4'b1100: dout = ue? {{16{DMem[addr[11:2]][31]}}, DMem[addr[11:2]][31:16]}:{16'b0, DMem[addr[11:2]][31:16]};
      4'b1111: dout = DMem[addr[11:2]][31:0];
      default: dout = 32'b0;
    endcase
  end
endmodule