`timescale 1ns / 1ps

module Mux16a1de16bits(A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,OP,R);
	input [15:0] A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15;
	input [3:0] OP;
	output reg [15:0] R;
	
	always @(A0 or A1 or A2 or A3 or A4 or A5 or A6 or A7 or A8 or A9 or A10 or A11 or A12 or A13 or A14 or A15 or OP)
		case (OP)
			4'b0000: R=A0;
			4'b0001: R=A1;
			4'b0010: R=A2;
			4'b0011: R=A3;
			4'b0100: R=A4;
			4'b0101: R=A5;
			4'b0110: R=A6; 
			4'b0111: R=A7;
			4'b1000: R=A8;
			4'b1001: R=A9;
			4'b1010: R=A10;
			4'b1011: R=A11;
			4'b1100: R=A12;
			4'b1101: R=A13; 
			4'b1110: R=A14;
			4'b1111: R=A15;
		endcase
		
endmodule 