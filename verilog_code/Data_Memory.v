`timescale 1ns / 1ps
/*
Data_Memory consists of 256 bytes RAM (256 locations each of 8 bit). 
It is used in store(STS) and load(LD) instruction.
*/
module Data_Memory(clk,en_DM_rd,en_DM_wr,mem_addr,mem_din,mem_dout);
  
  input             clk;				  //clock
  input             en_DM_rd;                             //enable data read (mem_addr)
  input             en_DM_wr;                             //enable data write (mem_din) 
  input      [7:0]  mem_addr;                             //memory address
  input      [7:0]  mem_din;                              //memory data input
  output reg [7:0]  mem_dout;                             //memory data output

  reg        [7:0]  data_memory[0:255];                   //256 registers of 8 bits each

  always@(posedge clk)
  begin
    if(en_DM_rd)
      begin
        mem_dout              <= data_memory[mem_addr];	  //Reading data from mem_addr in data_memory
      end
	
    if(en_DM_wr)
      begin
        data_memory[mem_addr] <= mem_din;                //writing data to mem_addr in data_memory
      end
  end

endmodule
