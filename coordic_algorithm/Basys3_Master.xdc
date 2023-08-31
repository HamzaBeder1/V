## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {sw_in[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw_in[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw_in[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw_in[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[3]}]

set_property PACKAGE_PIN W15 [get_ports {sw_in[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw_in[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw_in[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw_in[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[7]}]

set_property PACKAGE_PIN V2 [get_ports {sw_in[8]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw_in[9]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw_in[10]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw_in[11]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[11]}]

set_property PACKAGE_PIN W2 [get_ports {sw_in[12]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[12]}]
set_property PACKAGE_PIN U1 [get_ports {sw_in[13]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[13]}]
set_property PACKAGE_PIN T1 [get_ports {sw_in[14]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[14]}]
set_property PACKAGE_PIN R2 [get_ports {sw_in[15]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw_in[15]}]	

 

#7 segment display
set_property PACKAGE_PIN W7 [get_ports {cathodeOutput[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[6]}]
set_property PACKAGE_PIN W6 [get_ports {cathodeOutput[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[5]}]
set_property PACKAGE_PIN U8 [get_ports {cathodeOutput[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[4]}]
set_property PACKAGE_PIN V8 [get_ports {cathodeOutput[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[3]}]
set_property PACKAGE_PIN U5 [get_ports {cathodeOutput[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[2]}]
set_property PACKAGE_PIN V5 [get_ports {cathodeOutput[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[1]}]
set_property PACKAGE_PIN U7 [get_ports {cathodeOutput[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[0]}]

set_property PACKAGE_PIN V7 [get_ports {cathodeOutput[7]}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {cathodeOutput[7]}]

set_property PACKAGE_PIN U2 [get_ports {anodeOutput[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeOutput[3]}]
set_property PACKAGE_PIN U4 [get_ports {anodeOutput[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeOutput[2]}]
set_property PACKAGE_PIN V4 [get_ports {anodeOutput[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeOutput[1]}]
set_property PACKAGE_PIN W4 [get_ports {anodeOutput[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anodeOutput[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {st}]
set_property PACKAGE_PIN T17 [get_ports {st}]
