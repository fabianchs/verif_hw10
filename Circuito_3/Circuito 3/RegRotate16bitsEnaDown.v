`timescale 1ns / 1ps

module RegRotate16bitsEnaDown(CLK,RST,ENA,SEL,D,Q);
	input CLK,RST,ENA;
	input D;
	input [3:0] SEL;
	output wire [15:0] Q;
	
	wire [15:0] WR;
	
	RomRegRotate16bits RomSel(SEL,WR);
	
	Reg1bitEnaDown Q0(CLK,RST,ENA&WR[0],D,Q[15]);
	Reg1bitEnaDown Q1(CLK,RST,ENA&WR[1],D,Q[14]);
	Reg1bitEnaDown Q2(CLK,RST,ENA&WR[2],D,Q[13]);
	Reg1bitEnaDown Q3(CLK,RST,ENA&WR[3],D,Q[12]);
	Reg1bitEnaDown Q4(CLK,RST,ENA&WR[4],D,Q[11]);
	Reg1bitEnaDown Q5(CLK,RST,ENA&WR[5],D,Q[10]);
	Reg1bitEnaDown Q6(CLK,RST,ENA&WR[6],D,Q[9]);
	Reg1bitEnaDown Q7(CLK,RST,ENA&WR[7],D,Q[8]);
	Reg1bitEnaDown Q8(CLK,RST,ENA&WR[8],D,Q[7]);
	Reg1bitEnaDown Q9(CLK,RST,ENA&WR[9],D,Q[6]);
	Reg1bitEnaDown Q10(CLK,RST,ENA&WR[10],D,Q[5]);
	Reg1bitEnaDown Q11(CLK,RST,ENA&WR[11],D,Q[4]);
	Reg1bitEnaDown Q12(CLK,RST,ENA&WR[12],D,Q[3]);
	Reg1bitEnaDown Q13(CLK,RST,ENA&WR[13],D,Q[2]);
	Reg1bitEnaDown Q14(CLK,RST,ENA&WR[14],D,Q[1]);
	Reg1bitEnaDown Q15(CLK,RST,ENA&WR[15],D,Q[0]);
			
endmodule
