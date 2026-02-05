`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:16:46
// Design Name: 
// Module Name: CONTROL_UNIT
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


module CONTROL_UNIT(
    input clk,
    input reset,
    input [3:0] opcode,
    output reg pc_en,
    output reg jmp,
    output reg reg_wr,
    output reg mem_rd,
    output reg mem_wr,
    output reg [1:0] sel,      // Updated to drive the write-back mux
    output reg [3:0] pstate, 
    output reg [3:0] nstate  
);

    // State parameters matching Fig. 2
    parameter S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3, S4 = 4'h4, 
              S5 = 4'h5, S6 = 4'h6, S7 = 4'h7, S8 = 4'h8, S9 = 4'h9, 
              S10 = 4'ha, S11 = 4'hb, S12 = 4'hc;

    always @(posedge clk or posedge reset) begin
        if (reset) pstate <= S0;
        else pstate <= nstate;
    end

    always @(*) begin
        // Initialize all signals to low/default
        pc_en = 0; jmp = 0; reg_wr = 0; mem_rd = 0; mem_wr = 0; 
        sel = 2'b00; // Default to ALU result path
        nstate = S0;

        case(pstate)
            S0: begin // Idle State
                nstate = S1;
            end

            S1: begin // Decode State
                case(opcode)
                    4'hc: nstate = S2;    // MVI
                    4'hd: nstate = S3;    // LOAD
                    4'he: nstate = S7;    // STORE
                    4'hf: nstate = S12;   // JUMP
                    4'h0: nstate = S9;    // HLT
                    default: nstate = S5; // ALU Instructions
                endcase
            end

            // MVI Path: Write Immediate value to Register
            S2: begin 
                reg_wr = 1; //
                sel = 2'b10; // Select Immediate value path
                nstate = S10; 
            end

            // LOAD Path: Write Memory data to Register
            S3: begin 
                mem_rd = 1; //
                nstate = S4; 
            end
            S4: begin 
                reg_wr = 1; //
                sel = 2'b01; // Select Memory data path
                nstate = S10; 
            end

            // ALU Path: Write ALU Result to Register
            S5: begin 
                reg_wr = 0; // Reading registers
                nstate = S6; 
            end
            S6: begin 
                reg_wr = 1; // Writing back result
                sel = 2'b00; // Select ALU result path
                nstate = S10; 
            end

            // STORE Path: Write Register data to Memory
            S7: begin 
                reg_wr = 0; // Reading register
                nstate = S8; 
            end
            S8: begin 
                mem_wr = 1; // Writing to memory
                nstate = S10; 
            end

            // HLT State
            S9: nstate = S9; // Stay in HLT until reset

            // Delay and PC Increment Path
            S10: nstate = S11; // Delay for synchronization
            S11: begin 
                pc_en = 1; // Enable next instruction
                nstate = S0; 
            end

            // JUMP Path
            S12: begin 
                jmp = 1; // Enable Target Address update
                nstate = S0; 
            end

            default: nstate = S0;
        endcase
    end
endmodule