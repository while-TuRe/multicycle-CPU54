`timescale 1ns / 1ps
module CLZ(
    input ena,
    input [31:0] A,
    output [5:0] R
    );
    //32=6'b100000;
    wire [4:0] r1,r2;
    CLZ16 clz16_1(.ena(ena), .A(A[31:16]),.R(r1));
    CLZ16 clz16_2(.ena(ena), .A(A[15:0]),.R(r2));
    assign R = r1[4] ? r2 + r1 : r1;
endmodule

module CLZ16(
    input ena,
    input [15:0]A,
    output [4:0]R
    );
    wire [3:0] r1,r2;
    CLZ8 clz8_1(.ena(ena), .A(A[15:8]), .R(r1));
    CLZ8 clz8_2(.ena(ena), .A(A[7:0]), .R(r2));
    assign R = r1[3] ? r2 + r1 : r1;
endmodule

module CLZ8(
    input ena,
    input [7:0]A,
    output [3:0]R
    );
    wire [2:0] r1,r2;
    CLZ4 clz4_1(.ena(ena), .A(A[7:4]), .R(r1));
    CLZ4 clz4_2(.ena(ena), .A(A[3:0]), .R(r2));
    assign R = r1[2] ? r2 + r1 : r1;
endmodule

module CLZ4(
    input ena,
    input [3:0]A,
    output [2:0]R
    );
    wire [1:0] r1,r2;
    CLZ2 clz2_1(.ena(ena), .A(A[3:2]), .R(r1));
    CLZ2 clz2_2(.ena(ena), .A(A[1:0]), .R(r2));
    assign R = r1[1] ? r2 + r1 : r1;
endmodule

module CLZ2(
    input ena,
    input [1:0]A,
    output [1:0]R
    );
    /*A:00  2=10
      A:01  1=01
      A:10/11 0=00
    */
    assign R = ena ? (A[1] ? 2'b00 : (A[0]? 2'b01:2'b10)) : 2'bz;
endmodule
