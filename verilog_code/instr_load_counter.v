`timescale 1ns / 1ps

module instr_load_counter(bram_addr,progmem_addr,clk,rst,done,mem_en);

    input             rst;
	input             clk;
    output reg [9:0]  bram_addr;
    output reg [8:0]  progmem_addr;
    output reg        done;
    output     [1:0]  mem_en;
    
	
    assign mem_en[0]   =  ~done;
    assign mem_en[1]   =  ~done;
    
    always@(negedge clk)
    begin
      if(rst)
        begin
          bram_addr    <= 10'd1022;
          progmem_addr <= 9'd509;
        end
		
        else if(done)
        begin
          bram_addr    <= bram_addr;
          progmem_addr <= progmem_addr;
        end
		
        else
        begin
          bram_addr    <= bram_addr + 1;
          progmem_addr <= progmem_addr + 1;
        end
    end
    
    always@(*)
    begin
      if(progmem_addr == 9'd255)
        done<= 1;
		
      else
        done <= 0;
    end
        
endmodule
/*
module count_tb2;
    wire [8:0] count_addr;
    reg clk,rst;
    wire done;
    wire [1:0] mem_en;
    instr_load_counter uut(count_addr,clk,rst,done,mem_en);
    
    initial begin
    clk = 0;
    rst = 1;
    #40 rst = 0;
    #5200 rst = 1;
    #40 rst = 0;
    end
    
    always #10 clk = ~clk;
    
    
endmodule
*/