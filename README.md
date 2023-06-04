# 7SegmentControl

# Description
This project allows the control of the seven-segment display on the BASYS3 FPGA Board. Using the switches on the board, you can change select which digit you want to adjust and set it to a number ranging from 0-9. 

#Components
* __FPGA__: You will need a FPGA with a seven segment display. I am using the BASYS3, but you can run the Verilog code on a different board. The refresh period for the LEDs and the constraints may need to be adjusted, however.
*__Type B Micro USB cable__: Needed to program the board.
*__Vivado__: IDE needed to synthesize and generate the bitstream for the FPGA.

# Running the project
I will describe how the project works assuming the BASYS3 is being used. If another board is being used, the idea will be the same, but the constraints will need to be modified.
1. Copy the design source and constraint file into Vivado.
2. Go through synthesization, implementation, and then generate the bitstream. Then program the board.
3. Adjust the 4 switches to the far right to change the number shown on the LED. The 4 switches to the far left adjusts which LEDs you are changing.



