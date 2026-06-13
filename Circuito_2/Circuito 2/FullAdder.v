`timescale 1ns / 1ps

module FullAdder(A,B,Cin,R,Cout);
	input A,B,Cin;
	output wire R,Cout;
	wire R1,O1,O2;
	
	assign R1=A^B;
	assign O1=A&B;
	assign R=R1^Cin;
	assign O2=R1&Cin;
	assign Cout=O1|O2;
	
endmodule 
