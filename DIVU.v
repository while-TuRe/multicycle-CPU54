`timescale 1ns / 1ps
module DIVU(
    input [31:0]dividend,   //被除数
    input [31:0]divisor,    //除数
    input ena,
    input start,
    input clock,
    input reset,    //heigh
    output wire[31:0]q, //商
    output wire[31:0]r,  //余数
    output reg busy
    );
    reg[31:0]Q,R;
    assign q=ena?Q:32'bz;
    assign r=ena?R:32'bz;
  
    reg [6:0]count;
    reg [63:0]tempa;
    reg [31:0]tempb;
    always@(posedge clock or posedge reset)
    begin
        if(reset | ~ena)
        begin
            Q<=32'b0;
            R<=32'b0;
            busy<=1'b0;
            count<=0;
        end
        else if(start)begin
            tempa<={32'b0,dividend};
            tempb<=divisor;
            count<=0;
            busy<=1;
        end else begin
            if(count>=32)
            begin
                busy<=0;
                R<=tempa[63:32];
                Q<=tempa[31:0];
            end else begin
                count =count+1;
                tempa ={tempa[62:0],1'b0};
                if(tempa[63:32]>=tempb)begin
                    tempa[63:32] =tempa[63:32]-tempb;
                    tempa[0] =1'b1;
                end else 
                    ;
            end
        end
    end
endmodule
