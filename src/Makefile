#==========================================================================
# Makefile
#==========================================================================

.PHONY: dram pc rf all

all:  dram pc rf clean

dram:
	verilator  --binary -j 0 -Wall -I./memory/ ./memory/dram_test.v --timing  --timescale 1ns/1ps 
	./obj_dir/Vdram_test


pc: 
	verilator  --binary -j 0 -Wall -I./decode/  ./decode/test_pcbranch.v --timing  --timescale 1ns/1ps 
	./obj_dir/Vtest_pcbranch

rf: 
	verilator  --binary -j 0 -Wall -I./writeback/ ./writeback/register_file_test.v --timing  --timescale 1ns/1ps 
	./obj_dir/Vregister_file_test

clean:
	rm -rf ./obj_dir/