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
    output reg [1:0] sel
);

    // Internal state registers (NOT in port list anymore)
    reg [3:0] pstate, nstate;

    // State parameters
    parameter S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3, S4 = 4'h4, 
              S5 = 4'h5, S6 = 4'h6, S7 = 4'h7, S8 = 4'h8, S9 = 4'h9, 
              S10 = 4'ha, S11 = 4'hb, S12 = 4'hc;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            pstate <= S0;
        else
            pstate <= nstate;
    end

    // Next state + Output logic
    always @(*) begin
        // Default values
        pc_en = 0; 
        jmp = 0; 
        reg_wr = 0; 
        mem_rd = 0; 
        mem_wr = 0; 
        sel = 2'b00;
        nstate = S0;

        case(pstate)

            S0: nstate = S1;

            S1: begin
                case(opcode)
                    4'hc: nstate = S2;    // MVI
                    4'hd: nstate = S3;    // LOAD
                    4'he: nstate = S7;    // STORE
                    4'hf: nstate = S12;   // JUMP
                    4'h0: nstate = S9;    // HLT
                    default: nstate = S5; // ALU
                endcase
            end

            S2: begin
                reg_wr = 1;
                sel = 2'b10;
                nstate = S10;
            end

            S3: begin
                mem_rd = 1;
                nstate = S4;
            end

            S4: begin
                reg_wr = 1;
                sel = 2'b01;
                nstate = S10;
            end

            S5: nstate = S6;

            S6: begin
                reg_wr = 1;
                sel = 2'b00;
                nstate = S10;
            end

            S7: nstate = S8;

            S8: begin
                mem_wr = 1;
                nstate = S10;
            end

            S9: nstate = S9;  // HLT

            S10: nstate = S11;

            S11: begin
                pc_en = 1;
                nstate = S0;
            end

            S12: begin
                jmp = 1;
                nstate = S0;
            end

            default: nstate = S0;
        endcase
    end

endmodule
