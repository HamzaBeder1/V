`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2023 02:00:28 PM
// Design Name: 
// Module Name: timer
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


module setCurrentLED(clk, segmentOn
    );
    input clk;
     output [1:0] segmentOn;
    
   
    reg [18:0] LEDCycleCounter = 0;
    reg [1:0] currLED = 0;
    reg [3:0] setSegment;
    always @(posedge clk)
    begin
        if(LEDCycleCounter >= 200001)
        begin
            LEDCycleCounter = 0;
            currLED <= (currLED+1) % 4;
        end
        else
        begin
            LEDCycleCounter <= LEDCycleCounter + 1;
        end
        case(currLED)
        2'b00: 
        begin
            setSegment <= 2'b00;
            
        end
        2'b01:
        begin
            setSegment <= 4'b01;
            
        end
        2'b10:
        begin
            setSegment <= 4'b10;
          
        end
        2'b11:
        begin
            setSegment <= 4'b11;
           
        end
        endcase
    end
   assign segmentOn = setSegment;
   
endmodule
