`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2023 11:42:48 AM
// Design Name: 
// Module Name: Memory
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


module RAM#(parameter RAMSIZE = 64)(input CLK, input RST, input CS, input WE, input [RAMSIZE-1:1] ADDR, inout [31:0] Data_Bus

    );
    reg [31:0] RAM [RAMSIZE-1:0];
    reg[31:0] dout;
    integer i;
    
    assign Data_Bus = (CS == 1 && WE == 0)? dout: 32'dz;
    
    always@(posedge CLK)
    begin
        if(RST)
        begin
            for(i = 0; i <(RAMSIZE-1); i=i+1)
                RAM[i] = 32'd0;
        end
        else
        begin
            dout <= RAM[ADDR];
            if(CS && WE)
                RAM[ADDR] <= Data_Bus;
        end
    end
endmodule
