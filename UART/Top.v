`timescale 1ns / 1ps

/*
    File: Top.v 
    Author: Hamza Beder
*/

/*This is the top module that uses the sevensegment module to control the display, and the UART_byte  
  module to send the data on the display to the user's laptop. 
  
  Inputs:
            clk: clock signal for controlling operations
            rst: reset signal to bring signals to a known state. 
            transmit: used to start sending data to the user's laptop. 
            currLED: The input from the Basys3 switches that says which segment the user can modify
            number: Input from the Basys3 switches saying what value the user wants to display.
            
  Outputs:
            anodeOutput: drives the anodes of the display.
            cathodeOutput: drives the cathodes. 
            Txd: The TX line used for sending data.
*/
module Top#(parameter debounce_count = 50000000, idle = 2'b00, sending = 2'b01, waiting = 2'b11, debouncing = 2'b10)(
    input clk, input rst, input transmit, input [3:0] currLED, input [3:0] number, output [3:0] anodeOutput, output [7:0] cathodeOutput, output Txd
);

    wire [3:0] LED0, LED1, LED2, LED3;
    //for storing the last entered values for each display.
    wire [3:0] currNum;
    //The current number that needs to be sent via UART.
    wire [7:0] currASCII;
    //ascii value of currNum, required in order to send via UART.
    wire k;
    //set once all bytes are sent.
    wire BRG_SET;
    //This is the BRG signal output from the UART module, used to control when bytes are sent.
    wire UART_done;
    //Wire connected to the instance of the UART module, used to control when bytes are sent.
    
    //rst signals
    wire rst_segment;
    wire rst_UART;
    
    reg d;
    //set once debouncing is done
    integer count;
    //counter for the number of bytes sent.
    integer debounce_counter;
    //used for debouncing
    
    //SM logic
    reg [1:0] state, nextstate;
    reg up;
    //when set, count will increment.
    reg debounce;
    //when set, the debounce counter will increment.
    reg UART_start;
    //start signal for UART

    always @(state, count, transmit, UART_done, BRG_SET, k, d, count)
    begin
        nextstate<=0;
        up<=0;
        debounce<=0;
        UART_start<=0;
        
        //Wait in the idle state until transmit is pressed.
        //Once transmit is pressed, begin sending the first seven segment digit.
        case(state)
            idle:
            begin
                if(~transmit)
                begin
                    nextstate<=idle;
                end
                
                else
                begin
                    UART_start<=1;
                    nextstate<=waiting;
                end
            end
            
            //Keep the signal high until BRG_SET is HIGH because the UART module operates 
            //every 1/9600 seconds rather than on the active edge of the 100MHz clock of the Basys3.
            waiting:
            begin
                if(BRG_SET != 1)
                begin
                    nextstate<=waiting;
                    UART_start<=1;
                end
                else
                begin
                    nextstate<=sending;
                end
            end 
            
            sending:
            begin
                if(~UART_done)
                begin
                    nextstate<=sending; //Stay in this state until done sending the current byte.
                end
                
                //If ~k, that means more digits still need to be sent, so set up to 1 to increment count and go to the wait state 
                //before sending another byte.
                else if(~k)
                begin
                    up<=1;
                    nextstate<=waiting;
                end
                
                //If k is set, all data has been sent. Go to the debounce state.
                else if(k)
                begin
                    nextstate<= debouncing;
                    debounce<=1;
                end
                
            end
            
            //Wait until the debounce counter reaches the appropriate value. Once done, return to the idle state.
            debouncing:
            begin
                if(~d)
                begin
                    nextstate<=debouncing;
                    debounce<=1;
                end
                else if(d)
                begin
                    nextstate<= idle;
                end
            end
        endcase
    end

    always @(posedge clk)
    begin
        state<=nextstate;
        
        //In the idle state, initialize signals.
        if(state == idle)
        begin
            debounce_counter <= 0;
            count <= 0;
            d<=0;
        end
        
        //When up is 1, increment the counter; this means a byte has been sent.
        if(up)
        begin
            count <= count + 1;
        end
        
        //Used for debouncing.
        if(debounce)
        begin
            if(debounce_counter == debounce_count)
                begin
                    debounce_counter<=0;
                    d <= 1;
                end
            else
                begin
                    debounce_counter <=debounce_counter+1;
                    d <= 0;
                end
        end
    end
    
    assign currNum = (count == 0)? LED0: ((count == 1)? LED1: ((count == 2)? LED2: ((count == 3)? LED3:2'bzz) ));
    //count is used to determine which number to send.
    assign k = (count == 3)? 1:0;
    //set once all bytes are sent.
    assign rst_segment = (rst == 1)? 1:0;
    assign rst_UART = (rst == 1)? 1:0;
    sevensegment s(clk, rst_segment, number, currLED, anodeOutput, cathodeOutput, LED0, LED1, LED2, LED3);
    UART_byte u(clk, rst_UART, currASCII, UART_start, Txd, BRG_SET, UART_done);
    convertToASCII c(clk, currNum, currASCII);
endmodule

/*
    This module takes the BCD value of a 7-segment output, and then converts it to a byte 
to send over UART.
    
    Inputs:
            clk: clk signals for controlling operations.
            currNum: The BCD value to be converted.
            
    Outputs:
            currASCII: The results of the conversion.
*/
module convertToASCII(input clk, input [3:0] currNum, output reg [7:0] currASCII);
    begin
        always@(posedge clk)
        begin
            //case statement that performs BCD to ASCII conversion.
            case(currNum)
                4'b0000:
                currASCII <= 8'b00110000;
                4'b0001:
                currASCII <= 8'b00110001;
                4'b0010:
                currASCII <= 8'b00110010;
                4'b0011:
                currASCII <= 8'b00110011;
                4'b0100:
                currASCII <= 8'b00110100;
                4'b0101:
                currASCII <= 8'b00110101;
                4'b0110:
                currASCII <= 8'b00110110;
                4'b0111:
                currASCII <= 8'b00110111;
                4'b1000:
                currASCII <= 8'b00111000;
                4'b1001:
                currASCII <= 8'b00111001;
            endcase
        end
    end
endmodule
