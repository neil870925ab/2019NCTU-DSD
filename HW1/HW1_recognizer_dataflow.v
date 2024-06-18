module HW1_recognize_dataflow(Z, X, CLK, CLR);

input X, CLK, CLR;
output Z;
reg Q2, Q1, Q0;
wire not_q0, not_q1, not_q2, not_x, w1, w2, w3, 
	w5, w6, w7, w8, w10, w11, w12, w13, w14, w15, w16;


always @ (posedge CLK, negedge CLR) begin

	if(CLR==0) begin

		Q2 = 0;
		Q1 = 0;
		Q0 = 0;
	end

end


assign not_q0 = ~Q0;
assign not_q1 = ~Q1;
assign not_q2 = ~Q2;
assign not_x = X;

assign w1 = X & Q1;		//D2
assign w2 = not_x & not_q0;
assign w3 = w2 & Q2;
assign Q2 = w1 | w3;

assign w5 = w2 & Q1;           //D1
assign w6 = X & not_q2;
assign w7 = not_q1 & Q0; 
assign w8 = w6 & w7; 
assign Q1 = w5 | w8;

assign w10 = Q0 & Q1;           //D0 
assign w11 = not_x & not_q2;
assign w12 = w10 | w11;
assign Q0 = w2 | w12; 

assign w13 = not_x & Q2; 	 //Z
assign w14 = Q2 & Q0;
assign W15 = X & w10;  
assign w16 = w13 | w14;
assign Z = w15 | w16;  

	



endmodule
