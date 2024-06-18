module testbench;
  reg  Clk;
  reg  X1,X2,X3;
  wire Z1,Z2,Z3;
  reg  tX1[0:7],tX2[0:7],tX3[0:7];
  integer i;

 initial
  begin
        i = 0;
  	Clk = 0;
  	forever #10 Clk = ~Clk;
  end

 initial
  begin
  	tX1[0] = 0; tX2[0] = 0; tX3[0] = 0;
  	tX1[1] = 1; tX2[1] = 0; tX3[1] = 1;
  	tX1[2] = 0; tX2[2] = 1; tX3[2] = 1;
  	tX1[3] = 1; tX2[3] = 0; tX3[3] = 0;
  	tX1[4] = 0; tX2[4] = 1; tX3[4] = 0;
  	tX1[5] = 1; tX2[5] = 0; tX3[5] = 1;
  	tX1[6] = 1; tX2[6] = 1; tX3[6] = 1;
  	tX1[7] = 0; tX2[7] = 0; tX3[7] = 0;
        X1 = 1; X2 = 1; X3 = 0;
  end

 always @(posedge Clk) begin
 	  #5 X1 = tX1[i];
 	     X2 = tX2[i];
 	     X3 = tX3[i];
 	     i = i + 1;
 end

initial #200 $finish;

HW_3_SQTA_microprogram M1(Clk,X1,X2,X3,Z1,Z2,Z3);

endmodule
