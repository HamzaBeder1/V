`timescale 1ns / 1ps
/*
    This module is used for calculating the arctangent and magnitude of the input.
    
    Inputs:
            clk: Clock signal for controlling operations.
            st: start signal that begins the CORDIC iterations
            func: A register that determines if the output from the module should write to the result register and which function to write.
            
   Outputs:
            result: This is a bus shared by the modules in this project. Depending on func, this module either writes High-Z or the output it computes.
*/
module arctan_andmagnitude#(n = 16, START_STATE = 3'b000, ADD_STATE = 3'b001, MULT_STATE = 3'b010, DONE_STATE = 3'b011)(input clk, input st, input[15:0] x, input[15:0] y, input [3:0] func, output [31:0] result
    );
    reg signed [15:0] x_reg[16:0];
    reg signed [15:0] y_reg [16:0];
    reg signed [15:0] z_reg[16:0];
    wire signed [15:0] d;
    integer i;
    wire k;
    wire Mdone;
    //signal that is set once multiplication completes and the magnitude has been computed.
    wire done;
    
    //SM logic
    reg[2:0] state, nextstate;
    reg load, add, mult;
    
    wire [63:0] mult_temp;
    //stores the reuslt of multiplying the final x by the inverse of the CORDIC gain, necessary to compute magnitude.
    wire signed [15:0] arctan;
    wire signed [31:0] magnitude;
    wire [15:0] TANROM[15:0];
    //a LUT used to store the arctan(2^-i), where i+1 is the current CORDIC iteration.
    
    //Setting values for the arctan LUT
    assign TANROM[0] = 16'b0011001001000011;
    assign TANROM[1] = 16'b0001110110101100;
    assign TANROM[2] = 16'b0000111110101101;
    assign TANROM[3] = 16'b0000011111110101;
    assign TANROM[4] = 16'b0000001111111110;
    assign TANROM[5] = 16'b0000000111111111;
    assign TANROM[6] = 16'b0000000011111111;
    assign TANROM[7] = 16'b0000000001111111;
    assign TANROM[8] = 16'b0000000000111111;
    assign TANROM[9] = 16'b0000000000011111;
    assign TANROM[10] =16'b0000000000001111;
    assign TANROM[11] =16'b0000000000000111;
    assign TANROM[12] =16'b0000000000000011;
    assign TANROM[13] =16'b0000000000000001;
    assign TANROM[14] =16'b0000000000000000;
    assign TANROM[15] =16'b0000000000000000;
    
    always@(st, state, k, Mdone)
    begin
        nextstate<=0;
        load<=0;
        add<=0;
        mult<=0;
        case(state)
            START_STATE:
            begin
                if(~st)
                    nextstate<=0;
                else if(st)
                begin
                    load<=1;
                    nextstate<=ADD_STATE;
                end
            end
            
            ADD_STATE:
            begin
                if(~k)
                begin
                    add<=1;
                    nextstate<=ADD_STATE;
                end
                else
                begin
                    mult<=1;
                    nextstate<= MULT_STATE;
                end
            end
            
            MULT_STATE:
            begin
                if(Mdone)
                    nextstate<=DONE_STATE;
                else
                    nextstate<=MULT_STATE;
            end
            
            DONE_STATE:
            begin
                if(~st)
                begin
                    nextstate<=DONE_STATE;
                end
                else
                begin
                    load<=1;
                    nextstate<=ADD_STATE;
                end
            end
        endcase
    end
    
    //performs the CORDIC iterations.
    always@(posedge clk)
    begin
        state<=nextstate;
        if(load)
        begin
            x_reg[0] <= x;
            y_reg[0] <= y;
            z_reg[0] <= 16'd0;
            i<=0;
        end
        if(add)
        begin
            x_reg[i+1] <= x_reg[i] - d*(y_reg[i] >>> i);
            y_reg[i+1] <= y_reg[i] + d*(x_reg[i] >>> i);
            z_reg[i+1] <= z_reg[i] - d*TANROM[i];
            i <= i+1;
        end
    end
    
    assign done = (state == DONE_STATE)? 1:0;
    assign k = (i == 16)? 1:0;
    assign d = (y_reg[i] < 0)? 1:-1;
    assign arctan = (done == 1)? z_reg[16]:16'dx;
    assign magnitude = (done==1)? mult_temp[63:32]: 32'bx;
    assign result = (func == 0)? {arctan}:((func == 1)? magnitude:32'dz);
    
    booth booth_alg (clk,mult,32'b00000000000000001001111000000000,{x_reg[16], 16'd0}, mult_temp, Mdone); 
endmodule
