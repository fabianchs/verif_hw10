`timescale 1ns / 1ps

module Reg8bitsEnaDown(CLK,RST,ENA,D,Q);
	input CLK,RST,ENA;
	input [7:0] D;
	output reg [7:0] Q;

	always @(negedge CLK or posedge RST)
		if (RST)
			Q=8'h00;
		else if (ENA)
			Q=D;
		else
			Q=Q;

endmodule
