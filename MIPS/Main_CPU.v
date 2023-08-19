`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2023 04:05:02 PM
// Design Name: 
// Module Name: Main_CPU
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

`define opcode instr[31:26]
`define rs instr[25:21]
`define rt instr[20:16]
`define rd instr[15:11]
`define shamt instr[10:6]
`define f_code instr[5:0]
module Main_CPU(input CLK, input RST, output [31:0] ADDR, output reg WE, output reg CS, inout [31:0] Data_Bus

    );
    parameter R = 2'b00, I = 2'b01, J = 2'b10;
    parameter INITIALIZE_STATE = 3'b000, FETCH_STATE = 3'b001, DECODEANDEXECUTE_STATE = 3'b010, MEMORYACCESS_STATE = 3'b011, LOAD_STATE = 3'b100;
    //J types:
    parameter j = 6'b000010;
    parameter jal = 6'b000011;
    
    //I types:
    parameter addi = 6'd8;
    parameter andi = 6'd12;
    parameter ori = 6'd13;
    parameter lw = 6'd35;
    parameter sw = 6'd43;
    parameter beq = 6'd4;
    parameter bne = 6'd5;
    parameter slti = 6'd10;
    parameter sltiu = 6'd11;
    
    //R type (use f-code rather than op-code:
    parameter add = 6'd32;
    parameter sub = 6'd34;
    parameter addu = 6'd33;
    parameter subu = 6'd35;
    parameter and1 = 6'd36;
    parameter or1 = 6'd37;
    parameter sll = 6'd0;
    parameter srl = 6'd2;
    parameter slt = 6'd42;
    parameter sltu = 6'd43;
    parameter jr = 6'd8;
    
    reg [31:0] pc;
    reg [31:0] npc;
    reg [31:0] instr;
    reg [31:0] alu_result;
    
    wire [31:0] retrieve;
    wire instrType;
    wire immext;
    wire [31:0] readdata1, readdata2;
    wire [31:0] alu_A, alu_B;
    
    
    
    //controller logic
    reg [2:0] state, nextstate;
    reg fetch;
    reg loadPC;
    reg reg_write;
    reg decode;
    
    //status signals from datapath
    reg done;
    
    
    assign instrType = (`opcode == 0)? R: ((`opcode == jal || `opcode == j)? J:I);
    assign immext = (instr[15] == 1)? {16'hFF, instr[15:0]}: {16'h00, instr[15:0]};
    assign alu_A = readdata1;
    assign alu_B = (instrType == R || `opcode == beq ||  `opcode == bne)? readdata2: immext;
    ROM rom(CLK,pc,retrieve);
    RegisterFile registerfile(CLK,RST, reg_write, alu_result,`rs, `rt, `rd, readdata1,readdata2);
    
    always@(RST, state, done)
    begin
        nextstate <=0;
        fetch <=0;
        loadPC <= 0;
        reg_write <=0;
        decode <= 0;
        npc <= pc;
        CS<=0;
        WE<=0;
        reg_write<=0;
        if(done)
            nextstate<=0;
        case(state)
            INITIALIZE_STATE:
            begin
                loadPC <=1;
                nextstate<=1;
            end
            FETCH_STATE:
            begin
                fetch<=1;
                nextstate <= DECODEANDEXECUTE_STATE;
            end
            
            DECODEANDEXECUTE_STATE:
            begin
                decode <=1;
                nextstate <=MEMORYACCESS_STATE;
            end
            
            MEMORYACCESS_STATE:
            begin
                if(instrType == R || `opcode == andi || `opcode == ori || `opcode == addi || `opcode == slt || `opcode == sltu || `opcode == slti || `opcode ==sltiu)
                begin
                    reg_write<=1;
                    nextstate<= INITIALIZE_STATE;
                end
                else if(`opcode == sw)
                begin
                    WE<=1;
                    CS <=1;
                    nextstate<= INITIALIZE_STATE;
                end
                else  if(`opcode == lw)
                begin
                    CS <= 1;
                    nextstate <= LOAD_STATE;
                end
            end
            
            LOAD_STATE:
            begin
                reg_write <=1;
                CS <=1;
                nextstate<=INITIALIZE_STATE;
            end
            
            
        endcase
    end
    
    always @(posedge CLK)
    begin
        if(RST)
        begin
            pc<=0;
            state<=0;
            done<=0;
        end
        else
        begin
            state<=nextstate;
        end
        
        if(loadPC)
        begin
            done<=0;
            if(`opcode == j)
                pc <= {npc[31:28], instr[26:0], 2'b00};
            else if(`opcode == jr)
                pc <= alu_A;
            else if(`opcode == beq || `opcode == bne && alu_result == 1)
                    pc <= npc + immext;
            else
                pc <= npc;
        end
        
        if(fetch)
        begin
            instr <= retrieve;
        end
        
        if(decode)
        begin
            if(instrType == R)
            begin
                case(`f_code)
                add: alu_result <= alu_A+alu_B;
                addu: alu_result <= alu_A + alu_B;
                subu: alu_result <= alu_A - alu_B;
                sub: alu_result <= alu_A - alu_B;
                and1: alu_result <= alu_A&alu_B;
                or1: alu_result <= alu_A| alu_B;
                sll: alu_result <= alu_B << `shamt;
                srl: alu_result <= alu_B >> `shamt;
                jr: done <=1;
                endcase
            end
       
            else if(instrType == I)
            begin
                case(`opcode)
                    addi: alu_result <= alu_A + alu_B;
                    ori: alu_result <= alu_A | alu_B;
                    lw: alu_result <= alu_A + alu_B;
                    sw: alu_result <= alu_A + alu_B;
                    
                    beq: 
                    begin
                        alu_result <= (alu_A == alu_B);
                        done<=1;
                    end
                    bne:
                    begin
                        alu_result<= (alu_A != alu_B);
                        done <=1;
                    end
                    
                endcase
            end
            
            else
            begin
                case(`opcode)
                    j: done <= 1;
                endcase
            end 
        end  
    end
endmodule
