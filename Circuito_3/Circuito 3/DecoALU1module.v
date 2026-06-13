`timescale 1ns / 1ps


module DecoALU1module(op,opMux,FA,FS);
	input [2:0] op;
	output reg [1:0] opMux;
	output wire FA,FS;
	
	assign FA=(opMux[1]&opMux[0]&~op[0]);
	assign FS=(opMux[1]&opMux[0]&op[0]);
	
	always @(op)
		case (op)
			3'b000: opMux=2'b11;
			3'b001: opMux=2'b01;
			3'b010: opMux=2'b11;
			3'b011: opMux=2'b11;
			3'b100: opMux=2'b00;
			3'b101: opMux=2'b11;
			3'b110: opMux=2'b10;
			3'b111: opMux=2'b11;
		endcase

endmodule
