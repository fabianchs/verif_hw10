`timescale 1ns / 1ps

module RomopFL(opFL,RSTCF,RSTDF,RSTIF,SETCF,SETDF,SETIF,TOGCF);
	input [2:0] opFL;
	output wire RSTCF,RSTDF,RSTIF,SETCF,SETDF,SETIF,TOGCF;
	
	reg [6:0] D;
	assign {RSTCF,RSTDF,RSTIF,SETCF,SETDF,SETIF,TOGCF}=D;
	
	always @(opFL)
		case (opFL)
			3'b000: D=7'b0000000;
			3'b001: D=7'b1000000;
			3'b010: D=7'b0000001;
			3'b011: D=7'b0001000;
			3'b100: D=7'b0100000;
			3'b101: D=7'b0000100;
			3'b110: D=7'b0010000;
			3'b111: D=7'b0000010;
		endcase

endmodule
