`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2023 03:31:21 PM
// Design Name: 
// Module Name: ROM
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


module ROM#(parameter ROM_SIZE = 64)(input CLK, input [31:0] ADDR, output reg [31:0] CONTENTS

    );
    reg [31:0] ROM_MEM [(ROM_SIZE-1):0];
    initial
        $readmemh("Instructions.mem", ROM_MEM);
    always@(posedge CLK)
    begin
        CONTENTS <= ROM_MEM[ADDR];
    end
endmodule