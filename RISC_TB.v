`timescale 1ns / 1ps

module RISC_TB;

    // Inputs
    reg clk;
    reg reset;

    // Outputs from RISC
    wire [15:0] pc_out, rx_val, ry_val, alu_out, data_mem_out, reg_write_data;
    wire [23:0] instr;
    wire [3:0]  opcode, addr_rz;
    wire [15:0] src_imm;
    wire        pc_en, jmp, reg_wr, mem_rd, mem_wr;
    wire [1:0]  sel;
    wire        carry, zero, parity;

    // Instantiate DUT
    RISC uut (
        .clk(clk), .reset(reset), .pc_out(pc_out), .rx_val(rx_val),
        .ry_val(ry_val), .alu_out(alu_out), .data_mem_out(data_mem_out),
        .reg_write_data(reg_write_data), .instr(instr), .opcode(opcode),
        .addr_rz(addr_rz), .src_imm(src_imm), .pc_en(pc_en), .jmp(jmp),
        .reg_wr(reg_wr), .mem_rd(mem_rd), .mem_wr(mem_wr), .sel(sel),
        .carry(carry), .zero(zero), .parity(parity)
    );

    // Clock Generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset Sequence
    initial begin
        reset = 1;
        $display("Time: %0t | System Reset Initiated", $time);
        #20;
        reset = 0;
        $display("Time: %0t | System Reset Released", $time);
    end

    // Execution + Validation
    initial begin
        #25;
        // Monitor execution for 100 clock cycles to cover all instructions
        repeat (100) begin
            @(posedge clk);
            if (pc_en) begin
                $display("--------------------------------------------------");
                $display("Time: %0t | PC=%h | Opcode=%h | Instr=%h", $time, pc_out, opcode, instr);
                $display("RX=%h | RY=%h | ALU=%h", rx_val, ry_val, alu_out);
                $display("WriteData=%h | Sel=%b | RegWr=%b", reg_write_data, sel, reg_wr);
            end
        end

        // ==========================================
        // UPDATED FINAL CHECK (Matched to IM Code)
        // ==========================================
        #50;
        $display("\n================ FINAL SYSTEM CHECK ================");

        // 1. Check ADD Result: R1(10) + R2(5) = 15 (000F)
        if (uut.RF_Unit.registers[3] == 16'h000F)
            $display("[SUCCESS] ADD (R3): Expected 000F, Got %h", uut.RF_Unit.registers[3]);
        else
            $display("[FAIL]    ADD (R3): Expected 000F, Got %h", uut.RF_Unit.registers[3]);

        // 2. Check SHL Result: R1(10) << 1 = 20 (0014)
        if (uut.RF_Unit.registers[5] == 16'h0014)
            $display("[SUCCESS] SHL (R5): Expected 0014, Got %h", uut.RF_Unit.registers[5]);
        else
            $display("[FAIL]    SHL (R5): Expected 0014, Got %h", uut.RF_Unit.registers[5]);

        // 3. Check JUMP Verification: ADD R14 (PC=15) should be skipped
        // If PC skipped to 16, R14 should still be 0.
        if (uut.RF_Unit.registers[14] == 16'h0000)
            $display("[SUCCESS] JUMP Logic: Instruction at PC=15 was skipped.");
        else
            $display("[FAIL]    JUMP Logic: Instruction at PC=15 was executed (R14=%h).", uut.RF_Unit.registers[14]);

        $display("====================================================\n");

        #50;
        $stop;
    end
endmodule
