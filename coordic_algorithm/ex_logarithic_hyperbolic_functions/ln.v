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
module ln_x(
    input clk, input st, input [15:0] x,input[3:0] func, output signed [31:0] result
    );
    wire [16:0] ln;
    wire [15:0] ln_temp;
    wire [15:0] x_1, y_1;
    assign x_1 = x+16'b0100000000000000;
    assign y_1 = x-16'b0100000000000000;
    
    arctan_h atanh (clk, st,x_1, y_1, func, ln_temp, result);
    assign ln = ln_temp <<< 1;
    assign result = (func == 8)? ln:32'dz;
    
endmodule
