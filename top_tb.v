`timescale 1ns / 1ps
module top_tb();
    reg clk,reset;
    wire [7:0]seg;
    top top_md(.clk_in(clk),.reset(reset),.o_seg(seg));
    initial begin
        clk<=0;
        reset<=1;
        #20 reset=0;
    end
    always #1 clk=~clk;
    
    wire [31:0]pc,scc_pc;
    wire [7:0]o_seg;
    assign pc=top_md.pc;
    assign o_seg=t.seg.o_seg;
    wire clk_div,scc_rst;
    assign clk_div = top_md.clk_div;
    assign scc_pc = top_md.uut.pc;
    assign scc_rst = top_md.uut.reset;
endmodule
