`timescale 1ns / 1ps

module coordic_arctanandmagnitude#(parameter n = 16, START_STATE = 3'b000, ADD_STATE = 3'b001, MULT_STATE = 3'b010, DONE_STATE = 3'b011)(input clk, input st, input[n-1:0] x, input[n-1:0] y,output [n-1:0] arctan, output [31:0] magnitude

    );
    reg signed [n-1:0] x_reg[n:0];
    reg signed [n-1:0] y_reg [n:0];
    reg signed [n-1:0] z_reg[n:0];
    wire signed [n-1:0] d;
    integer i;
    wire k;
    wire Mdone;
    wire done;
    reg[2:0] state, nextstate;
    reg load, add, mult;
    wire [63:0] mult_temp;
    
    assign done = (state == DONE_STATE)? 1:0;
    assign k = (i == 16)? 1:0;
    assign d = (y_reg[i] < 0)? 1:-1;
    assign arctan = (done == 1)? z_reg[16]:16'dx;
    assign magnitude = (done==1)? mult_temp[63:32]: 32'bx;
    booth booth_alg (clk,mult,32'b00000000000000001001111000000000,{x_reg[16], 16'd0}, mult_temp, Mdone);
    
    wire [15:0] TANROM[15:0];
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
                nextstate<=START_STATE;
            end
        endcase
    end
    
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
    
    
    
endmodule
