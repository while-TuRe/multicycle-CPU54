`timescale 1ns / 1ns
module ALU(
    input [31:0] a, //������
    input [31:0] b,
    input [3:0] aluc, //����ģ��Ĳ���
    input ena,
    output reg [31:0] r=32'b0, //��a b ���� aluc ָ����������
    output reg zero=0,  //0��־λ ����
    output reg carry=0, //��λ��־λ �޷��żӼ��Ⱥ���λ
    output reg negative=0, //������־λ ����
    output reg overflow=0 //�����־λ �з��żӼ��� 
    );
    
    always@(*)
    if(ena)begin 
        casex (aluc)
            4'b0000:  //ADDU ADDUI
                {carry,r}={1'b0,a}+{1'b0,b};     
            4'b0010: //ADD ADDI
                //overflow=1 ���λ�ʹθ�λ��λ״̬��ͬ
                begin
                {overflow,r}={1'b0,a}+{1'b0,b};
                overflow = a[31]^b[31]^r[31]^overflow;
                end
            4'b0001: //SUBU
                begin
                {carry,r}={1'b1,a}-{1'b0,b};
                carry=~carry;
                end
            4'b0011://SUB BEQ BEN
                begin
                r=a-b;//-  + = +��+  - = -
                overflow=(b!={1'b1,30'b0,1'b1}) ? a[31]^b[31] & a[31]^ r[31] : ~a[31]&&a;
                end
            4'b0100://AND ANDI
                r = a & b;
            4'b0101://OR ORI
                r = a | b;
            4'b0110://XOR XORI
                r = a ^ b;  
            4'b0111://NOR
                r = ~(a | b);
            4'b100x://LUI�ø�λ������
                r={b[15:0],16'b0};
            4'b1011://SLT SLTI 
                begin
                r=a-b;//-  + = +��+  - = -
                if(r==32'b0)
                    zero=1;
                else
                    zero=0;
                if(a[31]^b[31] && a[31]^ r[31])begin//if(overflow)
                    negative=a[31];
                end else begin
                    negative=r[31]; 
                end 
                r=negative;
                end
            4'b1010://SLTU SLTIU
                begin
                {carry,r}={1'b1,a}-{1'b0,b};
                if(r==32'b0)
                    zero=1;
                else
                    zero=0;            
                carry = ~carry;//carry=r,��a-b<0 ʱΪ1
                r = carry;
                end
            4'b1100://SRA SRAV
                {r,carry} = b[31] ? ~(~{b,1'b0} >> a): {b,1'b0}>>a;
            4'b111x://SLL SLLV
                {carry,r} = {1'b0,b} << a;
            4'b1101://SRL SRLV
                {r,carry} = {b,1'b0} >> a;
        endcase
        
        if(aluc!=4'b101x)
            if(r==32'b0)
                zero = 1;
            else 
                zero = 0;
        else
            ;
                
        if(aluc != 4'b101x)
            negative = r[31];
        else
            ;
    end else
        r=32'bz;
endmodule
