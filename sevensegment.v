`timescale 1ns / 1ps

module sevensegment#(parameter cycleBits = 21, sevensegment_cycle = 1600000)(input clk, input rst, input [3:0] number, input [3:0] currLED, output reg [3:0] anodeOutput, output reg [7:0] cathodeOutput, output reg [3:0] LED0, output reg[3:0] LED1, output reg [3:0] LED2, output reg [3:0] LED3);

    reg LEDSET;
    reg [3:0] currAnode;
    reg [(cycleBits-1):0] LEDCycleCounter;
    reg [3:0] cathodeSource;

    reg state_100MHZ;
    reg state_LEDClock;
    
    
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
