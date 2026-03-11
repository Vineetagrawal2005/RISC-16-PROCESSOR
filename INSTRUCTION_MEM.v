`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 16:52:35
// Design Name: 
// Module Name: INSTRUCTION_MEM
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


module INSTRUCTION_MEM(
    input [15:0] addr,          // Address from Program Counter [cite: 42, 68]
    output [23:0] instruction   // 24-bit instruction output [cite: 10, 39]
);

    reg [23:0] mem [65535:0];   // Memory array (depth can be adjusted)
    initial begin
       // --- DATA INITIALIZATION ---
        mem[0]  = 24'hc1000A; // MVI R1, 10
        mem[1]  = 24'hc20005; // MVI R2, 5 
        
        // --- ARITHMETIC & LOGIC ---
        mem[2]  = 24'h130120; // ADD R3, R1, R2 (R3 = 15)
        mem[3]  = 24'h240120; // SUB R4, R1, R2 (R4 = 5) 
        mem[4]  = 24'h350120; // MUL R5, R1, R2 (R5 = 50)
        mem[5]  = 24'h460120; // AND R6, R1, R2 (R6 = 0) 
        mem[6]  = 24'h570120; // OR  R7, R1, R2 (R7 = 15)
        mem[7]  = 24'h680120; // XOR R8, R1, R2 (R8 = 15)
        
        // --- SHIFTS & UNARY ---
        mem[8]  = 24'h890100; // SHL R9, R1     (R9 = 20)
        mem[9]  = 24'h9a0100; // SHR R10, R1    (R10 = 5)
        mem[10] = 24'hab0100; // INC R11, R1    (R11 = 11)
        mem[11] = 24'hbc0200; // DEC R12, R2    (R12 = 4)
        
        // --- MEMORY & BRANCHING ---
        mem[12] = 24'he10064; // STORE R1, 100  (Store 10 at RAM[100])
        mem[13] = 24'hdD0064; // LOAD R13, 100  (Load RAM[100] into R13)
        mem[14] = 24'hf00002; // JUMP +2        (Skip next instruction)
        mem[15] = 24'h1e0120; // ADD R14, R1, R2 (SKIPPED)
        
        // --- TERMINATION ---
        mem[16] = 24'h000000; // HLT (Halt State S9)
    end
    // Instruction fetching logic
    assign instruction = mem[addr]; // Fetch instruction at PC address [cite: 69]

endmodule
