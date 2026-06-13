`timescale 1ns / 1ps

module ContadorUp3bitsIP(CLK,RST,SET,ENA,D,R);
	input CLK,RST,SET,ENA;
	input [2:0] D;
	output reg [2:0] R;
	
	always @(negedge CLK or posedge RST)
		if (RST)
			R=3'b000;
		else if (SET)
			R=D;
		else if (ENA)
			R=R+3'b001;
		else
			R=R;

endmodule
