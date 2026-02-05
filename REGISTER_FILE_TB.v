`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 16:46:55
// Design Name: 
// Module Name: REGISTER_FILE_TB
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


module REGISTER_FILE_TB;
    // Inputs
    reg clk;
    reg reset;
    reg reg_wr;
    reg [3:0] addr_Rx;
    reg [3:0] addr_Ry;
    reg [3:0] addr_Rz;
    reg [15:0] write_data;

    // Outputs
    wire [15:0] Rx_value;
    wire [15:0] Ry_value;

    // Instantiate Register File
    REGISTER_FILE uut (
        .clk(clk), .reset(reset), .reg_wr(reg_wr), 
        .addr_Rx(addr_Rx), .addr_Ry(addr_Ry), .addr_Rz(addr_Rz), 
        .write_data(write_data), .Rx_value(Rx_value), .Ry_value(Ry_value)
    );

    // Clock Generation (100MHz / 10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0; reset = 1; reg_wr = 0;
        addr_Rx = 0; addr_Ry = 0; addr_Rz = 0; write_data = 0;
        
        #20 reset = 0; // Release reset

        // Test 1: Write 16'hAAAA to Register R1 (Destination)
        @(posedge clk);
        addr_Rz = 4'h1; 
        write_data = 16'hAAAA; 
        reg_wr = 1; 
        
        // Test 2: Write 16'h5555 to Register R2 (Destination)
        @(posedge clk);
        addr_Rz = 4'h2; 
        write_data = 16'h5555;
        
        @(posedge clk);
        reg_wr = 0; // Stop writing

        // Test 3: Read back R1 and R2 simultaneously
        addr_Rx = 4'h1; // Should output AAAA
        addr_Ry = 4'h2; // Should output 5555
        
        #20;
        $display("R1 Value: %h, R2 Value: %h", Rx_value, Ry_value);
        $stop;
    end
endmodule
