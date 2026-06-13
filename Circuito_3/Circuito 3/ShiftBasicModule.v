`timescale 1ns / 1ps

//intrucciones de op
// op=00 => SHL
// op=01 => SHR
// op=10 => SAL
// op=11 => SAR

module ShiftBasicModule(A,B,Simp,op,R,CF,OF);
	input [15:0] A;
	input [3:0] B;
	input [1:0] op;
	input Simp;
	output wire [15:0] R;
	output wire CF,OF;
	
	wire [15:0] RSHL,RSHR,RSAR;
	wire CFRight,CFLeft;

//red de operacion
	reg [3:0] Des;
	always @(B or Simp)
		if (Simp)
			Des=4'b0001;
		else
			Des=B;
			
//modulos de corrimiento
	MuxShiftRightSimple CorrimientoRS(A,Des,RSHR);
	MuxShiftLeftSimple CorrimientoLS(A,Des,RSHL);
	MuxShiftRightSimpleArit CorrimientoRSA(A,Des,RSAR);
	
//muxes de Carry
	Mux16a1de1bit CarryRight(A[14],A[13],A[12],A[11],A[10],A[9],A[8],A[7],A[6],A[5],A[4],A[3],A[2],A[1],A[0],1'b0,Des,CFRight);
	Mux16a1de1bit CarryLeft(A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],A[9],A[10],A[11],A[12],A[13],A[14],A[15],1'b0,Des,CFLeft);

	
//Mux de salida
	Mux4a1de16bits Mux(RSHL,RSHR,RSHL,RSAR,op,R);

//carry y overflow
	assign CF=(CFRight&op[0])|(CFLeft&~op[0]);
	assign OF=(A[15]^R[15]);
	
endmodule

