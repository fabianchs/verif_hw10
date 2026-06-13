`timescale 1ns / 1ps

module FullComple2inc(A,Cin,cmp,R);
	input A,Cin,cmp;
	output wire R;
	
	wire opA;
	assign opA=A^cmp;
	
	assign R=opA^Cin;
endmodule
