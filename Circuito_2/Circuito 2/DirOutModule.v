`timescale 1ns / 1ps

module DirOutModule(CLK,RST,RSTREG,ENACD,opA,opB,RI,RSIP,REI,Dir);
	input CLK,RST;
	input RSTREG,ENACD,opA,opB;
	input [15:0] RI,RSIP,REI;
	output wire [19:0] Dir;
		
//Direccion de Salida
	wire [15:0] opMA,opMB;
	ACT16bits MuxA(RI,opA,opMA);
	Mux2a1de16bits MuxB(REI,RSIP,opB,opMB);

//Adder medio	
	wire [19:0] opR;
	SemiAdder20bits AdderOUT({opMA,4'b0},{4'b0,opMB},opR);

//Adder salida
	wire [2:0] CD;
	ContadorUp3bits Cont(CLK,RST|RSTREG,ENACD,CD);
	SemiAdder20bits AdderCUENTA(opR,{17'b0,CD},Dir);
	
endmodule
