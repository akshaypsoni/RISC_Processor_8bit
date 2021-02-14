`timescale 1ns / 1ps
/*
The input port is used to get inputs from the user.
*/
module in_port(in,out,clk);

  input            clk;
  input      [7:0] in;
  output reg [7:0] out;

  always @(negedge clk)
  begin
    out <= in;
  end
  
endmodule
