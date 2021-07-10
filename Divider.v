`timescale 1ns / 1ns
module Divider #(parameter t=100000000/2)(
    I_CLK,
    rst,
    O_CLK
    );
    integer i=0;
    
    input I_CLK;
    input rst;
    output reg O_CLK=0;
    
    always@(posedge I_CLK)
    begin
        if(rst)
        begin
            O_CLK<=0;
            i<=0;
        end
        else
        begin
            i<=i+1;
            if(i==t)
            begin
                O_CLK<=~O_CLK;
                i<=0;
            end
            else
                ;
        end
    end
endmodule
