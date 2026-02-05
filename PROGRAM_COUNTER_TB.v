`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:28:17
// Design Name: 
// Module Name: PROGRAM_COUNTER_TB
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


module PROGRAM_COUNTER_TB;
    reg clk, reset, pc_en, jmp;
    reg [15:0] offset;
    wire [15:0] pc_out;

    PROGRAM_COUNTER uut (.clk(clk), .reset(reset), .pc_en(pc_en), .jmp(jmp), .offset(offset), .pc_out(pc_out));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; pc_en = 0; jmp = 0; offset = 0;
        #20 reset = 0;
        
        // Test: Normal Increment
        #10 pc_en = 1; 
        #30 pc_en = 0; // PC should have reached 3
        
        // Test: JUMP
        #10 offset = 16'h0005; jmp = 1;
        #10 jmp = 0; // PC should jump by 5
        
        #20 $stop;
    end
endmodule
