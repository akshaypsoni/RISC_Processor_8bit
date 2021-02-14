`timescale 1ns / 1ps

module processor(clk, reset, result, wr_addr, wr_data, we, out_port, in_port);

  input         clk;               //Clock
  input         reset;             //Reset
  output [7:0]  result;            //ALU result
  input  [7:0]  wr_addr;           //Write Address to Program_Memory
  input  [15:0] wr_data;           //Write Data to Program_Memory
  input  [1:0]  we;                //Write Enable to Program_Memory
  output [7:0]  out_port;          //Output Port
  input  [7:0]  in_port;           //Input Port
  
  
  wire        en_ProgMem;          //Program_Memory enable
  wire        en_Fetch;            //Instruction_Register enable
  wire        en_Decode;           //Instruction_Decoder enable, Register_File read enable
  wire        en_Execute;          //ALU enable
  wire        en_Writeback;        //Register_File write enable
  
  wire        cy;                  //carry flag
  wire        zy;                  //zero flag
  wire [15:0] instruction;         //Instruction from Program_Memory
  wire [15:0] I_Reg;               //16-bit Instruction REG
  wire [4:0]  aluop;               //ALU operation
  wire [7:0]  RA;                  //Operand_1 REG data from Register_File
  wire [7:0]  RD;                  //Operand_2 REG data from Register_File
  wire [7:0]  mem_dout;            //Data_Memory output
  wire        en_DM_rd;            //Data_Memory read enable
  wire        en_DM_wr;            //Data_Memory write enable
  wire        sel_DM_rd;           //MUX select for Data_Memory read enable
  wire        sel_DM_wr;           //MUX select for Data_Memory write enable
  wire [7:0]  RD_out,RA_out;       //Inputs to ALU
  wire [2:0]  sel_alu_ip;          //MUX select for ALU inputs
  wire [7:0]  pc;                  //program counter (pointer to Program_Memory)
  wire [7:0]  PC_load;             //address to be loaded in pc
  wire        en_pc_load;          //PC_load enable
  wire        sel_pc_load;         //MUX select for PC_load enable
  wire [7:0]  LR_out;              //Link_register output
  wire        LR_load_en;          //Link_register enable  
  wire        sel_LR_load;         //MUX select for LR_load_en		
  wire        RD_addr_MSB;         //Operand_2 REG MSB address bit
  wire [7:0]  in_to_alu;           //Input port to ALU
  wire        en_output_load;      //Output port enable
  wire        sel_out_port;        //MUX select for Output port enable
  wire        pc_source_select;    //MUX select for PC source


  Control_Unit CU(
    .clk(clk), 
    .reset(reset),
    .en_ProgMem(en_ProgMem), 
    .en_Fetch(en_Fetch), 
    .en_Decode(en_Decode), 
    .en_Execute(en_Execute), 
    .en_Writeback(en_Writeback)
   ); 

  Program_Counter PC(
    .clk(clk), 
    .reset(reset), 
    .en_PC(en_Fetch), 
    .PC(pc), 
    .PC_load(PC_load), 
    .load_en(en_pc_load)
  ); 

  Program_Memory PM(
    .clk(clk), 
    .rden(en_ProgMem), 
    .rd_addr(pc), 
    .instr(instruction), 
    .wr_addr(wr_addr), 
    .wr_data(wr_data), 
    .we(we)
  );

  Link_register LR(
    .LR_in(pc), 
    .LR_out(LR_out), 
    .clk(clk), 
    .LR_load_en(LR_load_en)
   );

  Instruction_Register IR(
    .clk(clk), 
    .en_IR(en_Fetch), 
    .I_fetch(instruction), 
    .I_decode(I_Reg)
  );   

  Instruction_Decoder ID(
    .clk(clk), 
    .ID({I_Reg[15:9],I_Reg[3:0]}), 
    .en_dec(en_Decode), 
    .aluop(aluop), 
    .sel_alu_ip(sel_alu_ip), 
    .sel_DM_rd(sel_DM_rd), 
    .sel_DM_wr(sel_DM_wr), 
    .sel_pc_load(sel_pc_load), 
    .cy(cy), 
    .zy(zy), 
    .sel_LR_load(sel_LR_load), 
    .sel_out_port(sel_out_port)
  );  
  

  Register_File RF(
    .clk(clk), 
    .RA_addr({I_Reg[9],I_Reg[3:0]}),
    .RD_addr({RD_addr_MSB,I_Reg[7:4]}), 
    .en_rd(en_Decode), 
    .en_WD(en_Writeback), 
    .WD_addr({RD_addr_MSB,I_Reg[7:4]}), 
    .RA(RA), 
    .RD(RD), 
    .WD(result)
  );
  

  Alu ALU(
    .clk(clk), 
    .en_alu(en_Execute),
    .RD(RD_out), 
    .RA(RA_out),
    .aluop(aluop), 
    .out(result), 
    .cy(cy), 
    .zy(zy)
  );  

  Data_Memory DM(
    .clk(clk), 
    .en_DM_rd(en_DM_rd), 
    .en_DM_wr(en_DM_wr), 
    .mem_addr({{I_Reg[11:8],I_Reg[3:0]}}), 
    .mem_din(result), 
    .mem_dout(mem_dout)
  );  

  in_port in1(
    .in(in_port), 
    .out(in_to_alu), 
    .clk(clk)
  );   

  mux2x1_8bit mux_RA_ip(
    .A({I_Reg[11:8],I_Reg[3:0]}), 
    .B(RA), 
    .sel(sel_alu_ip[2]), 
    .out(RA_out)
  );

  mux4x1_8bit mux_RD_ip(
    .A(mem_dout), 
    .B(RD), 
    .C(in_to_alu), 
    .sel(sel_alu_ip[1:0]), 
    .out(RD_out)
  ); 

  mux2x1_8bit mux_PC_ip(
    .A(I_Reg[9:2]), 
    .B(LR_out), 
    .sel(pc_source_select), 
    .out(PC_load)
 );  
 
  mux2x1_1bit mux_lr_load(               
    .in(en_Execute), 
    .en(sel_LR_load), 
    .out(LR_load_en)
  );

  mux_mem m3(
    .en_dec(en_Decode), 
    .en_WD(en_Execute), 
    .sel_DM_rd(sel_DM_rd), 
    .sel_DM_wr(sel_DM_wr), 
    .en_DM_rd(en_DM_rd), 
    .en_DM_wr(en_DM_wr)
  );  

  mux2x1_1bit mux_pc_load(
    .in(en_Execute), 
    .en(sel_pc_load), 
    .out(en_pc_load)
  );

  out_port o1(
    .out_port_load(result), 
    .load_en(en_output_load), 
    .out_port_out(out_port), 
    .clk(clk)
  );   

  mux2x1_1bit mux_out_en(
    .in(en_Writeback), 
    .en(sel_out_port), 
    .out(en_output_load)
  );

  PC_source_sel pcss(
    .clk(clk), 
    .ireg_in({I_Reg[15:12],I_Reg[1:0]}), 
    .out(pc_source_select)
  );   

  Addr_MSB_gen ADDR_MSB_GEN(
    .clk(clk), 
    .en_Fetch(en_Fetch), 
    .I(I_Reg[15:12]), 
    .RD_addr_MSB_ip(I_Reg[8]), 
    .RD_addr_MSB(RD_addr_MSB)
  );

endmodule


/*
module processor_tb;
  reg clk,reset;
  wire [7:0] result;   //output result from alu
  wire cy,zy;

  processor uut(clk, reset, result, cy, zy);

  initial
  begin
    clk = 0;
    reset  = 1;
    #80 reset = 0;
  end

  always #20 clk = ~clk;
  
endmodule
*/
