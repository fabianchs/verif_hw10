`timescale 1ns / 1ps

module ContadorUp3bits(CLK,RST,ENA,R);
	input CLK,RST,ENA;
	output reg [2:0] R;
	
	always @(negedge CLK or posedge RST)
		if (RST)
			R=3'b000;
		else if (ENA)
			R=R+3'b001;
		else
			R=R;

endmodule
