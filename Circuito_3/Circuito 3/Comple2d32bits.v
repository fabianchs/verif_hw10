`timescale 1ns / 1ps

module Comple2d32bits(A,Cin,cmp,R);
	input [31:0] A;
	input Cin,cmp;
	output [31:0] R;

//redes
	wire C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,
		  C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30;
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
	FullComple2 FC15(A[15],C14,cmp,R[15],C15);
	FullComple2 FC16(A[16],C15,cmp,R[16],C16);
	FullComple2 FC17(A[17],C16,cmp,R[17],C17);
	FullComple2 FC18(A[18],C17,cmp,R[18],C18);
	FullComple2 FC19(A[19],C18,cmp,R[19],C19);
	FullComple2 FC20(A[20],C19,cmp,R[20],C20);
	FullComple2 FC21(A[21],C20,cmp,R[21],C21);
	FullComple2 FC22(A[22],C21,cmp,R[22],C22);
	FullComple2 FC23(A[23],C22,cmp,R[23],C23);
	FullComple2 FC24(A[24],C23,cmp,R[24],C24);
	FullComple2 FC25(A[25],C24,cmp,R[25],C25);
	FullComple2 FC26(A[26],C25,cmp,R[26],C26);
	FullComple2 FC27(A[27],C26,cmp,R[27],C27);
	FullComple2 FC28(A[28],C27,cmp,R[28],C28);
	FullComple2 FC29(A[29],C28,cmp,R[29],C29);
	FullComple2 FC30(A[30],C29,cmp,R[30],C30);
	FullComple2inc FC31(A[31],C30,cmp,R[31]);

endmodule
