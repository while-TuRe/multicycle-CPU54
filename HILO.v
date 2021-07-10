`timescale 1ns / 1ps
module HILO(
    input clk,
    input wena,
    input rst,
    input[31:0] wdata,
    output[31:0]rdata
    );
    reg [31:0]data;
    always@(posedge clk or posedge rst)
        if(rst)
            data<=32'b0;
        else if(wena)
            data<=wdata;
    assign rdata=data;
endmodule
