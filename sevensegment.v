`timescale 1ns / 1ps

/*
    File: sevensegment.v 
    Author: Hamza Beder
/*
    This module is used to drive the seven segment LEDs on the Basys3 Board.
    
    Inputs:
            clk: The clock signal that controls the module's operation  
            rst: Reset signal to initialize signals to a known state.
            number: The input from the Basys3 switches that is used to dictate what shows on the display.
            currLED: Input from the Basys3 Board that determines which of the 4 displays the user wnats to modify.
            
    Outputs:
            anodeOutput: The signals to drive the 4 anodes on the Basys3
            cathodeOutput: Signals to control the cathodes on the Basys3
            LED0, LED1, LED2, LED3: These registers store the numbers the user entered when modifying each display.
*/

module sevensegment#(parameter cycleBits = 21, sevensegment_cycle = 1600000)(input clk, input rst, input [3:0] number, input [3:0] currLED, output reg [3:0] anodeOutput, output reg [7:0] cathodeOutput, output reg [3:0] LED0, output reg[3:0] LED1, output reg [3:0] LED2, output reg [3:0] LED3);

    reg LEDSET;// On the rising edge of this signal, the signals driving the anodes and cathodes change.
    reg [3:0] currAnode; //Tracks the anode that is currently being driven HIGH.
    reg [(cycleBits-1):0] LEDCycleCounter; //Counter needed to meet the refresh rate requirements of the display.
    reg [3:0] cathodeSource; //BCD signal used to determine the cathode output. 
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            LEDCycleCounter <= 0;
        end

        else if(LEDCycleCounter == sevensegment_cycle/4)
            //If this is true, then the refresh rate time has elapsed, and the display can change.
            begin
                LEDCycleCounter <= 0;
                LEDSET <= 1;
                //On the rising edge of LEDSET, the display will change.
            end

        else
            begin
                LEDSET <= 0;
                LEDCycleCounter <= LEDCycleCounter + 1;
            end
    end

    //Circular shift-right register used for controlling the anode output.
    always@(posedge LEDSET)
    begin
        case(currAnode)
            4'b1000:
                currAnode <= 4'b0100;
            4'b0100:
                currAnode <= 4'b0010;
            4'b0010:
                currAnode <= 4'b0001;
            4'b0001:
                currAnode <= 4'b1000;
            default:
                currAnode <= 4'b1000;
         endcase
    end

    //This sets cathodeSource so that it can control the cathodeOutput on the rising edge of LEDSET 
    //LED0, LED1, LED2, and LED3 store the numbers entered for the first, second, third, and fourth LEDs respectively.
    always@(posedge clk)
    begin
        case(currAnode)
            4'b1000:
            begin
                if(currAnode == currLED)
                    begin
                        LED0 <= number;
                        cathodeSource <= number;
                    end
                else
                    cathodeSource<= LED0;
                    //If the user is not controlling the display controlled by the current anode, then use the last stored input
                    //which is stored in LED0. 
            end

            4'b0100:
            begin
                if(currAnode == currLED)
                    begin
                        LED1 <= number;
                        cathodeSource<= number;
                    end
                else
                    cathodeSource<= LED1;
            end

            4'b0010:
            begin
                if(currAnode == currLED)
                    begin
                        LED2 <= number;
                        cathodeSource<=number;
                    end
                else
                    cathodeSource<= LED2;
            end

            4'b0001:
            begin
                if(currAnode == currLED)
                    begin
                        LED3 <= number;
                        cathodeSource <= number;
                    end
                else
                    cathodeSource<= LED3;
            end
            
            default:
            begin
                cathodeSource <= number;
                LED0 <= number;
            end
        endcase
    end

    //This block uses the BCD value stored in cathodeSource to set cathodeOutput appropriately,
    //anodeOutput is set to the inverse of currAnode, since logic 1 corresponds to an LED being off.
    always @(posedge LEDSET)
    begin
        case(cathodeSource)
            4'b0000:
            cathodeOutput <= 8'b10000001;
            4'b0001:
            cathodeOutput <= 8'b11001111;
            4'b0010:
            cathodeOutput <= 8'b10010010;
            4'b0011:
            cathodeOutput <= 8'b10000110;
            4'b0100:
            cathodeOutput <= 8'b11001100;
            4'b0101:
            cathodeOutput <= 8'b10100100;
            4'b0110:
            cathodeOutput <= 8'b10100000;
            4'b0111:
            cathodeOutput <= 8'b10001111;
            4'b1000:
            cathodeOutput <= 8'b10000000;
            4'b1001:
            cathodeOutput <= 8'b10000100;
            default:
            cathodeOutput <= 8'b11111111;
        endcase
        anodeOutput <= ~currAnode;
    end

endmodule
