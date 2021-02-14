`timescale 1ns / 1ps
/*
The instructions to be executed are stored in the Program memory.
For execution to begin, the processor is held in reset and the Memory is loaded with instructions.
The program memory can hold 256 instructions of 16 bits each.
*/



module Program_Memory(clk,rden,rd_addr,instr,wr_addr,wr_data,we);

  input             clk;                  //clock
  input      [15:0] wr_data;              //Write data 
  input      [7:0]  rd_addr,wr_addr;	  //Read address, write address
  input             rden;				  //Read enable
  input      [1:0]  we;                   //Write enable
  output reg [15:0] instr;                //Instruction Fetch from Instruction_mem
    
  reg        [15:0] Instruction_mem [255:0];	//256 Registers each of 16 bit

  always@(posedge clk)
  begin
    if(we == 2'b11)
      Instruction_mem[wr_addr] =   wr_data;                      //port for loading instructions into memory
	  
    if(rden)
      instr                    =   Instruction_mem[rd_addr];     //Instruction fetch   
	  
    else
      instr                    =   16'd0;                        //Output is normally zero when instruction is not being fetched
	  
  end
  
endmodule
