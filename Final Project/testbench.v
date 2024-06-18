module testbench;

	parameter digis_of_test = 11;
    reg         Clk,St;
    wire        Done;
    wire         V; 
    reg     [3:0]N;
    reg    [3:0]tN[0:digis_of_test];     
    wire  [31:0]rst; 
    integer     i;
    reg 	break;
    wire ready;        // for the purpose of waiting call&replace


    

initial begin
    Clk = 1'b0;
    tN[0] = 4'b0111; tN[1] = 4'b1010; tN[2] = 4'b0110; tN[3] = 4'b1111; tN[4] = 4'b0010; tN[5] = 4'b1100; 		//   7+6/2*3-4+3
    tN[6] = 4'b0011; tN[7] = 4'b1011; tN[8] = 4'b0100; tN[9] = 4'b1010; tN[10] = 4'b0011; tN[11] = 4'b1110;
    i = 0; 
end

initial begin
	St = 1'b0;
    break = 1'b0;
end

assign V = (N != 4'b1101)? 1'b1:1'b0;

initial begin
    forever #20 Clk = ~Clk;
end

always @(posedge Clk)	begin
  	if((St == 1'b1) & (break != 1'b1)) begin
		for(i = 0; i <= digis_of_test; i = i + 1) begin
			if(ready == 1'b0) begin
				@(posedge Clk);
				@(posedge Clk);
			end
			N <= tN[i];
			@(posedge Clk);
			@(posedge Clk);
			if(i == digis_of_test)
				break = 1'b1;
		end
	end
	St = 1'b1;
	if((break == 1'b1) & (Done == 1'b1))
		#5 $finish;
end

initial #3000 $finish;

main_calculator C(Clk, St, N, V, ready, Done, rst);


initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,testbench);
end	

endmodule
