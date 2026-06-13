`timescale 1ns / 1ps

module Adder16bits(A,B,OP,Cin,R,AF,CF,OF);
	input [15:0] A,B;
	input OP,Cin;
	output [15:0] R;
	output wire AF,CF,OF;
	
	wire C0,C1,C2,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16;
	wire [15:0] opB;
	
	assign AF=C4,
			 CF=C16,
			 OF=(C15^C16);
	
	assign opB[0]=B[0]^OP,opB[1]=B[1]^OP,
			 opB[2]=B[2]^OP,opB[3]=B[3]^OP, 
			 opB[4]=B[4]^OP,opB[5]=B[5]^OP,
			 opB[6]=B[6]^OP,opB[7]=B[7]^OP,
			 opB[8]=B[8]^OP,opB[9]=B[9]^OP, 
			 opB[10]=B[10]^OP,opB[11]=B[11]^OP, 
			 opB[12]=B[12]^OP,opB[13]=B[13]^OP,
			 opB[14]=B[14]^OP,opB[15]=B[15]^OP; 
	
	assign C0=(Cin^OP);
	
	
	FullAdder	AD0 (A[0],opB[0],C0,R[0],C1);
	FullAdder	AD1 (A[1],opB[1],C1,R[1],C2);
	FullAdder	AD2 (A[2],opB[2],C2,R[2],C3);
	FullAdder	AD3 (A[3],opB[3],C3,R[3],C4);
	FullAdder	AD4 (A[4],opB[4],C4,R[4],C5);
	FullAdder	AD5 (A[5],opB[5],C5,R[5],C6); 
	FullAdder	AD6 (A[6],opB[6],C6,R[6],C7);
	FullAdder	AD7 (A[7],opB[7],C7,R[7],C8);
	FullAdder	AD8 (A[8],opB[8],C8,R[8],C9);
	FullAdder	AD9 (A[9],opB[9],C9,R[9],C10);
	FullAdder	AD10 (A[10],opB[10],C10,R[10],C11);
	FullAdder	AD11 (A[11],opB[11],C11,R[11],C12);
	FullAdder	AD12 (A[12],opB[12],C12,R[12],C13);
	FullAdder	AD13 (A[13],opB[13],C13,R[13],C14);
	FullAdder	AD14 (A[14],opB[14],C14,R[14],C15);
	FullAdder	AD15 (A[15],opB[15],C15,R[15],C16);				
							
endmodule 
