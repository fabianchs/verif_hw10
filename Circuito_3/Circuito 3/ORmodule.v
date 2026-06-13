`timescale 1ns / 1ps

module ORmodule(A,B,R);
	input [15:0] A,B;
	output [15:0] R;

	assign R=A|B;
	
endmodule
