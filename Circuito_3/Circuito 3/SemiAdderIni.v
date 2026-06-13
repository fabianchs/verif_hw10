`timescale 1ns / 1ps

module SemiAdderIni(A,B,R,Cout);
	input A,B;
	output wire R,Cout;
	
	assign R=A^B;
	assign Cout=A&B;
	
endmodule 
