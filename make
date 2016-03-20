ghdl -a --ieee=synopsys nondeterminism.vhd
ghdl -a std_fifo.vhd
ghdl -a --ieee=synopsys CPU.vhd
ghdl -a AXI.vhd
ghdl -a Memory.vhd
ghdl -a L1Cache.vhd
ghdl -a --ieee=synopsys top.vhd