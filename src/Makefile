#==========================================================================
# Makefile
#==========================================================================


simulate: 
	verilator  --binary -j 0 -Wall ./dram_test.v --timing  --timescale 1ns/1ps -Wno-UNUSEDSIGNAL
	./obj_dir/Vdram_test
