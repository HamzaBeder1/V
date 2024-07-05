# UART With Basys3
## Purpose
The purpose of this project is to use UART to communicate with a user's laptop using the Artix-7 FPGA on the Basys3 Board. The data that is sent is the digits shown on the board's 7=segment display.

The right-most four switches on the Basys3 are used to control the display, and a button on the board is pressed to send data. Pyserial is used to read the data and display it onto the laptop's screen.


