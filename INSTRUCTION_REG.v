`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:33:27
// Design Name: 
// Module Name: INSTRUCTION_REG
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


module INSTRUCTION_REG(
    input clk,
    input reset,
    input [23:0] instr_in, // Fetched from Instruction Memory
    output reg [3:0] opcode,
    output reg [3:0] addr_Rz,
    output reg [15:0] src_imm
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            opcode <= 4'h0;
            addr_Rz <= 4'h0;
            src_imm <= 16'h0;
        end else begin
            opcode <= instr_in[23:20];    // Extract Opcode [cite: 65]
            addr_Rz <= instr_in[19:16];   // Extract Destination [cite: 65]
            src_imm <= instr_in[15:0];    // Extract Source/Address/Immediate [cite: 66]
        end
    end
endmodule
