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
    wire [48:0] print_out;


    
    picorv32_wrapper#(
    .MEM_SIZE(MEM_SIZE)
    )i1(
    .clk(clk),
    .resetn(resetn),
    .print_out(print_out),
    .trap(trap)
    );
	
	
	
	always #5 clk = ~clk;

    always@(posedge clk) begin
        if (trap) $finish;
    end

    initial begin
        if ($test$plusargs("vcd")) begin
            $dumpfile("testbench.vcd");
            $dumpvars(0, testbench);
        end
        repeat (100) @(posedge clk);
        resetn <= 1;
        repeat (1000000) @(posedge clk);
        //$finish;
    end
    
    //always @(posedge clk) begin
    //    if (mem_valid && mem_ready) begin
    //        if (mem_instr)
    //            $display("ifetch 0x%08x: 0x%08x", mem_addr, mem_rdata);
    //        else if (mem_wstrb)
    //            $display("write  0x%08x: 0x%08x (wstrb=%b)", mem_addr, mem_wdata, mem_wstrb);
    //        else
    //            $display("read   0x%08x: 0x%08x", mem_addr, mem_rdata);
    //    end
    //end	
	
	wire display_en;
    wire [7:0] display_char;
    assign display_en = (i1.mem_addr == 32'h1000_0000) ? 1:0;
    assign display_char = i1.mem_wdata[7:0];
    
    always@(posedge clk) begin
        if(print_out[48])
            $write("%c", print_out[7:0]);
    end
    
    
	
endmodule
