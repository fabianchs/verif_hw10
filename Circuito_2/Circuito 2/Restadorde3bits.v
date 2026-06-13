`timescale 1ns / 1ps

module Restadorde3bits(A,B,R);
	input [2:0] A,B;
	output wire [2:0] R;
	
	wire C0,C1;
	//Adders
	FullAdder FA0(A[0],~B[0],1'b1,R[0],C0);
	FullAdder FA1(A[1],~B[1],C0,R[1],C1);
	SemiAdderFin FA2(A[2],~B[2],C1,R[2]);

endmodule
