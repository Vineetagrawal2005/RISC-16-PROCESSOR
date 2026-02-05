`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 09:19:39
// Design Name: 
// Module Name: ALU_TB
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


module ALU_TB;

    // Inputs
    reg [15:0] Rx_value;
    reg [15:0] Ry_value;
    reg [3:0]  opcode;

    // Outputs
    wire [15:0] alu_out;
    wire carry;
    wire zero;
    wire parity;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .Rx_value(Rx_value), 
        .Ry_value(Ry_value), 
        .opcode(opcode), 
        .alu_out(alu_out), 
        .carry(carry), 
        .zero(zero), 
        .parity(parity)
    );

    initial begin
        // Initialize Inputs
        Rx_value = 0; Ry_value = 0; opcode = 0;
        #100; // Wait for global reset
        
        // Test 1: ADD R1(5) + R2(3) = 8 [cite: 231]
        Rx_value = 16'h0005; 
        Ry_value = 16'h0003; 
        opcode = 4'h1; // ADD opcode [cite: 79]
        #20;
        
        // Test 2: MUL R1(5) * R2(3) = 15 (000f) 
        Rx_value = 16'h0005; 
        Ry_value = 16'h0003; 
        opcode = 4'h3; // MUL opcode [cite: 79]
        #20; // At this stage, parity flag should go High because 15 (1111) has four 1s 

        // Test 3: SUB R1(5) - R2(3) = 2 [cite: 232]
        Rx_value = 16'h0005; 
        Ry_value = 16'h0003; 
        opcode = 4'h2; // SUB opcode [cite: 79]
        #20;

        // Test 4: ZERO FLAG CHECK
        Rx_value = 16'h0005; 
        Ry_value = 16'h0005; 
        opcode = 4'h2; // 5 - 5 = 0
        #20;

        $stop; // Stop simulation
    end
      
endmodule
