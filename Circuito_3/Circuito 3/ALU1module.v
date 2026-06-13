`timescale 1ns / 1ps

//intrucciones de op
// op=000 => ADD
// op=001 => OR
// op=010 => ADC
// op=011 => SBB
// op=100 => AND
// op=101 => SUB
// op=110 => XOR
// op=111 => CMP

module ALU1module(opA,opB,Cin,op,R,CFA,AFA,OFA);
	input [15:0] opA,opB;
	input Cin;
	input [2:0] op;
	output wire [15:0] R;
	output wire CFA,AFA,OFA;
	
//modulos de operacion
	wire [15:0] RAND,ROR,RXOR,RSUM;
	wire CinAdder,AF,CF,OF;
	assign CinAdder=(Cin&op[1]&~op[2]);
	ANDmodule AND(opA,opB,RAND);
	ORmodule OR(opA,opB,ROR);
	XORmodule XOR(opA,opB,RXOR);
	Adder16bits Adder(opA,opB,op[0],CinAdder,RSUM,AF,CF,OF);

//Deco de Salidas
	wire [1:0] opMux;
	wire FA,FS;
	DecoALU1module DecSal(op,opMux,FA,FS);
	
//Mux de salida de datos
	Mux4a1de16bits MuxRDatos(RAND,ROR,RXOR,RSUM,opMux,R);
	
//Asignacion de Banderas	
	assign CFA=(CF&FA)|(~CF&FS);
	assign AFA=(AF&FA)|(~AF&FS);
	assign OFA=OF&(FA|FS);
endmodule
