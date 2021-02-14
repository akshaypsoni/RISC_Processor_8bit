`timescale 1ns / 1ps
/*
Control_Unit performs enabling modules according to cycle.
IDLE, only      : Program_Memory enable is high to fetch instruction.
FETCH_CYCLE     : enable signal given to Instruction_Register to fetch instruction from Program_Memory.
DECODE_CYCLE    : enable signal given to Instruction_Decoder to decode the Instruction REG.
EXECUTE_CYCLE   : enable signal given to ALU to perform its operations. 
WRITEBACK_CYCLE : enable signal given to Register_File to write data. 
*/
module Control_Unit(clk, reset, en_ProgMem, en_Fetch, en_Decode, en_Execute, en_Writeback);

  input      clk;                 
  input      reset;                
  output reg en_ProgMem;           //Program_Memory enable
  output reg en_Fetch;             //Fetch enable
  output reg en_Decode;            //Decode enable
  output reg en_Execute;           //Execute enable
  output reg en_Writeback;         //Writeback enable

  reg [3:0] ps;                    //Present state
  reg [3:0] ns;                    //Next state
  
  parameter IDLE            =  4'b0000;
  parameter FETCH_CYCLE     =  4'b0001;    
  parameter DECODE_CYCLE    =  4'b0010;
  parameter EXECUTE_CYCLE   =  4'b0011;
  parameter WRITEBACK_CYCLE =  4'b0100;    
  
  always@(negedge clk)
  begin
   if(reset)
     ps <= IDLE;
   else
     ps <= ns;
  end
 
  always@(ps)
  begin
    case(ps)
	
      IDLE:
	    begin
          ns           <= FETCH_CYCLE;
          en_ProgMem   <= 1;
          en_Fetch     <= 0;
          en_Decode    <= 0;
          en_Execute   <= 0;
          en_Writeback <= 0;    
        end
		
      FETCH_CYCLE:
	    begin 
          ns           <= DECODE_CYCLE;
          en_ProgMem   <= 0;
          en_Fetch     <= 1;
          en_Decode    <= 0;
          en_Execute   <= 0;
          en_Writeback <= 0;
        end
    
      DECODE_CYCLE: 
	    begin
          ns           <= EXECUTE_CYCLE;
          en_ProgMem   <= 0;
          en_Fetch     <= 0;
          en_Decode    <= 1;
          en_Execute   <= 0;
          en_Writeback <= 0;
        end
    
      EXECUTE_CYCLE: 
	    begin
          ns           <= WRITEBACK_CYCLE;
          en_ProgMem   <= 0;
          en_Fetch     <= 0;
          en_Decode    <= 0;
          en_Execute   <= 1;
          en_Writeback <= 0;
        end

      WRITEBACK_CYCLE: 
	    begin
          ns           <= FETCH_CYCLE;
          en_ProgMem   <= 1;
          en_Fetch     <= 0;
          en_Decode    <= 0;
          en_Execute   <= 0;
          en_Writeback <= 1;
        end
    
      default: 
	    begin
	      ns           <= IDLE;
          en_ProgMem   <= 0;
          en_Fetch     <= 0;
          en_Decode    <= 0;
          en_Execute   <= 0;
          en_Writeback <= 0;  
        end
	   
    endcase
	
  end

endmodule 
