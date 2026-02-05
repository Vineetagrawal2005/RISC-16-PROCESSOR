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
        // Example machine code
        mem[0] = 24'hc10005; // MVI R1, 5
        mem[1] = 24'hc20003; // MVI R2, 3
        mem[2] = 24'h131200; // ADD R3, R1, R2
    end
    // Instruction fetching logic
    assign instruction = mem[addr]; // Fetch instruction at PC address [cite: 69]

endmodule
