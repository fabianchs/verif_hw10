/*
Autor: Fabian Chacon 201813154
Tecnologico de Costa Rica
Modulo: BancoDeRegistros / BancoDeEjecucion

Testbench SystemVerilog autochecking para el banco de registros del 8088.
Incluye transacciones, Tester, Scoreboard y Cover Groups.
*/

`timescale 1ns / 1ps

`include "Circuito 1/BancoDeRegistros.v"

typedef struct packed {
    bit [15:0] r;
    bit [15:0] ri;
    bit        cxz;
} banco_sample_t;

interface banco_registros_if;
    logic        CLK;
    logic        RST;
    logic [15:0] A;
    logic [7:0]  DatoIN;
    logic [23:0] DESP;
    logic [1:0]  mod;
    logic [2:0]  RM;
    logic [3:0]  opER;
    logic [3:0]  opEW;
    logic        WR;
    logic        LDI;
    logic [3:0]  DirST;
    logic [2:0]  SelIn;
    logic [15:0] R;
    logic [15:0] RI;
    logic        CXZ;

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    task automatic set_idle();
        A      = 16'h0000;
        DatoIN = 8'h00;
        DESP   = 24'h000000;
        mod    = 2'b00;
        RM     = 3'b000;
        opER   = 4'h0;
        opEW   = 4'h0;
        WR     = 1'b0;
        LDI    = 1'b0;
        DirST  = 4'h0;
        SelIn  = 3'h0;
    endtask

    function automatic banco_sample_t sample();
        sample.r   = R;
        sample.ri  = RI;
        sample.cxz = CXZ;
    endfunction

    modport dut (
        input  CLK, RST, A, DatoIN, DESP, mod, RM, opER, opEW, WR, LDI, DirST, SelIn,
        output R, RI, CXZ
    );
endinterface

module tb_BancoDeEjecucion;
    localparam int NUM_RANDOM_TESTS = 180;

    banco_registros_if bus();

    BancoDeEjecucion dut (
        .CLK(bus.CLK),
        .RST(bus.RST),
        .A(bus.A),
        .DatoIN(bus.DatoIN),
        .DESP(bus.DESP),
        .mod(bus.mod),
        .RM(bus.RM),
        .opER(bus.opER),
        .opEW(bus.opEW),
        .WR(bus.WR),
        .LDI(bus.LDI),
        .DirST(bus.DirST),
        .SelIn(bus.SelIn),
        .R(bus.R),
        .RI(bus.RI),
        .CXZ(bus.CXZ)
    );

    class banco_tx;
        rand bit [15:0] data;
        rand bit [7:0]  dato_in;
        rand bit [23:0] desp;
        rand bit [1:0]  mode;
        rand bit [2:0]  rm;
        rand bit [3:0]  read_sel;
        rand bit [3:0]  write_sel;
        rand bit        wr_en;
        rand bit        ldi_en;
        rand bit [3:0]  dir_st;
        rand bit [2:0]  sel_in;

        constraint useful_controls {
            wr_en  dist {1 := 7, 0 := 3};
            ldi_en dist {1 := 2, 0 := 8};
        }
    endclass

    class scoreboard;
        bit [7:0]  ah, al, bh_live, bl_live, ch, cl, dh, dl;
        bit [15:0] sp, bp_live, si_live, di_live;
        bit [7:0]  bh_latch, bl_latch;
        bit [15:0] bp_latch, si_latch, di_latch;
        bit [15:0] ea_latch;
        bit [7:0]  dato_latch;
        int checks;
        int errors;

        function new();
            reset();
        endfunction

        function void reset();
            ah = 8'h00; al = 8'h00; bh_live = 8'h00; bl_live = 8'h00;
            ch = 8'h00; cl = 8'h00; dh = 8'h00; dl = 8'h00;
            sp = 16'h0000; bp_live = 16'h0000; si_live = 16'h0000; di_live = 16'h0000;
            bh_latch = 8'h00; bl_latch = 8'h00;
            bp_latch = 16'h0000; si_latch = 16'h0000; di_latch = 16'h0000;
            ea_latch = 16'h0000; dato_latch = 8'h00;
        endfunction

        function void predict(input banco_tx tx);
            if (tx.wr_en) begin
                unique case (tx.write_sel)
                    4'h0: al = tx.data[7:0];
                    4'h1: cl = tx.data[7:0];
                    4'h2: dl = tx.data[7:0];
                    4'h3: bl_live = tx.data[7:0];
                    4'h4: ah = tx.data[7:0];
                    4'h5: ch = tx.data[7:0];
                    4'h6: dh = tx.data[7:0];
                    4'h7: bh_live = tx.data[7:0];
                    4'h8: begin ah = tx.data[15:8]; al = tx.data[7:0]; end
                    4'h9: begin ch = tx.data[15:8]; cl = tx.data[7:0]; end
                    4'hA: begin dh = tx.data[15:8]; dl = tx.data[7:0]; end
                    4'hB: begin bh_live = tx.data[15:8]; bl_live = tx.data[7:0]; end
                    4'hC: sp = tx.data;
                    4'hD: bp_live = tx.data;
                    4'hE: si_live = tx.data;
                    4'hF: di_live = tx.data;
                endcase
            end

            if (tx.ldi_en) begin
                di_latch = di_live;
                si_latch = si_live;
                bp_latch = bp_live;
                bh_latch = bh_live;
                bl_latch = bl_live;
                ea_latch = tx.data;
                dato_latch = tx.dato_in;
            end
        endfunction

        function bit [15:0] expected_r(input bit [3:0] sel);
            unique case (sel)
                4'h0: expected_r = {8'h00, al};
                4'h1: expected_r = {8'h00, cl};
                4'h2: expected_r = {8'h00, dl};
                4'h3: expected_r = {8'h00, bl_latch};
                4'h4: expected_r = {8'h00, ah};
                4'h5: expected_r = {8'h00, ch};
                4'h6: expected_r = {8'h00, dh};
                4'h7: expected_r = {8'h00, bh_latch};
                4'h8: expected_r = {ah, al};
                4'h9: expected_r = {ch, cl};
                4'hA: expected_r = {dh, dl};
                4'hB: expected_r = {bh_live, bl_live};
                4'hC: expected_r = sp;
                4'hD: expected_r = bp_live;
                4'hE: expected_r = si_live;
                4'hF: expected_r = di_live;
            endcase
        endfunction

        function bit expected_cxz();
            expected_cxz = ({ch, cl} == 16'h0000);
        endfunction

        function void check(input banco_tx tx, input banco_sample_t actual);
            bit [15:0] exp_r;
            bit exp_cxz;

            exp_r = expected_r(tx.read_sel);
            exp_cxz = expected_cxz();
            checks++;

            if (actual.r !== exp_r) begin
                errors++;
                $error("[SCOREBOARD][R] opER=%0h esperado=%04h obtenido=%04h", tx.read_sel, exp_r, actual.r);
            end

            if (actual.cxz !== exp_cxz) begin
                errors++;
                $error("[SCOREBOARD][CXZ] esperado=%0b obtenido=%0b", exp_cxz, actual.cxz);
            end
        endfunction
    endclass

    class tester;
        mailbox #(banco_tx) outbox;

        function new(input mailbox #(banco_tx) outbox);
            this.outbox = outbox;
        endfunction

        task run(input int count);
            banco_tx tx;

            repeat (count) begin
                tx = new();
                assert(tx.randomize())
                    else $fatal(1, "No se pudo randomizar banco_tx");
                outbox.put(tx);
            end
        endtask
    endclass

    covergroup cg_banco @(posedge bus.CLK);
        option.per_instance = 1;
        cp_read: coverpoint bus.opER {
            bins all_regs[] = {[4'h0:4'hF]};
        }
        cp_write: coverpoint bus.opEW {
            bins all_regs[] = {[4'h0:4'hF]};
        }
        cp_wr: coverpoint bus.WR {
            bins idle = {0};
            bins active = {1};
        }
        cp_ldi: coverpoint bus.LDI {
            bins idle = {0};
            bins active = {1};
        }
        cp_cxz: coverpoint bus.CXZ {
            bins zero = {1};
            bins non_zero = {0};
        }
        cp_mode: coverpoint bus.mod;
        cp_rm: coverpoint bus.RM;
        cp_dir: coverpoint bus.DirST;
        x_write_enable: cross cp_write, cp_wr;
        x_read_write: cross cp_read, cp_write;
    endgroup

    mailbox #(banco_tx) tx_mbx;
    scoreboard sb;
    tester tst;
    cg_banco cov;

    task automatic drive_tx(input banco_tx tx);
        @(posedge bus.CLK);
        bus.A      = tx.data;
        bus.DatoIN = tx.dato_in;
        bus.DESP   = tx.desp;
        bus.mod    = tx.mode;
        bus.RM     = tx.rm;
        bus.opER   = tx.read_sel;
        bus.opEW   = tx.write_sel;
        bus.WR     = tx.wr_en;
        bus.LDI    = tx.ldi_en;
        bus.DirST  = tx.dir_st;
        bus.SelIn  = tx.sel_in;
        @(negedge bus.CLK);
        #1;
        sb.predict(tx);
        bus.WR  = 1'b0;
        bus.LDI = 1'b0;
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
        banco_tx tx;

        for (int i = 0; i < 16; i++) begin
            tx = new();
            tx.data      = 16'h1000 + i;
            tx.dato_in   = 8'h40 + i;
            tx.desp      = 24'h000100 + i;
            tx.mode      = i;
            tx.rm        = i;
            tx.read_sel  = i;
            tx.write_sel = i;
            tx.wr_en     = 1'b1;
            tx.ldi_en    = (i == 3 || i == 7 || i >= 13);
            tx.dir_st    = i;
            tx.sel_in    = i;
            drive_tx(tx);
        end

        tx = new();
        tx.data      = 16'h0000;
        tx.dato_in   = 8'h00;
        tx.desp      = 24'h000000;
        tx.mode      = 2'b00;
        tx.rm        = 3'b000;
        tx.read_sel  = 4'h9;
        tx.write_sel = 4'h9;
        tx.wr_en     = 1'b1;
        tx.ldi_en    = 1'b0;
        tx.dir_st    = 4'h0;
        tx.sel_in    = 3'h0;
        drive_tx(tx);

        tx = new();
        tx.data      = 16'hCAFE;
        tx.dato_in   = 8'h00;
        tx.desp      = 24'h000000;
        tx.mode      = 2'b00;
        tx.rm        = 3'b000;
        tx.read_sel  = 4'h9;
        tx.write_sel = 4'h9;
        tx.wr_en     = 1'b1;
        tx.ldi_en    = 1'b0;
        tx.dir_st    = 4'h0;
        tx.sel_in    = 3'h0;
        drive_tx(tx);
    endtask

    initial begin
        banco_tx tx;

        $dumpfile("tb_BancoDeEjecucion.vcd");
        $dumpvars(0, tb_BancoDeEjecucion);

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

        $display("Checks BancoDeEjecucion: %0d, errores: %0d, cobertura: %.2f%%",
                 sb.checks, sb.errors, cov.get_coverage());

        if (sb.errors == 0) begin
            $display("RESULTADO BancoDeEjecucion: PASS");
        end else begin
            $fatal(1, "RESULTADO BancoDeEjecucion: FAIL con %0d errores", sb.errors);
        end

        $finish;
    end
endmodule
