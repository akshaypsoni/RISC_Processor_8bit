`timescale 1ns / 1ps
/*
Link_register used during CALL instruction. It stores the Next instruction address(PC+1) in Link Register when CALL instruction executed.
When RET instruction executed, Link Register value loaded in PC for next instruction fetch. 
*/

module Link_register(LR_in, LR_out, clk, LR_load_en);

  input             clk;
  input             LR_load_en;		//Link Register load enable
  input       [7:0] LR_in;	 
  output reg  [7:0] LR_out;			 

  always @(posedge clk)
  begin
    if(LR_load_en)
      LR_out <= LR_in;              //Load link register with PC
	  
	else
      LR_out <= LR_out;             //Hold value until required
  
  end
  
endmodule
