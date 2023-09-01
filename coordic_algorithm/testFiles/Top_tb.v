`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2023 05:06:48 PM
// Design Name: 
// Module Name: Toptb
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


module Toptb #(parameter n = 8, wait_count = 20, START_STATE = 3'b000,DEBOUNCE_STATE = 3'b001, SELECT_STATE = 3'b010, ENTER1_STATE = 3'b011, ENTER2_STATE = 3'b100, READY_STATE = 3'b101, DONE_STATE = 3'b110)();
    reg clk;
    reg st;
    reg [15:0] sw_in;
    wire [3:0] anodeOutput;
    wire [7:0] cathodeOutput;
    
    always 
    begin
        #5 clk <= !clk;
    end
    
    reg [31:0] op_arr[1:n];
    reg[3:0] i;
    reg[3:0] j;
    integer wait_counter;
    reg [2:0] state, nextstate;
    reg F, E1, E2;
    reg INCI, INCJ;
    reg w;
    wire op_done;
    wire f_done;
    reg wait_done;
    wire two_ops, one_op;
    
    initial
    begin
        clk = 0;
        st = 0;
        i = 0;
        j = 1;
        wait_counter = 0;
        wait_done = 0;
        op_arr[1] = {{16'b0100000000000000}, {16'd0}};
        op_arr[2] = {{16'b0100000000000000}, {16'b0010101010011011}};
        op_arr[3] = {{16'b0100000000000000}, {16'b0110010010000111}};
        op_arr[4] = {{16'b0010000000000000}, {16'b0110010010000111}};
        op_arr[5] = {{16'b0100000000000000}, {16'b0010000000000000}};
        op_arr[6] = {{16'b0100000000000000}, {16'b0001100110011001}};
        op_arr[7] = {{16'b0100000000000000}, {16'b0000011001100110}};
        op_arr[8] = {{16'b0100000000000000}, {16'b0001000000000000}};
    end
    
    
    
    always@(state, wait_done, op_done, f_done)
    begin
        nextstate<=0;
        st<=0;
        F<=0;
        E1<=0;
        E2<=0;
        INCI<=0;
        INCJ<=0;
        w<=0;
        case(state)
        0:
        begin
            if(~wait_done)
            begin
                w<=1;
                nextstate<=0;
            end
            else
            begin
                st<=1;
                F<=1;
                nextstate<=1;
            end
        end
        
        1:
        begin
            if(~wait_done)
            begin
                w<=1;
                F<=1;
                nextstate<=1;
            end
            else
            begin
                if(f_done)
                    nextstate<=6;
                else if(two_ops)
                begin
                    F<=1;
                    nextstate<=2;
                end
                else if(one_op)
                begin
                    F<=1;
                    nextstate<=3;
                end
            end
        end
        
        2:
        begin
            E1<=1;
            if(~wait_done)
            begin
                w<=1;
                nextstate<=2;
            end
            else
            begin
                st<=1;
                nextstate<=3;
            end
        end
        
        3:
        begin
            E2<=1;
            if(~wait_done)
            begin
                w<=1;
                nextstate<=3;
            end
            else
            begin
                st<=1;
                INCJ<=1;
                nextstate<=4;
            end
        end
        
        4:
        begin
            if(~wait_done)
            begin
                w<=1;
                nextstate<=4;
            end
            else
            begin
                st<=1;
                nextstate<=5;
            end
        end
        
        5:begin
            if(op_done)
                INCI<=1;
            nextstate<=1;
        end
        
        6:
        begin
            nextstate<=6;
        end
        endcase
    end
    
    always@(posedge clk)
    begin
        state<=nextstate;
        wait_done <=0;
        if(w)
        begin
            if(wait_counter == wait_count)
            begin
                wait_done <=1;
                wait_counter <=0;
            end
            else
            begin
                wait_counter<= wait_counter +1;
            end
        end
        if(F)
            sw_in <= i;
        if(E1)
            sw_in <= op_arr[j][31:16];
        if(E2)
            sw_in <= op_arr[j][15:0];
        if(INCI)
            i<=i+1;
        if(INCJ)
            j<=j+1;
    end
    
    assign op_done = (j == n+1)? 1:0;
    assign f_done = (i == 8)? 1:0;
    assign two_ops = (i == 0 || i == 1 || i== 7)? 1:0;
    assign one_op = ~two_ops;
    Top DUT(clk, st, sw_in, anodeOutput, cathodeOutput);
endmodule
