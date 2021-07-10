`timescale 1ns / 1ps
module DMEM(
    input clk,
    input ena,
    input DM_W,
    input DM_R,
    input DM_sign,
    input [2:0]DM_size,
    input [11:0] DM_addr,//10+2
    input [31:0] DM_wdata,
    output reg[31:0] DM_rdata
    );

    reg [31:0] D_mem[0:1023];
    //always @(posedge DM_W or DM_addr or DM_wdata) begin
    always @(posedge clk) 
    if(ena)begin
        if (DM_W) begin
            if(DM_size[0])//8
                case(DM_addr[1:0])
                    2'b00:D_mem[DM_addr[11:2]][7:0]<=DM_wdata[7:0];
                    2'b01:D_mem[DM_addr[11:2]][15:8]<=DM_wdata[7:0];
                    2'b10:D_mem[DM_addr[11:2]][23:16]<=DM_wdata[7:0];
                    2'b11:D_mem[DM_addr[11:2]][31:24]<=DM_wdata[7:0];
                endcase
            else if(DM_size[1])begin//16
                case(DM_addr[1])
                    1'b0:D_mem[DM_addr[11:2]][15:0]<=DM_wdata[15:0];
                    1'b1:D_mem[DM_addr[11:2]][31:16]<=DM_wdata[15:0];
                endcase
            end else if(DM_size[2])begin//32
                D_mem[DM_addr[11:2]]<=DM_wdata[31:0];
            end
        end else if(DM_R)begin
            if(DM_size[0])//8
                case(DM_addr[1:0])
                    2'b00: DM_rdata <= {DM_sign ? {24{D_mem[DM_addr[11:2]][7]}}:24'b0, D_mem[DM_addr[11:2]][7:0]};
                    2'b01: DM_rdata <= {DM_sign ? {24{D_mem[DM_addr[11:2]][15]}}:24'b0, D_mem[DM_addr[11:2]][15:8]};
                    2'b10: DM_rdata <= {DM_sign ? {24{D_mem[DM_addr[11:2]][23]}}:24'b0, D_mem[DM_addr[11:2]][23:16]};
                    2'b11: DM_rdata <= {DM_sign ? {24{D_mem[DM_addr[11:2]][31]}}:24'b0, D_mem[DM_addr[11:2]][31:24]};
                endcase
            else if(DM_size[1])begin//16
                case(DM_addr[1])
                    1'b0: DM_rdata <= {DM_sign ? {16{D_mem[DM_addr[11:2]][15]}}:16'b0, D_mem[DM_addr[11:2]][15:0]};
                    1'b1: DM_rdata <= {DM_sign ? {16{D_mem[DM_addr[11:2]][31]}}:16'b0, D_mem[DM_addr[11:2]][31:16]};
                endcase
            end else if(DM_size[2])begin//32
                DM_rdata <= D_mem[DM_addr[11:2]];
            end    
        end
    end
endmodule

