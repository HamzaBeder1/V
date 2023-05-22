`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2023 08:36:12 AM
// Design Name: 
// Module Name: 7segmentcontrol
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


module segmentcontrol(clk, anodeON
    );
    output [3:0] anodeON;
    input clk;
    output [6:0] cathodeOFF;
    
    wire [1:0] currLED;
    reg [3:0] anodeTracker;
    
    
    setCurrentLED x (clk, currLED);
    always @(posedge clk)
    begin
      case(currLED)
      2'b00:
        anodeTracker <= 4'b0001;
      2'b01:
        anodeTracker <= 4'b0010;
      2'b10:
        anodeTracker <= 4'b0100;
      2'b11:
        anodeTracker <= 4'b1000;
      endcase
     
        
    end
      assign anodeON = anodeTracker;
    
    
    
   
    
    
    
    
    
    
