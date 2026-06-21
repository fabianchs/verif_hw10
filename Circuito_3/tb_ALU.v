/*
Autor: Fabian Chacon 201813154
Tecnologico de Costa Rica
Modulo: ALU

Testbench SystemVerilog autochecking para la ALU del 8088.
Incluye transacciones, Tester, Scoreboard y Cover Groups.
*/

`timescale 1ns / 1ps

`include "Circuito 3/ALU.v"

typedef struct packed {
    bit [15:0] r1;
    bit [15:0] r2;
    bit [15:0] flags;
    bit [5:0]  fl;
    bit        finp;
    bit        if_flag;
} alu_sample_t;

interface alu_if;
    logic        CLK;
    logic        RST;
    logic [15:0] A;
    logic        V;
    logic [5:0]  op;
    logic        WA;
    logic        WB;
    logic        WD;
    logic        ENADi;
    logic [1:0]  WR;
    logic [2:0]  opFL;
    logic [15:0] R1;
    logic [15:0] R2;
    logic [15:0] FLAGS;
    logic [5:0]  FL;
    logic        FINP;
    logic        IF;

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    task automatic idle_controls();
        WA    = 1'b0;
        WB    = 1'b0;
        WD    = 1'b0;
        WR    = 2'b00;
        ENADi = 1'b0;
    endtask

    task automatic set_idle();
        A    = 16'h0000;
        V    = 1'b0;
        op   = 6'b000000;
        opFL = 3'b000;
        idle_controls();
    endtask

    function automatic alu_sample_t sample();
        sample.r1      = R1;
        sample.r2      = R2;
        sample.flags   = FLAGS;
        sample.fl      = FL;
        sample.finp    = FINP;
        sample.if_flag = IF;
    endfunction

    modport dut (
        input  CLK, RST, A, V, op, WA, WB, WD, WR, ENADi, opFL,
        output R1, R2, FLAGS, FL, FINP, IF
    );
endinterface

module tb_ALU;
    localparam int NUM_RANDOM_TESTS = 160;

    alu_if bus();

    ALU dut (
        .CLK(bus.CLK),
        .RST(bus.RST),
        .A(bus.A),
        .V(bus.V),
        .op(bus.op),
        .WA(bus.WA),
        .WB(bus.WB),
        .WD(bus.WD),
        .ENADi(bus.ENADi),
        .WR(bus.WR),
        .opFL(bus.opFL),
        .R1(bus.R1),
        .R2(bus.R2),
        .FLAGS(bus.FLAGS),
        .FL(bus.FL),
        .FINP(bus.FINP),
        .IF(bus.IF)
    );

    class alu_tx;
        rand bit [15:0] opa;
        rand bit [15:0] opb;
        rand bit [15:0] opd;
        rand bit [5:0]  opcode;
        rand bit        carry_in;
        rand bit [1:0]  wr_flags;
        rand bit [2:0]  op_flags;

        constraint supported_ops {
            opcode inside {
                6'b000000, 6'b000001, 6'b000010, 6'b000011,
                6'b000100, 6'b000101, 6'b000110, 6'b000111,
                6'b001000, 6'b001001, 6'b001100, 6'b001101,
                6'b001110, 6'b001111
            };
        }

        constraint useful_counts {
            if (opcode[4:3] == 2'b01) opb[15:4] == 12'h000;
            if (opcode[4:3] == 2'b01) opb[3:0] inside {[1:4]};
        }

        constraint flag_activity {
            wr_flags dist {2'b00 := 5, 2'b01 := 4, 2'b10 := 1};
            op_flags dist {3'b000 := 6, [3'b001:3'b111] := 1};
        }
    endclass

    class scoreboard;
        bit [15:0] reg_a;
        bit [15:0] reg_b;
        bit [15:0] reg_d;
        bit [15:0] flags_model;
        int checks;
        int errors;

        function new();
            reset();
        endfunction

        function void reset();
            reg_a = 16'h0000;
            reg_b = 16'h0000;
            reg_d = 16'h0000;
            flags_model = 16'h0000;
        endfunction

        function bit parity_even(input bit [15:0] value);
            parity_even = ~^value[7:0];
        endfunction

        function bit [15:0] rol16(input bit [15:0] value, input int count);
            int c;
            c = count % 16;
            rol16 = (value << c) | (value >> (16 - c));
        endfunction

        function bit [15:0] ror16(input bit [15:0] value, input int count);
            int c;
            c = count % 16;
            ror16 = (value >> c) | (value << (16 - c));
        endfunction

        function bit [16:0] addsub17(input bit [15:0] a, input bit [15:0] b,
                                     input bit sub, input bit carry);
            if (sub) begin
                addsub17 = {1'b0, a} + {1'b0, ~b} + 17'd1 + {16'h0000, carry};
            end else begin
                addsub17 = {1'b0, a} + {1'b0, b} + {16'h0000, carry};
            end
        endfunction

        function bit [15:0] expected_result(input alu_tx tx);
            bit [16:0] wide;
            int count;

            count = tx.opb[3:0];
            unique case (tx.opcode)
                6'b000000: begin wide = addsub17(tx.opa, tx.opb, 1'b0, 1'b0); expected_result = wide[15:0]; end
                6'b000001: expected_result = tx.opa | tx.opb;
                6'b000010: begin wide = addsub17(tx.opa, tx.opb, 1'b0, flags_model[0]); expected_result = wide[15:0]; end
                6'b000011: begin wide = addsub17(tx.opa, tx.opb, 1'b1, flags_model[0]); expected_result = wide[15:0]; end
                6'b000100: expected_result = tx.opa & tx.opb;
                6'b000101: begin wide = addsub17(tx.opa, tx.opb, 1'b1, 1'b0); expected_result = wide[15:0]; end
                6'b000110: expected_result = tx.opa ^ tx.opb;
                6'b000111: begin wide = addsub17(tx.opa, tx.opb, 1'b1, 1'b0); expected_result = wide[15:0]; end
                6'b001000: expected_result = rol16(tx.opa, count);
                6'b001001: expected_result = ror16(tx.opa, count);
                6'b001100: expected_result = tx.opa << count;
                6'b001101: expected_result = tx.opa >> count;
                6'b001110: expected_result = tx.opa << count;
                6'b001111: expected_result = $signed(tx.opa) >>> count;
                default:   expected_result = 16'h0000;
            endcase
        endfunction

        function bit expected_cf(input alu_tx tx, input bit [15:0] result);
            bit [16:0] wide;
            int count;

            count = tx.opb[3:0];
            unique case (tx.opcode)
                6'b000000: begin wide = addsub17(tx.opa, tx.opb, 1'b0, 1'b0); expected_cf = wide[16]; end
                6'b000010: begin wide = addsub17(tx.opa, tx.opb, 1'b0, flags_model[0]); expected_cf = wide[16]; end
                6'b000101,
                6'b000111: expected_cf = (tx.opa < tx.opb);
                6'b001100,
                6'b001110: expected_cf = (count == 0) ? flags_model[0] : tx.opa[16 - count];
                6'b001101,
                6'b001111: expected_cf = (count == 0) ? flags_model[0] : tx.opa[count - 1];
                6'b001000: expected_cf = result[0];
                6'b001001: expected_cf = result[15];
                default:   expected_cf = 1'b0;
            endcase
        endfunction

        function void update_flags(input alu_tx tx, input bit [15:0] result);
            bit cf;
            bit of_bit;

            cf = expected_cf(tx, result);
            of_bit = tx.opa[15] ^ result[15];

            if (tx.wr_flags[0] || tx.wr_flags[1]) begin
                if (tx.wr_flags[1]) begin
                    flags_model[0] = tx.opa[0];
                    flags_model[2] = tx.opa[2];
                    flags_model[4] = tx.opa[4];
                    flags_model[6] = tx.opa[6];
                    flags_model[7] = tx.opa[7];
                    flags_model[11] = tx.opa[11];
                end else begin
                    flags_model[0] = cf;
                    flags_model[2] = parity_even(result);
                    flags_model[4] = 1'b0;
                    flags_model[6] = (result == 16'h0000);
                    flags_model[7] = result[15];
                    flags_model[11] = of_bit;
                end
            end

            unique case (tx.op_flags)
                3'b001: flags_model[0] = 1'b0;
                3'b010: flags_model[10] = 1'b0;
                3'b011: flags_model[9] = 1'b0;
                3'b100: flags_model[0] = 1'b1;
                3'b101: flags_model[10] = 1'b1;
                3'b110: flags_model[9] = 1'b1;
                3'b111: flags_model[0] = ~flags_model[0];
                default: ;
            endcase

            flags_model[1] = 1'b0;
            flags_model[3] = 1'b0;
            flags_model[5] = 1'b0;
            flags_model[8] = 1'b0;
            flags_model[12] = 1'b0;
            flags_model[13] = 1'b0;
            flags_model[14] = 1'b0;
            flags_model[15] = 1'b0;
        endfunction

        function void check(input alu_tx tx, input alu_sample_t actual);
            bit [15:0] exp_r1;

            exp_r1 = expected_result(tx);
            checks++;

            if (actual.r1 !== exp_r1) begin
                errors++;
                $error("[SCOREBOARD][R1] op=%06b A=%04h B=%04h esperado=%04h obtenido=%04h",
                       tx.opcode, tx.opa, tx.opb, exp_r1, actual.r1);
            end

            update_flags(tx, exp_r1);

            if (actual.flags[0] !== flags_model[0] ||
                actual.flags[6] !== flags_model[6] ||
                actual.flags[7] !== flags_model[7]) begin
                errors++;
                $error("[SCOREBOARD][FLAGS] esperado CF/ZF/SF=%0b/%0b/%0b obtenido=%0b/%0b/%0b",
                       flags_model[0], flags_model[6], flags_model[7],
                       actual.flags[0], actual.flags[6], actual.flags[7]);
            end
        endfunction
    endclass

    class tester;
        mailbox #(alu_tx) outbox;

        function new(input mailbox #(alu_tx) outbox);
            this.outbox = outbox;
        endfunction

        task run(input int count);
            alu_tx tx;

            repeat (count) begin
                tx = new();
                assert(tx.randomize())
                    else $fatal(1, "No se pudo randomizar alu_tx");
                outbox.put(tx);
            end
        endtask
    endclass

    covergroup cg_alu @(posedge bus.CLK);
        option.per_instance = 1;
        cp_op: coverpoint bus.op {
            bins alu1[] = {
                6'b000000, 6'b000001, 6'b000010, 6'b000011,
                6'b000100, 6'b000101, 6'b000110, 6'b000111
            };
            bins alu2[] = {
                6'b001000, 6'b001001, 6'b001100, 6'b001101,
                6'b001110, 6'b001111
            };
        }
        cp_wr: coverpoint bus.WR {
            bins none = {2'b00};
            bins basic = {2'b01};
            bins full = {2'b10};
            bins load_basic = {2'b11};
        }
        cp_opa: coverpoint bus.A {
            bins zero = {16'h0000};
            bins ones = {16'hFFFF};
            bins sign_edge = {16'h7FFF, 16'h8000};
            bins others = default;
        }
        cp_flags: coverpoint {bus.FLAGS[0], bus.FLAGS[6], bus.FLAGS[7]} {
            bins flag_states[] = {[3'b000:3'b111]};
        }
        x_op_flags: cross cp_op, cp_wr;
    endgroup

    mailbox #(alu_tx) tx_mbx;
    scoreboard sb;
    tester tst;
    cg_alu cov;

    task automatic idle_controls();
        bus.idle_controls();
    endtask

    task automatic load_reg(input bit wa, input bit wb, input bit wd, input bit [15:0] value);
        @(posedge bus.CLK);
        bus.A  = value;
        bus.WA = wa;
        bus.WB = wb;
        bus.WD = wd;
        @(negedge bus.CLK);
        #1;
        idle_controls();
    endtask

    task automatic drive_tx(input alu_tx tx);
        load_reg(1'b1, 1'b0, 1'b0, tx.opa);
        load_reg(1'b0, 1'b1, 1'b0, tx.opb);
        load_reg(1'b0, 1'b0, 1'b1, tx.opd);

        @(posedge bus.CLK);
        bus.A     = tx.opa;
        bus.V     = tx.carry_in;
        bus.op    = tx.opcode;
        bus.WR    = tx.wr_flags;
        bus.opFL  = tx.op_flags;
        bus.ENADi = 1'b0;
        @(negedge bus.CLK);
        #2;
        sb.check(tx, bus.sample());
        idle_controls();
    endtask

    task automatic apply_reset();
        bus.RST = 1'b1;
        bus.set_idle();
        repeat (3) @(posedge bus.CLK);
        bus.RST = 1'b0;
        sb.reset();
        @(posedge bus.CLK);
    endtask

    task automatic directed_tests();
        alu_tx tx;
        bit [5:0] ops [14] = '{
            6'b000000, 6'b000001, 6'b000010, 6'b000011,
            6'b000100, 6'b000101, 6'b000110, 6'b000111,
            6'b001000, 6'b001001, 6'b001100, 6'b001101,
            6'b001110, 6'b001111
        };

        foreach (ops[i]) begin
            tx = new();
            tx.opa      = (i < 8) ? 16'h00F0 + i : 16'h8001 >> (i % 4);
            tx.opb      = (i < 8) ? 16'h0003 + i : 16'h0001 + (i % 3);
            tx.opd      = 16'h0000;
            tx.opcode   = ops[i];
            tx.carry_in = 1'b0;
            tx.wr_flags = 2'b01;
            tx.op_flags = 3'b000;
            drive_tx(tx);
        end

        tx = new();
        tx.opa      = 16'hFFFF;
        tx.opb      = 16'h0001;
        tx.opd      = 16'h0000;
        tx.opcode   = 6'b000000;
        tx.carry_in = 1'b0;
        tx.wr_flags = 2'b01;
        tx.op_flags = 3'b000;
        drive_tx(tx);
    endtask

    initial begin
        alu_tx tx;

        $dumpfile("tb_ALU.vcd");
        $dumpvars(0, tb_ALU);

        tx_mbx = new();
        sb = new();
        tst = new(tx_mbx);
        cov = new();

        apply_reset();
        directed_tests();

        fork
            tst.run(NUM_RANDOM_TESTS);
            begin
                repeat (NUM_RANDOM_TESTS) begin
                    tx_mbx.get(tx);
                    drive_tx(tx);
                end
            end
        join

        $display("Checks ALU: %0d, errores: %0d, cobertura: %.2f%%",
                 sb.checks, sb.errors, cov.get_coverage());

        if (sb.errors == 0) begin
            $display("RESULTADO ALU: PASS");
        end else begin
            $fatal(1, "RESULTADO ALU: FAIL con %0d errores", sb.errors);
        end

        $finish;
    end
endmodule
