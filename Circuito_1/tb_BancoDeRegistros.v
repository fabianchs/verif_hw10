/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: BancoDeEjecucion

Descripción:
Testbench para el banco de registros 8088. Valida la escritura y lectura
de registros de 8 y 16 bits, el reset y la detección de CX=0.
*/

`timescale 1ns / 1ps

`include "Circuito 1/BancoDeRegistros.v"

module tb_BancoDeEjecucion();
    
    // =========================================================================
    // Señales de Control
    // =========================================================================
    reg CLK;
    reg RST;
    
    // =========================================================================
    // Señales de Entrada
    // =========================================================================
    reg [15:0] A;              // Dato de entrada para escritura
    reg [7:0]  DatoIN;         // Dato de 8 bits (interrupciones)
    reg [23:0] DESP;           // Desplazamiento
    reg [1:0]  mod;            // Modo de direccionamiento
    reg [2:0]  RM;             // Registro/Memoria
    reg [3:0]  opER;           // Operando de lectura
    reg [3:0]  opEW;           // Operando de escritura
    reg        WR;             // Write Enable
    reg        LDI;            // Load Instruction
    reg [3:0]  DirST;          // Dirección Stack
    reg [2:0]  SelIn;          // Selección Interrupción
    
    // =========================================================================
    // Señales de Salida
    // =========================================================================
    wire [15:0] R;             // Salida del registro leído
    wire [15:0] RI;            // Salida de interfaz
    wire        CXZ;            // Detector CX=0
    
    // =========================================================================
    // Instanciación del Módulo bajo Prueba
    // =========================================================================
    BancoDeEjecucion uut (
        .CLK(CLK),
        .RST(RST),
        .A(A),
        .DatoIN(DatoIN),
        .DESP(DESP),
        .mod(mod),
        .RM(RM),
        .opER(opER),
        .opEW(opEW),
        .WR(WR),
        .LDI(LDI),
        .DirST(DirST),
        .SelIn(SelIn),
        .R(R),
        .RI(RI),
        .CXZ(CXZ)
    );
    
    // =========================================================================
    // Generador de Reloj (50 MHz)
    // =========================================================================
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end
    
    // =========================================================================
    // Procedimiento de Inicialización
    // =========================================================================
    initial begin
        // Configuración del waveform para visualización
        $dumpfile("tb_BancoDeEjecucion.vcd");
        $dumpvars(0, tb_BancoDeEjecucion);
        
        // Inicialización de señales
        RST = 1'b1;
        A = 16'h0000;
        DatoIN = 8'h00;
        DESP = 24'h000000;
        mod = 2'b00;
        RM = 3'b000;
        opER = 4'h0;
        opEW = 4'h0;
        WR = 1'b0;
        LDI = 1'b0;
        DirST = 4'h0;
        SelIn = 3'h0;
        
        #20;  // Esperar a que se estabilice el reloj
        RST = 1'b0;
        
        $display("\n========================================");
        $display("TESTBENCH: BANCO DE EJECUCION");
        $display("========================================\n");
        
        // Ejecutar casos de prueba
        test_reset();
        test_escritura_lectura_8bits();
        test_escritura_lectura_16bits();
        test_detector_cxz();
        test_multiple_escrituras();
        
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
            
            // Leer AL
            opER = 4'h0;  // AL
            #10;
            $display("  Ciclo 1: opER=AL(0x00), R=%h (esperado: 0000)", R);
            
            // Leer AX
            opER = 4'h8;  // AX
            #10;
            $display("  Ciclo 2: opER=AX(0x08), R=%h (esperado: 0000)", R);
            
            // Verificar que CXZ = 1 (CX = 0 después del reset)
            #10;
            $display("  Ciclo 3: CXZ=%b (esperado: 1, porque CX=0)", CXZ);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 2: Escribir y Leer Registros de 8 bits
    // =========================================================================
    task test_escritura_lectura_8bits();
        begin
            $display("\n--- PRUEBA 2: ESCRITURA/LECTURA REGISTROS 8 BITS ---");
            
            // Escribir en AL (opEW = 0x0)
            $display("\n  Escritura en AL con valor 0xAB:");
            A = 16'h00AB;
            opEW = 4'h0;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer AL
            $display("  Lectura de AL:");
            opER = 4'h0;  // AL
            #10;
            $display("    R=%h (esperado: 00ab)", R);
            
            // Escribir en AH (opEW = 0x4)
            $display("\n  Escritura en AH con valor 0xCD:");
            A = 16'h00CD;
            opEW = 4'h4;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer AX (debe mostrar AH:AL = CD:AB)
            $display("  Lectura de AX (AH:AL):");
            opER = 4'h8;  // AX
            #10;
            $display("    R=%h (esperado: cdab)", R);
            
            // Escribir en BL
            $display("\n  Escritura en BL con valor 0x12:");
            A = 16'h0012;
            opEW = 4'h3;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer BL
            opER = 4'h3;  // BL
            #10;
            $display("  Lectura de BL:");
            $display("    R=%h (esperado: 0012)", R);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 3: Escribir y Leer Registros de 16 bits
    // =========================================================================
    task test_escritura_lectura_16bits();
        begin
            $display("\n--- PRUEBA 3: ESCRITURA/LECTURA REGISTROS 16 BITS ---");
            
            // Escribir en SP (opEW = 0xC)
            $display("\n  Escritura en SP con valor 0x1234:");
            A = 16'h1234;
            opEW = 4'hC;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer SP
            opER = 4'hC;  // SP
            #10;
            $display("  Lectura de SP:");
            $display("    R=%h (esperado: 1234)", R);
            
            // Escribir en BP (opEW = 0xD)
            $display("\n  Escritura en BP con valor 0x5678:");
            A = 16'h5678;
            opEW = 4'hD;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Leer BP
            opER = 4'hD;  // BP
            #10;
            $display("  Lectura de BP:");
            $display("    R=%h (esperado: 5678)", R);
            
            // Escribir en SI y DI
            $display("\n  Escritura en SI con valor 0xAAAA:");
            A = 16'hAAAA;
            opEW = 4'hE;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            $display("  Escritura en DI con valor 0xBBBB:");
            A = 16'hBBBB;
            opEW = 4'hF;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            // Verificar lecturas
            opER = 4'hE;  // SI
            #10;
            $display("  Lectura de SI:");
            $display("    R=%h (esperado: aaaa)", R);
            
            opER = 4'hF;  // DI
            #10;
            $display("  Lectura de DI:");
            $display("    R=%h (esperado: bbbb)", R);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 4: Detector de CX = 0
    // =========================================================================
    task test_detector_cxz();
        begin
            $display("\n--- PRUEBA 4: DETECTOR CX=0 (CXZ) ---");
            
            // CX debería ser 0 inicialmente
            $display("\n  Estado inicial (CX=0):");
            #10;
            $display("    CXZ=%b (esperado: 1)", CXZ);
            
            // Escribir CX con valor no cero (opEW = 0x9)
            $display("\n  Escritura en CX con valor 0xFFFF:");
            A = 16'hFFFF;
            opEW = 4'h9;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            #10;
            $display("    CXZ=%b (esperado: 0, porque CX≠0)", CXZ);
            
            // Escribir CX con cero nuevamente
            $display("\n  Escritura en CX con valor 0x0000:");
            A = 16'h0000;
            opEW = 4'h9;
            WR = 1'b1;
            #20;
            WR = 1'b0;
            
            #10;
            $display("    CXZ=%b (esperado: 1, porque CX=0)", CXZ);
        end
    endtask
    
    // =========================================================================
    // PROCEDIMIENTO 5: Múltiples Escrituras Secuenciales
    // =========================================================================
    task test_multiple_escrituras();
        begin
            $display("\n--- PRUEBA 5: ESCRITURAS MULTIPLES SECUENCIALES ---");
            
            // Secuencia: cargar AX, BX, DX con valores diferentes
            $display("\n  Secuencia de escrituras:");
            
            A = 16'h1111;
            opEW = 4'h8;  // AX
            WR = 1'b1;
            #20;
            $display("    Ciclo 1: AX <- 0x1111");
            
            A = 16'h2222;
            opEW = 4'hB;  // BX
            #20;
            $display("    Ciclo 2: BX <- 0x2222");
            
            A = 16'h3333;
            opEW = 4'hA;  // DX
            #20;
            $display("    Ciclo 3: DX <- 0x3333");
            
            WR = 1'b0;
            #20;
            
            // Verificar las escrituras
            $display("\n  Verificación de valores:");
            opER = 4'h8;  // AX
            #10;
            $display("    AX=%h (esperado: 1111)", R);
            
            opER = 4'hB;  // BX
            #10;
            $display("    BX=%h (esperado: 2222)", R);
            
            opER = 4'hA;  // DX
            #10;
            $display("    DX=%h (esperado: 3333)", R);
        end
    endtask
    
endmodule
