`timescale 1ns / 1ps

module Top#(parameter debounce_count = 50000000, START_STATE = 3'b000,DEBOUNCE_STATE = 3'b001, SELECT_STATE = 3'b010, ENTER1_STATE = 3'b011, ENTER2_STATE = 3'b100, READY_STATE = 3'b101, DONE_STATE = 3'b110)(input clk, input st, input[15:0] sw_in, output [3:0] anodeOutput, output [7:0] cathodeOutput

    );
    reg [2:0] state, nextstate;
    reg idle, debounce, up, loadfunc, loadop1, loadop2, compute, rst;
    reg [2:0] k;
    reg [3:0] func;
    reg signed [15:0] op1, op2;
    reg debounce_done;
    wire[31:0] result;
    wire[15:0] sinh;
    wire [15:0] cosh;
    wire [15:0] atanh;
    integer debounce_counter;
    
    arctan_andmagnitude atan_mag(clk, compute,op1, op2,func, result);
    arcsin_andarccos asin_andacos(clk, compute, op1, func, result);
    sinh_andcosh sh_andch(clk, compute, op1, func, sinh, cosh, result);
    arctan_h ath(clk, compute, op1, op2, func, atanh, result);
    ex e_x(clk, compute, op1, func, result);
    ln_x lnx(clk, compute, op1, func, result);
    sevensegment s(clk, idle, state, result, anodeOutput, cathodeOutput);
    always@(state,st, k, debounce_done, func)
    begin
        nextstate<=0;
        idle<=0;
        debounce<=0;
        up<=0;
        loadfunc<=0;
        loadop1<=0;
        loadop2<=0;
        compute<=0;
        rst <=0;
        case(state)
            START_STATE:
            begin
                if(~st)
                begin
                    idle<=1;
                    nextstate<=START_STATE;
                end
                else
                begin
                    nextstate<=DEBOUNCE_STATE;
                end
            end
            
            DEBOUNCE_STATE:
            begin
                if(~debounce_done)
                begin
                    debounce<=1;
                    nextstate<=DEBOUNCE_STATE;
                end
                else
                begin
                    if(k == 0)
                    begin
                        nextstate<= SELECT_STATE;   
                    end
                    else if (k== 1)
                    begin
                        nextstate<= ENTER1_STATE;
                    end
                    else if(k == 2)
                    begin
                        if(func  == 0 || func == 1 || func == 7)
                            nextstate<= ENTER2_STATE;
                        else
                        begin
                            up<=1;
                            nextstate<= READY_STATE;
                        end
                    end
                    else if(k == 3)
                    begin
                        nextstate<= READY_STATE;
                    end
                    else if(k == 4)
                    begin
                        nextstate<= DONE_STATE;
                    end
                end
            end
            
            SELECT_STATE:
            begin
                if(~st)
                begin
                    nextstate<=SELECT_STATE;
                end
                else
                begin
                    loadfunc<=1;
                    up<=1;
                    nextstate<=DEBOUNCE_STATE;
                end
            end
            
            ENTER1_STATE:
            begin
                if(~st)
                begin
                    nextstate<=ENTER1_STATE;
                end
                else
                begin
                    loadop1<=1;
                    up<=1;
                    nextstate<=DEBOUNCE_STATE;
                end
            end
            
            ENTER2_STATE:
            begin
            nextstate<=4;
                if(~st)
                begin
                    nextstate=ENTER2_STATE;
                end
                else
                begin
                    loadop2<=1;
                    up<=1;
                    nextstate<=DEBOUNCE_STATE;
                end
            end
            
            READY_STATE:
            begin
                if(~st)
                begin
                    nextstate<=READY_STATE;
                end
                else
                begin
                    compute<=1;
                    up<=1;
                    nextstate=DEBOUNCE_STATE;
                end
            end
            
            DONE_STATE:
            begin
                if(~st)
                begin
                    nextstate<=DONE_STATE;
                end
                else
                begin
                    rst<=1;
                    nextstate<=DEBOUNCE_STATE;
                end
            end
        endcase
    end
    
    always@(posedge clk)
    begin
        state<=nextstate;
        if(idle)
        begin
            debounce_counter<=0;
            debounce_done<=0;
            k<=0;
        end
        
        if(debounce)
        begin
            if(debounce_counter == debounce_count)
            begin
                debounce_counter<=0;
                debounce_done<=1;
            end
            else
            begin
                debounce_counter<=debounce_counter+1;
                debounce_done<=0;
            end
        end
        else
            debounce_done <=0;
        
        if(loadfunc)
        begin
            func <= sw_in[3:0];
        end
        
        if(loadop1)
        begin
            op1<=sw_in;
        end
        
        if(loadop2)
        begin
            op2<=sw_in;
        end
        
        if(up)
        begin
            k<= k+1;
        end
        
        if(rst)
        begin
            k<=0;
        end
    end
endmodule
