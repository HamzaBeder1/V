`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 09:45:49 PM
// Design Name: 
// Module Name: double_dabble
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


module double_dabble(input clk, input st, input [7:0] num, output [3:0] BCD0, output [3:0] BCD1, output [3:0] BCD2

    );
    reg [11:0] ACC_BCD;
    reg [7:0] ACC_bin;
    reg [2:0] state, nextstate;
    reg load, shift, add;
    integer count;
    
    wire k;
    wire D0GT, D1GT, D2GT;
    wire GT;
    
    assign k = (count == 8)? 1:0;
    assign D0GT = ACC_BCD[3:0] >= 5? 1:0;
    assign D1GT = ACC_BCD[7:4] >= 5? 1:0;
    assign D2GT = ACC_BCD[11:8] >= 5? 1:0;
    assign GT = (D0GT || D1GT || D2GT);
    assign BCD0 = ACC_BCD[3:0];
    assign BCD1 = ACC_BCD[7:4];
    assign BCD2 = ACC_BCD[11:8];
    
    always@(state, k, st, GT)
    begin
    nextstate<=0;
    load <= 0;
    shift<=0;
    add<=0;
    case(state)
        0:
        begin
            if(st)
            begin
                load<=1;
                nextstate<=1;
            end
            else
                nextstate<=0;
        end
        
        1:
        begin
            shift<=1;
            nextstate<=2;
        end
        
        2:
        begin
            if(k)
            begin
                nextstate <= 4;
            end
            else
            begin
                if(GT)
                begin
                    nextstate<=3;
                    add<=1;
                end
                else
                begin
                    nextstate<=2;
                    shift<=1;
                end
            end
        end
        
        3:
        begin
            shift<=1;
            nextstate<=2;
        end
        
        4:
        begin
            nextstate<= 0;
        end
    endcase
    end
    
    always@(posedge clk)
    begin
        state<=nextstate;
        if(load)
        begin
            ACC_BCD = 12'd0;
            ACC_bin <= num;
            count <= 0;
        end
        if(add)
        begin
            if(D0GT)
                ACC_BCD[3:0] <= ACC_BCD[3:0] + 4'd3;
            if(D1GT)
                ACC_BCD[7:4] <= ACC_BCD[7:4] + 4'd3;
            if(D2GT)
                ACC_BCD[11:8] <= ACC_BCD[11:8] + 4'd3;
        end
        
        if(shift)
        begin
            ACC_BCD <= {ACC_BCD[10:0], ACC_bin[7]};
            ACC_bin <= ACC_bin << 1;
            count <= count +1;
        end
    end
    
    
endmodule
