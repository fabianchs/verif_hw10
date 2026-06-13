`timescale 1ns / 1ps

module FullDivi(A,B,Comp,Cin,R,Cout);
	input A,B,Comp,Cin;
	output wire R,Cout;
	
	wire opB;
	assign opB=B^Comp;
	
	FullAdder FA(A,opB,Cin,R,Cout);
endmodule
