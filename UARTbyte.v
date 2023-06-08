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


module UARTbyte#(parameter cycle_BRG = 10416, idle = 2'b00, loading = 2'b01, sending = 2'b11, done = 2'b10, debounce_seconds = 2500)(
input clk, input [7:0] data_send, input transmit, output reg Txd, output reg Done
    );
    
    reg [13:0] BRG_counter = 0;
    reg [9:0] bit_counter = 0;
    reg BRG_SET;            //set to 1 every (1/9600) seconds
    reg BRG_SET_tracker;     //used so that I can set BRG_SET in two always blocks
    
    reg [1:0] state = 0;
    reg load = 0;
    reg shift = 0;
    reg clear = 0;
    reg [9:0] shiftright_register = 0;
    
    reg[26:0] debounce_counter = 0;
    
   //BRG for UART
    always @(posedge clk)
    begin
        if(BRG_counter == cycle_BRG)
            begin
                BRG_SET <= 1;
                BRG_counter <= 0;
            end
         else
            begin
                BRG_counter <= BRG_counter + 1;
                BRG_SET <= 0;
            end
    end
    
    //controller for UART
    always@(posedge clk)
    begin
       case(state) 
            idle: //waiting for transmit button to be pressed
            begin
                if(transmit)
                begin
                    state <= loading;
                    load <= 1;
                    shift <= 0;
                    clear <= 0;
                    Txd <= 1;
                end
                
                else
                begin
                    state <= idle;
                    load <= 0;
                    shift <= 0;
                    clear <= 0;
                    Txd <= 1;
                end
            end 
            
            loading: //button was pressed, keeping load signal high until BRG has been set so that data path can update the shift register
            begin
                if(BRG_SET)
                begin
                    state <= sending;
                    load <= 0;
                    shift <= 1;
                    clear <= 0;
                    Txd <= 1;
                end
                
                else
                begin
                    state <= loading;
                    load <= 1;
                    shift <= 0;
                    clear <= 0;
                    Txd <= 1;
                end
            end
            
            sending: //send data until 10 bits have been sent on TX line
            begin
                if(bit_counter == 10)
                begin
                    state <= done;
                    load <= 0;
                    shift <= 0;
                    clear <= 1;
                    Txd <= 1;
                end
                else
                begin
                    state <= sending;
                    load <= 0;
                    shift <= 1;
                    clear <= 0;
                    Txd <= shiftright_register[0];
                end
            end
           
            done: //once 10 bits set, keep clear high and wait for BRG_SET to become 1 so that data path can reset the bit counter and BRG counter
            begin
                if(debounce_counter == debounce_seconds)
                begin
                    Done <= 0;
                    state <= idle;
                    load <= 0;
                    shift <= 0;
                    clear <= 0;
                    Txd <= 1;
                    debounce_counter <= 0;
                end
                else
                begin
                    Done <= 1;
                    state <= done;
                    load <= 0;
                    shift <= 0;
                    clear <= 1;
                    Txd <= 1;
                    debounce_counter <= debounce_counter + 1;
                end
            end  
       endcase 
    end
    
    //data path for UART
    always @(posedge BRG_SET)
    begin
        if(load)
        begin
            shiftright_register <= {1'b1, data_send, 1'b0};
            bit_counter <= 0;
        end
        else if(shift)
        begin
            shiftright_register <= shiftright_register >> 1;
            bit_counter <= bit_counter +1;    
        end
        else if(clear)
        begin
            bit_counter <= 0; 
        end    
    end
    
endmodule
