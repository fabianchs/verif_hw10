`timescale 1ns / 1ps

module Mux2a1de16bits(A0,A1,OP,R);
	input [15:0] A0,A1;
	input OP;
	output reg [15:0] R;
	
	always @(A0 or A1 or OP)
		case (OP)
			1'b0: R=A0;
			1'b1: R=A1;
		endcase

endmodule
