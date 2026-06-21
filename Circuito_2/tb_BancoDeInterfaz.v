/*
Autor: Fabian Chacon 201813154
Tecnologico de Costa Rica
Modulo: BancoDeInterfaz

Testbench SystemVerilog autochecking para el banco de registros de segmento.
Incluye transacciones aleatorias, Tester, Scoreboard y Cover Groups.
*/

`timescale 1ns / 1ps

`include "Circuito 2/BancoDeInterfaz.v"

typedef struct packed {
    bit [15:0] re;
    bit [15:0] ri;
} segmento_sample_t;

interface banco_interfaz_if;
    logic        CLK;
    logic        RST;
    logic [15:0] A;
    logic [1:0]  opE;
    logic [1:0]  opI;
    logic        WR;
    logic [15:0] RE;
    logic [15:0] RI;

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    task automatic set_idle();
        A   = 16'h0000;
        opE = 2'b00;
        opI = 2'b00;
        WR  = 1'b0;
    endtask

    function automatic segmento_sample_t sample();
        sample.re = RE;
        sample.ri = RI;
    endfunction

    modport dut (
        input  CLK, RST, A, opE, opI, WR,
        output RE, RI
    );
endinterface

module tb_BancoDeInterfaz;
    localparam int NUM_RANDOM_TESTS = 120;

    banco_interfaz_if bus();

    BancoDeInterfaz dut (
        .CLK(bus.CLK),
        .RST(bus.RST),
        .A(bus.A),
        .opE(bus.opE),
        .opI(bus.opI),
        .WR(bus.WR),
        .RE(bus.RE),
        .RI(bus.RI)
    );

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

        function void check(input segmento_tx tx, input segmento_sample_t actual);
            bit [15:0] exp_re;
            bit [15:0] exp_ri;

            exp_re = model[tx.sel_e];
            exp_ri = model[tx.sel_i];
            checks++;

            if (actual.re !== exp_re) begin
                errors++;
                $error("[SCOREBOARD][RE] opE=%0d esperado=%04h obtenido=%04h", tx.sel_e, exp_re, actual.re);
            end

            if (actual.ri !== exp_ri) begin
                errors++;
                $error("[SCOREBOARD][RI] opI=%0d esperado=%04h obtenido=%04h", tx.sel_i, exp_ri, actual.ri);
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

    covergroup cg_segmentos @(posedge bus.CLK);
        option.per_instance = 1;
        cp_opE: coverpoint bus.opE {
            bins ES = {2'b00};
            bins CS = {2'b01};
            bins SS = {2'b10};
            bins DS = {2'b11};
        }
        cp_opI: coverpoint bus.opI {
            bins ES = {2'b00};
            bins CS = {2'b01};
            bins SS = {2'b10};
            bins DS = {2'b11};
        }
        cp_wr: coverpoint bus.WR {
            bins read = {0};
            bins write = {1};
        }
        cp_data: coverpoint bus.A {
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
        @(posedge bus.CLK);
        bus.A   = tx.data;
        bus.opE = tx.sel_e;
        bus.opI = tx.sel_i;
        bus.WR  = tx.wr_en;
        @(negedge bus.CLK);
        #1;
        sb.predict(tx);
        bus.WR = 1'b0;
        #1;
        sb.check(tx, bus.sample());
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
