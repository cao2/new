ghdl -a arbiter.vhd
ghdl -a arbiter2.vhd
ghdl -a --ieee=synopsys nondeterminism.vhd
ghdl -a std_fifo.vhd
ghdl -a --ieee=synopsys CPU.vhd
ghdl -a AXI.vhd
ghdl -a --ieee=synopsys Memory.vhd
ghdl -a L1Cache.vhd
ghdl -a --ieee=synopsys top.vhd
ghdl -a PWR.vhd
ghdl -e --ieee=synopsys top

./top --stop-time=2000ps  --vcd=new.vcd 