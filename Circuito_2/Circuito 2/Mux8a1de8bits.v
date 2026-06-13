`timescale 1ns / 1ps

module Mux8a1de8bits(A0,A1,A2,A3,A4,A5,A6,A7,OP,R);
	input [7:0] A0,A1,A2,A3,A4,A5,A6,A7;
	input [2:0] OP;
	output reg [7:0] R;
	
	always @(A0 or A1 or A2 or A3 or A4 or A5 or A6 or A7 or OP)
		case (OP)
			3'b000: R=A0;
			3'b001: R=A1;
			3'b010: R=A2;
			3'b011: R=A3;
			3'b100: R=A4;
			3'b101: R=A5;
			3'b110: R=A6;
			3'b111: R=A7;
		endcase

endmodule