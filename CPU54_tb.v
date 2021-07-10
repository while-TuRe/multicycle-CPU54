`timescale 1ns / 1ps
module CPU54_tb ();
    reg clk, rst;
    wire [31:0] inst;
    wire [31:0] pc;
    
//    wire [31:0] data;
//    assign data= uut.dmemory.D_mem[1];
//    wire DM_W,DM_R,DM_sign;
//    wire [2:0]DM_size;
//    wire [11:0]DM_addr;
//    wire [31:0]DM_rdata,DM_wdata,DM_reg;
//    assign DM_W = uut.dmemory.DM_W;
//    assign DM_R = uut.dmemory.DM_R;
//    assign DM_sign= uut.dmemory.DM_sign;
//    assign DM_size= uut.dmemory.DM_size;
//    assign DM_addr= uut.dmemory.DM_addr;
//    assign DM_rdata= uut.dmemory.DM_rdata;
//    assign DM_wdata= uut.dmemory.DM_wdata;
//    assign DM_reg = uut.dmemory.D_mem[DM_addr[11:2]];
//    wire t;
//    assign t=uut.dmemory.t;
//    wire [9:0]ad;
//    assign ad=uut.dmemory.ad;

//    assign DM_W = uut.DM_W;
//    assign DM_R = uut.DM_R;
//    assign DM_sign= uut.DM_sign;
//    assign DM_size= uut.DM_size;
//    assign DM_addr= uut.DM_addr;
//    assign DM_rdata= uut.DM_rdata;
//    assign DM_wdata= uut.DM_wdata;
//    assign DM_reg = uut.dmemory.D_mem[DM_addr[11:2]];
//    wire [31:0]jal_Res;
//    assign jal_Res = uut.sccpu.jal_Res;
    
//    wire [31:0]cp0_status;
//    assign cp0_status = uut.sccpu.cp0_status;
//    wire [63:0]z,mul_div;
//    assign z = uut.sccpu.mul.z;
//    assign mul_div = uut.sccpu.mul_div;
//    wire [31:0] R,Rd;
//    wire RF_W;
//    assign R=uut.sccpu.R;
//    assign Rd=uut.sccpu.Rd;
//    assign RF_W = uut.sccpu.RF_W;
//    wire [31:0]a,b;
//    assign a = uut.sccpu.mul.a;
//    assign b = uut.sccpu.mul.b;
//    wire [127:0]z128;
//    assign z128 = uut.sccpu.mul.uut.z;
//    wire [63:0]z64;
//    assign z64 = uut.sccpu.mul.uut.uut3.z;    //wire [4:0]status;
//    wire [31:0]z32;
//    assign z32 = uut.sccpu.mul.uut.uut3.uut3.z; 
//    wire [15:0]z16;
//    assign z16 = uut.sccpu.mul.uut.uut3.uut3.uut3.z; 
//    wire [7:0]z8;
//    assign z8 = uut.sccpu.mul.uut.uut3.uut3.uut3.uut3.z; 
//    assign status = uut.sccpu.status;

//    wire [31:0]r,q;
//    assign a=uut.sccpu.divu.dividend;
//    assign b=uut.sccpu.divu.divisor;
//    assign r=uut.sccpu.divu.r;
//    assign q=uut.sccpu.divu.q;
//    wire [31:0]Q,R;
//    wire ena,clock,busy,start;
//    assign Q = uut.sccpu.divu.Q;
   // assign reg_b = uut.sccpu.divu.reg_b;
//    assign R = uut.sccpu.divu.R;
//    assign ena = uut.sccpu.divu.ena;
//    assign clock = uut.sccpu.divu.clock;
//    assign busy = uut.sccpu.divu.busy;
//    assign start = uut.sccpu.divu.start;
//    wire [63:0]tempa;
//    wire [31:0]tempb;
//    assign tempa = uut.sccpu.divu.tempa;
//    assign tempb=uut.sccpu.divu.tempb;
//    wire [6:0]count;
//    assign count = uut.sccpu.divu.count;
//    wire[31:0] divr,divur,mulr,multur;
//    assign divr=uut.sccpu.div.r;
//    assign divur =uut.sccpu.divu.r;
//    assign mulr =  uut.sccpu.mul.z;
//    assign multur = uut.sccpu.multu.z;
//    wire[31:0] HI,LO;
//    assign HI= uut.sccpu.hi.data;
//    assign LO= uut.sccpu.lo.data;
//    assign HI_wdata = uut.sccpu.HI_wdata;
//    assign HI_rdata= uut.sccpu.HI_rdata;
//    wire [31:0]cp00;
//    assign cp00 = uut.sccpu.cp0.cp0Reg[0];
    sccomp_dataflow uut(.clk_in(clk), .reset(rst), .inst(inst), .pc(pc));
    integer  file_output;
    initial #3000;
    initial begin
        file_output = $fopen("D:/Source/vivado/CPU54/output.txt");
        clk = 0;
        rst = 1;
        #1 rst = 0;
        
    end
    always  #1 clk = ~clk;
    always@(inst)
    begin
        $fdisplay(file_output, "pc: %h", pc);
        $fdisplay(file_output, "instr: %h", inst);
        //$fdisplay(file_output,"cp0Reg0:%h",uut.sccpu.cp0.cp0Reg[0]);
//        $fdisplay(file_output, "HI:%h LO:%h R:%h",
//         uut.sccpu.hi.data, uut.sccpu.lo.data, uut.sccpu.R);
//        $fdisplay(file_output,"div:%h divu:%h mul:%h mult:%h",
//        uut.sccpu.div.r, uut.sccpu.divu.r, uut.sccpu.mul.z, uut.sccpu.multu.z);
//        $fdisplay(file_output,"div_mul %h",uut.sccpu.mul_div);
        //$fdisplay(file_output, "inst1: %h addr %h", uut.inst1,uut.im_addr[13:2]);
       
        //$fdisplay(file_output,"clz_Res %h R %h clz: %h Rd %h,RF_W %b",uut.sccpu.clz_Res, uut.sccpu.R,uut.sccpu.clz_, uut.sccpu.Rd,uut.sccpu.RF_W);
       // $fdisplay(file_output,"clz_Res %h R %h mul_ %h mfc0_ %h  mthi: %h mtlo: %h clz: %h ",uut.sccpu.clz_Res, uut.sccpu.R, uut.sccpu.mul_, uut.sccpu.mfc0_, uut.sccpu.mthi_, uut.sccpu.mtlo_, uut.sccpu.clz_);
        //$fdisplay(file_output,"Res: %h R: %h mthi: %h mtlo: %h clz: %h alu_ena: %h",uut.sccpu.Res,uut.sccpu.R, uut.sccpu.mthi_, uut.sccpu.mtlo_,uut.sccpu.clz_,uut.sccpu.alu_ena);
    //    $fdisplay(file_output,"X: %h Y: %h A: %h B: %h",uut.sccpu.X, uut.sccpu.Y, uut.sccpu.A, uut.sccpu.B);
    //    $fdisplay(file_output,"tmp: %h, beq: %h res: %h",uut.sccpu.tmp, uut.sccpu.beq_, uut.sccpu.Res);
        //$fdisplay(file_output,"dm_addr: %h , dm_wdata: %h , dm_rdata: %h ",uut.sccpu.DM_addr, uut.sccpu.DM_wdata, uut.sccpu.DM_rdata);
    //    $fdisplay(file_output, "ALUC: %h Raddr: %h R: %h Res:%h A; %h B: %h addi_: %h RF_W: %h",
    //    uut.sccpu.ALUC, uut.sccpu.Rd, uut.sccpu.R, uut.sccpu.Res, uut.sccpu.A, uut.sccpu.B, uut.sccpu.addi_, uut.sccpu.RF_W);
    //    $fdisplay(file_output, "RegFile: Rdc: %h Rd: %h ",uut.sccpu.cpu_ref.Rdc, uut.sccpu.cpu_ref.Rd);
    //    $fdisplay(file_output, "condition RF_rst: %h RF_ena: %h",uut.sccpu.cpu_ref.RF_rst, uut.sccpu.cpu_ref.RF_ena);
         //$fdisplay(file_output,"Y %h DM_wdata %h DM_addr %h DM_W %b DM_size %h",uut.sccpu.Y, uut.sccpu.DM_wdata, uut.sccpu.DM_addr,uut.sccpu.DM_W ,uut.sccpu.DM_size);
       //  $fdisplay(file_output,"dmem DM_wdata %h ena %h DM_W:%h size[2] %h dm_addr:%h",uut.sccpu.dmemory.DM_wdata, uut.sccpu.dmemory.ena, uut.sccpu.dmemory.DM_W, uut.sccpu.dmemory.size[2], uut.sccpu.dmemory.DM_addr[11:2]);
    //     $fdisplay(file_output, "dmem0: %h", uut.scinteger filecpu.dmemory.D_mem[0]);
    //     $fdisplay(file_output, "dmem1: %h", uut.sccpu.dmemory.D_mem[1]);
    //     $fdisplay(file_output, "dmem2: %h", uut.sccpu.dmemory.D_mem[2]);
    //     $fdisplay(file_output, "dmem3: %h", uut.sccpu.dmemory.D_mem[3]);
        //$fdisplay(file_output,"dmem DM_rdata %h R:%h",uut.sccpu.dmemory.DM_rdata,uut.sccpu.R);
        $fdisplay(file_output, "regfile0: %h", uut.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_output, "regfile1: %h", uut.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_output, "regfile2: %h", uut.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_output, "regfile3: %h", uut.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_output, "regfile4: %h", uut.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_output, "regfile5: %h", uut.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_output, "regfile6: %h", uut.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_output, "regfile7: %h", uut.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_output, "regfile8: %h", uut.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_output, "regfile9: %h", uut.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_output, "regfile10: %h", uut.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_output, "regfile11: %h", uut.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_output, "regfile12: %h", uut.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_output, "regfile13: %h", uut.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_output, "regfile14: %h", uut.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_output, "regfile15: %h", uut.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_output, "regfile16: %h", uut.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_output, "regfile17: %h", uut.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_output, "regfile18: %h", uut.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_output, "regfile19: %h", uut.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_output, "regfile20: %h", uut.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_output, "regfile21: %h", uut.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_output, "regfile22: %h", uut.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_output, "regfile23: %h", uut.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_output, "regfile24: %h", uut.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_output, "regfile25: %h", uut.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_output, "regfile26: %h", uut.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_output, "regfile27: %h", uut.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_output, "regfile28: %h", uut.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_output, "regfile29: %h", uut.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_output, "regfile30: %h", uut.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_output, "regfile31: %h", uut.sccpu.cpu_ref.array_reg[31]);
    end

endmodule