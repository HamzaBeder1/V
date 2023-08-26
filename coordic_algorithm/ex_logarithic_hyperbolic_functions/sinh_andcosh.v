`timescale 1ns / 1ps

module sinh_andcosh #(parameter n = 16)(
    input clk, input st,input compute, input [15:0] z_0, output [15:0] sinh, output[15:0] cosh);
    wire k;
    reg signed [15:0] reg_z [n:1];
    reg signed [15:0] reg_x[n:1];
    reg signed [15:0] reg_y [n:1];
    integer i;
    reg sign;
    wire [15:0] TANHROM [n-1:1];
    wire LED_reset;

    reg [1:0] state, nextstate;
    reg load, add;
    assign k = (i ==16)? 1:0;
    assign sinh = (state == 2'b10)? reg_y[n]: 16'bz;
    assign cosh = (state == 2'b10)? reg_x[n]: 16'bz;
    assign LED_reset = (state == 2'b00)? 1:0;
    assign TANHROM[1] = 16'b0010001100100111;
    assign TANHROM[2] = 16'b0001000001011000;
    assign TANHROM[3] = 16'b0000100000001010;
    assign TANHROM[4] = 16'b0000010000000001;
    assign TANHROM[5] = 16'b0000001000000000;
    assign TANHROM[6] = 16'b0000000100000000;
    assign TANHROM[7] = 16'b0000000010000000;
    assign TANHROM[8] = 16'b0000000001000000;
    assign TANHROM[9] = 16'b0000000000100000;
    assign TANHROM[10] =16'b0000000000010000;
    assign TANHROM[11] =16'b0000000000001000;
    assign TANHROM[12] =16'b0000000000000100;
    assign TANHROM[13] =16'b0000000000000010;
    assign TANHROM[14] =16'b0000000000000001;
    assign TANHROM[15] =16'b0000000000000000;
    
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
                nextstate<=0;
        endcase
    end

    always@(posedge clk)
    begin
        state<=nextstate;
        if(load)
        begin
            i<= 1;
            reg_x[1] <= 16'b0101000000000000;
            reg_y[1] <= 16'd0;
            reg_z[1] <= z_0;
        end
        if(add)
        begin
            i<= i+1;
            if(reg_z[i] < 0)
            begin
                reg_x[i+1] <= reg_x[i] -(reg_y[i] >>> i);
                reg_y[i+1] <= reg_y[i] - (reg_x[i]>>>i);
                reg_z[i+1] <= reg_z[i] + TANHROM[i];
            end
            else
            begin
                reg_x[i+1] <= reg_x[i] + (reg_y[i] >>> i);
                reg_y[i+1] <= reg_y[i] + (reg_x[i]>>>i);
                reg_z[i+1] <= reg_z[i] - TANHROM[i];
            end
        end
    end
endmodule
