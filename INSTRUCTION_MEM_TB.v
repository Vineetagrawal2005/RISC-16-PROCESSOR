`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 16:54:01
// Design Name: 
// Module Name: INSTRUCTION_MEM_TB
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


module INSTRUCTION_MEM_TB;
    // Inputs
    reg [15:0] addr;

    // Outputs
    wire [23:0] instruction;

    // Instantiate Instruction Memory
    INSTRUCTION_MEM uut (
        .addr(addr), 
        .instruction(instruction)
    );

    initial begin
        // Initialize address
        addr = 16'h0000;

        // In a real project, you would load a .mem file using $readmemh.
        // For this test, manually pre-load a few locations:
        uut.mem[0] = 24'hc10005; // MVI R1, 0005 (Opcode 'c', Dest '1', Imm '0005')
        uut.mem[1] = 24'hd20004; // LOAD R2, 0004 (Opcode 'd', Dest '2', Addr '0004')
        uut.mem[2] = 24'h131200; // ADD R3, R1, R2 (Opcode '1', Dest '3', Sources '1, 2')

        #20;
        
        // Test 1: Fetch first instruction
        addr = 16'h0000;
        #10;
        $display("Address 0: Instruction = %h", instruction);

        // Test 2: Fetch second instruction
        addr = 16'h0001;
        #10;
        $display("Address 1: Instruction = %h", instruction);

        // Test 3: Fetch third instruction
        addr = 16'h0002;
        #10;
        $display("Address 2: Instruction = %h", instruction);

        #20;
        $stop;
    end
endmodule