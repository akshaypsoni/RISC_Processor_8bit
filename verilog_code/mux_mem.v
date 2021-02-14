`timescale 1ns / 1ps

/*
mux_mem performs enabling Data_Memory read/write according to select inputs.
*/

module mux_mem(en_dec, en_WD, sel_DM_rd, sel_DM_wr, en_DM_rd, en_DM_wr);

  input   en_dec,en_WD;		//enable signals
  input   sel_DM_rd;        //MUX select for Data_Memory read enable
  input   sel_DM_wr;        //MUX select for Data_Memory write enable
  output  en_DM_rd;         //Data_Memory read enable
  output  en_DM_wr;         //Data_Memory write enable

  assign  en_DM_wr  = (sel_DM_wr==1) ? en_WD : 1'b0;

  assign  en_DM_rd  = (sel_DM_rd==0) ? en_dec : 1'b1;

endmodule