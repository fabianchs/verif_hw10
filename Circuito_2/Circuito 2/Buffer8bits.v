`timescale 1ns / 1ps

module Buffer8bits(A,op,R);
	input [7:0] A;
	input op;
	output reg [7:0] R;
	
	always @(A or op)
		if (op)
			R=A;
		else
			R=8'bz;

endmodule
