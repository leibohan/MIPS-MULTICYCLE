module mips_tb();
    `timescale  1ns/1ps
    reg clk;
    reg PcReSet;
    wire [31:0]pc;
    wire [31:0]ins;
    integer i;
    initial
    begin
        clk=0;
        PcReSet = 0;
        PcReSet = 1;
        #150
        PcReSet = 0;
    end
    always
    begin
        #50 clk<=~clk;
        if (clk)
        begin
            $display("PC: %h",pc);
            $display("Instruction: %b",ins);
            $display();
        end
    end
    mips my_mips(clk,PcReSet,pc,ins);
endmodule