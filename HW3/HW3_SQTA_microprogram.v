module HW_3_SQTA_microprogram (Clk,X1,X2,X3,Z1,Z2,Z3);
   input  Clk;
   input  X1,X2,X3;
   output Z1,Z2,Z3;
   reg    Z1,Z2,Z3;
   reg    [2:0]state;
   reg    [2:0]NSF;
   reg    [2:0]NST;
   reg   [1:0]test;
   reg    q; 

parameter  S0 = 3'b000, S01 = 3'b001, S02 = 3'b010, S03 = 3'b011;
parameter  S04 = 3'b100, S1 = 3'b101, S2 = 3'b110;


initial 
  begin
  	state = S0;
  	NSF = S02; NST = S01;
       test = 2'b10;
 end

always @(X1,X2,X3) begin
	case(test)
	 2'b00:begin
	 	    q = 1;
	       end
	 2'b01:begin
	 	    q = X1;
	       end
	 2'b10:begin
	 	    q = X2;
	       end
   default:begin
	 	    q = X3;
	       end
	 endcase
end

always @(X1,X2,X3,state) begin
	Z1 = 0;
        Z2 = 0;
        Z3 = 0;
	case(state)
	  S0:begin
	  	   NSF <= S02; NST <= S01;
                   test <= 2'b10;
	     end
	 S01:begin
	 	   NSF <= S03; NST <= S04;
	 	   test <= 2'b01;
	 	   Z1 = 1;
	     end
	 S02:begin
	 	   NSF <= S1; NST <= S1;
	 	   test <= 2'b00;
	 	   Z2 = 1;
	     end
	 S03:begin
	 	   NSF <= S2; NST <= S2;
	 	   test <= 2'b00;
	 	   Z3 = 1;
	     end
	 S04:begin
	 	   NSF <= S1; NST <= S2;
	 	   test <= 2'b11;
	     end
	  S1:begin
	  	   NSF <= S1; NST <= S2;
	  	   test <= 2'b10;
	  	   Z1 = 1;
	     end
	  S2:begin
	  	   NSF <= S1; NST <= S0;
	  	   test <= 01;
	  	   Z1 = 1;
	     end
	endcase
end

always@(posedge Clk) begin
	case(q)
     0:begin
     	state <= NSF;
       end
     1:begin
     	state <= NST;
       end
    endcase
end

endmodule
