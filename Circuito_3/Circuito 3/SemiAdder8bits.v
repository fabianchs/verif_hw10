`timescale 1ns / 1ps

module SemiAdder8bits(A,B,R);
	input [7:0] A,B;
	output [7:0] R;
	
	wire C0,C1,C2,C4,C5,C6;

	SemiAdderIni	AD0 (A[0],B[0],R[0],C0);
	FullAdder	AD1 (A[1],B[1],C0,R[1],C1);
	FullAdder	AD2 (A[2],B[2],C1,R[2],C2);
	FullAdder	AD3 (A[3],B[3],C2,R[3],C3);
	FullAdder	AD4 (A[4],B[4],C3,R[4],C4);
	FullAdder	AD5 (A[5],B[5],C4,R[5],C5); 
	FullAdder	AD6 (A[6],B[6],C5,R[6],C6);
	SemiAdderFin	AD7 (A[7],B[7],C6,R[7]);
							
endmodule 
