`timescale 1ns / 1ps

module ln_x(
    input clk, input st, input compute, input [15:0] x,input[3:0] func, output [31:0] ln
    );
    wire [16:0] ln;
    wire [15:0] x_1, y_1;
    wire [31:0] result;
    assign x_1 = x+16'b0100000000000000;
    assign y_1 = x-16'b0100000000000000;
    
    arctan_h atanh (clk, st, compute,x_1, y_1, result);
    assign ln = result << 1;
    assign result = (func == 8)? ln:32'bz;
    
endmodule
