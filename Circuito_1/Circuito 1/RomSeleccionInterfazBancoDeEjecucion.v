`timescale 1ns / 1ps

module RomSeleccionInterfazBancoDeEjecucion(mod,RM,opMuxA,opMuxB,opMuxC,opSA);
	input [1:0] mod;
	input [2:0] RM;
	output reg [1:0] opMuxA;
	output wire opMuxB,opMuxC;
	output wire [2:0] opSA;
	
	assign opSA[0]=~(~mod[1]&~mod[0]&RM[2]&RM[1]&~RM[0]);
	assign opSA[1]=~RM[2];
	assign opSA[2]=(mod[1]^mod[0])|(~mod[1]&~mod[0]&RM[2]&RM[1]&~RM[0]);
	assign opMuxB=RM[0];
	assign opMuxC=(mod[1])|(~mod[1]&~mod[0]&RM[2]&RM[1]&~RM[0]);
	
	always @(RM)
		case (RM)
			3'b000: opMuxA=2'b00;
			3'b001: opMuxA=2'b00;
			3'b010: opMuxA=2'b01;
			3'b011: opMuxA=2'b01;
			3'b100: opMuxA=2'b10;
			3'b101: opMuxA=2'b11;
			3'b110: opMuxA=2'b01;
			3'b111: opMuxA=2'b00;
		endcase

endmodule
