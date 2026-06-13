`timescale 1ns / 1ps

module DatosINOUT(CLK,RST,ENARD,W,WRDO,RSTREG,ENACD,BOUT,DATA,DatoIN1,DatoIN2,DatoIN3,DataBus);
	input CLK,RST;
	input ENARD,W,RSTREG,ENACD,BOUT;
	input [1:0] WRDO;
	input [15:0] DATA;
	output [15:0] DatoIN1,DatoIN2,DatoIN3;
	inout [7:0] DataBus;

//Registro de Datos
	wire [15:0] opDatoIN1;
	RegistroDatos RDatos(CLK,RST,ENARD,DataBus,opDatoIN1,DatoIN2,DatoIN3);
	Mux2a1de16bits MuxRDatos({8'b0,opDatoIN1[7:0]},{opDatoIN1[7:0],opDatoIN1[15:8]},W,DatoIN1);
	
//Registro de Salida
	wire [15:0] QOUT0,QOUT1,QOUT2;
	wire [7:0] DATAOUT;
	wire [2:0] C;
	Reg16bitsEnaDown RegSal(CLK,RST,~WRDO[1]&WRDO[0],DATA,QOUT0);
	Reg16bitsEnaDown RegSal1(CLK,RST,WRDO[1]&~WRDO[0],DATA,QOUT1);
	Reg16bitsEnaDown RegSal2(CLK,RST,WRDO[1]&WRDO[0],DATA,QOUT2);
	ContadorUp3bits ContOut(CLK,RST|RSTREG,ENACD,C);
	Mux8a1de8bits MuxSal(QOUT0[7:0],QOUT0[15:8],QOUT1[7:0],QOUT1[15:8],QOUT2[7:0],QOUT2[15:8],8'b0,8'b0,C,DATAOUT);

//Buffer
	Buffer8bits Buffer(DATAOUT,BOUT,DataBus);


endmodule
