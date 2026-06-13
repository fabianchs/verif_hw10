/*
Autor: Fabian Chacon 201813154
Tecnologico de Costa Rica
Modulo: BancoDeInterfaz

Testbench SystemVerilog autochecking para el banco de registros de segmento.
Incluye transacciones aleatorias, Tester, Scoreboard y Cover Groups.
*/

`timescale 1ns / 1ps

`include "Circuito 2/BancoDeInterfaz.v"

module tb_BancoDeInterfaz;
    localparam int NUM_RANDOM_TESTS = 120;

    logic        CLK;
    logic        RST;
    logic [15:0] A;
    logic [1:0]  opE;
    logic [1:0]  opI;
    logic        WR;
    wire  [15:0] RE;
    wire  [15:0] RI;

    BancoDeInterfaz dut (
        .CLK(CLK),
        .RST(RST),
        .A(A),
        .opE(opE),
        .opI(opI),
        .WR(WR),
        .RE(RE),
        .RI(RI)
    );

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    class segmento_tx;
        rand bit [15:0] data;
        rand bit [1:0]  sel_e;
        rand bit [1:0]  sel_i;
        rand bit        wr_en;

        constraint useful_writes {
            wr_en dist {1 := 7, 0 := 3};
        }
    endclass

    class scoreboard;
        bit [15:0] model [4];
        int checks;
        int errors;

        function new();
            reset();
        endfunction

        function void reset();
            foreach (model[i]) model[i] = 16'h0000;
        endfunction

        function void predict(input segmento_tx tx);
            if (tx.wr_en) begin
                model[tx.sel_e] = tx.data;
            end
        endfunction

        function void check(input segmento_tx tx, input bit [15:0] actual_re, input bit [15:0] actual_ri);
            bit [15:0] exp_re;
            bit [15:0] exp_ri;

            exp_re = model[tx.sel_e];
            exp_ri = model[tx.sel_i];
            checks++;

            if (actual_re !== exp_re) begin
                errors++;
                $error("[SCOREBOARD][RE] opE=%0d esperado=%04h obtenido=%04h", tx.sel_e, exp_re, actual_re);
            end

            if (actual_ri !== exp_ri) begin
                errors++;
                $error("[SCOREBOARD][RI] opI=%0d esperado=%04h obtenido=%04h", tx.sel_i, exp_ri, actual_ri);
            end
        endfunction
    endclass

    class tester;
        mailbox #(segmento_tx) outbox;

        function new(input mailbox #(segmento_tx) outbox);
            this.outbox = outbox;
        endfunction

        task run(input int count);
            segmento_tx tx;

            repeat (count) begin
                tx = new();
                assert(tx.randomize())
                    else $fatal(1, "No se pudo randomizar segmento_tx");
                outbox.put(tx);
            end
        endtask
    endclass

    covergroup cg_segmentos @(posedge CLK);
        option.per_instance = 1;
        cp_opE: coverpoint opE {
            bins ES = {2'b00};
            bins CS = {2'b01};
            bins SS = {2'b10};
            bins DS = {2'b11};
        }
        cp_opI: coverpoint opI {
            bins ES = {2'b00};
            bins CS = {2'b01};
            bins SS = {2'b10};
            bins DS = {2'b11};
        }
        cp_wr: coverpoint WR {
            bins read = {0};
            bins write = {1};
        }
        cp_data: coverpoint A {
            bins zero = {16'h0000};
            bins ones = {16'hFFFF};
            bins low_values = {[16'h0001:16'h00FF]};
            bins high_values = {[16'hFF00:16'hFFFE]};
            bins others = default;
        }
        x_read_ports: cross cp_opE, cp_opI;
        x_write_target: cross cp_opE, cp_wr;
    endgroup

    mailbox #(segmento_tx) tx_mbx;
    scoreboard sb;
    tester tst;
    cg_segmentos cov;

    task automatic drive_tx(input segmento_tx tx);
        @(posedge CLK);
        A   = tx.data;
        opE = tx.sel_e;
        opI = tx.sel_i;
        WR  = tx.wr_en;
        @(negedge CLK);
        #1;
        sb.predict(tx);
        WR = 1'b0;
        #1;
        sb.check(tx, RE, RI);
    endtask

    task automatic apply_reset();
        RST = 1'b1;
        A   = 16'h0000;
        opE = 2'b00;
        opI = 2'b00;
        WR  = 1'b0;
        repeat (3) @(posedge CLK);
        RST = 1'b0;
        sb.reset();
        @(posedge CLK);
    endtask

    task automatic directed_tests();
        segmento_tx tx;

        for (int i = 0; i < 4; i++) begin
            tx = new();
            tx.data  = 16'h1111 * (i + 1);
            tx.sel_e = i;
            tx.sel_i = 3 - i;
            tx.wr_en = 1'b1;
            drive_tx(tx);
        end

        for (int e = 0; e < 4; e++) begin
            for (int r = 0; r < 4; r++) begin
                tx = new();
                tx.data  = 16'h0000;
                tx.sel_e = e;
                tx.sel_i = r;
                tx.wr_en = 1'b0;
                drive_tx(tx);
            end
        end
    endtask

    initial begin
        segmento_tx tx;

        $dumpfile("tb_BancoDeInterfaz.vcd");
        $dumpvars(0, tb_BancoDeInterfaz);

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

        $display("Checks BancoDeInterfaz: %0d, errores: %0d, cobertura: %.2f%%",
                 sb.checks, sb.errors, cov.get_coverage());

        if (sb.errors == 0) begin
            $display("RESULTADO BancoDeInterfaz: PASS");
        end else begin
            $fatal(1, "RESULTADO BancoDeInterfaz: FAIL con %0d errores", sb.errors);
        end

        $finish;
    end
endmodule
