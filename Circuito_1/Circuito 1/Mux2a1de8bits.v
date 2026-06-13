`timescale 1ns / 1ps

module Mux2a1de8bits(A0,A1,OP,R);
	input [7:0] A0,A1;
	input OP;
	output reg [7:0] R;
	
	always @(A0 or A1 or OP)
		case (OP)
			1'b0: R=A0;
			1'b1: R=A1;
		endcase

endmodule
