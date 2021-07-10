`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
);
    wire [31:0] im_addr;
    assign im_addr = pc - 32'h0040_0000;
    wire DM_W,DM_R,DM_sign;
    wire [2:0]DM_size;
    wire [11:0]DM_addr;
    wire [31:0]DM_rdata,DM_wdata;
    IMEM imemory(
       .addr(im_addr[12:2]),
       .inst(inst) // output
    );
    DMEM dmemory(
   .clk(clk_in), .ena(DM_W|DM_R), .DM_W(DM_W), .DM_R(DM_R), .DM_sign(DM_sign), .DM_size(DM_size), .DM_addr(DM_addr), 
   .DM_wdata(DM_wdata), .DM_rdata(DM_rdata)
    );
    CPU54 sccpu(
       .clk(clk_in), .ena(1'b1),.rst(reset), .DM_rdata(DM_rdata), .IM_inst(inst), .pc(pc),
        .DM_W(DM_W), .DM_R(DM_R), .DM_sign(DM_sign), .DM_size(DM_size), .DM_addr(DM_addr),  .DM_wdata(DM_wdata)
    );
endmodule
