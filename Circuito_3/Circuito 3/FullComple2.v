`timescale 1ns / 1ps

module FullComple2(A,Cin,cmp,R,Cout);
	input A,Cin,cmp;
	output wire R,Cout;
	
	wire opA;
	assign opA=A^cmp;
	
	assign R=opA^Cin;
	assign Cout=opA&Cin;
endmodule
