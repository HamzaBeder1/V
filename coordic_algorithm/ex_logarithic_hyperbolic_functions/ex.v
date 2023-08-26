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


module ex(input clk, input st, input compute, input [15:0] x, output [16:0] ex

    );
    
    wire [15:0] sinh;
    wire [15:0] cosh;
    sinh_andcosh s(clk, st, compute, x, sinh, cosh);
    assign ex = sinh+cosh;
endmodule
