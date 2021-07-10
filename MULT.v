`timescale 1ns / 1ps
module MULT(
    input clk,
    input reset,
    input ena,
    input [31:0]a,
    input [31:0]b,
    output [63:0]z
    );
    wire [63:0]aa,bb;
    wire [127:0]zz;
    assign aa={{32{a[31]}},a};
    assign bb={{32{b[31]}},b};
    MULTU64 uut(clk,reset,ena,aa,bb,zz);
    assign z = zz[63:0];
endmodule

module MULTU64(
    input clk,
    input reset,
    input ena,
    input [63:0]a,
    input [63:0]b,
    output [127:0]z
    );
    wire [63:0]afbf,afbb,abbf,abbb;
    MULTU uut0(clk,reset,ena,a[63:32],b[63:32],afbf);
    MULTU uut1(clk,reset,ena,a[63:32],b[31:0],afbb);
    MULTU uut2(clk,reset,ena,a[31:0],b[63:32],abbf);
    MULTU uut3(clk,reset,ena,a[31:0],b[31:0],abbb);
    assign z = ena? ({afbf,64'b0}+{32'b0,afbb,32'b0}+{32'b0,abbf,32'b0}+{64'b0,abbb}) :128'bz;
endmodule

module MULTU(
    input clk,
    input reset,
    input ena,
    input [31:0]a,
    input [31:0]b,
    output [63:0]z
    );
    wire [31:0]afbf,afbb,abbf,abbb;
    MULTU16 uut0(clk,reset,a[31:16],b[31:16],afbf);
    MULTU16 uut1(clk,reset,a[31:16],b[15:0],afbb);
    MULTU16 uut2(clk,reset,a[15:0],b[31:16],abbf);
    MULTU16 uut3(clk,reset,a[15:0],b[15:0],abbb);
    assign z = ena?({afbf,32'b0}+{16'b0,afbb,16'b0}+{16'b0,abbf,16'b0}+{32'b0,abbb}) : 64'bz;
endmodule
module MULTU16(
    input clk,
    input reset,
    input [15:0]a,
    input [15:0]b,
    output [31:0]z
    );
    wire [15:0]afbf,afbb,abbf,abbb;
    MULTU8 uut0(clk,reset,a[15:8],b[15:8],afbf);
    MULTU8 uut1(clk,reset,a[15:8],b[7:0],afbb);
    MULTU8 uut2(clk,reset,a[7:0],b[15:8],abbf);
    MULTU8 uut3(clk,reset,a[7:0],b[7:0],abbb);
    assign z = {afbf,16'b0}+{8'b0,afbb,8'b0}+{8'b0,abbf,8'b0}+{16'b0,abbb};
endmodule

module MULTU8(
    input clk,
    input reset,
    input [7:0]a,
    input [7:0]b,
    output [15:0]z
    );
    wire [7:0]afbf,afbb,abbf,abbb;
    MULTU4 uut0(clk,reset,a[7:4],b[7:4],afbf);
    MULTU4 uut1(clk,reset,a[7:4],b[3:0],afbb);
    MULTU4 uut2(clk,reset,a[3:0],b[7:4],abbf);
    MULTU4 uut3(clk,reset,a[3:0],b[3:0],abbb);
    assign z = {afbf,8'b0}+{4'b0,afbb,4'b0}+{4'b0,abbf,4'b0}+{8'b0,abbb};
endmodule

module MULTU4(
    input clk,
    input reset,
    input [3:0]a,
    input [3:0]b,
    output [7:0]z
    );
    reg [7:0]temp0,temp1,temp2,temp3,add1,add2;
    always@(posedge clk)
    begin
        temp0 <= b[0] ? {4'b0,a} :8'b0;
        temp1 <= b[1] ? {3'b0,a,1'b0} :8'b0;
        temp2 <= b[2] ? {2'b0,a,2'b0} :8'b0;
        temp3 <= b[3] ? {1'b0,a,3'b0} :8'b0;
    end
    assign z = reset ? 8'b0 : temp0+temp1+temp2+temp3;
endmodule
