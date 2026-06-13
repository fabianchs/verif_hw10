`timescale 1ns / 1ps

module MuxShiftLeftSimple(A,OP,R);
	input [15:0] A;
	input [3:0] OP;
	output reg [15:0] R;
	
	always @ (A or OP)
		case (OP)
			4'b0000: R=A[15:0];
			4'b0001: R={A[14:0],1'b0};
			4'b0010: R={A[13:0],2'b0};
			4'b0011: R={A[12:0],3'b0};
			4'b0100: R={A[11:0],4'b0};
			4'b0101: R={A[10:0],5'b0};
			4'b0110: R={A[9:0],6'b0};
			4'b0111: R={A[8:0],7'b0};
			4'b1000: R={A[7:0],8'b0};
			4'b1001: R={A[6:0],9'b0};
			4'b1010: R={A[5:0],10'b0};
			4'b1011: R={A[4:0],11'b0};
			4'b1100: R={A[3:0],12'b0};
			4'b1101: R={A[2:0],13'b0};
			4'b1110: R={A[1:0],14'b0};
			4'b1111: R={A[0],15'b0};
		endcase
		
endmodule 
