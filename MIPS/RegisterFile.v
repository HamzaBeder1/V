`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2023 09:40:21 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(input CLK, input RST, input Write, input [31:0] writedata, input [4:0] readreg1, input [4:0] readreg2, input [4:0] writereg,
output reg [31:0] readdata1, output reg [31:0] readdata2

    );
    
    reg [31:0] REGISTER_FILE[31:0];
    integer i;
    

    
    always@(posedge CLK)
    begin
        if(RST)
        begin
            for(i = 0; i < 32; i = i+1)
        begin
            REGISTER_FILE[i] <= 32'd0;
        end
        end
        REGISTER_FILE[0] = 32'd0;
        if(Write && writereg != 0)
        begin
            REGISTER_FILE[writereg] <= writedata;
        end
        readdata1 <= REGISTER_FILE[readreg1];
        readdata2 <= REGISTER_FILE[readreg2];      
    end
    
endmodule
