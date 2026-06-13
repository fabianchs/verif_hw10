`timescale 1ns / 1ps

module FSMDivi(CLK,RST,ENA,FIN,PRE);
	input CLK,RST,ENA;
	output [3:0] PRE;
	output wire FIN;
	
	//Registros de estado
	reg [3:0] PRE,FUT;
	parameter T0=4'b0000,T1=4'b0001,T2=4'b0010,T3=4'b0011,
				 T4=4'b0100,T5=4'b0101,T6=4'b0110,T7=4'b0111,
				 T8=4'b1000,T9=4'b1001,T10=4'b1010,T11=4'b1011,
				 T12=4'b1100,T13=4'b1101,T14=4'b1110,T15=4'b1111;

//Cambio de estado
	always @(negedge CLK or posedge RST)
		if (RST)
			PRE=T0;
		else 
			PRE=FUT;

//Seleccion de Siguiente estado			
	always @(PRE or ENA)
		case (PRE)
			T0: if (ENA)
					FUT=T1;
				 else
					FUT=T0;
			T1: FUT=T2;
			T2: FUT=T3;
			T3: FUT=T4;
			T4: FUT=T5;
			T5: FUT=T6;
			T6: FUT=T7;
			T7: FUT=T8;
			T8: FUT=T9;
			T9: FUT=T10;
			T10: FUT=T11;
			T11: FUT=T12;
			T12: FUT=T13;
			T13: FUT=T14;
			T14: FUT=T15;
			T15: FUT=T0;
		endcase

//Asignaciones de salida
	assign FIN=(~PRE[3]&~PRE[2]&~PRE[1]&~PRE[0]);

endmodule
