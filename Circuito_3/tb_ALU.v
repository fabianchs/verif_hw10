/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: ALU

Descripción:
Testbench para la unidad aritmética y lógica 8088. Valida operaciones
aritméticas, lógicas, desplazamientos y el comportamiento de las banderas.
*/

`timescale 1ns / 1ps

`include "Circuito 3/ALU.v"

module tb_ALU();
    
    // =========================================================================
    // Señales de Control
    // =========================================================================
    reg CLK;
    reg RST;
    
    // =========================================================================
    // Señales de Entrada
    // =========================================================================
    reg [15:0] A;              // Dato de entrada
    reg        V;              // Carry de entrada
    reg [5:0]  op;             // Código de operación
    reg        WA;             // Write Enable Registro A
    reg        WB;             // Write Enable Registro B
    reg        WD;             // Write Enable Registro D
    reg        ENADi;          // Enable División
    reg [1:0]  WR;             // Write FLAGS
    reg [2:0]  opFL;           // Operación FLAGS
    
    // =========================================================================
    // Señales de Salida
    // =========================================================================
    wire [15:0] R1;            // Resultado principal
    wire [15:0] R2;            // Resultado secundario
    wire [15:0] FLAGS;         // Registro completo de FLAGS
    wire [5:0]  FL;            // FLAGS comprimidas
    wire        FINP;          // Fin de división
    wire        IF;            // Interrupt Flag
    
    // =========================================================================
    // Instanciación del Módulo bajo Prueba
    // =========================================================================
    ALU uut (
        .CLK(CLK),
        .RST(RST),
        .A(A),
        .V(V),
        .op(op),
        .WA(WA),
        .WB(WB),
        .WD(WD),
        .ENADi(ENADi),
        .WR(WR),
        .opFL(opFL),
        .R1(R1),
        .R2(R2),
        .FLAGS(FLAGS),
        .FL(FL),
        .FINP(FINP),
        .IF(IF)
    );
    
    // =========================================================================
    // Generador de Reloj (50 MHz)
    // =========================================================================
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end
    
    // =========================================================================
    // Procedimiento Principal de Prueba
    // =========================================================================
    initial begin
        // Configuración del waveform para visualización
        $dumpfile("tb_ALU.vcd");
        $dumpvars(0, tb_ALU);
        
        // Inicialización de señales
        RST = 1'b1;
        A = 16'h0000;
        V = 1'b0;
        op = 6'b000000;
        WA = 1'b0;
        WB = 1'b0;
        WD = 1'b0;
        ENADi = 1'b0;
        WR = 2'b00;
        opFL = 3'b000;
        
        #20;  // Esperar a que se estabilice el reloj
        RST = 1'b0;
        
        $display("\n========================================");
        $display("TESTBENCH: UNIDAD ARITMETICA Y LOGICA");
        $display("========================================\n");
        
        // Ejecutar casos de prueba
        test_reset();
        test_operaciones_aritmeticas();
        test_operaciones_logicas();
        test_operaciones_desplazamiento();
        test_banderas_basicas();
        test_banderas_aritmeticas();
        
        // Mensaje de finalización
        #20;
        $display("\n========================================");
        $display("SIMULACION COMPLETADA");
        $display("========================================\n");
        
        $finish;
    end
    
    // =========================================================================
    // PROCEDIMIENTO 1: Verificar Reset
    // =========================================================================
    task test_reset();
        begin
            $display("\n--- PRUEBA 1: RESET DEL SISTEMA ---");
            $display("Todos los registros y FLAGS deben estar en cero");
            
            // Verificar FLAGS después del reset
            #10;
            $display("  FLAGS=%h (esperado: 0000)", FLAGS);
            $display("  R1=%h (esperado: 0000)", R1);
            $display("  FL=%h (esperado: 000000)", FL);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 2: Operaciones Aritméticas
    // =========================================================================
    task test_operaciones_aritmeticas();
        begin
            $display("\n--- PRUEBA 2: OPERACIONES ARITMETICAS ---");
            
            // ADD: 0x0005 + 0x0003 = 0x0008
            $display("\n  ADD: 0x0005 + 0x0003");
            A = 16'h0005;
            WA = 1'b1;
            WR = 2'b01;
            #20;
            WA = 1'b0;
            
            A = 16'h0003;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000000;  // ADD
            #20;
            $display("    R1=%h (esperado: 0008)", R1);
            $display("    CF=%b, ZF=%b", FLAGS[0], FLAGS[6]);
            
            // SUB: 0x0008 - 0x0003 = 0x0005
            $display("\n  SUB: 0x0008 - 0x0003");
            A = 16'h0008;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0003;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000101;  // SUB
            #20;
            $display("    R1=%h (esperado: 0005)", R1);
            
            // ADD con Carry: 0xFFFF + 0x0001 + CF
            $display("\n  ADC: 0xFFFF + 0x0001 con CF=0");
            A = 16'hFFFF;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0001;
            WB = 1'b1;
            V = 1'b0;
            #20;
            WB = 1'b0;
            
            op = 6'b000010;  // ADC
            #20;
            $display("    R1=%h (esperado: 0000)", R1);
            $display("    CF=%b (esperado: 1), ZF=%b (esperado: 1)", FLAGS[0], FLAGS[6]);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 3: Operaciones Lógicas
    // =========================================================================
    task test_operaciones_logicas();
        begin
            $display("\n--- PRUEBA 3: OPERACIONES LOGICAS ---");
            
            // OR: 0x00FF | 0xFF00 = 0xFFFF
            $display("\n  OR: 0x00FF | 0xFF00");
            A = 16'h00FF;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'hFF00;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000001;  // OR
            #20;
            $display("    R1=%h (esperado: ffff)", R1);
            
            // AND: 0xFFFF & 0x00FF = 0x00FF
            $display("\n  AND: 0xFFFF & 0x00FF");
            A = 16'hFFFF;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h00FF;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000100;  // AND
            #20;
            $display("    R1=%h (esperado: 00ff)", R1);
            
            // XOR: 0xAAAA ^ 0x5555 = 0xFFFF
            $display("\n  XOR: 0xAAAA ^ 0x5555");
            A = 16'hAAAA;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h5555;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000110;  // XOR
            #20;
            $display("    R1=%h (esperado: ffff)", R1);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 4: Operaciones de Desplazamiento
    // =========================================================================
    task test_operaciones_desplazamiento();
        begin
            $display("\n--- PRUEBA 4: OPERACIONES DE DESPLAZAMIENTO ---");
            
            // SHL: 0x0001 << 1 = 0x0002
            $display("\n  SHL (Desplazar Izquierda): 0x0001 << 1");
            A = 16'h0001;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0001;  // Cantidad de desplazamiento
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b001100;  // SHL
            #20;
            $display("    R1=%h (esperado: 0002)", R1);
            
            // SHR: 0x0080 >> 1 = 0x0040
            $display("\n  SHR (Desplazar Derecha): 0x0080 >> 1");
            A = 16'h0080;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0001;  // Cantidad de desplazamiento
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b001101;  // SHR
            #20;
            $display("    R1=%h (esperado: 0040)", R1);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 5: Banderas Básicas
    // =========================================================================
    task test_banderas_basicas();
        begin
            $display("\n--- PRUEBA 5: BANDERAS BASICAS ---");
            
            // Prueba ZF (Zero Flag)
            $display("\n  Prueba ZF (Zero Flag):");
            A = 16'h0005;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0005;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000101;  // SUB (5-5=0)
            WR = 2'b01;
            #20;
            WR = 2'b00;
            $display("    Operación: 0x0005 - 0x0005 = 0");
            $display("    R1=%h, ZF=%b (esperado: 1)", R1, FLAGS[6]);
            
            // Prueba SF (Sign Flag)
            $display("\n  Prueba SF (Sign Flag):");
            A = 16'h0001;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0005;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000101;  // SUB (1-5=-4 = 0xFFFC)
            WR = 2'b01;
            #20;
            WR = 2'b00;
            $display("    Operación: 0x0001 - 0x0005 = 0xFFFC");
            $display("    R1=%h, SF=%b (esperado: 1)", R1, FLAGS[7]);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 6: Banderas en Operaciones Aritméticas
    // =========================================================================
    task test_banderas_aritmeticas();
        begin
            $display("\n--- PRUEBA 6: BANDERAS EN OPERACIONES ARITMETICAS ---");
            
            // Prueba CF (Carry Flag) - Overflow sin signo
            $display("\n  Prueba CF (Carry Flag):");
            A = 16'hFFFF;
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0001;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000000;  // ADD (0xFFFF + 0x0001 = 0x0000 con CF=1)
            WR = 2'b01;
            #20;
            WR = 2'b00;
            $display("    Operación: 0xFFFF + 0x0001");
            $display("    R1=%h, CF=%b, ZF=%b (esperado CF: 1, ZF: 1)", R1, FLAGS[0], FLAGS[6]);
            
            // Prueba OF (Overflow Flag) - Overflow con signo
            $display("\n  Prueba OF (Overflow Flag):");
            A = 16'h7FFF;  // Máximo positivo
            WA = 1'b1;
            #20;
            WA = 1'b0;
            
            A = 16'h0001;
            WB = 1'b1;
            #20;
            WB = 1'b0;
            
            op = 6'b000000;  // ADD (0x7FFF + 0x0001 overflow)
            WR = 2'b01;
            #20;
            WR = 2'b00;
            $display("    Operación: 0x7FFF + 0x0001");
            $display("    R1=%h, OF=%b", R1, FLAGS[11]);
        end
    endtask
    
endmodule
