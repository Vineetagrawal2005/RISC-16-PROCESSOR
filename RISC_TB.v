
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
    // Inputs
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    RISC uut (
        .clk(clk), 
        .reset(reset)
    );

    // Clock Generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        // --- 1. System Initialization ---
        clk = 0;
        reset = 1;
        $display("Time: %0t | System Reset Initiated", $time);
        
        #20 reset = 0;
        $display("Time: %0t | System Reset Released - Fetching Instructions...", $time);

        // --- 2. Monitoring Routine ---
        // This loop checks the state of the processor every few cycles
        // Specifically looks for S11 (PC Increment State) to report results
        repeat (60) begin
            @(posedge clk);
            if (uut.CU_Unit.pstate == 4'hb) begin // State S11: PC Increment
                $display("--------------------------------------------------");
                $display("Time: %0t | EXECUTION REPORT | PC: %h", $time, uut.pc_out);
                $display("Instruction: %h | Opcode: %h", uut.instr, uut.opcode);
                $display("Control Signals | RegWr: %b | Sel: %b", uut.reg_wr, uut.sel);
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
        
        // Check if R3 contains the sum (5+3=8) from your INSTRUCTION_MEM
        if (uut.RF_Unit.registers[3] == 16'h0008) begin
            $display("[SUCCESS] ALU ADD Logic: R3 contains 0008.");
            $display("[SUCCESS] Full System Integration Perfect!");
        end else begin
            $display("[ERROR] Final Result Incorrect. Expected 0008, got %h", uut.RF_Unit.registers[3]);
            $display("Check Write-Back Mux and Control Unit 'sel' signal.");
        end
        $display("====================================================\n");
        
        $stop;
    end
endmodule