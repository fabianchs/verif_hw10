`timescale 1ns / 1ps

module SemiAdderFin(A,B,Cin,R);
	input A,B,Cin;
	output wire R;
	wire R1;
	
	assign R1=A^B;
	assign R=R1^Cin;
	
endmodule 
