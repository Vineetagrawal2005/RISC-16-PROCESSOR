`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:39:25
// Design Name: 
// Module Name: RISC
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


module RISC(
    input clk,
    input reset,
    output [15:0] pc_out,
    output [15:0] rx_val,
    output [15:0] ry_val,
    output [15:0] alu_out,
    output [15:0] data_mem_out,
    output [15:0] reg_write_data,
    output [23:0] instr,
    output [3:0]  opcode,
    output [3:0]  addr_rz,
    output [15:0] src_imm,
    output        pc_en,
    output        jmp,
    output        reg_wr,
    output        mem_rd,
    output        mem_wr,
    output [1:0]  sel,
    output        carry,
    output        zero,
    output        parity
);

    // Internal wires for interconnection

    // 1. Program Counter
    PROGRAM_COUNTER PC_Unit (
        .clk(clk), .reset(reset), .pc_en(pc_en), 
        .jmp(jmp), .offset(src_imm), .pc_out(pc_out)
    );

    // 2. Instruction Memory
    INSTRUCTION_MEM IM_Unit (
        .addr(pc_out), .instruction(instr)
    );

    // 3. Instruction Register
    INSTRUCTION_REG IR_Unit (
        .clk(clk), .reset(reset), .instr_in(instr),
        .opcode(opcode), .addr_Rz(addr_rz), .src_imm(src_imm)
    );

    // 4. Control Unit
    CONTROL_UNIT CU_Unit (
        .clk(clk), .reset(reset), .opcode(opcode),
        .pc_en(pc_en), .jmp(jmp), .reg_wr(reg_wr), 
        .mem_rd(mem_rd), .mem_wr(mem_wr), .sel(sel)
    );

    // 5. Register File
    REGISTER_FILE RF_Unit (
        .clk(clk), .reset(reset), .reg_wr(reg_wr),
        .addr_Rx(src_imm[11:8]), .addr_Ry(src_imm[7:4]), .addr_Rz(addr_rz),
        .write_data(reg_write_data), .Rx_value(rx_val), .Ry_value(ry_val)
    );

    // 6. ALU
    ALU ALU_Unit (
        .Rx_value(rx_val), .Ry_value(ry_val), .opcode(opcode),
        .alu_out(alu_out), .carry(carry), .zero(zero), .parity(parity)
    );

    // 7. Data Memory
    DATA_MEM DM_Unit (
        .clk(clk), .mem_rd(mem_rd), .mem_wr(mem_wr),
        .addr(src_imm), .write_data(rx_val), .read_data(data_mem_out)
    );

    // 8. Write-Back Multiplexer
  assign reg_write_data = (sel == 2'b00) ? alu_out :      // For ADD, SUB, etc.
                        (sel == 2'b01) ? data_mem_out : // For LOAD
                        (sel == 2'b10) ? src_imm :      // For MVI (Move Immediate)
                        16'h0000;                       // Default/Safety

endmodule