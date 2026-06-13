`timescale 1ns / 1ps

//intrucciones de op
// op=00 => ROL
// op=01 => ROR
// op=10 => RCL
// op=11 => RCR

module RotateBasicModule(A,B,Cin,Simp,op,R,CF,OF);
	input [15:0] A;
	input [3:0] B;
	input [1:0] op;
	input Cin,Simp;
	output wire [15:0] R;
	output wire CF,OF;
	
	wire [15:0] RRCL,RRCR,RROL,RROR;
	wire CRCR,CRCL;

//red de operacion
	reg [3:0] Des;
	always @(B or Simp)
		if (Simp)
			Des=4'b0001;
		else
			Des=B;
			
//modulos de corrimiento
	MuxShiftRightRotaWC RotacionRCR(A,Cin,Des,{RRCR[15:0],CRCR});
	MuxShiftLeftRotaWC RotacionRCL(A,Cin,Des,{CRCL,RRCL[15:0]});
	MuxShiftLeftRota RotacionROL(A,Des,RROL);
	MuxShiftRightRota RotacionROR(A,Des,RROR);	
	
//Mux de salida
	Mux4a1de16bits Mux(RROL,RROR,RRCL,RRCR,op,R);
	
	Mux4a1de1bit MuxC(R[15],R[0],CRCL,CRCR,op,CF);

//carry y overflow
	assign OF=(A[15]^R[15]);
	
endmodule

