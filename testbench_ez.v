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
	wire mem_valid;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    wire [31:0] mem_rdata;
    wire [31:0] irq;


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
	
	picorv_mem#(
        .MEM_SIZE(MEM_SIZE)
    ) picorv_mem_inst(
        .clk    (clk),
        .resetn      (resetn     ),
        .mem_valid   (mem_valid  ),
        .mem_instr   (mem_instr  ),
        .mem_ready   (mem_ready  ),
        .mem_addr    (mem_addr   ),
        .mem_wdata   (mem_wdata  ),
        .mem_wstrb   (mem_wstrb  ),
        .mem_rdata   (mem_rdata  ),
        .irq         (irq        )
    ); 
	
	
	
endmodule
