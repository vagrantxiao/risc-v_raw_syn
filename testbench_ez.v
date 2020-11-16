// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

module testbench;
    parameter MEM_SIZE=128*1024/4;
	reg clk = 1;
	reg resetn = 0;
	wire trap;

	always #5 clk = ~clk;

	initial begin
		if ($test$plusargs("vcd")) begin
			$dumpfile("testbench.vcd");
			$dumpvars(0, testbench);
		end
		repeat (100) @(posedge clk);
		resetn <= 1;
		repeat (700000) @(posedge clk);
		$finish;
	end

	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;

	//always @(posedge clk) begin
	//	if (mem_valid && mem_ready) begin
	//		if (mem_instr)
	//			$display("ifetch 0x%08x: 0x%08x", mem_addr, mem_rdata);
	//		else if (mem_wstrb)
	//			$display("write  0x%08x: 0x%08x (wstrb=%b)", mem_addr, mem_wdata, mem_wstrb);
	//		else
	//			$display("read   0x%08x: 0x%08x", mem_addr, mem_rdata);
	//	end
	//end
	
	
    reg [31:0] irq = 0;
	reg [15:0] count_cycle = 0;
    always @(posedge clk) count_cycle <= resetn ? count_cycle + 1 : 0;

    always @* begin
        irq = 0;
        irq[4] = &count_cycle[12:0];
        irq[5] = &count_cycle[15:0];
    end	
	
	wire display_en;
    wire [7:0] display_char;
    assign display_en = (mem_addr == 32'h1000_0000) ? 1:0;
    assign display_char = mem_wdata[7:0];
    always@(posedge clk) begin
        if(display_en && mem_ready==1)
            $write("%c", display_char);
    end
    
	picorv32 #(
	) uut (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
	);


	
	
	reg [31:0] memory [0:MEM_SIZE-1];
	initial begin
      $readmemh("/home/ylxiao/ws_182/F200929_riscv/src/firmware.hex", memory);
    end
    
	//initial begin
	//	memory[0] = 32'h 3fc00093; //       li      x1,1020
	//	memory[1] = 32'h 0000a023; //       sw      x0,0(x1)
	//	memory[2] = 32'h 0000a103; // loop: lw      x2,0(x1)
	//	memory[3] = 32'h 00110113; //       addi    x2,x2,1
	//	memory[4] = 32'h 0020a023; //       sw      x2,0(x1)
	//	memory[5] = 32'h ff5ff06f; //       j       <loop>
	//end

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
