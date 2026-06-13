`timescale 1ns / 1ps

//seleccion de op
// op=00 => ES 
// op=01 => CS
// op=10 => SS
// op=11 => DS


module BancoDeInterfaz(CLK,RST,A,opE,opI,WR,RE,RI);
	input CLK,RST;
	input [15:0] A;
	input [1:0] opE,opI;
	input WR;
	output wire [15:0] RE,RI;

//Rom de Seleccion
	wire WES,WCS,WSS,WDS;
	RomSeleccionBancoDeInterfaz Selec(opE,WES,WCS,WSS,WDS);	

//Registros 
	wire [15:0] ES,CS,SS,DS;
	Reg16bitsEnaDown RegES(CLK,RST,WES&WR,A,ES);
	Reg16bitsEnaDownCS RegCS(CLK,RST,WCS&WR,A,CS);
	Reg16bitsEnaDown RegSS(CLK,RST,WSS&WR,A,SS);
	Reg16bitsEnaDown RegDS(CLK,RST,WDS&WR,A,DS);

//Mux de Salida
	Mux4a1de16bits MuxSalEjecucion(ES,CS,SS,DS,opE,RE);
	Mux4a1de16bits MuxSalInterfaz(ES,CS,SS,DS,opI,RI);
	
endmodule
