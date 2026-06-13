`timescale 1ns / 1ps

module Comple2d16bitsCin(A,Cin,cmp,R);
	input [15:0] A;
	input Cin,cmp;
	output [15:0] R;

//redes
	wire C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14;
//modulos
	FullComple2 FC0(A[0],Cin,cmp,R[0],C0);
	FullComple2 FC1(A[1],C0,cmp,R[1],C1);
	FullComple2 FC2(A[2],C1,cmp,R[2],C2);
	FullComple2 FC3(A[3],C2,cmp,R[3],C3);
	FullComple2 FC4(A[4],C3,cmp,R[4],C4);
	FullComple2 FC5(A[5],C4,cmp,R[5],C5);
	FullComple2 FC6(A[6],C5,cmp,R[6],C6);
	FullComple2 FC7(A[7],C6,cmp,R[7],C7);
	FullComple2 FC8(A[8],C7,cmp,R[8],C8);
	FullComple2 FC9(A[9],C8,cmp,R[9],C9);
	FullComple2 FC10(A[10],C9,cmp,R[10],C10);
	FullComple2 FC11(A[11],C10,cmp,R[11],C11);
	FullComple2 FC12(A[12],C11,cmp,R[12],C12);
	FullComple2 FC13(A[13],C12,cmp,R[13],C13);
	FullComple2 FC14(A[14],C13,cmp,R[14],C14);
	FullComple2inc FC15(A[15],C14,cmp,R[15]);

endmodule