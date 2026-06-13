`timescale 1ns / 1ps

module Divi16x16bits(CLK,RST,ENA,D,A,B,R,R2,FIN);
	input CLK,RST,ENA;
	input [15:0] D,A,B;
	output wire [15:0] R,R2;
	output wire FIN;
	
//Maquina de Estados
	wire [3:0] PRE;
	FSMDivi MaqEstDivi(CLK,RST,ENA,FIN,PRE);
	
//Redes
	wire [15:0] R3,Ro,RE,opD;
	wire C,Co,A0,P0;
	
	assign P0=|PRE;
	
//Muxes de operandos
	Mux16a1de1bit MuxdeA0(A[15],A[14],A[13],A[12],A[11],A[10],A[9],A[8],
								 A[7],A[6],A[5],A[4],A[3],A[2],A[1],A[0],PRE,A0);
								 
	Mux16a1de1bit MuxdeC(1'b1,R[15],R[14],R[13],R[12],R[11],R[10],R[9],
								R[8],R[7],R[6],R[5],R[4],R[3],R[2],R[1],PRE,C);
								
	Mux2a1de16bits MuxdeA(D,RE,P0,opD);
	
//Modulo Divisor
	Divi16bits D15({opD[15:0],A0},B,C,Ro,Co);

//Registro de ETAPA
	Reg16bitsEnaDown RegDeRE(CLK,RST,ENA|P0,Ro,RE);
	
//Registro de salida
	RegRotate16bitsEnaDown RegDeC(CLK,RST,ENA|P0,PRE,Co,R);
	
//Salida de Residuo
	SemiAdder16bits Sum(RE,B,R3);
	Mux2a1de16bits MuxResiduo(R3,RE,R[0],R2);


endmodule
