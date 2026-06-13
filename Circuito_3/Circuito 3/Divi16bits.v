`timescale 1ns / 1ps

module Divi16bits(A,B,Comp,R,Cout);
	input [16:0] A;
	input [15:0] B;
	input Comp;
	output wire [15:0] R;
	output wire Cout;

//redes
	wire C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15;
	
//modulos
	FullDivi FD0(A[0],B[0],Comp,Comp,R[0],C0);
	FullDivi FD1(A[1],B[1],Comp,C0,R[1],C1);
	FullDivi FD2(A[2],B[2],Comp,C1,R[2],C2);
	FullDivi FD3(A[3],B[3],Comp,C2,R[3],C3);
	FullDivi FD4(A[4],B[4],Comp,C3,R[4],C4);
	FullDivi FD5(A[5],B[5],Comp,C4,R[5],C5);
	FullDivi FD6(A[6],B[6],Comp,C5,R[6],C6);
	FullDivi FD7(A[7],B[7],Comp,C6,R[7],C7);
	FullDivi FD8(A[8],B[8],Comp,C7,R[8],C8);
	FullDivi FD9(A[9],B[9],Comp,C8,R[9],C9);
	FullDivi FD10(A[10],B[10],Comp,C9,R[10],C10);
	FullDivi FD11(A[11],B[11],Comp,C10,R[11],C11);
	FullDivi FD12(A[12],B[12],Comp,C11,R[12],C12);
	FullDivi FD13(A[13],B[13],Comp,C12,R[13],C13);
	FullDivi FD14(A[14],B[14],Comp,C13,R[14],C14);
	FullDivi FD15(A[15],B[15],Comp,C14,R[15],C15);
 
	assign Cout=((~Comp&A[16]&C15)|(Comp&(A[16]|C15)));
	
endmodule 