# ESPECIFICACIÓN DEL MÓDULO: BANCO DE EJECUCIÓN (BancoDeRegistros)

## Descripción General
El módulo `BancoDeEjecucion` implementa el banco de registros del procesador 8088. Contiene 16 registros de propósito general organizados en dos grupos:
- **Registros de 8 bits (cortos):** AL, AH, BL, BH, CL, CH, DL, DH
- **Registros de 16 bits (largos):** AX, BX, CX, DX, SP, BP, SI, DI

## Puertos de Entrada

| Puerto | Tamaño | Descripción |
|--------|--------|-------------|
| `CLK` | 1 bit | Reloj del sistema |
| `RST` | 1 bit | Reset activo en alto |
| `A[15:0]` | 16 bits | Dato de entrada para escritura en registros |
| `DatoIN[7:0]` | 8 bits | Dato de 8 bits de entrada (posiblemente para interrupciones) |
| `DESP[23:0]` | 24 bits | Desplazamiento (usado en cálculos de direcciones) |
| `mod[1:0]` | 2 bits | Selector de modo de direccionamiento |
| `RM[2:0]` | 3 bits | Selector de registro/memoria |
| `opER[3:0]` | 4 bits | Operando de lectura (selecciona qué registro leer) |
| `opEW[3:0]` | 4 bits | Operando de escritura (selecciona qué registro escribir) |
| `WR` | 1 bit | Write enable - permite escritura en registros |
| `LDI` | 1 bit | Load Instruction - carga de instrucción |
| `DirST[3:0]` | 4 bits | Dirección del Stack pointer |
| `SelIn[2:0]` | 3 bits | Selección de interrupción |

## Puertos de Salida

| Puerto | Tamaño | Descripción |
|--------|--------|-------------|
| `R[15:0]` | 16 bits | Salida del registro leído (opER) |
| `RI[15:0]` | 16 bits | Salida calculada (resultado de interfaz) |
| `CXZ` | 1 bit | Indicador de que CX = 0 |

## Funcionalidad

### Selección de Registros (opER y opEW)
Los valores de `opER` y `opEW` (4 bits) seleccionan los registros según:

| opER/opEW | Registro | Tamaño |
|-----------|----------|--------|
| 0000 | AL | 8 bits |
| 0001 | CL | 8 bits |
| 0010 | DL | 8 bits |
| 0011 | BL | 8 bits |
| 0100 | AH | 8 bits |
| 0101 | CH | 8 bits |
| 0110 | DH | 8 bits |
| 0111 | BH | 8 bits |
| 1000 | AX | 16 bits |
| 1001 | CX | 16 bits |
| 1010 | DX | 16 bits |
| 1011 | BX | 16 bits |
| 1100 | SP | 16 bits |
| 1101 | BP | 16 bits |
| 1110 | SI | 16 bits |
| 1111 | DI | 16 bits |

### Operaciones Principales

1. **Escritura de Registros (opEW)**
   - Cuando `WR=1`, se escribe el dato de entrada `A[15:0]` en el registro seleccionado por `opEW`
   - Para registros de 8 bits: se usa `A[7:0]` como dato bajo y `A[15:8]` como dato alto
   - Las ROM de selección decodifican `opEW` y generan señales individuales de escritura

2. **Lectura de Registros (opER)**
   - Mediante multiplexadores se selecciona el registro indicado por `opER`
   - El resultado se envía al puerto `R[15:0]`

3. **Detección de CX=0 (CXZ)**
   - Detecta si el registro CX es cero
   - Usado para instrucciones condicionales tipo CXNZ

4. **Interfaz de Direccionamiento**
   - Red compleja que calcula direcciones efectivas combinando registros
   - Utiliza multiplexadores y sumadores para combinar SI, DI, BP, BX y DESP
   - Resultado en `RI[15:0]`

5. **Latchs de Búsqueda (LDI)**
   - Cuando `LDI=1`, se capturan valores en latches internos
   - Almacenan DI, SI, BP, BH, BL y otros valores para uso posterior

## Casos de Uso

### Caso 1: Escritura Simple
- Entrada: `opEW = 0000` (AL), `A[15:0] = 0x00FF`, `WR = 1`
- Resultado: El registro AL se carga con 0xFF

### Caso 2: Lectura Simple
- Entrada: `opER = 1000` (AX), registro AX contiene 0x1234
- Resultado: `R[15:0] = 0x1234`

### Caso 3: Detección CX=0
- Entrada: Registros CH:CL = 0x0000
- Resultado: `CXZ = 1`
- Entrada: Registros CH:CL ≠ 0x0000
- Resultado: `CXZ = 0`

## Restricciones de Diseño

1. El módulo utiliza lógica combinacional para multiplexación
2. El almacenamiento de datos depende de registros síncronos con CLK
3. Las escrituras se producen en el flanco ascendente del reloj
4. El reset `RST=1` limpia todos los registros a 0

## Módulos Internos Utilizados

- `Mux2a1de8bits`, `Mux2a1de16bits`: Multiplexadores 2:1
- `Mux4a1de16bits`, `Mux8a1de16bits`, `Mux16a1de16bits`: Multiplexadores 4:1, 8:1, 16:1
- `Reg8bitsEnaDown`, `Reg16bitsEnaDown`: Registros síncronos
- `DetectorZero`: Detector de valor cero
- `SemiAdder16bits3op`: Sumador de tres operandos
- `RomSeleccionBancoDeEjecucion`: Decodificador de escritura
- `RomSeleccionInterfazBancoDeEjecucion`: Selector de interfaz de direccionamiento
