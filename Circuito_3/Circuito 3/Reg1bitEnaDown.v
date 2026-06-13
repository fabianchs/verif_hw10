`timescale 1ns / 1ps

module Reg1bitEnaDown(CLK,RST,ENA,D,Q);
	input CLK,RST,ENA;
	input D;
	output reg Q;

	always @(negedge CLK or posedge RST)
		if (RST)
			Q=1'b0;
		else if (ENA)
			Q=D;
		else
			Q=Q;

endmodule
