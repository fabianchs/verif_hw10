`timescale 1ns / 1ps

module RomDecComp(op,A15,A7,B15,B7,D15,CA,c2inA,c2inB,c2out);	
	input [3:0] op;
	input A15,A7,B15,B7,D15;
	output wire CA,c2inA,c2inB,c2out;
	
	wire I,Mu,Di,N8,N16,MD,NI;
	assign I=op[1];
	assign Mu=~op[3]&~op[2];
	assign Di=~op[3]&op[2];
	assign N8=~op[0];
	assign N16=op[0];
	assign MD=~op[3];
	assign NI=op[3]&~op[2];
	
	assign c2inA=(I&((Mu&((A15&N16)|(A7&N8)))|(Di&((D15&N16)|(A15&N8)))))|NI;
	
	assign c2inB=I&(MD)&
						((B15&N16)|(B7&N8));
	
	assign CA=(MD&(I&((Mu&((A15&N16)|(A7&N8)))|(Di&((D15&N16)|(A15&N8))))))|(NI&op[0]);
	
	assign c2out=MD&(c2inA^c2inB);
	
endmodule
