`timescale 1ns / 1ps

/*
    This module is used to drive the Basys3 seven-segment display.
    
    Inputs:
            clk: Clock signal for controlling operations.
            rst: Reset signal for bringing signals to a known state.
            state: Determines what value should be displayed; this signal comes from the Top module.
            result: When it is time to display the results, this input is used to drive the display accordingly.
            
    Outputs:
            anodeOutput: Used to drive the anodes on the Basys3.
            cathodeOutput: Used to drive the cathodes of the Basys3.
*/
module sevensegment#(parameter cycleBits = 21, sevensegment_cycle = 1600000)(input clk, input rst, input [2:0] state, input [31:0] result, output reg [3:0] anodeOutput, output reg [7:0] cathodeOutput);

    reg LEDSET;
    //when set, the display will change.
    reg [3:0] currAnode;
    //used to drive anodeOutput.
    reg [(cycleBits-1):0] LEDCycleCounter;
    //counter that is needed to set an appropriate refresh rate for the LEDs.
    reg [7:0] cathodeSource;
    //During the BCD to 7-segment conversion, this register is used to drive the cathodes.
    reg [3:0] BCD;
    //BCD value that will be converted to the 7-segment output.
    wire signed [15:0] converted_out;
    //Holds the results of converting result to BCD.
    
    //counter that sets LED when refresh period elapses.
    always@(posedge clk)
    begin
        if(rst)
        begin
            LEDCycleCounter <= 0;
        end

        else if(LEDCycleCounter == sevensegment_cycle/4)
            begin
                LEDCycleCounter <= 0;
                LEDSET <= 1;
            end

        else
            begin
                LEDSET <= 0;
                LEDCycleCounter <= LEDCycleCounter + 1;
            end
    end
    
    //Cyclic shift register for changing which anode should be on at a given time.
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

    //BCD is set to bits in converted_out. cathodeSource is set depending on what state the Top module is in; 
    //cathodeOutput will drive the 7-segment in all states except state 6, which is when the result is displayed.
    always@(posedge clk)
    begin
        case(currAnode)
            4'b1000:
            begin
                cathodeSource <= 8'b11111111;
                BCD <= converted_out[15:12];
            end

            4'b0100:
            begin
                cathodeSource <=8'b11111111;
                BCD <= converted_out[11:8];
            end

            4'b0010:
            begin
                BCD<= converted_out[7:4];
                if(state == 3)
                begin
                    cathodeSource<=8'b10110000; //E
                end
                else if(state == 4)
                begin
                    cathodeSource<=8'b10110000; //E
                end
                else if(state == 5)
                begin
                    cathodeSource<=8'b10100000; //G
                end
                else
                begin
                    cathodeSource<=8'b11111111;
                end
            end

            4'b0001:
            begin
                BCD<=converted_out[3:0];
                if(state == 2)
                    cathodeSource<=8'b10111000; //F
                else if(state == 3)
                    cathodeSource<=8'b11001111; //1
                else if(state == 4)
                    cathodeSource<=8'b10010010; //2
                else if(state == 5)
                    cathodeSource<=8'b10000001; //O
            end
            
            default:
            begin
                BCD <= 4'b1010;
                cathodeSource<=8'b11111111;
            end
        endcase
    end

    //sets both cathodeOutput and anodeOutut
    always @(LEDSET, rst)
    begin
        if(rst)
        begin
            cathodeOutput<=8'b11111111;
        end
        else if(state ==2 || state == 3 || state == 4 || state == 5)
        begin
            cathodeOutput <= cathodeSource;
        end
        
        else if(state == 6)
        begin
            if(currAnode == 4'b1000)
                cathodeOutput[7] <= 1;
            else
                cathodeOutput[7] <= 0;
            case(BCD)
            4'b0000:
            cathodeOutput[6:0] <= 7'b0000001;
            4'b0001:
            cathodeOutput[6:0] <= 7'b1001111;
            4'b0010:
            cathodeOutput[6:0] <= 7'b0010010;
            4'b0011:
            cathodeOutput[6:0] <= 7'b0000110;
            4'b0100:
            cathodeOutput[6:0] <= 7'b1001100;
            4'b0101:
            cathodeOutput[6:0] <= 7'b0100100;
            4'b0110:
            cathodeOutput[6:0] <= 7'b0100000;
            4'b0111:
            cathodeOutput[6:0] <= 7'b0001111;
            4'b1000:
            cathodeOutput[6:0] <= 7'b0000000;
            4'b1001:
            cathodeOutput[6:0] <= 7'b0000100;
            default:
            cathodeOutput[6:0] <= 7'b1111111;
        endcase
        end
        anodeOutput <= ~currAnode;
    end

    binaryFractionToBCD bf_toBCD(clk,result,converted_out);
    
endmodule

/*
    This module converts result from a binary fraction to a BCD value.
    
    Inputs:
            clk: Clock signal for controlling operations.
            result: The results to be converted.
            
    Outputs:
            converted_out: The results of the conversion.
    
*/
module binaryFractionToBCD(input clk, input [31:0] result, output reg signed [15:0] converted_out);
    reg [31:0] r;
    always@(posedge clk)
    begin
        r <= (result*1000) >> 14;
        converted_out[15:12] <= (r/1000)%10;
        converted_out[11:8] <= (r/100)%10;
        converted_out[7:4] <= (r/10)%10;
        converted_out[3:0] <= (r)%10;
    end
endmodule
