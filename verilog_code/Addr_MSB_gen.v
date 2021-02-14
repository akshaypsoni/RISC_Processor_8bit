/*
Addr_MSB_gen calculates Destination Register address MSB bit(RD_addr_MSB) depending upon the opcode from Instruction Register.
Normally, Instructions have 5 bit for Destination Register address(RD_addr) but some instructions have only 4 bit for RD_addr. 
*/

module Addr_MSB_gen(clk, en_Fetch, I, RD_addr_MSB_ip, RD_addr_MSB);

  input           clk;
  input           en_Fetch;
  input     [3:0] I;
  input           RD_addr_MSB_ip;
  output reg      RD_addr_MSB;
    
  always@(negedge clk)
    begin
      if(en_Fetch)
        begin
          //checking Instructions with 4 bit RD_Addr
          if((I==4'b0011)||(I==4'b0110)||(I==4'b0111)||(I==4'b1000)||(I==4'b1010)||(I==4'b1110))	
            RD_addr_MSB  <= 1'b0;	
          else
            RD_addr_MSB  <= RD_addr;
        end
    end

endmodule
