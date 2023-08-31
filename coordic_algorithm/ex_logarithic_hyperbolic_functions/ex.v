`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2023 01:24:48 PM
// Design Name: 
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
