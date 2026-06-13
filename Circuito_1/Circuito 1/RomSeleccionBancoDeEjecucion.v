`timescale 1ns / 1ps

module RomSeleccionBancoDeEjecucion(Dir,WAH,WAL,WBH,WBL,WCH,WCL,WDH,WDL,WSP,WBP,WDI,WSI);
	input [3:0] Dir;
	output reg WAL,WAH,WBL,WBH,WCL,WCH,WDL,WDH,WSP,WBP,WDI,WSI;
	
	always @(Dir)
		case (Dir)
			4'b0000: begin
							WAL=1'b1;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0001: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b1;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0010: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b1;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0011: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b1;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0100: begin
							WAL=1'b0;
							WAH=1'b1;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0101:begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b1;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0110: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b1;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b0111: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b1;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1000: begin
							WAL=1'b1;
							WAH=1'b1;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1001: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b1;
							WCH=1'b1;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1010: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b1;
							WDH=1'b1;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1011: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b1;
							WBH=1'b1;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1100: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b1;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1101: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b1;
							WDI=1'b0;
							WSI=1'b0;
						end
			4'b1110: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b0;
							WSI=1'b1;
						end
			4'b1111: begin
							WAL=1'b0;
							WAH=1'b0;
							WBL=1'b0;
							WBH=1'b0;
							WCL=1'b0;
							WCH=1'b0;
							WDL=1'b0;
							WDH=1'b0;
							WSP=1'b0;
							WBP=1'b0;
							WDI=1'b1;
							WSI=1'b0;
						end
		endcase
	
endmodule
