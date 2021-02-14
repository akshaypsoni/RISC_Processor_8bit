`timescale 1ns / 1ps

module mux2x1_8bit(A, B, sel, out);

  input        sel;
  input  [7:0] A;
  input  [7:0] B;
  output [7:0] out;

  assign out = (sel==1'b1)? A : B;
 
endmodule
