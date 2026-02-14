`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:18:11
// Design Name: 
// Module Name: CONTROL_UNIT_TB
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


module CONTROL_UNIT_TB;
    reg clk, reset;
    reg [3:0] opcode;
    wire pc_en, jmp, reg_wr, mem_rd, mem_wr;
    wire [1:0] sel;
    wire [3:0] pstate, nstate;

    CONTROL_UNIT uut (
        .clk(clk), .reset(reset), .opcode(opcode),
        .pc_en(pc_en), .jmp(jmp), .reg_wr(reg_wr), 
        .mem_rd(mem_rd), .mem_wr(mem_wr), .sel(sel),
        .pstate(pstate), .nstate(nstate)
    );

    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0; reset = 1; opcode = 0;
        #20 reset = 0;

        // Test 1: MVI Instruction (Opcode C) [cite: 158]
        opcode = 4'hc;
        #50; // Observe S1 -> S2 -> S10 -> S11 cycle

        // Test 2: ALU ADD Instruction (Opcode 1) [cite: 157]
        opcode = 4'h1;
        #50; // Observe S1 -> S5 -> S6 -> S10 -> S11 cycle

        // Test 3: LOAD Instruction (Opcode D) [cite: 220]
        opcode = 4'hd;
        #50; // Observe S1 -> S3 -> S4 -> S10 -> S11 cycle

        $stop;
    end
endmodule