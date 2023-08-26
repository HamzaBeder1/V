`timescale 1ns / 1ps

module UART_byte#(parameter cycle_BRG = 10416, idle = 2'b00, loading = 2'b01, sending = 2'b11, done = 2'b10, debounce_seconds = 2500)(
input clk, input rst, input [7:0] data_send, input transmit, output reg Txd, output Done
    );
    
    reg [13:0] BRG_counter;
    reg [9:0] bit_counter;
    reg BRG_SET;
    
    reg [1:0] state;
    reg [1:0] nextstate;
    reg load = 0;
    reg shift = 0;
    reg clear = 0;
    reg [9:0] shiftright_register;
    reg[26:0] debounce_counter = 0;
    
    assign Done = (state == done)? 1:0;
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
    always @(transmit, state,BRG_SET, bit_counter)
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
    
endmodule
