`timescale 1ns / 1ps

//intrucciones de op
// op=000 => ROL
// op=001 => ROR
// op=010 => RCL
// op=011 => RCR
// op=100 => SHL
// op=101 => SHR
// op=110 => SAL
// op=111 => SAR

module ALU2module(opA,opB,V,Cin,op,R,CF,OF);
	input [15:0] opA;
	input [3:0] opB;
	input V,Cin;
	input [2:0] op;
	output wire [15:0] R;
	output wire CF,OF;
	
//modulos de operacion
	wire [15:0] RS,RR;
	wire CFS,CFR,OFS,OFR;
	ShiftBasicModule SHI(opA,opB,V,op[1:0],RS,CFS,OFS);
	RotateBasicModule ROT(opA,opB,Cin,V,op[1:0],RR,CFR,OFR);
	
//Mux de salida de datos
	Mux2a1de16bits MuxRDatos(RR,RS,op[2],R);
	assign CF=(CFS&op[2])|(CFR&~op[2]);
	assign OF=(OFS&op[2])|(OFR&~op[2]);	
		
endmodule
