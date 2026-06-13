`timescale 1ns / 1ps

`include "ACT16bits.v"
`include "BancoDeInterfaz.v"
`include "Buffer8bits.v"
`include "ContadorUp3bits.v"
`include "ContadorUp3bitsIP.v"
`include "DatosINOUT.v"
`include "DirOutModule.v"
`include "FullAdder.v"
`include "IP.v"
`include "Mux2a1de16bits.v"
`include "Mux4a1de16bits.v"
`include "Mux8a1de8bits.v"
`include "Reg8bitsEnaDown.v"
`include "Reg16bitsEnaDown.v"
`include "Reg16bitsEnaDownCS.v"
`include "RegistroDatos.v"
`include "RegistroSiguienteInstruccion.v"
`include "Restadorde3bits.v"
`include "RomSeleccionBancoDeInterfaz.v"
`include "SemiAdder16bits.v"
`include "SemiAdder20bits.v"
`include "SemiAdderFin.v"
`include "SemiAdderIni.v"

module ModuloInterfaz(CLK,RST,opI,ENAIP,WIPDI,RSTREG,ENACD,opA,opB,ENARD,BOUT,ENASI,CUENTA,opE,WBDI,WIPDE,W,WRDO,DATA,REI,
							 REBDI,RIPE,DatoIN1,DatoIN2,DatoIN3,Dir,NuevaINST,DataBus);
	input CLK,RST;
//Entradas del control de Interfaz
	input [1:0] opI;
	input ENAIP,WIPDI,RSTREG,ENACD,opA,opB,ENARD,BOUT,ENASI;
	input [2:0] CUENTA;
//Entradas del control de Ejecucion
	input [1:0] opE;
	input WBDI,WIPDE,W;
	input [1:0] WRDO;
//Entradas del modulo Ejecucion 
	input [15:0] DATA,REI;
//Salidas
	output wire [15:0] REBDI,RIPE,DatoIN1,DatoIN2,DatoIN3;
	output wire [19:0] Dir;
	output wire [47:0] NuevaINST;
//Bus Externo
	inout [7:0] DataBus;
	
//Banco de Interfaz
	wire [15:0] RIBDI;
	BancoDeInterfaz BanInt(CLK,RST,DATA,opE,opI,WBDI,REBDI,RIBDI);

//Registro IP
	wire [15:0] RIPI;
	IP regIP(CLK,RST,ENAIP,WIPDI,WIPDE,DATA,CUENTA,RIPI,RIPE);
	
//Modulo de Direccionamiento
	DirOutModule DirecMo(CLK,RST,RSTREG,ENACD,opA,opB,RIBDI,RIPI,REI,Dir);
	
//Modulo de Recibo y envio de datos
	DatosINOUT DIO(CLK,RST,ENARD,W,WRDO,RSTREG,ENACD,BOUT,DATA,DatoIN1,DatoIN2,DatoIN3,DataBus);
	
//Modulo de Siguiente Instruccion
	RegistroSiguienteInstruccion NextIns(CLK,RST,ENASI,DataBus,NuevaINST);
	
endmodule
