.ONESHELL:
cpu_tb:
	cd ..
	iverilog -c iverilog_compile_cpu.cmdfile test_cpu/cpu_tb.v -Wall -s cpu_tb -o test_cpu/cpu_tb

%.bin: src/%.asm
	perl ../../wiscasm/assembler.pl $< > $@

test: $(case).bin cpu_tb
	$(RM) *.img
	ln -s $< loadfile_inst.img
	ln -s src/$(case).mem loadfile_data.img
	./cpu_tb
	cmp dumpfile_data.img src/$(case).ans && echo "Test passed." || echo "Test failed."


clean:
	$(RM) *.bin *.log *.trace *.vcd cpu_tb *.img
