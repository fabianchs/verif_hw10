`timescale 1ns / 1ps

module DetectorZero(A,Z);
	input [15:0] A;
	output wire Z;
	
	assign Z=~|A;


endmodule
