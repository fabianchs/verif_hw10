`timescale 1ns / 1ps

module Reg16bitsEnaDown(CLK,RST,ENA,D,Q);
	input CLK,RST,ENA;
	input [15:0] D;
	output reg [15:0] Q;

	always @(negedge CLK or posedge RST)
		if (RST)
			Q=16'h0000;
		else if (ENA)
			Q=D;
		else
			Q=Q;

endmodule
