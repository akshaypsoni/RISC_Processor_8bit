`timescale 1ns / 1ps
/*
Instruction_Decoder decodes the instruction REG and gives respective outputs according to instruction REG.
It makes path for the current instruction REG.
*/
module Instruction_Decoder(clk, ID, en_dec, aluop, sel_alu_ip, sel_DM_rd, sel_DM_wr, sel_pc_load, cy, zy, sel_LR_load, sel_out_port);
	
  input             clk;                //clock
  input      [10:0] ID;	                //16-bit Instruction REG
  input             en_dec;             //decoder enable
  input             cy;	                //carry flag
  input             zy;                 //zero flag
  output reg [4:0]  aluop;              //ALU function         
  output reg        sel_DM_rd;          //MUX select for Data_Memory read enable	
  output reg        sel_DM_wr;          //MUX select for Data_Memory write enable
  output reg        sel_pc_load;        //MUX select for PC_load enable
  output reg        sel_LR_load;        //MUX select for LR_load_en
  output reg        sel_out_port;       //MUX select for Output port enable
  output reg [2:0]  sel_alu_ip;         //MUX select for ALU inputs

/*
  initial 
  begin
   sel_alu_ip   = 3'b000;
   sel_DM_rd    = 1'b0;
   sel_DM_wr    = 1'b0;
   sel_pc_load  = 1'b0;
   sel_out_port  = 0;
  end
*/
	
  always@(posedge clk)
  begin
  
    if(en_dec)
    begin
	
      case(ID[10:7])	
	  
        //---------------------------ADD, LSL, NOP----------------------------------
        4'b0000:begin
                  if(ID[6]==1)	
                    aluop          <=  5'b00001;             //ADD, LSL
                  else
                    aluop          <=  5'b00000;             //NOP
						
                  sel_alu_ip       <=  3'b000;
                  sel_DM_wr        <=  1'b0;
                  sel_DM_rd        <=  1'b0;
                  sel_pc_load      <=  1'b0;
                  sel_LR_load      <=  1'b0;
                  sel_out_port     <=  1'b0;
                end
					
        //-------------------------ADC, SUB, CP, ROL--------------------------------
        4'b0001:begin
                  case(ID[6:5])
                    2'b01: aluop   <=  5'b01011;             //CP
                    2'b10: aluop   <=  5'b00011;             //SUB
                    2'b11: aluop   <=  5'b00010;             //ADC,ROL
                  endcase
				
                  sel_alu_ip       <=   3'b000;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;
                  sel_pc_load      <=   1'b0;
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end
			
        //-------------------------AND, OR, EOR, MOV--------------------------------
        4'b0010:begin
                  case(ID[6:5])	
                    2'b00:aluop    <=  5'b00100;             //AND
                    2'b01:aluop    <=  5'b00110;             //EOR
                    2'b10:aluop    <=  5'b00101;             //OR
                    2'b11:aluop    <=  5'b11110;             //MOV						
                  endcase 
					 
                  sel_alu_ip       <=    3'b000;
                  sel_DM_wr        <=    1'b0;
                  sel_DM_rd        <=    1'b0;
                  sel_pc_load      <=    1'b0;
                  sel_LR_load      <=    1'b0;
                  sel_out_port     <=    1'b0;
                end
			
        //-------------------------------CPI----------------------------------------	
        4'b0011:begin
                  aluop            <=   5'b01011;            //CPI
                  sel_alu_ip       <=   3'b100;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;
                  sel_pc_load      <=   1'b0;                       
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end
				   
        //-------------------------------OPI----------------------------------------	
        4'b0110:begin
                  aluop            <=   5'b00101;            //OPI
                  sel_alu_ip       <=   3'b100;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;
                  sel_pc_load      <=   1'b0;
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end
                   
        //------------------------------ANDI----------------------------------------	
        4'b0111:begin
                  aluop            <=   5'b00100;            //ANDI
                  sel_alu_ip       <=   3'b100;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;                       
                  sel_LR_load      <=   1'b0;
                  sel_pc_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end
             
        //------------------COM, NEG, SWAP, INC, ASR, LSR, ROR, DEC-----------------
        4'b1001:begin
                  if(ID[6:4]==3'b010)
                  begin
                    case(ID[3:0])
					
                     4'b0000:aluop <= 5'b01001;              //COM
                     4'b0001:aluop <= 5'b01101;              //NEG
                     4'b0010:aluop <= 5'b01111;              //SWAP
                     4'b0011:aluop <= 5'b00111;              //INC
                     4'b0101:aluop <= 5'b01110;              //ASR
                     4'b0110:aluop <= 5'b01010;              //LSR
                     4'b0111:aluop <= 5'b01100;              //ROR
                     4'b1010:aluop <= 5'b01000;              //DEC
					  
                    endcase
					   
                    sel_alu_ip     <=   3'b000;
                    sel_DM_wr      <=   1'b0;
                    sel_DM_rd      <=   1'b0; 
                    sel_pc_load    <=   1'b0;                       
                    sel_LR_load    <=   1'b0;
                    sel_out_port   <=   1'b0;			  
                  end
                end
             
        //-------------------------------STS----------------------------------------
        4'b1010:begin
                  aluop            <=   5'b00000;             //NOP
                  sel_alu_ip       <=   3'b000;
                  sel_DM_wr        <=   1'b1;
                  sel_DM_rd        <=   1'b0;
                  sel_pc_load      <=   1'b0;
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;                          
                end
            
        //-------------------------------LD-----------------------------------------
        4'b1000:begin
                  aluop            <=   5'b00000;            //NOP
                  sel_alu_ip       <=   3'b010;
                  sel_DM_rd        <=   1'b1;
                  sel_DM_wr        <=   1'b0;
                  sel_pc_load      <=   1'b0;
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end
                        
        //----------------------------JMP, CALL, RET--------------------------------
        4'b1100:begin
                  if(ID[1:0]==2'b11)                         //JMP
                  begin
                    aluop          <=   5'b00000;            //NOP       
                    sel_alu_ip     <=   3'b000;
                    sel_DM_rd      <=   1'b0;
                    sel_DM_wr      <=   1'b0;
                    sel_pc_load    <=   1'b1;
					sel_LR_load    <=   1'b0;
                    sel_out_port   <=   1'b0;
                  end
					
                  else if(ID[1:0]==2'b01)                   //CALL
                  begin
                    aluop          <=    5'b00000;          //NOP
                    sel_alu_ip     <=    3'b000;
                    sel_DM_rd      <=    1'b0;
                    sel_DM_wr      <=    1'b0;
                    sel_pc_load    <=    1'b1;
					sel_LR_load    <=    1'b1;
                    sel_out_port   <=    1'b0;
                  end
				  
                  else if(ID[1:0]==2'b00)                   //RET
                  begin
                    aluop          <=    5'b00000;          //NOP
                    sel_alu_ip     <=    3'b000;
                    sel_DM_rd      <=    1'b0;
                    sel_DM_wr      <=    1'b0;
                    sel_pc_load    <=    1'b1;
					sel_LR_load    <=    1'b0;
                    sel_out_port   <=    1'b0;
                  end
					 
                end
                             
        //--------------------------------LDI---------------------------------------
        4'b1110:begin
                  aluop            <=   5'b11110;          //BUFFER RA
                  sel_alu_ip       <=   3'b100;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;
                  sel_pc_load      <=   1'b0;                       
                  sel_LR_load      <=   1'b0;
				  sel_out_port     <=   1'b0;
                end
                       	
        //-------------------------BRCC, BRCS, BREQ, BRNE---------------------------
        4'b1111:begin
                  
                 case({ID[5],ID[1:0]})
                      
                  3'b100:
                  begin                                    //BRCC
                    if(cy==0)                                          
                      sel_pc_load  <= 1'b1;      
                    else
                      sel_pc_load  <= 1'b0;    
                  end
							 
                  3'b000:
                  begin                                    //BRCS
                    if(cy==1)                    
                      sel_pc_load  <= 1'b1;    
                    else 
                      sel_pc_load  <= 1'b0;     
                  end
                      
                  3'b001:
                  begin                                    //BREQ
                    if(zy==1)                   
                      sel_pc_load  <= 1'b1;      
                    else
                      sel_pc_load  <= 1'b0;
                  end
							  
                  3'b101:
                  begin                                    //BRNE      
                    if(zy==0)                  
                      sel_pc_load  <= 1'b1;       
                    else 
                      sel_pc_load  <= 1'b0;
                  end
							  
                  default:
                    begin
                      sel_pc_load  <= 1'b0;
                    end
						 
                 endcase
				  
                  aluop            <=   5'b00000;
                  sel_alu_ip       <=   3'b000;
                  sel_DM_wr        <=   1'b0;
                  sel_DM_rd        <=   1'b0;
                  sel_LR_load      <=   1'b0;
                  sel_out_port     <=   1'b0;
                end 
		
        //-----------------------------IN, OUT--------------------------------------
        4'b1011:begin
                  if(ID[6])                                //OUT
                  begin
                    aluop          <=   5'b00000;          //NOP
                    sel_alu_ip     <=   3'b000;
                    sel_DM_wr      <=   1'b0;
                    sel_DM_rd      <=   1'b0;
                    sel_pc_load    <=   1'b0;
                    sel_LR_load    <=   1'b0;
                    sel_out_port   <=   1'b1;
                    
                  end

                  else                                     //IN
                  begin
                    aluop          <=   5'b00000;          //NOP
                    sel_alu_ip     <=   3'b001;
                    sel_DM_wr      <=   1'b0;
                    sel_DM_rd      <=   1'b0;
                    sel_pc_load    <=   1'b0;
                    sel_LR_load    <=   1'b0;
                    sel_out_port   <=   1'b0;
                  end
                end		  
          
         endcase
    end
	
  end
			
endmodule	

		   	

