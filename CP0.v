`timescale 1ns / 1ps
//实现 break、syscall、teq 的异常跳转和 eret 的异常返回； 实现mfc0 mtc0读写
module CP0(
    input clk,  //时钟上升沿改变数据（下降沿改变PC）
    input rst,  //高电平进行复位
    input mfc0, // 指令为mfc0 高电平有效    读
    input mtc0, // 指令为mtc0 高电平有效    写
    input [31:0]pc,
    input [4:0] Rd,     // Reg Adress
    input [31:0] wdata, // 待写入数据
    input exception,    //异常发生信号
    input eret,         //指令为eret
    input [4:0]cause,   //异常原因
    output [31:0] rdata, // 传出读出数据
    output [31:0] status,//状态
    output [31:0]exc_addr // 异常发生地址
);

reg [31:0]cp0Reg[31:0];//CP0寄存器
parameter [4:0]STATUS=12, CAUSE=13, EPC=14;
//STATUS寄存器
parameter [4:0]IE=0, SYSCALL=1, BREAK=2, TEQ=3;
//CAUSE 寄存器
parameter [4:0]C_SYS = 5'b1000, C_BREAK = 5'b1001, C_TEQ = 5'b1101, C_ERET = 5'b0000;
/*
　　Register 12，Status，用于处理器状态的控制。置 0 时表示禁止或屏蔽中断
            本实验中将 status[3:1]定为中断屏蔽位，status[1] 屏蔽 systcall, status[2]屏蔽 break，status[3]屏蔽 teq，
            应中断异常时把 Status 寄存器的内容左移 5 位关中断，中断返回时再将 Status 寄存器右移 5 位恢复其内容
　　Register 13，Cause，这个寄存器体现了处理器异常发生的原因。
            cause[6:2]：异常类型号 'ExcCode' ，1000 为 systcall 异常，1001 为 break，1101 为 teq。
　　Register 14，EPC，这个寄存器存放异常发生时，系统正在执行的指令的地址。
*/
assign exc_addr = cp0Reg[EPC];              // 异常发生地址
assign status = cp0Reg[STATUS];             //状态
assign rdata = mfc0 ? cp0Reg[Rd] : 32'bz;   //读
/*
mfc0:由rd指定的协处理器0寄存器的内容被加载到rdata。
mtc0:将wdata写入rd指定的cp0寄存器
ERET 在中断、异常或错误陷阱处理完成时，ERET返回被中断的指令。ERET不执行下一条指令（即，它没有延迟槽）
*/
always @(posedge clk or posedge rst)begin
    if(rst)begin    //复位
        cp0Reg[0]<=32'b0;
        cp0Reg[1]<=32'b0;
        cp0Reg[2]<=32'b0;
        cp0Reg[3]<=32'b0;
        cp0Reg[4]<=32'b0;
        cp0Reg[5]<=32'b0;
        cp0Reg[6]<=32'b0;
        cp0Reg[7]<=32'b0;
        cp0Reg[8]<=32'b0;
        cp0Reg[9]<=32'b0;
        cp0Reg[10]<=32'b0;
        cp0Reg[11]<=32'b0;
        cp0Reg[STATUS]<=32'h1F;
        cp0Reg[13]<=32'h0;
        cp0Reg[14]<=32'b0;
        cp0Reg[15]<=32'b0;
        cp0Reg[16]<=32'b0;
        cp0Reg[17]<=32'b0;
        cp0Reg[18]<=32'b0;
        cp0Reg[19]<=32'b0;
        cp0Reg[20]<=32'b0;
        cp0Reg[21]<=32'b0;
        cp0Reg[22]<=32'b0;
        cp0Reg[23]<=32'b0;
        cp0Reg[24]<=32'b0;
        cp0Reg[25]<=32'b0;
        cp0Reg[26]<=32'b0;
        cp0Reg[27]<=32'b0;
        cp0Reg[28]<=32'b0;
        cp0Reg[29]<=32'b0;
        cp0Reg[30]<=32'b0;
        cp0Reg[31]<=32'b0;
    end else begin
        if(eret)//eret退出中断，status复位，
            cp0Reg[STATUS]={5'b0,cp0Reg[STATUS][31:5]};
        else if(mtc0)//写
            cp0Reg[Rd] = wdata[31:0];
        else if(exception && cp0Reg[STATUS][IE] && cp0Reg[STATUS][4:1]!=4'b0)begin//异常信号 break syscal teq
            cp0Reg[EPC]=pc;
            cp0Reg[STATUS]={cp0Reg[STATUS][26:0],5'b0};
            cp0Reg[CAUSE]={25'b0,cause[4:0],2'b0};
        end 
    else ; end   
end
endmodule
