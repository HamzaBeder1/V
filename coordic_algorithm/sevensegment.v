`timescale 1ns / 1ps

module sevensegment#(parameter cycleBits = 21, sevensegment_cycle = 1600000)(input clk, input rst, input [2:0] state, input [31:0] result, output reg [3:0] anodeOutput, output reg [7:0] cathodeOutput);

    reg LEDSET;
    reg [3:0] currAnode;
    reg [(cycleBits-1):0] LEDCycleCounter;
    reg [7:0] cathodeSource;
    reg [3:0] BCD;
    wire signed [15:0] converted_out;
    binaryFractionToBCD bf_toBCD(clk,result,converted_out);
    
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
                    cathodeSource<=8'b11001111; //1
                end
                else if(state == 4)
                begin
                    cathodeSource<=8'b10010010; //2
                end
                else if(state == 5)
                begin
                    cathodeSource<=8'b10000001; //O
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
                    cathodeSource<=8'b10100100; //S
                else if(state == 3)
                    cathodeSource<=8'b10110000; //E
                else if(state == 4)
                    cathodeSource<=8'b10110000; //E
            end
            
            default:
            begin
                BCD <= 4'b1010;
                cathodeSource<=8'b11111111;
            end
        endcase
    end

    always @(posedge LEDSET)
    begin
        if(state ==2 || state == 3 || state == 4 || state == 5)
        begin
            cathodeOutput <= cathodeSource;
        end
        else if(state == 6 && currAnode == 4'b1000)
        begin
            if(BCD == 0)
                cathodeOutput<=8'b00000001;
            else
                cathodeOutput<=8'b01001111;
        end
        else
        begin
            case(BCD)
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
        end
        anodeOutput <= ~currAnode;
    end

endmodule

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
