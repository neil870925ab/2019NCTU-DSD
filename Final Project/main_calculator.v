module main_calculator(Clk,St,N,V,ready,Done,result);
     input        Clk,St;
     input   [3:0]N;
     input        V;
     output [31:0]result;
     output       Done, ready;
     reg        Ldopt,Ldopd;
     reg        Cal_R, Cal_D;
     reg  signed[31:0]result;
     reg     [3:0]state;
     reg     [3:0]nextstate;
     reg  signed[31:0]opd[4:0];
     reg     [3:0]opr[4:0];
     reg          Done, ready;
     integer      dindex,rindex,i,j;

parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100;
parameter S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000, S9 = 4'b1001, S10 = 4'b1010;

parameter Add = 4'b1010, Sub = 4'b1011, Mul = 4'b1100, Div = 4'b1111, Eql = 4'b1110;


initial
  begin
  	dindex = 0; rindex = 0;
  	result = 32'b0; i = 0; j = 1;
  	state = S0; nextstate = S0;
  	opd[0] = 32'd0; opd[1] = 32'd0; opd[2] = 32'd0; opd[3] = 32'd0; opd[4] = 32'd0;
  	opr[0] = 4'b0000; opr[1] = 4'b0000; opr[2] = 4'b0000; opr[3] = 4'b0000; opr[4] = 4'b0000;
  end


always @(St,state,V,N,result) begin
    Ldopd = 1'b0; Ldopt = 1'b0;
    Cal_D = 1'b0;
    Cal_R = 1'b0;  Done = 1'b0; ready = 1'b1;
	case(state)
	  S0:begin
	  	   if(St == 1'b1)
	  	      begin
	  	      	nextstate = S1;
	  	      end
	  	    else
	  	      begin
	  	      	nextstate = S0;
	  	      end
	     end
	  S1:begin
	  	   if(V == 1'b1)
	  	     begin
	  	       if(N == Add || N == Sub || N == Mul || N == Div || N == Eql)
	  	         begin
	  	           nextstate = S4; 	
	  	         end 
	  	       else 
	  	         begin
	  	           nextstate = S2;
	  	         end
	  	     end
	  	   else
	  	     begin
	  	       nextstate = S1;
	  	     end
	     end
	  S2:begin
	  	   Ldopd = 1'b1;
	  	   nextstate = S3;
	     end
	  S3:begin
	  	   if(V == 1'b1)
	  	     begin
	  	       if(N == Add || N == Sub || N == Mul || N == Div || N == Eql)
	  	         begin
	  	           nextstate = S4; 	
	  	         end 
	  	       else 
	  	         begin
	  	           nextstate = S2;
	  	         end
	  	     end
	  	   else
	  	     begin
	  	       nextstate = S3;
	  	     end
	     end
	  S4:begin
	  	   Ldopt = 1'b1;
	  	   if(N == Eql)
	  	     begin
	  	     	nextstate = S9;
	  	     end
	  	   else
	  	     begin
	  	     	if(N == Mul || N == Div)
	  	     	  begin
	  	     	  	nextstate = S5;
	  	     	  end
	  	     	else
	  	     	  begin
	  	     	  	nextstate = S1;
	  	     	  end
	  	     end
	     end
	  S5:begin
	  	   if(V == 1'b1)
	  	     begin
	  	       if(N == Add || N == Sub || N == Mul || N == Div || N == Eql)
	  	         begin
	  	           nextstate = S5; 	
	  	         end 
	  	       else 
	  	         begin
	  	           nextstate = S6;
	  	         end
	  	     end
	  	   else 
	  	     begin
	  	     	nextstate = S5;
	  	     end
	     end
	  S6:begin
	  	   Ldopd = 1'b1;
	  	   nextstate = S7;
	     end
	  S7:begin
	  		ready = 1'b0;
	  	    if(V == 1'b1)
	  	     begin
	  	       if(N == Add || N == Sub || N == Mul || N == Div || N == Eql)
	  	         begin
	  	           if(N == Eql)
	  	             begin
	  	               dindex = dindex - 1;
	  	               Ldopt = 1'b1;
	  	               nextstate = S10; 
	  	             end
	  	           else
	  	           	begin
	  	           	  nextstate = S8;
	  	           	end
	  	         end 
	  	       else 
	  	         begin
	  	           nextstate = S6;
	  	         end
	  	     end
	  	   else 
	  	     begin
	  	     	nextstate = S7;
	  	     end
	     end
      S8:begin
      	   Cal_R = 1'b1;
      	   if(N == Add || N == Sub || N == Mul || N == Div || N == Eql) begin
      	   	 if(N == Add || N == Sub) begin
      	   	   nextstate = S3;
	      	   ready = 1'b0;
      	   	 end
	      	 else if(N == Mul || N == Div)
	      	   nextstate = S7;	
      	   end 
         end
      S9:begin
      	   if(result != 0)
      	     begin
      	       nextstate = S0;
      	       Done = 1'b1;
      	     end
      	   else
      	     begin
      	       Cal_D = 1'b1;
      	       nextstate = S9;
      	     end
         end
     S10:begin
           rindex = rindex - 1;
      	   Cal_R = 1'b1;
      	   nextstate = S9;
         end
    endcase
end




always @(posedge Clk) begin
	state <= nextstate;
	if(Ldopd == 1'b1)
	  begin
	  	if(opd[dindex] != 0)
          begin
          	opd[dindex] = opd[dindex]*4'd10 + N;
          end
        else
          begin
          	opd[dindex] = N;
         end
        Ldopd = 1'b0;
	  end
    if(Ldopt == 1'b1)
      begin
        dindex = dindex + 1;
      	opr[rindex] = N;
      	rindex = rindex + 1;
      	Ldopt = 1'b0;
      end
    if(Cal_R == 1'b1)
      begin
      	case(opr[rindex-1])
      	  Mul:begin
      	  	    opd[dindex-1] = opd[dindex]*opd[dindex-1];
      	  	    opd[dindex] = 0;
      	  	    opr[rindex-1] = N;
      	      end
      	  Div:begin
      	  	    opd[dindex-1] = opd[dindex-1]/opd[dindex];
      	  	    opd[dindex] = 0;
      	  	    opr[rindex-1] = N;
      	      end
      	endcase
      end
    if(Cal_D == 1'b1)
      begin
         $display("%d %d %d %d %d",opd[0],opd[1],opd[2],opd[3],opd[4]);
      	 case(opr[i])
      	   Add:begin
      	 	    opd[0] = opd[0] + opd[j];
      	 	    j = j +1;
      	       end
      	   Sub:begin
      	 	    opd[0] = opd[0] - opd[j];
      	 	    j = j +1;
      	       end
      	   Mul:begin
      	 	    opd[0] = opd[0]*opd[j];
      	 	    j = j +1;
      	       end
      	   Div:begin
      	 	    opd[0] = opd[0] / opd[j];
      	 	    j = j +1;
      	       end
      	 endcase
      	 if(i == rindex-1)
      	   begin
      	   	result = opd[0];
      	   	$display("result: %d",opd[0]);
      	   	Cal_D = 1'b0;
      	   end
      	 else begin
      	 	i = i + 1;
      	 end
      end
end


endmodule



