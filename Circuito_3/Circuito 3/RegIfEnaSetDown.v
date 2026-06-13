`timescale 1ns / 1ps

module RegIfEnaSetDown(CLK,RST,RSET,ENA,SET,D,Q);
	input CLK,RST,RSET,ENA,SET;
	input D;
	output reg Q;

	always @(negedge CLK or posedge RST)
		if (RST)
			Q=1'b1;
		else if (RSET)
			Q=1'b0;
		else if (SET)
			Q=1'b1;
		else if (ENA)
			Q=D;
		else
			Q=Q;

endmodule
