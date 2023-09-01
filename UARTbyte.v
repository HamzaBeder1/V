`timescale 1ns / 1ps
/*
    File: UART.v
    Author: Hamza Beder
*/

/*
    This module sends a single byte to a user's computer using UART.
    
    Inputs:
            clk: This is the clock signal used to control the operations of the module.
            rst: Reset signal to bring signals to a known state.
            data_send: The byte to be sent.
            transmit: Start signal for sending data.
            
    Outputs:
            Txd: The TX line used to send data to the user's laptop.
            BRG_SET: BRG signal that is used in the Top module to control when bytes are sent.
            Done: Set when the byte has been sent; this signal is used in the Top module to assist in sending multiple bytes.
            
           
*/
module UART_byte#(parameter cycle_BRG = 10416, idle = 2'b00, loading = 2'b01, sending = 2'b11, done = 2'b10, debounce_seconds = 2500)(
input clk, input rst, input [7:0] data_send, input transmit, output reg Txd, output reg BRG_SET, output Done
    );
    
    reg [13:0] BRG_counter;// Counter used to implement the BRG.
    reg [9:0] bit_counter;// Keeps track of the number of bits sent.
    
    //SM control signals
    reg [1:0] state;
    reg [1:0] nextstate;
    reg load = 0; //Loads the shift register that stores the data along with the start and stop bits.
    reg shift = 0; //Control signal for shifting the shiftirght_register bits onto the TX line.
    reg clear = 0; //clears the bit counter when done sending.
    reg [9:0] shiftright_register; //stores the bits to be sent.
    
    
    reg[26:0] debounce_counter = 0; //Prevents issues with switch bounces when pressing the transmi button the Basys3.
    
   //BRG, creating 9600 pulses per second
    always @(posedge clk)
    begin
        state<=nextstate;
        if(rst)
            BRG_counter <= 0;
        else if(BRG_counter == cycle_BRG)
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
    always @(transmit, state, BRG_SET, bit_counter)
    begin
        nextstate<=idle;
        load<=0;
        shift<=0;
        clear<=0;
        case(state) 
            idle: //waiting for transmit button to be pressed
            begin
                if(transmit)
                begin
                    nextstate <= loading;
                    load <= 1;
                    Txd <= 1;
                end
                
                else
                begin
                    nextstate <= idle;
                    Txd <= 1;
                end
            end 
            
            loading: //button was pressed, keeping load signal high until BRG has been set so that data path can update the shift register
            begin
                if(BRG_SET)
                begin
                    nextstate <= sending;
                    shift <= 1;
                    Txd <= 1;
                end
                
                else
                begin
                    nextstate <= loading;
                    load <= 1;
                    Txd <= 1;
                end
            end
            
            sending: //send data until 10 bits have been sent on TX line
            begin
                if(bit_counter == 10)
                begin
                    nextstate <= done;
                    clear <= 1;
                    Txd <= 1;
                end
                else
                begin
                    nextstate <= sending;
                    shift <= 1;
                    Txd <= shiftright_register[0];
                end
            end
           
            done: //once 10 bits sent, keep clear high and wait for BRG_SET to become 1 so that data path can reset the bit counter
            begin
                nextstate<=idle;
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
    
    assign Done = (state == done)? 1:0;
endmodule
