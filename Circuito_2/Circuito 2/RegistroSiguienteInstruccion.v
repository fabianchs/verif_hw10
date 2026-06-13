`timescale 1ns / 1ps

module RegistroSiguienteInstruccion(CLK,RST,ENA,DATO,OUT);
	input CLK,RST,ENA;
	input [7:0] DATO;
	output wire [47:0] OUT;
	

//registros
	wire [7:0] S1,S2,S3,S4,S5,S6;
	
	Reg8bitsEnaDown r1(CLK,RST,ENA,DATO,S1);
	Reg8bitsEnaDown r2(CLK,RST,ENA,S1,S2);
	Reg8bitsEnaDown r3(CLK,RST,ENA,S2,S3);
	Reg8bitsEnaDown r4(CLK,RST,ENA,S3,S4);
	Reg8bitsEnaDown r5(CLK,RST,ENA,S4,S5);
	Reg8bitsEnaDown r6(CLK,RST,ENA,S5,S6);
	
	assign OUT={S6,S5,S4,S3,S2,S1};
	
endmodule
