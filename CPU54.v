`timescale 1ns / 1ps
//`define AKL  1
module CPU54(
    input clk,
    input ena,
    input rst,
    input [31:0] IM_inst,
    input [31:0] DM_rdata,
    output reg[31:0]pc, //指令位
    //Data Memory 参数
    output DM_W,
    output DM_R,
    output DM_sign,
    output [2:0]DM_size,
    output reg [11:0] DM_addr,
    output reg [31:0] DM_wdata
    );

    //指令类型
   // reg [31:0] IM_inst;
    reg[31:0]PC;
    wire [5:0]OP,func;
    assign OP = IM_inst[31:26];//RIJ指令类型
    assign func =  IM_inst[5:0];
    
    wire add_, addu_, sub_, subu_, and_, or_, xor_, nor_;
    wire slt_, sltu_, sll_, srl_, sra_, sllv_, srlv_, srav_;
    wire addi_, addiu_, andi_, ori_, xori_;
    wire slti_, sltiu_, lui_, clz_;
    wire j_, jr_,jal_,jalr_, beq_, bne_, bgez_;
    wire mul_, multu_, div_, divu_;
    wire lw_, sw_, lh_, lhu_, sh_, lb_, lbu_, sb_, mthi_, mfhi_, mtlo_, mflo_;
    wire eret_,mfc0_, mtc0_, syscall_, teq_, break_;
    
    reg div_start;
    wire div_busy;
    wire ZF, SF, CF, OF,alu_ena;    //ALU标志位
    wire [3:0] ALUC;    //ALU控制位，区分不同运算
    reg [31:0]A,B;
    wire [31:0]Res;//ALU的两个操作数
    
    //从寄存器中得到新操作数
    reg [4:0] Xd, Yd,Rd;       //寄存器地址
    wire [31:0] X, Y;     //寄存器值
    wire[31:0]R;
    reg RF_W;  //是否写入答案（仅时钟上升沿）
    
    reg [4:0]status;
    
    wire[31:0]HI_wdata,LO_wdata,HI_rdata,LO_rdata;    
    wire[63:0]mul_div;
    wire [5:0]clz_Res;
    reg [31:0]jal_Res;

    RegFile cpu_ref(
        .RF_ena(ena),
        .RF_rst(rst),
        .RF_clk(clk),
        .Rsc(Xd),
        .Rtc(Yd),
        .Rdc(Rd),
        .Rs(X),
        .Rt(Y),
        .Rd(R),
        .RF_W(RF_W)
    );
    
    //HILO
    HILO hi(.clk(clk), .wena(multu_|div_|divu_|mthi_), .rst(rst), .wdata(HI_wdata), .rdata(HI_rdata));
    HILO lo(.clk(clk), .wena(multu_|div_|divu_|mtlo_), .rst(rst), .wdata(LO_wdata), .rdata(LO_rdata));
    
    //CP0
    parameter [4:0]C_SYS = 5'b1000, C_BREAK = 5'b1001, C_TEQ = 5'b1101, C_ERET = 5'b0000;
    parameter [31:0]ACCIDENT=32'h00400004;
    parameter [4:0]IE=0, SYSCALL=1, BREAK=2, TEQ=3;//STATUS寄存器
    wire [4:0]cp0_cause;
    assign cp0_cause=syscall_? C_SYS : (break_ ? C_BREAK :(teq_ ? C_TEQ : (eret_ ?  C_ERET :5'bz)));
    wire [31:0]cp0_Res,cp0_addr,cp0_status;
    CP0 cp0(
    .clk(clk),  //时钟上升沿改变数据（下降沿改变PC）
    .rst(rst),  //高电平进行复位
    .mfc0(mfc0_), // 指令为mfc0 高电平有效    读
    .mtc0(mtc0_), // 指令为mtc0 高电平有效    写
    .pc(PC),
    .Rd(IM_inst[15:11]),     // Reg Adress
    .wdata(Y), // 待写入数据
    .exception(break_|syscall_|teq_),    //异常发生信号
    .eret(eret_),         //指令为eret
    .cause(cp0_cause),   //异常原因4:0
    .rdata(cp0_Res), // 传出读出数据
    .status(cp0_status),//状态
    .exc_addr(cp0_addr) // 异常发生地址
    );    
    //指令执行周期        获取信息+执行+更新状态
    always@(posedge clk or posedge rst)begin
        if (rst) begin
            PC <= 32'h00400000;
            status <=5'b00001;
            RF_W<=0;
        end else if(status[0])begin
            //IM_inst <= inst;
            pc<=PC;
            PC<=PC+4;
            status <= 5'b00010;
            RF_W<=0;
        end else if(status[1])begin
            Xd <= IM_inst[25:21];//取出3个R型指令操作数地址
            Yd <= IM_inst[20:16];       
            //Rd
            if(jal_)
                Rd<=31;
            else if (OP && !(clz_|mul_))
                Rd<=IM_inst[20:16];  // I|sw mfc0_ lw lui等
            else
                Rd<=IM_inst[15:11];//R jalr mfhi mfc0   mul
                //mfc0 OP!=0 rt,rd Reg[前]=Cp0[后] Reg[rt]=Cp0[rd]
            //RF_W
            if(jal_|jalr_|mfhi_|mflo_|mfc0_)
                RF_W<=1;
            else
                RF_W<=0;
               
            //status
            if(j_)
                status<=5'b00001;
            else if(mfc0_|mfhi_|mflo_|jal_) 
                status <=5'b10000;
            else
                status <= 5'b00100;     
                
            //处理跳转PC   
            if(j_|jal_)begin
                PC <= {PC[31:28],IM_inst[25:0],2'b0};//4+26+2
            end
            if(jal_|jalr_)
                jal_Res<=PC;
        end else if(status[2])begin//T3
            if(jr_|beq_|bne_|bgez_|break_|syscall_|teq_|eret_)
                status <=5'b00001;
            else if(lw_|lh_|lhu_|lb_|lbu_|div_|divu_|mul_)
                status<=5'b01000;
            else
                status<=5'b10000;
                
            //ALU等运算
            //对两个操作数赋值
            if(sll_ | srl_ | sra_)//是否是shamt命令
                A<={23'b0,IM_inst[10:6]};
            else 
                A <= X;
            if(OP==0| beq_ |bne_|mul_)
                B<=Y;
            else if(addi_ |addiu_| slti_ | sltiu_ )//有符号数，进行有符号拓展
                B<={{16{IM_inst[15]}},IM_inst[15:0]};
            else
                B<={16'b0,IM_inst[15:0]};
            //其他非运算数操作
            div_start<=1;
            if( break_| syscall_ | teq_ )
                PC<=ACCIDENT;
            else if((beq_&(X==Y)) | (bne_ & (X!=Y)) | (bgez_ & ~X[31]))
                // if (rs == rt) PC <- PC+4 + (sign-extend)immediate<<2 
                PC <= PC + {{14{IM_inst[15]}},IM_inst[15:0],2'b0};
            else if(jr_)
                PC<=X;
            else if(eret_)
                PC<=cp0_addr;
//            else if(mthi_)
//                HI<=X;
//            else if(mtlo_)
//                LO<=X;
            else if(lw_|sw_|lh_|lhu_|sh_|lb_|lbu_|sb_)begin
                DM_addr<=X + {{16{IM_inst[15]}},IM_inst[15:0]}- 32'h10010000;
                if(sw_|sh_|sb_)
                    DM_wdata<=Y;
            end
            
            //RF_W
            if(alu_ena|mul_|mfc0_|clz_)
                RF_W<=1;                
            else 
                RF_W<=0;               
        end else if(status[3])begin//只有 l*_
            status <= 5'b10000;
            div_start<=0;
            if((div_|divu_)&~div_busy)
                status<=5'b10000;
            else
                RF_W<=1; //|lw_|lh_|lhu_|lb_|lbu_|mul_
        end else if(status[4])begin//写入寄存器、DATAMEM
            status <= 5'b00001;
            if(jalr_)
                PC<=X;
            RF_W<=0;
        end 
    end
    assign HI_wdata= multu_|div_|divu_?
                    mul_div[63:32]:(
                mthi_?
                    X:
                    32'bz);
    assign LO_wdata= multu_|div_|divu_?
                    mul_div[31:0]:(
                mtlo_?
                    X:
                    32'bz);

    assign R = lw_|lh_|lhu_|lb_|lbu_ ?
               DM_rdata:(
           jal_|jalr_?
                jal_Res:
           mul_?
               mul_div[31:0]:(
           mfc0_?
               cp0_Res:(
           mfhi_?
               HI_rdata:(
           mflo_?
               LO_rdata:(
           clz_?
               {26'b0,clz_Res}:(
           alu_ena?
                Res:
                32'bz))))));
    ALU alu(
        .a(A),
        .b(B),
        .r(Res),
        .aluc(ALUC),
        .ena(ena & alu_ena),
        .zero(ZF),  // 0 is true, others are false
        .carry(CF), // unsigned cf
        .negative(SF), // 1 is false, 0 is true
        .overflow(OF) // signed of
    );
    wire div_busy1,div_busy2;
    assign div_busy = div_busy1|div_busy2;
    DIV div(
    .dividend(A),
    .divisor(B),
    .start(div_start),
    .ena(div_),
    .clock(clk),
    .reset(rst),
    .q(mul_div[31:0]),   //商
    .r(mul_div[63:32]),   //余数
    .busy(div_busy1)
    );
    DIVU divu(
    .dividend(A),
    .divisor(B),
    .start(div_start),
    .ena(divu_),
    .clock(clk),
    .reset(rst),
    .q(mul_div[31:0]),   //商
    .r(mul_div[63:32]),   //余数
    .busy(div_busy2)
    );
    MULTU multu(
    .clk(clk),
    .reset(rst),
    .ena(multu_),
    .a(A),
    .b(B),
    .z(mul_div)
    );
    MULT mul(
    .clk(clk),
    .reset(rst),
    .ena(mul_),
    .a(A),
    .b(B),
    .z(mul_div)
    );
    CLZ clz(
    .ena(clz_),
    .A(A),
    .R(clz_Res)
    );
    assign add_ = (OP == 0 && func == 6'b100_000);
    assign addu_ = (OP == 0 && func == 6'b100_001);
    assign sub_ = (OP == 0 && func == 6'b100_010);
    assign subu_ = (OP == 0 && func == 6'b100_011);
    assign and_ = (OP == 0 && func == 6'b100_100);
    assign or_ = (OP == 0 && func == 6'b100_101);
    assign xor_ = (OP == 0 && func == 6'b100_110);
    assign nor_ = (OP == 0 && func == 6'b100_111);
    assign slt_ = (OP == 0 && func == 6'b101_010);
    assign sltu_ = (OP == 0 && func == 6'b101_011);
    assign sll_ = (OP == 0 && func == 6'b000_000);
    assign srl_ = (OP == 0 && func == 6'b000_010);
    assign sra_ = (OP == 0 && func == 6'b000_011);
    assign sllv_ = (OP == 0 && func == 6'b000_100);
    assign srlv_ = (OP == 0 && func == 6'b000_110);
    assign srav_ = (OP == 0 && func == 6'b000_111);
    assign jr_ = (OP == 0 && func == 6'b001_000);
    
    assign addi_ = (OP == 6'b001_000);
    assign addiu_ = (OP == 6'b001_001);
    assign andi_ = (OP == 6'b001_100);
    assign ori_ = (OP == 6'b001_101);
    assign xori_ = (OP == 6'b001_110);

    assign beq_ = (OP == 6'b000_100);
    assign bne_ = (OP == 6'b000_101);
    assign bgez_ = (OP == 6'b000001);
    assign slti_ = (OP == 6'b001_010);
    assign sltiu_ = (OP == 6'b001_011);
    assign lui_ = (OP == 6'b001_111);

    assign j_ = (OP == 6'b000_010);
    assign jal_ = (OP==6'b000_011);
    assign jalr_ = (OP==6'b000000 && func == 6'b001_001);
                
    assign mul_ = (OP==6'b011_100 && func == 6'b000_010);
    assign multu_ =(OP==6'b0 && func==6'b011_001);
    assign div_ = (OP==6'b0 && func == 6'b011_010);
    assign divu_ = (OP==6'b0 && func == 6'b011_011);
    assign clz_ = (OP == 6'b011_100 && func == 6'b100_000);
    
    assign eret_ = (OP == 6'b010000 && func == 6'b011_000);
    assign syscall_ = (OP == 6'b0 && func == 6'b001100);
    assign break_ = (OP== 6'b0 && func == 6'b001101);
    assign teq_ = (OP==6'b0 && func == 6'b110100);
    assign mfc0_ = (OP==6'b010000 && IM_inst[25:21] == 5'b00000);
    assign mtc0_ = (OP==6'b010000 && IM_inst[25:21] == 5'b00100);
    assign mfhi_ = (OP==6'b0 && func == 6'b010000);
    assign mthi_ = (OP==6'b0 && func == 6'b010001);
    assign mflo_ = (OP==6'b0 && func == 6'b010010);
    assign mtlo_ = (OP==6'b0 && func == 6'b010011);
        
    assign lw_ = (OP == 6'b100_011);
    assign sw_ = (OP == 6'b101_011);
    assign lh_ = (OP == 6'b100_001);
    assign lhu_ = (OP== 6'b100_101);
    assign sh_ = (OP == 6'b101_001);
    assign lb_ = (OP == 6'b100_000);
    assign lbu_ = (OP == 6'b100_100);
    assign sb_ = (OP == 6'b101_000);

    assign ALUC[0] = subu_ | sub_| beq_|bne_|teq_| or_ |ori_| nor_ | slt_ | slti_ | srl_ | srlv_;
    assign ALUC[1] = add_ | addi_ | sub_ | beq_|bne_|teq_| xor_ | xori_ | nor_ | slt_ | slti_ | sltu_ | sltiu_ | sll_ | sllv_;
    assign ALUC[2] = and_ | andi_ | or_ | ori_ |xor_ | xori_ |nor_ | sra_|srav_ | sll_ |sllv_|srl_|srlv_;
    assign ALUC[3] = lui_|slt_|slti_|sltu_|sltiu_|sra_|srav_|sll_|sllv_|srl_|srlv_;
    
    assign alu_ena = addi_ | addiu_ | andi_ | ori_ | sltiu_ | lui_ | xori_ | slti_ | addu_ | 
                     and_ | xor_ | nor_ | or_ | sll_ | sllv_ | sltu_ | sra_ | 
                     srl_ | subu_ | add_ | sub_ | slt_ | srlv_ | srav_; 
                 
    //data memory 操作
    assign DM_R=lw_|lh_|lhu_|lb_|lbu_;
    assign DM_W=sw_|sh_|sb_;
    assign DM_sign=lw_|lh_|lb_;
    assign DM_size={lw_|sw_, lh_|lhu_|sh_, lb_|lbu_|sb_};
endmodule

