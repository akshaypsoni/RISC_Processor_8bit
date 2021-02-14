`timescale 1ns / 1ps

/*
The out port is an 8 bit register latch which is used to store data, that is to be 
displayed to the user.

*/

module out_port(out_port_load, load_en, out_port_out, clk);

  input             clk;
  input             load_en;             //output port latch enable
  input       [7:0] out_port_load;       //data to be displayed
  output reg  [7:0] out_port_out;

    
  always @(posedge clk)
    begin
      if(load_en)
        out_port_out <= out_port_load;   //latch data on to output port only is port is enabled      
        
      else
        out_port_out <= out_port_out;
    end
    
endmodule
