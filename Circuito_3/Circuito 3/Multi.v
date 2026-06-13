`timescale 1ns / 1ps

module Multi(A,B,R);
	input [15:0] A,B;
	output wire [31:0] R;
	
	assign R=A*B;

endmodule
