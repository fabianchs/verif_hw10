`timescale 1ns / 1ps

//intrucciones de op
// op=0000 => MUL	8BITS
// op=0001 => MUL  16BITS 
// op=0010 => IMUL 8BITS
// op=0011 => IMUL 16BITS
// op=0100 => DIV  8BITS
// op=0101 => DIV  16BITS
// op=0110 => IDIV 8BITS
// op=0111 => IDIV 16BITS
// op=1000 => NOT
// op=1001 => NEG
// op=1100 => CBW
// op=1101 => CWD
// op=1110 => AAM
// op=1111 => AAD

module UnidadProducto(CLK,RST,ENA,A,B,D,op,R1,R2,OF,CF,FIN);
	input CLK,RST,ENA;
	input [15:0] A,B,D;
	input [3:0] op;
	output wire [15:0] R1,R2;
	output wire OF,CF,FIN;

//Muxes de AAM y AAD de entrada
	wire [15:0] AAMD,AA;
	Mux2a1de8bits MuxAMAD(A[7:0],A[15:8],op[0],AAMD[7:0]);
	assign AAMD[15:8]=8'b0;
	Mux2a1de16bits MuxdeEntrada(A,AAMD,op[3]&op[2],AA);
	
//Complemento a 2
	wire CA,Co,c2inA,c2inB,c2out;
	wire [15:0] opA,opB,opD,DR;
	Comple2d32bits CompA2A({D,AA},CA,c2inA,{DR,opA});
	Comple2d16bits CompA2B(B,c2inB,opB);
	
	ACT16bits ActivadorD(DR,op[0],opD);
	
//Rom decodificador de complementos
	RomDecComp DecoComple(op,AA[15],AA[7],B[15],B[7],D[15],CA,c2inA,c2inB,c2out);	
	
//Modulos
	wire [15:0] RMUL,RDIV,RMUL2,REDIV;
	Divi16x16bits Divisor(CLK,RST,ENA,opD,opA,opB,RDIV,REDIV,FIN);
	Multi Multiplicador(opA,opB,{RMUL2,RMUL});
	
//Complementos a 2 de salida
	wire [15:0] opR1,opR2,C2R1,C2R2,opR;
	Mux2a1de16bits MuxR1(RMUL,RDIV,op[2],opR1);
	Mux2a1de16bits MuxR2(RMUL2,REDIV,op[2],opR2);
	
	Comple2d16bitsB CompA2R1(opR1,c2out,c2out,C2R1,Co);
	Comple2d16bitsCin CompA2R2(opR2,((Co&~op[2])|(c2out&op[2])),c2out,C2R2);
	
	Mux2a1de16bits AjustedeDIV(C2R1,{C2R2[7:0],C2R1[7:0]},(op[2]&~op[0]),opR);

//Seleccion de AAM y AAD e Conversiones a Word o DWord
	wire [15:0] opAAMDC;
	wire [7:0] opRAAD;
	SemiAdder8bits AdderdeAAM(RMUL[7:0],A[7:0],opRAAD);	
	Mux4a1de16bits MuxdeopAAMDC({A[7],A[7],A[7],A[7],A[7],A[7],A[7],A[7],A[7:0]},
										{A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15]},
										{RDIV[7:0],REDIV[7:0]},
										{8'b0,opRAAD},
										op[1:0],opAAMDC);
	
//Mux de Salida
	Mux4a1de16bits MuxdeR1(opR,opR,opA,opAAMDC,op[3:2],R1);
	assign R2=C2R2;

//Banderas
	assign OF=CF;
	assign CF=|RMUL2;
endmodule
