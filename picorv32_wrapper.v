module picorv32_wrapper#(
  parameter MEM_SIZE = 128*1024/4
  )(
  input clk,
  input resetn,
  output trap
);
  wire mem_valid;
  wire mem_instr;
  wire mem_ready;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [3:0] mem_wstrb;
  wire [31:0] mem_rdata;
  wire [31:0] irq;



    
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
	) picorv_mem_inst (
        .clk         (clk),
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
	
