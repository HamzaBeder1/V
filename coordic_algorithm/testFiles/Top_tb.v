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


module Toptb #(parameter n = 8, wait_count = 70, INITIAL_STATE = 3'b000, F_STATE = 3'b001, E1_STATE = 3'b010, E2_STATE = 3'b011, GO_STATE = 3'b100, RESULT_STATE = 3'b101)();
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
    wire wait_done;
    wire two_ops, one_op;
    wire done;
    
    initial
    begin
        clk = 0;
        st = 0;
        i = 0;
        j = 1;
        wait_counter = 0;
        op_arr[1] = {{16'b0100000000000000}, {16'd0}}; //op1=1 and op2 = 0
        op_arr[2] = {{16'b0100000000000000}, {16'b0010101010011011}}; //op1 = 1 and op2 = 0.6657
        op_arr[3] = {{16'b0100000000000000}, {16'b0110010010000111}}; //op1 = 1 and op2 = pi/2
        op_arr[4] = {{16'b0010000000000000}, {16'b0110010010000111}}; //op1 = 0.5 and op2 = pi/2
        op_arr[5] = {{16'b0100000000000000}, {16'b0010000000000000}}; //op1 = 1 and op2 = 0.5
        op_arr[6] = {{16'b0100000000000000}, {16'b0001100110011001}}; //op1 = 1 and op2 = 0.4
        op_arr[7] = {{16'b0100000000000000}, {16'b0000011001100110}}; //op1 = 1 and op2 = 0.1
        op_arr[8] = {{16'b0100000000000000}, {16'b0001000000000000}}; //op1 = 1 and op2 = 0.25
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
            INITIAL_STATE:
            begin
                if(~wait_done)
                begin
                    w<=1;
                    nextstate<=INITIAL_STATE;
                end
                else
                begin
                    w<=1;
                    st<=1;
                    nextstate<= F_STATE;
                end
            end
            
            F_STATE:
            begin
                if(~wait_done)
                begin
                    F<=1;
                    w<=1;
                    nextstate<=F_STATE;
                end
                else
                begin
                    w<=1;
                    st<=1;
                    F<=1;
                    nextstate<= E1_STATE;
                end
            end
            
            E1_STATE:
            begin
                if(~wait_done)
                begin
                    w<=1;
                    E1<=1;
                    nextstate<=E1_STATE;
                end
                else
                begin
                    w<=1;
                    E1<=1;
                    st<=1;
                    nextstate<=E2_STATE;
                end
            end
            
            E2_STATE:
            begin
                if(~wait_done)
                begin
                    w<=1;
                    E2<=1;
                    nextstate<=E2_STATE;
                end
                else
                begin
                    w<=1;
                    E2<=1;
                    INCJ<=1;
                    st<=1;
                    nextstate<=GO_STATE;
                end
            end
            
            GO_STATE:
            begin
                if(~wait_done)
                begin
                    w <=1;
                    nextstate<=GO_STATE;
                end
                else
                begin
                    w<=1;
                    st<=1;
                    nextstate<=RESULT_STATE;
                end
            end
            
            RESULT_STATE:
            begin
                if(~wait_done)
                begin
                    w<=1;
                    nextstate<=RESULT_STATE;
                end
                else
                begin
                    w<=1;
                    st<=1;
                    if(op_done)
                        INCI<=1;
                    nextstate<=F_STATE;
                end
            end
        endcase
    end
    
    always@(posedge clk)
    begin
        state<=nextstate;
        if(w)
        begin
            if(wait_counter == wait_count)
            begin
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
    assign f_done = (i == 9)? 1:0;
    assign two_ops = (i == 0 || i == 1 || i== 7)? 1:0;
    assign one_op = ~two_ops;
    assign wait_done = (wait_counter == wait_count)? 1:0;
    assign done = (state == RESULT_STATE)? 1:0;
    Top DUT(clk, st, sw_in, anodeOutput, cathodeOutput);
endmodule
