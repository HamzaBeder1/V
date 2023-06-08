`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:33:54 PM
// Design Name: 
// Module Name: TopUART
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


module UARTTX#(parameter idle = 2'b00, sendfirst = 2'b01, sendsecond = 2'b10, debouncing = 2'b11, debounce = 50)(
input clk, input [7:0] first_byte, input [7:0] second_byte, input transmit, output reg Txd, output reg Done
    );
    reg transmit1;
    reg transmit2;
    reg [25:0] debounce_counter = 0;
    wire Txd1;
    wire Txd2;
    reg [1:0] state = 0;
    wire Done1;
    wire Done2;
    UARTbyte byte1 (clk, first_byte, transmit1,Txd1, Done1);
    UARTbyte byte2 (clk, second_byte, transmit2,Txd2, Done2);
    
    always@(posedge clk)
    begin
        case(state)
            idle:
                if(transmit)
                begin
                    transmit1 <= 1;
                    transmit2 <= 0;
                    state <= sendfirst;
                    Txd<= Txd1;
                    Done <= 0;
                end
                else
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    state <= idle;
                    Txd<= 1;
                    Done <= 0; 
                end
            
            sendfirst:
                if(Done1)
                begin
                    transmit1 <= 0;
                    transmit2 <=1;
                    state <= sendsecond;
                    Txd <= Txd2;
                    Done <= 0;
                end
                else
                begin
                    transmit1 <=0;
                    transmit2 <= 0;
                    state <= sendfirst;
                    Txd <= Txd1;
                    Done <= 0;
                end
             
             sendsecond:
                if(Done2)
                begin
                    transmit1<=0;
                    transmit2 <= 0;
                    state <= debouncing;
                    Done <= 1;
                    Txd <= 1;
                end
                else
                begin
                    transmit1<=0;
                    transmit2<=0;
                    state<=sendsecond;
                    Done <= 0;
                    Txd <= Txd2;
                end
             
            debouncing:
                if(debounce_counter == debounce)
                    begin
                    debounce_counter <= 0;
                    transmit1<=0;
                    transmit2<=0;
                    state<=idle;
                    Done <= 0;
                    Txd <= 1;
                    end
                else
                begin
                    debounce_counter<=debounce_counter+1;
                    transmit1<=0;
                    transmit2<=0;
                    state<=debouncing;
                    Done <= 0;
                    Txd <= 1;
                end
         endcase
    end
    
    assign state_debug = state;
    assign debounce_counterdebug = debounce_counter;
        
    
    
endmodule