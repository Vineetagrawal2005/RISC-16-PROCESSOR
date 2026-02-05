`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:06:15
// Design Name: 
// Module Name: DATA_MEM_TB
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


module DATA_MEM_TB;
    reg clk;
    reg mem_rd;
    reg mem_wr;
    reg [15:0] addr;
    reg [15:0] write_data;
    wire [15:0] read_data;

    DATA_MEM uut (
        .clk(clk), .mem_rd(mem_rd), .mem_wr(mem_wr), 
        .addr(addr), .write_data(write_data), .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; mem_rd = 0; mem_wr = 0; addr = 0; write_data = 0;

        // Test 1: STORE operation (Write 16'h1234 to address 0004H)
        @(posedge clk);
        addr = 16'h0004;
        write_data = 16'h1234;
        mem_wr = 1;

        @(posedge clk);
        mem_wr = 0;

        // Test 2: LOAD operation (Read from address 0004H)
        #10;
        mem_rd = 1;
        addr = 16'h0004;
        
        #10;
        if (read_data == 16'h1234)
            $display("Memory Test Passed!");
        else
            $display("Memory Test Failed! Read: %h", read_data);

        $stop;
    end
endmodule
