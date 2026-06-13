/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: BancoDeInterfaz

Descripción:
Testbench para el banco de segmentos 8088. Comprueba lecturas de ES, CS,
SS y DS, escritura de segmentos y la lectura dual simultánea.
*/


`timescale 1ns / 1ps

`include "Circuito 2/BancoDeInterfaz.v"

module tb_BancoDeInterfaz();
    
    // =========================================================================
    // Señales de Control
    // =========================================================================
    reg CLK;
    reg RST;
    
    // =========================================================================
    // Señales de Entrada
    // =========================================================================
    reg [15:0] A;              // Dato de entrada para escritura
    reg [1:0]  opE;            // Selector de lectura ejecución
    reg [1:0]  opI;            // Selector de lectura interfaz
    reg        WR;             // Write Enable
    
    // =========================================================================
    // Señales de Salida
    // =========================================================================
    wire [15:0] RE;            // Salida lectura ejecución
    wire [15:0] RI;            // Salida lectura interfaz
    
    // =========================================================================
    // Instanciación del Módulo bajo Prueba
    // =========================================================================
    BancoDeInterfaz uut (
        .CLK(CLK),
        .RST(RST),
        .A(A),
        .opE(opE),
        .opI(opI),
        .WR(WR),
        .RE(RE),
        .RI(RI)
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
        $dumpfile("tb_BancoDeInterfaz.vcd");
        $dumpvars(0, tb_BancoDeInterfaz);
        
        // Inicialización de señales
        RST = 1'b1;
        A = 16'h0000;
        opE = 2'b00;
        opI = 2'b00;
        WR = 1'b0;
        
        #20;  // Esperar a que se estabilice el reloj
        RST = 1'b0;
        
        $display("\n========================================");
        $display("TESTBENCH: BANCO DE INTERFAZ");
        $display("========================================\n");
        
        // Ejecutar casos de prueba
        test_reset();
        test_escritura_lectura_individual();
        test_lectura_dual_simultanea();
        test_independencia_puertos();
        test_escritura_multiple();
        
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
            $display("Todos los registros deben contener 0x0000");
            
            // Verificar ES
            opE = 2'b00;  // ES
            #10;
            $display("  opE=ES(00), RE=%h (esperado: 0000)", RE);
            
            // Verificar CS
            opE = 2'b01;  // CS
            #10;
            $display("  opE=CS(01), RE=%h (esperado: 0000)", RE);
            
            // Verificar SS
            opE = 2'b10;  // SS
            #10;
            $display("  opE=SS(10), RE=%h (esperado: 0000)", RE);
            
            // Verificar DS
            opE = 2'b11;  // DS
            #10;
            $display("  opE=DS(11), RE=%h (esperado: 0000)", RE);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 2: Escritura y Lectura Individual de Segmentos
    // =========================================================================
    task test_escritura_lectura_individual();
        begin
            $display("\n--- PRUEBA 2: ESCRITURA/LECTURA INDIVIDUAL ---");
            
            // Escribir en ES
            $display("\n  Escribir ES = 0x1111:");
            A = 16'h1111;
            opE = 2'b00;  // ES
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer ES
            #10;
            $display("  Leer ES: RE=%h (esperado: 1111)", RE);
            
            // Escribir en CS
            $display("\n  Escribir CS = 0x2222:");
            A = 16'h2222;
            opE = 2'b01;  // CS
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer CS
            opE = 2'b01;
            #10;
            $display("  Leer CS: RE=%h (esperado: 2222)", RE);
            
            // Escribir en SS
            $display("\n  Escribir SS = 0x3333:");
            A = 16'h3333;
            opE = 2'b10;  // SS
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer SS
            opE = 2'b10;
            #10;
            $display("  Leer SS: RE=%h (esperado: 3333)", RE);
            
            // Escribir en DS
            $display("\n  Escribir DS = 0x4444:");
            A = 16'h4444;
            opE = 2'b11;  // DS
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer DS
            opE = 2'b11;
            #10;
            $display("  Leer DS: RE=%h (esperado: 4444)", RE);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 3: Lectura Dual Simultánea
    // =========================================================================
    task test_lectura_dual_simultanea();
        begin
            $display("\n--- PRUEBA 3: LECTURA DUAL SIMULTÁNEA ---");
            $display("Los dos puertos pueden leer independientemente");
            
            // Leer CS desde RE y DS desde RI simultáneamente
            $display("\n  opE=CS(01), opI=DS(11):");
            opE = 2'b01;
            opI = 2'b11;
            #10;
            $display("    RE=%h (esperado: 2222 - valor de CS)", RE);
            $display("    RI=%h (esperado: 4444 - valor de DS)", RI);
            
            // Leer SS desde RE y ES desde RI simultáneamente
            $display("\n  opE=SS(10), opI=ES(00):");
            opE = 2'b10;
            opI = 2'b00;
            #10;
            $display("    RE=%h (esperado: 3333 - valor de SS)", RE);
            $display("    RI=%h (esperado: 1111 - valor de ES)", RI);
            
            // Leer el mismo registro desde ambos puertos
            $display("\n  opE=CS(01), opI=CS(01) (mismo registro):");
            opE = 2'b01;
            opI = 2'b01;
            #10;
            $display("    RE=%h, RI=%h (ambos esperado: 2222)", RE, RI);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 4: Independencia de Puertos de Lectura
    // =========================================================================
    task test_independencia_puertos();
        begin
            $display("\n--- PRUEBA 4: INDEPENDENCIA DE PUERTOS ---");
            $display("Los puertos de lectura son independientes del puerto de escritura");
            
            // Cambiar el valor de opE mientras leemos con opI
            $display("\n  Lectura de ES en opI mientras opE cambia:");
            opI = 2'b00;  // Leer ES
            opE = 2'b01;  // Escribir en CS
            #10;
            $display("    RI=%h (esperado: 1111 - ES)", RI);
            
            // Leer datos del puerto de interfaz
            $display("\n  Lectura múltiple secuencial de RI:");
            opI = 2'b00;  // ES
            #10;
            $display("    opI=ES(00), RI=%h (esperado: 1111)", RI);
            
            opI = 2'b01;  // CS
            #10;
            $display("    opI=CS(01), RI=%h (esperado: 2222)", RI);
            
            opI = 2'b10;  // SS
            #10;
            $display("    opI=SS(10), RI=%h (esperado: 3333)", RI);
            
            opI = 2'b11;  // DS
            #10;
            $display("    opI=DS(11), RI=%h (esperado: 4444)", RI);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 5: Escritura Múltiple Secuencial
    // =========================================================================
    task test_escritura_multiple();
        begin
            $display("\n--- PRUEBA 5: ESCRITURA MÚLTIPLE SECUENCIAL ---");
            $display("Cambiar valores y verificar actualización");
            
            // Secuencia de escrituras
            $display("\n  Secuencia de escrituras:");
            
            A = 16'hAAAA;
            opE = 2'b00;  // ES
            WR = 1'b1;
            #20;
            $display("    Ciclo 1: ES <- 0xAAAA");
            
            A = 16'hBBBB;
            opE = 2'b01;  // CS
            #20;
            $display("    Ciclo 2: CS <- 0xBBBB");
            
            A = 16'hCCCC;
            opE = 2'b10;  // SS
            #20;
            $display("    Ciclo 3: SS <- 0xCCCC");
            
            A = 16'hDDDD;
            opE = 2'b11;  // DS
            #20;
            WR = 1'b0;
            $display("    Ciclo 4: DS <- 0xDDDD");
            
            // Verificar todos los valores escritos
            $display("\n  Verificación de valores escritos:");
            opE = 2'b00;
            #10;
            $display("    ES=%h (esperado: aaaa)", RE);
            
            opE = 2'b01;
            #10;
            $display("    CS=%h (esperado: bbbb)", RE);
            
            opE = 2'b10;
            #10;
            $display("    SS=%h (esperado: cccc)", RE);
            
            opE = 2'b11;
            #10;
            $display("    DS=%h (esperado: dddd)", RE);
        end
    endtask
    
endmodule
