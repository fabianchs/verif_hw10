`timescale 1ns / 1ps

module DetectorParidad(A,P);
	input [15:0] A;
	output wire P;
	
	assign P=~(^A[15:0]);


endmodule
