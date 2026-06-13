`timescale 1ns / 1ps

module Reg1bitEnaSetTogDown(CLK,RST,ENA,SET,TOG,D,Q);
	input CLK,RST,ENA,TOG,SET;
	input D;
	output reg Q;

	always @(negedge CLK or posedge RST)
		if (RST)
			Q=1'b0;
		else if (SET)
			Q=1'b1;
		else if (TOG)
			Q=~Q;
		else if (ENA)
			Q=D;
		else
			Q=Q;

endmodule
