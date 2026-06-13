`timescale 1ns / 1ps

module SemiAdder16bits(A,B,R);
	input [15:0] A,B;
	output [15:0] R;
	
	wire C0,C1,C2,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14;

	SemiAdderIni	AD0 (A[0],B[0],R[0],C0);
	FullAdder	AD1 (A[1],B[1],C0,R[1],C1);
	FullAdder	AD2 (A[2],B[2],C1,R[2],C2);
	FullAdder	AD3 (A[3],B[3],C2,R[3],C3);
	FullAdder	AD4 (A[4],B[4],C3,R[4],C4);
	FullAdder	AD5 (A[5],B[5],C4,R[5],C5); 
	FullAdder	AD6 (A[6],B[6],C5,R[6],C6);
	FullAdder	AD7 (A[7],B[7],C6,R[7],C7);
	FullAdder	AD8 (A[8],B[8],C7,R[8],C8);
	FullAdder	AD9 (A[9],B[9],C8,R[9],C9);
	FullAdder	AD10 (A[10],B[10],C9,R[10],C10);
	FullAdder	AD11 (A[11],B[11],C10,R[11],C11);
	FullAdder	AD12 (A[12],B[12],C11,R[12],C12);
	FullAdder	AD13 (A[13],B[13],C12,R[13],C13);
	FullAdder	AD14 (A[14],B[14],C13,R[14],C14);
	SemiAdderFin	AD15 (A[15],B[15],C14,R[15]);
							
endmodule 
