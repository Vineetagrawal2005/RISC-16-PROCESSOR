`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:05:07
// Design Name: 
// Module Name: DATA_MEM
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


module DATA_MEM(
    input clk,
    input mem_rd,               // Read enable signal [cite: 113]
    input mem_wr,               // Write enable signal [cite: 145]
    input [15:0] addr,          // Data memory address [cite: 66]
    input [15:0] write_data,    // Data to write (from register) [cite: 144]
    output reg [15:0] read_data // Data read from memory [cite: 114]
);

    reg [15:0] ram [65535:0];

    // Synchronous Write Logic
    always @(posedge clk) begin
        if (mem_wr)
            ram[addr] <= write_data; // STORE operation [cite: 145]
    end

    // Combinational Read Logic
    always @(*) begin
        if (mem_rd)
            read_data = ram[addr];   // LOAD operation [cite: 114]
        else
            read_data = 16'hzzzz;    // High impedance if not reading
    end

endmodule