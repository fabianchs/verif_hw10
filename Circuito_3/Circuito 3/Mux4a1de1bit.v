`timescale 1ns / 1ps

module Mux4a1de1bit(A0,A1,A2,A3,OP,R);
	input A0,A1,A2,A3;
	input [1:0] OP;
	output reg R;
	
	always @(A0 or A1 or A2 or A3 or OP)
		case (OP)
			2'b00: R=A0;
			2'b01: R=A1;
			2'b10: R=A2;
			2'b11: R=A3;
		endcase

endmodule
