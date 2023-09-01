General-Purpose CORDIC Algorithm on Basys3 Board.
------
This project implements the CORDIC Algorithm; CORDIC is a hardware-efficient algorithm that is used to compute trigonometric and hyperbolic functions.

To use this project, click the T17 button to walk through the states of the SM used to create this design. The 7-segment display will display values to show what state the machine is currently on:  

| 7-Segment Output | Meaning 
| ---------------- | ---
|         F        |  Enter the function to compute using the 4 right-most switches. View the table below to see which values correspond to each function.
|         E1       |  Enter the first operand |
|         E2       |  Enter the second operand. Note that this state is skipped if the function chosen requires only a single operand.
|         GO       |  This means the values that were entered are stored in registers, and the machine is ready to compute the function.
|         Result   |   After viewing Go and pressing the T17 button once more, the results will be displayed onto the seven-segment display.

| Function      | Number           
| ------------- |:-------------:|
| arctan        |       0       |
| magnitude     |       1       |   
| arccos        |       2       |
| arcsin        |       3       |
| cosh          |       4       |
| sinh          |       5       |
| e^x           |       6       |
| arctanh       |       7       |
| lnx           |       8       |
