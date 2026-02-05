
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 17:47:26
// Design Name: 
// Module Name: RISC_TB
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

module RISC_TB();
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    RISC uut (
        .clk(clk), 
        .reset(reset)
    );

    // Clock Generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    initial begin
        // --- 1. Initialization ---
        clk = 0;
        reset = 1;
        $display("Time: %0t | SYSTEM INITIALIZATION", $time);
        
        #20 reset = 0;
        $display("Time: %0t | RESET RELEASED - STARTING FETCH", $time);

        // --- 2. Live Monitoring Loop ---
        // Monitors the processor state machine and data flow
        repeat (60) begin
            @(posedge clk);
            
            // Check during the Write-Back / PC Increment Phase (S11)
            if (uut.CU_Unit.pstate == 4'hb) begin
                $display("--------------------------------------------------");
                $display("EXECUTION REPORT | PC: %h", uut.pc_out);
                $display("Instruction: %h | Opcode: %h", uut.instr, uut.opcode);
                $display("Control Signals | RegWr: %b | MemRd: %b | Sel: %b", 
                          uut.reg_wr, uut.mem_rd, uut.sel);
                $display("Register Dump   | R1: %h | R2: %h | R3: %h", 
                          uut.RF_Unit.registers[1], 
                          uut.RF_Unit.registers[2], 
                          uut.RF_Unit.registers[3]);
                $display("ALU Status      | Out: %h | Zero: %b | Parity: %b", 
                          uut.alu_out, uut.zero, uut.parity);
            end
        end

        // --- 3. Final Automated Validation ---
        #50;
        $display("\n================ FINAL VERIFICATION ================");
        
        // Check MVI (Move Immediate) success
        if (uut.RF_Unit.registers[1] == 16'h0005 && uut.RF_Unit.registers[2] == 16'h0003)
            $display("[SUCCESS] MVI Logic: Immediate values loaded to R1 & R2.");
        else
            $display("[ERROR] MVI Logic: Registers failed to capture immediate data.");

        // Check ALU ADD success
        if (uut.RF_Unit.registers[3] == 16'h0008)
            $display("[SUCCESS] ALU ADD Logic: R1 + R2 = R3 (5 + 3 = 8).");
        else
            $display("[ERROR] ALU ADD Logic: Summation result is incorrect.");

        // Check Program Counter Sequencing
        if (uut.pc_out >= 16'h0003)
            $display("[SUCCESS] PC Sequencing: Instructions fetched in order.");
        else
            $display("[ERROR] PC Sequencing: Program Counter stalled.");

        $display("====================================================\n");
        $stop;
    end
endmodule