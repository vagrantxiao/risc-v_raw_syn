module picorv_mem#(
  parameter MEM_SIZE=128*1024/4
  )(
  input clk,
  input resetn,
  input mem_valid,
  input mem_instr,
  output reg mem_ready,
  input [31:0] mem_addr,
  input [31:0] mem_wdata,
  input [3:0] mem_wstrb,
  output reg [31:0] mem_rdata,
  output reg [31:0] irq
  ); 

	reg [31:0] memory [0:MEM_SIZE-1];
	initial begin
      $readmemh("/home/ylxiao/ws_182/F200929_riscv/src/firmware.hex", memory);
    end
    
    reg [15:0] count_cycle;
    always @(posedge clk) count_cycle <= resetn ? count_cycle + 1 : 0;

    always @* begin
        irq = 0;
        irq[4] = &count_cycle[12:0];
        irq[5] = &count_cycle[15:0];
    end	

	always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			//if (mem_addr < 32'h1000_0000) begin
				mem_ready <= 1;
				mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			//end
			/* add memory-mapped IO here */
		end
	end


endmodule

