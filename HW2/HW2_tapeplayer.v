module HW2_tapeplayer(Clk, PL, RE, FF, ST, M, P, R, F);
input Clk, PL, RE, FF, ST, M;
output reg P, R, F;
reg [2:0] state, nextstate;

parameter ini = 0;
parameter rewind = 1;
parameter play = 2;
parameter fastforward = 3;
parameter slowbackward = 4;
parameter slowforward = 5;


initial	begin
	state = 0;
	nextstate = 0;
	P = 0;
	R = 0;
	F = 0;
end

always @(posedge Clk) begin
	state <= nextstate;
end

always@(state, PL, RE, FF, ST, M) begin

	R = 0;
	P = 0;
	F = 0;

	case(state)
		0:	//ini
			begin
				if(RE == 1)
					nextstate = rewind;
				else if(PL == 1)
					nextstate = play;
				else if(FF == 1)
					nextstate = fastforward;
				else
					nextstate = ini; 
			end
		1:	//rewind
			begin
				R = 1;
				if((ST == 1) || (FF == 1))
					nextstate = ini;
				else if(PL == 1)
					nextstate = play;
				else
					nextstate = rewind;
			end
		2:	//play
			begin
				P = 1;
				if((ST == 1) || (PL == 0))
					nextstate = ini;
				else if((PL == 1) && (RE == 1))
					nextstate = slowbackward;
				else if((PL == 1) && (FF == 1))
					nextstate = slowforward;
				else
					nextstate = play;
			end
		3:	//fastforward
			begin
				F = 1;
				if((ST == 1) || (RE == 1))
					nextstate = ini;
				else if(PL == 1)
					nextstate = play;
				else
					nextstate = fastforward;
			end
		4:	//slowbackward
			begin
				R = 1;
				if(ST == 1)
					nextstate = ini;
				else if((ST == 0) && (M == 0))
					nextstate = play;
				else
					nextstate = slowbackward;
			end
		5:	//slowforward
			begin
				F = 1;
				if(ST == 1)
					nextstate = ini;
				else if((ST == 0) && (M == 0))
					nextstate = play;
				else 
					nextstate = slowforward;
			end	
	endcase
end

endmodule
