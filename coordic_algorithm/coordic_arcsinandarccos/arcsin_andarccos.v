`timescale 1ns / 1ps

/*
    This module is used for calculating the arcsin and arccos of the input.
    
    Inputs:
            clk: Clock signal for controlling operations.
            st: start signal that begins the CORDIC iterations
            arcsin_in: Angle to compute the arcsin of.
            func: A register that determines if the output from the module should write to the result register and which function to write.
            
   Outputs:
            result: This is a bus shared by the modules in this project. Depending on func, this module either writes High-Z or the output it computes.
*/

module arcsin_andarccos#(parameter n = 16) (input clk, input st, input signed [15:0] arcsin_in, input [3:0] func, output signed [31:0] result

    );
    wire k;
    integer i;
    reg signed [15:0] reg_x[n:0];
    reg signed [15:0] reg_y[n:0];
    reg signed [15:0] reg_z[n:0];
    
    reg[1:0] state, nextstate;
    reg load, add;
    
    wire signed [15:0] arcsin, arccos;
    wire done;
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
    
    always@(state, st, k)
    begin
        nextstate<=0;
        load<=0;
        add<=0;
        
        case(state)
        0:
        begin
            if(~st)
                nextstate<=0;
            else if(st == 1)
            begin
                load<=1;
                nextstate<=1;
            end
        end
        
        1:
        begin
            if(k)
            begin
                nextstate<=2;
            end
            else
            begin
                add<=1;
                nextstate<=1;
            end
        end
        
        2:
            begin
                if(~st)
                begin
                    nextstate<=2;
                end
                else
                begin
                    load<=1;
                    nextstate<=1;
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
            reg_x[0] <= 16'b0010011011011101;
            reg_y[0] <= 16'd0;
            reg_z[0] <= 16'd0;
            i<=0;
        end
        else if(add)
        begin
            i<= i+1;
            if(reg_y[i] < arcsin_in)
            begin
                reg_x[i+1] <= reg_x[i] -(reg_y[i] >>> i);
                reg_y[i+1] <= reg_y[i] + (reg_x[i]>>>i);
                reg_z[i+1] <= reg_z[i] + TANROM[i];
            end
            else
            begin
                reg_x[i+1] <= reg_x[i] +(reg_y[i] >>> i);
                reg_y[i+1] <= reg_y[i] - (reg_x[i]>>>i);
                reg_z[i+1] <= reg_z[i] - TANROM[i];
            end
        end
    end
    
    assign result = (func == 2)? arccos :((func == 3)?arcsin:32'dz);
    assign k = (i == n)? 1:0;
    assign done = (state == 2)? 1:0;
    assign arcsin = (done == 1)? reg_z[n]: 16'dz;
    assign arccos = (done == 1)? ~{reg_z[n] - 16'b0110010010000111}+1:16'dz;
    
endmodule
