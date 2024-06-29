## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {number[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {number[0]}]
set_property PACKAGE_PIN V16 [get_ports {number[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {number[1]}]
set_property PACKAGE_PIN W16 [get_ports {number[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {number[2]}]
set_property PACKAGE_PIN W17 [get_ports {number[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {number[3]}]

set_property PACKAGE_PIN W2 [get_ports {currLED[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {currLED[3]}]
set_property PACKAGE_PIN U1 [get_ports {currLED[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {currLED[2]}]
set_property PACKAGE_PIN T1 [get_ports {currLED[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {currLED[1]}]
set_property PACKAGE_PIN R2 [get_ports {currLED[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {currLED[0]}]
 

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

set_property IOSTANDARD LVCMOS33 [get_ports {Txd}]
set_property PACKAGE_PIN A18 [get_ports {Txd}]
set_property PACKAGE_PIN U18 [get_ports transmit]						
set_property IOSTANDARD LVCMOS33 [get_ports transmit]
set_property PACKAGE_PIN T17 [get_ports rst]						
set_property IOSTANDARD LVCMOS33 [get_ports rst]
