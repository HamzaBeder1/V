`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2023 08:31:57 AM
// Design Name: 
// Module Name: booth
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

`define B1B0 RegB[1:0]
module booth#(parameter n = 32, START_STATE = 2'b00, SHIFT_AND_ADD_STATE = 2'b01, DONE_STATE = 2'b10)(input clk, input st, input [(n-1):0] A, input [(n-1):0] B, output[n*2-1:0] product, output Done

    );
    
    reg [(n):0] ACC;
    reg [(n):0] RegB;
    integer count;
    
    wire K;
    wire [n:0] A_in;
    wire [n:0] addout;
    
    reg load, sh, sh_addinvert, sh_add;
    reg [1:0] state, nextstate;
    
    assign Done = (state==DONE_STATE)? 1:0;
    assign A_in = (sh_add)? {A[n-1], A}:((sh_addinvert)? ~{A[n-1],A}+1:0);
    assign K = (count == n)? 1:0;
    assign addout = A_in + ACC;
    assign product = {ACC, RegB[n:1]};
    
    always@(state, st, K, RegB)
    begin
        nextstate<=0;
        load <=0;
        sh<=0;
        sh_addinvert <=0;
        sh_add <=0;
        case(state)
            START_STATE:
            begin
                if(st)
                begin
                    load <=1;
                    nextstate<=SHIFT_AND_ADD_STATE;
                end
                else
                    nextstate<=START_STATE;
            end
            
            SHIFT_AND_ADD_STATE:
            begin 
                if(K)
                    nextstate<=DONE_STATE;
                else
                begin
                    nextstate <= SHIFT_AND_ADD_STATE;
                if(`B1B0 == 2'b00 || `B1B0 == 2'b11)
                    sh<=1;
                else if(`B1B0 == 2'b01)
                    sh_add <=1;
                else if (`B1B0 == 2'b10)
                    sh_addinvert<=1;
                end
            end
            
            DONE_STATE:
            begin
                nextstate<=START_STATE;
            end
        endcase
    end
    
    always@(posedge clk)
    begin
        state<=nextstate;
        if(load)
        begin
            ACC<=0;
            RegB[n:1] <= B;
            RegB[0] <= 0;
            count <=0;
        end
        
        if(sh_add || sh_addinvert)
        begin
            ACC <= {addout[n], addout[n:1]};
            RegB  <= {addout[0], RegB[n:1]};
            count <= count +1;
        end
        
        if(sh)
        begin
            ACC <= {ACC[n], ACC[n:1]};
            RegB <= {ACC[0], RegB[n:1]};
            count <= count + 1;
        end
    end
    
    
endmodule
