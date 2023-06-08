`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2023 01:38:10 AM
// Design Name: 
// Module Name: Top
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


module Top#(idle = 2'b00, sending_hour = 2'b01, sending_minutes = 2'b10, waiting = 2'b11)(
    input clk, input [3:0] number, input [3:0] currLED, input transmit, output [3:0] anodeOutput, output [7:0] cathodeOutput, output reg Txd);
    wire [3:0] LED0;
    wire [3:0] LED1;
    wire [3:0] LED2;
    wire [3:0] LED3;
    wire Done1;
    wire Done2;
    reg transmit1;
    reg transmit2;
    wire Txd1;
    wire Txd2;
    wire [15:0] hour;
    wire [15:0] minutes;
    reg [1:0] state = 0;
    
    reg [7:0] digit_0;
    reg [7:0] digit_1;
    reg [7:0] digit_2;
    reg [7:0] digit_3;
    reg [25:0] debounce_counter = 0;
    
    
    sevensegment a(clk, number, currLED, anodeOutput, cathodeOutput, LED0, LED1, LED2, LED3);
    UARTTX b1(clk,hour[7:0], hour[15:8],transmit1,Txd1, Done1);
    UARTTX b2(clk,minutes[7:0], minutes[15:8],transmit2,Txd2, Done2);
    
    always@(posedge clk)
    begin
        case(LED0)
            4'b0000:
                digit_0 <= 8'b00110000;
            4'b0001:
                digit_0 <= 8'b00110001;
            4'b0010:
                digit_0 <= 8'b00110010;
            4'b0011:
                digit_0 <= 8'b00110011;
            4'b0100:
                digit_0 <= 8'b00110100;
             4'b0101:
                digit_0 <= 8'b00110101;
             4'b0110:
                digit_0 <= 8'b00110110;
             4'b0111:
                digit_0 <= 8'b00110111;
             4'b1000:
                digit_0 <= 8'b00110000;
             4'b1001:
                digit_0 <= 8'b00111001;
             default:
                digit_0 <= 8'b00000000;
        endcase
        
        case(LED1)
            4'b0000:
                digit_1 <= 8'b00110000;
            4'b0001:
                digit_1 <= 8'b00110001;
            4'b0010:
                digit_1 <= 8'b00110010;
            4'b0011:
                digit_1 <= 8'b00110011;
            4'b0100:
                digit_1 <= 8'b00110100;
             4'b0101:
                digit_1 <= 8'b00110101;
             4'b0110:
                digit_1 <= 8'b00110110;
             4'b0111:
                digit_1 <= 8'b00110111;
             4'b1000:
                digit_1 <= 8'b00110000;
             4'b1001:
                digit_1 <= 8'b00111001;
             default:
                digit_1 <= 8'b00000000;
        endcase
        
        case(LED2)
            4'b0000:
                digit_2 <= 8'b00110000;
            4'b0001:
                digit_2 <= 8'b00110001;
            4'b0010:
                digit_2 <= 8'b00110010;
            4'b0011:
                digit_2 <= 8'b00110011;
            4'b0100:
                digit_2 <= 8'b00110100;
             4'b0101:
                digit_2 <= 8'b00110101;
             4'b0110:
                digit_2 <= 8'b00110110;
             4'b0111:
                digit_2 <= 8'b00110111;
             4'b1000:
                digit_2 <= 8'b00110000;
             4'b1001:
                digit_2 <= 8'b00111001;
             default:
                digit_2 <= 8'b00000000;
        endcase
        
        case(LED3)
            4'b0000:
                digit_3 <= 8'b00110000;
            4'b0001:
                digit_3 <= 8'b00110001;
            4'b0010:
                digit_3 <= 8'b00110010;
            4'b0011:
                digit_3 <= 8'b00110011;
            4'b0100:
                digit_3 <= 8'b00110100;
             4'b0101:
                digit_3 <= 8'b00110101;
             4'b0110:
                digit_3 <= 8'b00110110;
             4'b0111:
                digit_3 <= 8'b00110111;
             4'b1000:
                digit_3 <= 8'b00110000;
             4'b1001:
                digit_3 <= 8'b00111001;
             default:
                digit_3 <= 8'b00000000;
        endcase
    end
    
    always@(posedge clk)
    begin
        case(state)
            idle:
            begin
                if(transmit)
                begin
                    transmit1 <= 1;
                    transmit2 <= 0;
                    Txd <= Txd1;
                    state <= sending_hour;
                end
                
                else
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= 1;
                    state <= idle;
                end
            end
            
            sending_hour:
            begin
                if(Done1)
                begin
                    transmit1 <= 0;
                    transmit2 <= 1;
                    Txd <= Txd2;
                    state <= sending_minutes;
                end
                
                else
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= Txd1;
                    state <= sending_hour;
                end
            end
            
            sending_minutes:
            begin
                if(Done2)
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= 1;
                    state <= waiting;
                end
                
                else
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= Txd2;
                    state <= sending_minutes;
                end
            end
            waiting:
            begin
                if(debounce_counter == 50000000)
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= 1;
                    state <= idle;
                    debounce_counter <= 0;
                end
                else
                begin
                    transmit1 <= 0;
                    transmit2 <= 0;
                    Txd <= 1;
                    state <= waiting;
                    debounce_counter <= debounce_counter + 1;
                end
            end
        endcase
    end
    
    
    assign hour = {digit_1, digit_0};
    assign minutes = {digit_3,  digit_2};
    assign state_debug = state;
    
   
    
endmodule