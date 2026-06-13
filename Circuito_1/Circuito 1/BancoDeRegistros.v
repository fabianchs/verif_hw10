`timescale 1ns / 1ps

//seleccion de op
// op=0000 => AL 
// op=0001 => CL
// op=0010 => DL
// op=0011 => BL
// op=0100 => AH
// op=0101 => CH
// op=0110 => DH
// op=0111 => BH
// op=1000 => AX
// op=1001 => CX 
// op=1010 => DX
// op=1011 => BX
// op=1100 => SP
// op=1101 => BP
// op=1110 => SI
// op=1111 => DI

`include "DetectorZero.v" 
`include "Mux16a1de16bits.v" 
`include "Mux2a1de16bits.v" 
`include "Mux2a1de8bits.v"
`include "Mux4a1de16bits.v" 
`include "Mux8a1de16bits.v" 
`include "Reg16bitsEnaDown.v" 
`include "Reg8bitsEnaDown.v" 
`include "RomSeleccionBancoDeEjecucion.v" 
`include "RomSeleccionInterfazBancoDeEjecucion.v" 
`include "SemiAdder16bits3op.v" 
`include "ACT16bits.v" 
`include "SemiAdder16bits.v" 
`include "FullAdder.v" 
`include "SemiAdderFin.v" 
`include "SemiAdderIni.v"

module BancoDeEjecucion(CLK,RST,A,DatoIN,DESP,mod,RM,opER,opEW,DirST,SelIn,WR,LDI,CXZ,R,RI);
	input CLK,RST;
	input [15:0] A;
	input [7:0] DatoIN;
	input [23:0] DESP;
	input [1:0] mod;
	input [2:0] RM;
	input [3:0] opER,opEW;
	input WR,LDI;
	input [3:0] DirST;
	input [2:0] SelIn;
	output wire CXZ;
	output wire [15:0] R,RI;

//Mux para registros altos
	wire [7:0] opH;
	Mux2a1de8bits MuxH(A[7:0],A[15:8],opEW[3],opH); 

//Rom de Seleccion
	wire WAH,WAL,WBH,WBL,WCH,WCL,WDH,WDL,WSP,WBP,WDI,WSI;
	RomSeleccionBancoDeEjecucion RomSel(opEW,WAH,WAL,WBH,WBL,WCH,WCL,WDH,WDL,WSP,WBP,WDI,WSI);	

//Registros Cortos
	wire [7:0] AH,AL,BHm,BLm,BH,BL,CH,CL,DH,DL;	
	Reg8bitsEnaDown RegAH(CLK,RST,WAH&WR,opH,AH);
	Reg8bitsEnaDown RegAL(CLK,RST,WAL&WR,A[7:0],AL);
	Reg8bitsEnaDown RegBH(CLK,RST,WBH&WR,opH,BHm);
	Reg8bitsEnaDown RegBL(CLK,RST,WBL&WR,A[7:0],BLm);
	Reg8bitsEnaDown RegCH(CLK,RST,WCH&WR,opH,CH);
	Reg8bitsEnaDown RegCL(CLK,RST,WCL&WR,A[7:0],CL);
	Reg8bitsEnaDown RegDH(CLK,RST,WDH&WR,opH,DH);
	Reg8bitsEnaDown RegDL(CLK,RST,WDL&WR,A[7:0],DL);

//Registros Largos
	wire [15:0] SP,BPm,BP,DIm,DI,SIm,SI;
	Reg16bitsEnaDown RegSP(CLK,RST,WSP&WR,A,SP);
	Reg16bitsEnaDown RegBP(CLK,RST,WBP&WR,A,BPm);
	Reg16bitsEnaDown RegDI(CLK,RST,WDI&WR,A,DIm);
	Reg16bitsEnaDown RegSI(CLK,RST,WSI&WR,A,SIm);

//Latchs de Busqueda
	Reg16bitsEnaDown LDDI(CLK,RST,LDI,DIm,DI);
	Reg16bitsEnaDown LDSI(CLK,RST,LDI,SIm,SI);
	Reg16bitsEnaDown LDBP(CLK,RST,LDI,BPm,BP);
	Reg8bitsEnaDown LDBH(CLK,RST,LDI,BHm,BH);
	Reg8bitsEnaDown LDBL(CLK,RST,LDI,BLm,BL);
	wire [15:0] EA;
	wire [7:0] opDato;
	Reg16bitsEnaDown LDA(CLK,RST,LDI,A,EA);
	Reg8bitsEnaDown LDopDato(CLK,RST,LDI,DatoIN,opDato);
	
//Mux de Salida
	Mux16a1de16bits MuxSalE({8'b0,AL},{8'b0,CL},{8'b0,DL},{8'b0,BL},{8'b0,AH},{8'b0,CH},{8'b0,DH},{8'b0,BH},
									{AH,AL},{CH,CL},{DH,DL},{BHm,BLm},SP,BPm,SIm,DIm,opER,R);

//Seleccion de Interrupcion
	wire [15:0] DirInt;
	Mux8a1de16bits MuxDeInt(16'b0,16'b0,{12'b0,4'b1000},{6'b0,opDato,2'b0},
									16'h000c,{8'b0,DESP[21:16],2'b00},16'h0010,16'b0,
									SelIn,DirInt);
	
//Red de interfaz
	wire [15:0] opS1,opS2,opS3,opRI,RIn;
	wire [1:0] opMuxA;
	wire opMuxC,opMuxB; 
	wire [2:0] opSA;
	RomSeleccionInterfazBancoDeEjecucion RomSelInt(mod,RM,opMuxA,opMuxB,opMuxC,opSA);
	Mux4a1de16bits MuxA({BH,BL},BP,SI,DI,opMuxA,opS1);
	Mux2a1de16bits MuxB(SI,DI,opMuxB,opS2);
	Mux2a1de16bits MuxC({8'b0,DESP[7:0]},DESP[15:0],opMuxC,opS3);
	SemiAdder16bits3op SemiAdder(opS1,opS2,opS3,opSA,opRI);
	
	Mux8a1de16bits MuxRI(opRI,SP,{8'b0,DESP[23:16]},{DH,DL},
							  {DESP[7:0],DESP[23:16]},SI,DI,DirInt,DirST[2:0],RIn);
	
	Mux2a1de16bits MuxSak(RIn,EA,DirST[3],RI);
	
//Red de CXNZ
	DetectorZero Zer({CH,CL},CXZ);
endmodule
