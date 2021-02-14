`timescale 1ns / 1ps

module mux4x1_8bit(A, B, C, sel, out);

  input      [7:0] A;
  input      [7:0] B;
  input      [7:0] C;
  input      [1:0] sel;
  output reg [7:0] out;

  always@(*)
  begin
    case(sel)
      2'b00:  out <= B;
      2'b10:  out <= A;
      2'b01:  out <= C;
      2'b11:  out <= 0;
    default:  out <= 0;

   endcase
  end
 
endmodule
