module t_HW1_recognizer;
   wire Z1,Z2,Z3;
   reg  X;
   reg  clk,clr;

HW1_recognizer_behavioral M1(Z1,X,clk,clr);
HW1_recognizer_dataflow  M2(Z2,X,clk,clr);
HW1_recognizer_structural M3(Z3,X,clk,clr);

initial 
   begin
      clr = 0;
      clk = 0;
      #10 clr = 1;
      forever #10 clk = ~clk;
      
   end

initial
   begin
        X = 1'b0;
    #30 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b0;
    #20 X = 1'b1;
    #20 X = 1'b1;
    #20 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b1;
    #20 X = 1'b1;
    #20 X = 1'b0;
    #20 X = 1'b1;
  end
initial #400 $finish;
endmodule
 