`timescale 1ns / 1ps

module Top#(parameter debounce_count = 50000000, idle = 2'b00, sending = 2'b01, debouncing = 2'b10)(
    input clk, input rst, input transmit, input [3:0] currLED, input [3:0] number, output [3:0] anodeOutput, output [7:0] cathodeOutput, output Txd
);
    wire [3:0] LED0, LED1, LED2, LED3;
    wire [3:0] currNum;
    wire [7:0] currASCII;
    wire k;
    wire rst_segment;
    wire rst_UART;
    reg d;
    integer count;
    integer debounce_counter;
    reg UART_start;
    wire UART_done;
    assign currNum = (count == 0)? LED0: ((count == 1)? LED1: ((count == 2)? LED2: LED3));
    assign k = (count == 4)? 1:0;
    assign rst_segment = (rst == 1)? 1:0;
    assign rst_UART = (rst == 1)? 1:0;
    sevensegment s(clk, rst_segment, number, currLED, anodeOutput, cathodeOutput, LED0, LED1, LED2, LED3);
    UART_byte u(clk, rst_UART, currASCII, UART_start, Txd, UART_done);
    convertToASCII c(clk, currNum, currASCII);

    reg [1:0] state, nextstate;
    reg up, debounce;

    always @(transmit, UART_done,k, d, count)
    begin
        nextstate<=0;
        up<=0;
        debounce<=0;
        UART_start<=0;
        case(state)
            idle:
            begin
                if(~transmit)
                begin
                    nextstate<=idle;
                end
                else
                begin
                    up<=1;
                    UART_start<=1;
                    nextstate<=sending;
                end
            end
            
            sending:
            begin
                if(~UART_done)
                begin
                    UART_start<=1;
                    nextstate<=sending;
                end
                else if(~k)
                begin
                    up<=1;
                    UART_start<=1;
                    nextstate<=sending;
                end
                else if(k)
                begin
                    nextstate<= debouncing;
                    debounce<=1;
                end
            end
            
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
        if(state == idle)
        begin
            debounce_counter <= 0;
            count <= 0;
            d<=0;
        end
        
        if(up)
        begin
            count <= count + 1;
        end
        
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
endmodule

module convertToASCII(input clk, input [3:0] currNum, output reg [7:0] currASCII);
    begin
        always@(posedge clk)
        begin
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

