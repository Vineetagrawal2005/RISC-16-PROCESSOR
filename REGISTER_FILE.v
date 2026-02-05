`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 16:43:35
// Design Name: 
// Module Name: REGISTER_FILE
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


module REGISTER_FILE(
    input clk,
    input reset,
    input reg_wr,              // Control signal to enable writing [cite: 75]
    input [3:0] addr_Rx,       // Address for Source Register Rx [cite: 66]
    input [3:0] addr_Ry,       // Address for Source Register Ry [cite: 66]
    input [3:0] addr_Rz,       // Address for Destination Register Rz [cite: 65]
    input [15:0] write_data,   // Data to be written into Rz [cite: 111]
    output [15:0] Rx_value,    // Output value of Rx [cite: 39]
    output [15:0] Ry_value     // Output value of Ry [cite: 39]
);

    reg [15:0] registers [15:0]; // Array of 16 registers, each 16-bit wide 
    integer i;

    // Sequential Write Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 16'h0000; // Initialize all registers to zero
            end
        end else if (reg_wr) begin
            registers[addr_Rz] <= write_data; // Write result to Rz [cite: 75, 78]
        end
    end

    // Combinational Read Logic (Multiplexers)
    assign Rx_value = registers[addr_Rx]; // Read operand Rx [cite: 60]
    assign Ry_value = registers[addr_Ry]; // Read operand Ry [cite: 60]

endmodule
