`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2023 01:03:54 AM
// Design Name: 
// Module Name: doubledabble_BCDtobinary
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


module doubledabble_BCDtobinary(input clk, input st, input [11:0] BCD_in, output [7:0] bin_out

    );
    reg [11:0] ACC_BCD;
    reg [7:0] ACC_bin;
    integer count;
    
    reg load, shift, sub;
    reg [2:0] state, nextstate;
    
    wire k;
    wire B0_gt, B1_gt, B2_gt, gt;
    
    assign k = (count == 8)? 1:0;
    assign B0_gt = ACC_BCD[3:0] >= 5? 1:0;
    assign B1_gt = ACC_BCD[7:4] >= 5? 1:0;
    assign B2_gt = ACC_BCD[11:8] >= 5? 1:0;
    assign gt = (B0_gt || B1_gt || B2_gt);
    assign bin_out = ACC_bin;
    
    always@(state, st, k, gt)
    begin
        nextstate<=0;
        load<=0;
        shift<=0;
        sub <= 0;
        case(state)
            0:
            begin
                if(st)
                begin
                    nextstate<=1;
                    load<=1;
                end
                else
                    nextstate<=0;
            end
            
            1:
            begin
                shift <=1;
                nextstate<=2;
            end
            
            2:
            begin
                if(k)
                begin
                    nextstate<=4;
                end
                else
                begin
                    if(gt)
                    begin
                        sub <=1;
                        nextstate<=3;
                    end
                    else
                    begin
                        shift<=1;
                        nextstate<=2;
                    end
                end
            end
            
            3:
            begin
                nextstate<=2;
                shift<=1;
            end
            
            4:
            begin
                nextstate<=0;
            end
        endcase
    end
    always@(posedge clk)
    begin
        state<=nextstate;
        if(load)
        begin
            ACC_BCD = BCD_in;
            ACC_bin = 8'd0;
            count <= 0;
        end
        
        if(sub)
        begin
            if(B0_gt)
                ACC_BCD[3:0] <= ACC_BCD[3:0] - 4'd3;
            if(B1_gt)
                ACC_BCD[7:4] <= ACC_BCD[7:4] - 4'd3;
            if(B2_gt)
                ACC_BCD[11:8] <= ACC_BCD[11:8] - 4'd3;
        end
        
        if(shift)
        begin
            ACC_BCD <= ACC_BCD >> 1;
            ACC_bin <= {ACC_BCD[0], ACC_bin[7:1]};
            count <= count +1;
        end
    end
endmodule
