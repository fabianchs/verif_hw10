`timescale 1ns / 1ps

module SemiAdder16bits3op(A,B,C,op,R);
	input [15:0] A,B,C;
	input [2:0] op;
	output wire [15:0] R;

//MUXES
	wire [15:0] opA,opB,opC,opR;
	ACT16bits MuxA(A,op[0],opA);
	ACT16bits MuxB(B,op[1],opB);
	ACT16bits MuxC(C,op[2],opC);
	
//modulos Adder
	SemiAdder16bits Adder1(opA,opB,opR);
	SemiAdder16bits Adder2(opR,opC,R);

endmodule
