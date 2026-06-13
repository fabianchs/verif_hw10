`timescale 1ns / 1ps

module MuxShiftRightSimple(A,OP,R);
	input [15:0] A;
	input [3:0] OP;
	output reg [15:0] R;
	
	always @ (A or OP)
		case (OP)
			4'b0000: R=A[15:0];
			4'b0001: R={1'b0,A[15:1]};
			4'b0010: R={2'b0,A[15:2]};
			4'b0011: R={3'b0,A[15:3]};
			4'b0100: R={4'b0,A[15:4]};
			4'b0101: R={5'b0,A[15:5]};
			4'b0110: R={6'b0,A[15:6]};
			4'b0111: R={7'b0,A[15:7]};
			4'b1000: R={8'b0,A[15:8]};
			4'b1001: R={9'b0,A[15:9]};
			4'b1010: R={10'b0,A[15:10]};
			4'b1011: R={11'b0,A[15:11]};
			4'b1100: R={12'b0,A[15:12]};
			4'b1101: R={13'b0,A[15:13]};
			4'b1110: R={14'b0,A[15:14]};
			4'b1111: R={15'b0,A[15]};
		endcase
		
endmodule 
