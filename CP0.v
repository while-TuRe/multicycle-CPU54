`timescale 1ns / 1ps
//ʵ�� break��syscall��teq ���쳣��ת�� eret ���쳣���أ� ʵ��mfc0 mtc0��д
module CP0(
    input clk,  //ʱ�������ظı����ݣ��½��ظı�PC��
    input rst,  //�ߵ�ƽ���и�λ
    input mfc0, // ָ��Ϊmfc0 �ߵ�ƽ��Ч    ��
    input mtc0, // ָ��Ϊmtc0 �ߵ�ƽ��Ч    д
    input [31:0]pc,
    input [4:0] Rd,     // Reg Adress
    input [31:0] wdata, // ��д������
    input exception,    //�쳣�����ź�
    input eret,         //ָ��Ϊeret
    input [4:0]cause,   //�쳣ԭ��
    output [31:0] rdata, // ������������
    output [31:0] status,//״̬
    output [31:0]exc_addr // �쳣������ַ
);

reg [31:0]cp0Reg[31:0];//CP0�Ĵ���
parameter [4:0]STATUS=12, CAUSE=13, EPC=14;
//STATUS�Ĵ���
parameter [4:0]IE=0, SYSCALL=1, BREAK=2, TEQ=3;
//CAUSE �Ĵ���
parameter [4:0]C_SYS = 5'b1000, C_BREAK = 5'b1001, C_TEQ = 5'b1101, C_ERET = 5'b0000;
/*
����Register 12��Status�����ڴ�����״̬�Ŀ��ơ��� 0 ʱ��ʾ��ֹ�������ж�
            ��ʵ���н� status[3:1]��Ϊ�ж�����λ��status[1] ���� systcall, status[2]���� break��status[3]���� teq��
            Ӧ�ж��쳣ʱ�� Status �Ĵ������������� 5 λ���жϣ��жϷ���ʱ�ٽ� Status �Ĵ������� 5 λ�ָ�������
����Register 13��Cause������Ĵ��������˴������쳣������ԭ��
            cause[6:2]���쳣���ͺ� 'ExcCode' ��1000 Ϊ systcall �쳣��1001 Ϊ break��1101 Ϊ teq��
����Register 14��EPC������Ĵ�������쳣����ʱ��ϵͳ����ִ�е�ָ��ĵ�ַ��
*/
assign exc_addr = cp0Reg[EPC];              // �쳣������ַ
assign status = cp0Reg[STATUS];             //״̬
assign rdata = mfc0 ? cp0Reg[Rd] : 32'bz;   //��
/*
mfc0:��rdָ����Э������0�Ĵ��������ݱ����ص�rdata��
mtc0:��wdataд��rdָ����cp0�Ĵ���
ERET ���жϡ��쳣��������崦�����ʱ��ERET���ر��жϵ�ָ�ERET��ִ����һ��ָ�������û���ӳٲۣ�
*/
always @(posedge clk or posedge rst)begin
    if(rst)begin    //��λ
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
        if(eret)//eret�˳��жϣ�status��λ��
            cp0Reg[STATUS]={5'b0,cp0Reg[STATUS][31:5]};
        else if(mtc0)//д
            cp0Reg[Rd] = wdata[31:0];
        else if(exception && cp0Reg[STATUS][IE] && cp0Reg[STATUS][4:1]!=4'b0)begin//�쳣�ź� break syscal teq
            cp0Reg[EPC]=pc;
            cp0Reg[STATUS]={cp0Reg[STATUS][26:0],5'b0};
            cp0Reg[CAUSE]={25'b0,cause[4:0],2'b0};
        end 
    else ; end   
end
endmodule
