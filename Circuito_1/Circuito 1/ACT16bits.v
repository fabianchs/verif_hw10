`timescale 1ns / 1ps

module ACT16bits(A,OP,R);
	input [15:0] A;
	input OP;
	output reg [15:0] R;
	
	always @(A or OP)
		case (OP)
			1'b0: R=16'b0;
			1'b1: R=A;
		endcase

endmodule
