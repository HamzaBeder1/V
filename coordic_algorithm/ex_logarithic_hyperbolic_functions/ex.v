`timescale 1ns / 1ps

/*
    This module is used for calculating e^x of the input.
    
    Inputs:
            clk: Clock signal for controlling operations.
            st: start signal that begins the CORDIC iterations
            x: Input to pass into the function.
            func: A register that determines if the output from the module should write to the result register and which function to write to it.
            
   Outputs:
            result: This is a bus shared by the modules in this project. Depending on func, this module either writes High-Z or the output it computes.
*/
module ex(input clk, input st, input signed [15:0] x, input[3:0] func, output [31:0] result

    );
    wire signed [16:0] ex;
    wire signed [15:0] sinh;
    wire signed [15:0] cosh;
    wire signed [31:0] result_temp;
    sinh_andcosh s(clk, st, x, func,sinh, cosh, result);
    assign ex = sinh+cosh;
    assign result = (func == 6)? ex: 32'dz;
endmodule
