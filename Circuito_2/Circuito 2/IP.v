`timescale 1ns / 1ps

module IP(CLK,RST,ENA,WR,WD,DATA,CUENTA,R,RIP);
	input CLK,RST,ENA,WR,WD;
	input [15:0] DATA;
	input [2:0] CUENTA;
	output wire [15:0] R,RIP;

//MUX de entrada
	wire [15:0] DATAIP,Rse;
	SemiAdder16bits SeAd({13'b0,CUENTA[2:0]},RIP,Rse);
	Mux2a1de16bits muxip(Rse,DATA,WD,DATAIP);
	
//Registro IP
	Reg16bitsEnaDown REGIP(CLK,RST,WR|WD,DATAIP,RIP);
	
//Contador
	wire [2:0] Rcont,D;
	Restadorde3bits Restador(3'b110,CUENTA,D);
	ContadorUp3bitsIP Cont(CLK,RST,(WR|WD),ENA,D,Rcont);
	
//sumador
	SemiAdder16bits SAD(RIP,{13'b0,Rcont},R);

endmodule
