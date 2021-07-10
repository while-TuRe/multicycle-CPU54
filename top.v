`timescale 1ns / 1ps
module top(
    input clk_in,
    input reset,
    output [7:0]o_seg
    );
    wire clk_div;
    wire [31:0]pc,inst;
    wire [7:0]o_sel;//o_sel第几位显示数字
    seg7x16 seg(.clk(clk_div),.reset(reset),.cs(1'b1),.i_data(pc), .o_seg(o_seg),.o_sel(o_sel));
    Divider #(1) divider(.I_CLK(clk_in), .rst(reset), .O_CLK(clk_div));
    sccomp_dataflow uut(.clk_in(clk_div), .reset(reset), .inst(inst), .pc(pc));
endmodule
