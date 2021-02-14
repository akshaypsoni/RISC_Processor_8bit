`timescale 1ns / 1ps

module top(clk_in,rst_load,rst_processor,in_port,out_port,result);
    
  input         clk_in;
  input         rst_load;
  input         rst_processor;
  input   [ 7:0] in_port;
  output  [ 7:0] out_port;
  output  [ 7:0] result;

  wire           done;

  wire    [15:0] DO;
  wire    [ 9:0] ADDR;
  wire    [ 1:0] mem_en;
  wire    [ 8:0] addr;
//wire clk;

  bram flash_1(clk_in,mem_en[0],ADDR,DO,rst_load);

  instr_load_counter c1(ADDR,addr,clk_in,rst_load,done,mem_en);

  processor p1(.clk_in(clk), .rst_processor(reset), .result(result), .addr[7:0](wr_addr), .DO(wr_data), .mem_en(we), .out_port(out_port), .in_port(in_port));
         
endmodule

module top_tb;


reg clk_in,rst_load,rst_processor;
reg [7:0] in_port;
wire [7:0] out_port, result;


top t1(clk_in,rst_load,rst_processor,in_port,out_port,result);

initial
begin
clk_in = 0;
rst_processor  = 1;
rst_load = 1;

#80 rst_load = 0;
 #12000 rst_processor = 0;


end

always #20 clk_in = ~clk_in;
endmodule

