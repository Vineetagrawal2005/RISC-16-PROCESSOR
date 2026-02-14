`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 09:18:42
// Design Name: 
// Module Name: ALU
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
/////////////////////////////////////////////////////////////////////////////////


module ALU(
    input  [15:0] Rx_value,     // [cite: 39]
    input  [15:0] Ry_value,     // [cite: 39]
    input  [3:0]  opcode,       // [cite: 65]
    output [15:0] alu_out,      // [cite: 12]
    output        carry,        // [cite: 39]
    output        zero,         // [cite: 39]
    output        parity        // [cite: 39]
);

    // Internal wires for each functional unit's output
    wire [15:0] sum, diff, prod, logic_and, logic_or, logic_xor, logic_not;
    wire [15:0] shift_l, shift_r, increment, decrement;
    wire c_add, c_sub;

    // Structural "Units" (Functional logic)
    assign {c_add, sum}  = Rx_value + Ry_value;       // ADD unit [cite: 79]
    assign {c_sub, diff} = Rx_value - Ry_value;       // SUB unit [cite: 79]
    assign prod          = Rx_value * Ry_value;       // MUL unit [cite: 79]
    assign logic_and     = Rx_value & Ry_value;       // AND unit [cite: 79]
    assign logic_or      = Rx_value | Ry_value;       // OR unit [cite: 79]
    assign logic_xor     = Rx_value ^ Ry_value;       // XOR unit [cite: 79]
    assign logic_not     = ~Rx_value;                 // NOT unit [cite: 79]
    assign shift_l       = Rx_value << 1;             // SHL unit [cite: 79]
    assign shift_r       = Rx_value >> 1;             // SHR unit [cite: 79]
    assign increment     = Rx_value + 1'b1;           // INC unit [cite: 79]
    assign decrement     = Rx_value - 1'b1;           // DEC unit [cite: 79]

    // 16-to-1 Multiplexer to select the final result 
    assign alu_out = (opcode == 4'h1) ? sum :
                     (opcode == 4'h2) ? diff :
                     (opcode == 4'h3) ? prod :
                     (opcode == 4'h4) ? logic_and :
                     (opcode == 4'h5) ? logic_or :
                     (opcode == 4'h6) ? logic_xor :
                     (opcode == 4'h7) ? logic_not :
                     (opcode == 4'h8) ? shift_l :
                     (opcode == 4'h9) ? shift_r :
                     (opcode == 4'ha) ? increment :
                     (opcode == 4'hb) ? decrement : 16'h0000;

    // Flag Logic [cite: 13, 39]
    assign carry  = (opcode == 4'h1) ? c_add : (opcode == 4'h2) ? c_sub : 1'b0;
    assign zero   = (alu_out == 16'h0000); 
    assign parity = ~^alu_out; // High if even number of 1s [cite: 233]

endmodule
