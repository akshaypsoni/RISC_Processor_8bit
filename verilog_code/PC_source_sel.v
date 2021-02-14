`timescale 1ns / 1ps
/*

The PC is loaded with an address during branch, jump, call and return instructions.
The PC source select block is used to give the select input to the 
mux that is used to select the source form which PC is loaded. 
|  Instruction  |     Source    |
---------------------------------
|    Branch     |   I_register  |
|     Jump      |   I_register  |
|     Call      |   I_register  |
|    Return     | Link Register |
----------------------------------
*/
module PC_source_sel(clk,ireg_in,out);

  input            clk;
  input      [5:0] ireg_in;
  output reg       out;

  always @(negedge clk)
  begin
    if(ireg_in == 6'b110000)      //Return instruction
      out <= 0;		
    else 
      out <= 1;                   //Other instructions
	  
  end

endmodule
