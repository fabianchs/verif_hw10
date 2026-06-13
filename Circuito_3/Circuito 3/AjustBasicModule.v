`timescale 1ns / 1ps

//intrucciones de op
// op=00 => sin ajuste
// op=01 => sin ajuste
// op=10 => Ajuste Ascii (AAA o AAS)
// op=11 => Ajuste Decimal (DAA o DAS)

module AjustBasicModule(Ain,Bin,op,CFin,AFin,A,B,CF,AF);
	input [15:0] Ain,Bin;
	input [1:0] op;
	input AFin,CFin;
	output wire [15:0] A,B;
	output wire CF,AF;
	
	wire MA,MD;
	assign MA=(AFin|(Ain[3]&(Ain[2]|Ain[1])));
	assign MD=(CFin|(Ain[7]&(Ain[6]|Ain[5])));	
		
//Modulo de memoria
	wire [2:0] Dir;
	assign Dir={op[0],MD,MA};
   wire [15:0] Sal;
	RomDatosAjustBasic Rom(Dir,Sal);

//Salida
	Mux2a1de16bits MuxB(Bin,Sal,op[1],B);
	assign A=Ain;
	assign AF=op[1]&MA;
	assign CF=op[1]&((~op[0]&AF)|(op[0]&MD));
	
endmodule
