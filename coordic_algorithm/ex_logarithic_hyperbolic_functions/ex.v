`timescale 1ns / 1ps



module ex(input clk, input st, input compute, input [15:0] x, input[3:0] func, output [31:0] result

    );
    wire [16:0] ex;
    wire [15:0] sinh;
    wire [15:0] cosh;
    sinh_andcosh s(clk, st, x, func,sinh, cosh, result);
    assign ex = sinh+cosh;
    assign result = (func == 6)? ex: 32'bz;
endmodule
