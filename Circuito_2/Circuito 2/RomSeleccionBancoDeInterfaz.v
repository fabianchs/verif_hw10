`timescale 1ns / 1ps

module RomSeleccionBancoDeInterfaz(Dir,WES,WCS,WSS,WDS);
	input [1:0] Dir;
	output reg WES,WCS,WSS,WDS;
	
	always @(Dir)
		case (Dir)
			2'b00: begin
							WES=1'b1;
							WCS=1'b0;
							WSS=1'b0;
							WDS=1'b0;
						end
			2'b01: begin
							WES=1'b0;
							WCS=1'b1;
							WSS=1'b0;
							WDS=1'b0;
						end
			2'b10: begin
							WES=1'b0;
							WCS=1'b0;
							WSS=1'b1;
							WDS=1'b0;
						end
			2'b11: begin
							WES=1'b0;
							WCS=1'b0;
							WSS=1'b0;
							WDS=1'b1;
						end
		endcase
	
endmodule
