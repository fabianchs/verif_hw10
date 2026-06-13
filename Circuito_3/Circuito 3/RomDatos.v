`timescale 1ns / 1ps

module RomDatosAjustBasic(Dir,Sal);
	input [2:0] Dir;
	output reg [15:0] Sal;
	
	always @(Dir)
		case (Dir)
			3'b000: Sal=16'b0000;
			3'b001: Sal=16'h0106;
			3'b010: Sal=16'h0000;
			3'b011: Sal=16'h0106;
			3'b100: Sal=16'b0000;
			3'b101: Sal=16'h0006;
			3'b110: Sal=16'h0060;
			3'b111: Sal=16'h0066;

		endcase

endmodule
