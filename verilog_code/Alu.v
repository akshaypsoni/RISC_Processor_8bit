`timescale 1ns / 1ps
/*
ALU performs all arithmatical and logical operation on inputs according aluop input.
Carry Flag, Zero Flag changes according to execution.
*/
module Alu(clk, en_alu, RD, RA, aluop, out, cy, zy);

  input         clk;                                           // clock
  input         en_alu;                                        // ALU enable
  input  [7:0]  RD;                                            // Operand_2 Data 
  input  [7:0]  RA;  	                                       // Operand_1 Data
  input  [4:0]  aluop;                                         // alu operation 
  output [7:0]  out;                                           // alu result
  output        cy,zy;                                         // carry and zero flag
	 
  reg    [8:0]  result;                                        //All operation will take place at this reg

  assign cy  =  result[8];                                     //assigning carry to the last bit of result
 
  assign out =  result[7:0];                                   //assigning result to output of 8 bits data
 
  assign zy  = (result == 9'd0) ? 1'b1 : 1'b0;                 //zero flag

  always @(posedge clk)
  begin
    if(en_alu)
    begin
      case(aluop)
        
        5'b00000: result        <=   RD;                        // NOP,STS,LD
        
        5'b00001: result        <=   RD + RA;                   // Addition ADD, Left shift by 1(LSL)
        
        5'b00010: result        <=   RD + RA + result[8];       // Add with carry(ADC), Left shift through carry(ROL)
        
        5'b00011: result        <=   RD - RA;                   // Subtraction SUB
        
        5'b00100: result        <=   RD & RA;                   // AND_operation
        
        5'b00101: result        <=   RD | RA;                   // OR_operation
        
        5'b00110: result        <=   RD ^ RA;                   // XOR
        
        5'b00111: result        <=   RD + 1'b1;                 // Increment INC
        
        5'b01000: result        <=   RD - 1'b1;                 // Decrement DEC
            
        5'b01001: result        <=  ~RD;                        // Complement COM
            
        5'b01010: result[7:0]   <=   RD >> 1;                   // Right_shift by 1 (LSR)
            
        5'b01011: begin                                         // Compare CP & CPI
                   if(RD != RA)
                      result[8] <=   1;
				   else 
                      result[8] <=   0;    
                   result[7:0]  <=  RD;
                  end
                      
        5'b01100: result        <=   {RD[0],result[8],RD[7:1]};  // Right shift through carry ROR
            
        5'b01101: result        <=   ~ RD + 1;                   // 2's Complement NEG
            
        5'b01110: result        <=  {result[8],RD[7],RD[7:1]};   // Arithmetic Shift Right ASR
            
        5'b01111: result        <=  {RD[3:0],RD[7:4]};           // swap nibbles SWAP
            
        5'b11110: result        <=  RA;                          // buffer for MOV
            
        default : result        <=  0;
        
      endcase
	  
    end
        
  end

endmodule
