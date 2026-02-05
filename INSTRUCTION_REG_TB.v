`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:34:39
// Design Name: 
// Module Name: INSTRUCTION_REG_TB
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


module INSTRUCTION_REG_TB;

    // Inputs
    reg clk;
    reg reset;
    reg [23:0] instr_in;

    // Outputs
    wire [3:0] opcode;
    wire [3:0] addr_Rz;
    wire [15:0] src_imm;

    // Instantiate the Unit Under Test (UUT)
    INSTRUCTION_REG uut (
        .clk(clk), 
        .reset(reset), 
        .instr_in(instr_in), 
        .opcode(opcode), 
        .addr_Rz(addr_Rz), 
        .src_imm(src_imm)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        instr_in = 0;

        // Wait 20ns for reset
        #20 reset = 0;

        // Test 1: MVI R1, 0005 (c10005) [cite: 160]
        // Opcode = c, Dest = 1, Imm = 0005
        @(posedge clk);
        instr_in = 24'hc10005; 
        
        // Test 2: LOAD R2, 0004 (d20004) [cite: 222]
        // Opcode = d, Dest = 2, Addr = 0004
        @(posedge clk);
        instr_in = 24'hd20004;
        
        // Test 3: ADD R3, R1, R2 (131200) [cite: 231]
        // Opcode = 1, Dest = 3, Source info = 1200
        @(posedge clk);
        instr_in = 24'h131200;

        #20;
        $stop;
    end
      
endmodule

