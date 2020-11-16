VERILATOR = verilator
IVERILOG = iverilog$(ICARUS_SUFFIX)
VVP = vvp$(ICARUS_SUFFIX)


test: testbench_ez.vvp firmware.hex
	$(VVP) -N $< 

testbench_ez.vvp: testbench_ez.v picorv32.v picorv_mem.v picorv32_wrapper.v
	$(IVERILOG) -o $@ $(subst C,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@

git:
	./git.sh
clean:
	rm -rf  ./testbench_ez.vvp
