`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:26:51
// Design Name: 
// Module Name: PROGRAM_COUNTER
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


module PROGRAM_COUNTER(
    input clk,
    input reset,
    input pc_en,        // From Control Unit
    input jmp,          // From Control Unit
    input [15:0] offset, // Immediate value from instruction
    output reg [15:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 16'h0000; // Reset to the first instruction address
        else if (jmp)
            pc_out <= pc_out + offset; // Update PC for JUMP instructions
        else if (pc_en)
            pc_out <= pc_out + 1'b1;   // Increment PC for next instruction
    end
endmodule
