`timescale 1ns / 1ps

module RISC_TB;

    // ==========================
    // Inputs
    // ==========================
    reg clk;
    reg reset;

    // ==========================
    // Outputs from RISC
    // ==========================
    wire [15:0] pc_out;
    wire [15:0] rx_val;
    wire [15:0] ry_val;
    wire [15:0] alu_out;
    wire [15:0] data_mem_out;
    wire [15:0] reg_write_data;
    wire [23:0] instr;
    wire [3:0]  opcode;
    wire [3:0]  addr_rz;
    wire [15:0] src_imm;
    wire        pc_en;
    wire        jmp;
    wire        reg_wr;
    wire        mem_rd;
    wire        mem_wr;
    wire [1:0]  sel;
    wire        carry;
    wire        zero;
    wire        parity;

    // ==========================
    // Instantiate DUT
    // ==========================
    RISC uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .rx_val(rx_val),
        .ry_val(ry_val),
        .alu_out(alu_out),
        .data_mem_out(data_mem_out),
        .reg_write_data(reg_write_data),
        .instr(instr),
        .opcode(opcode),
        .addr_rz(addr_rz),
        .src_imm(src_imm),
        .pc_en(pc_en),
        .jmp(jmp),
        .reg_wr(reg_wr),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .sel(sel),
        .carry(carry),
        .zero(zero),
        .parity(parity)
    );

    // ==========================
    // Clock Generation (100 MHz)
    // ==========================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ==========================
    // Reset Sequence
    // ==========================
    initial begin
        reset = 1;
        $display("Time: %0t | System Reset Initiated", $time);
        #20;
        reset = 0;
        $display("Time: %0t | System Reset Released", $time);
    end

    // ==========================
    // Execution + Validation
    // ==========================
    initial begin
        #25;

        repeat (60) begin
            @(posedge clk);

            if (pc_en) begin
                $display("--------------------------------------------------");
                $display("Time: %0t | PC=%h | Opcode=%h", $time, pc_out, opcode);
                $display("RX=%h | RY=%h | ALU=%h", rx_val, ry_val, alu_out);
                $display("WriteData=%h | MemOut=%h", reg_write_data, data_mem_out);
                $display("RegWr=%b | MemRd=%b | MemWr=%b | Sel=%b",
                          reg_wr, mem_rd, mem_wr, sel);
                $display("Zero=%b | Carry=%b | Parity=%b",
                          zero, carry, parity);
            end
        end

        // ==========================
        // FINAL CHECK (Correct Way)
        // ==========================
        #20;
        $display("\n================ FINAL CHECK ================");

        // Check that last written data was 0008
        if (uut.RF_Unit.registers[3] == 16'h0008)
            $display("[SUCCESS] ADD operation correct.");
        else
            $display("[FAIL] Expected 0008, got %h",uut.RF_Unit.registers[3]);

        $display("=============================================\n");

        #50;
        $stop;
    end

endmodule
