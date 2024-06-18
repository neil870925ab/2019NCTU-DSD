module HW3_FPMUL_754SP(Clk, St, FPmplier, FPmcand, Done, Ovf, Unf, FPproduct);

	input Clk, St;
	input [31:0] FPmplier, FPmcand;
	output reg [31:0] FPproduct;
	output reg Ovf, Unf, Done;
	
	wire [47:0] mult_out;
	wire [8:0] expo_out;		//sum the two E
	reg [22:0] F;
	reg [8:0] E, E_biased;
	reg S;
	reg [1:0] state;

	initial begin
		FPproduct = 32'b0;
		E = 9'b0;
		E_biased = 9'b0;
		S = 1'b0;
		state = 2'b0;
	end

	assign mult_out = ({1'b1, FPmplier[22:0]}) * ({1'b1, FPmcand[22:0]});
	assign expo_out = (FPmplier[30:23] - 8'd127) + (FPmcand[30:23] - 8'd127);

	always @ (posedge Clk)	begin
		Done = 1'b0;
		Ovf = 1'b0;
		Unf = 1'b0;

		case(state)
			0: begin
				if(St == 1'b0)
					state <= 2'b00;					
				else
					state <= 2'b01;
			end
			1: begin
				state <= 2'b10;
				S <= FPmplier[31] ^ FPmcand[31];
				if(FPmplier == 32'b0 || FPmcand == 32'b0) begin
					E <= 9'b0;
					E_biased <= 9'b0;
					F <= mult_out[45:23];					
				end
				else if(mult_out[47] == 1'b1) begin
					E <= expo_out + 9'b1;
					E_biased <= expo_out + 9'd128;
					F <= mult_out[46:24];
				end	
				else begin
					E <= expo_out;
					E_biased <= expo_out + 9'd127;
					F <= expo_out[45:23];
				end
			end
			2: begin
				state <= 2'b0;
				Done <= 1'b1;
				if(E_biased > 8'b11111110)
					Ovf = 1'b1;
				if(E_biased < 8'b00000001)
					Unf = 1'b1;
				FPproduct <= {S, E_biased[7:0], F};
			end
			default: begin
				if(St == 1'b0)
					state <= 2'b00;					
				else
					state <= 2'b01;
			end
		endcase
	end 
endmodule
