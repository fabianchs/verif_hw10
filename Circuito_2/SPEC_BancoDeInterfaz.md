# ESPECIFICACIÓN DEL MÓDULO: BANCO DE INTERFAZ DE SEGMENTOS

## Descripción General
Este módulo maneja los registros de segmento del procesador 8088. Son cuatro registros de 16 bits que guardan las direcciones base de la memoria:
- **ES (Extra Segment):** para datos adicionales y operaciones con strings
- **CS (Code Segment):** para la dirección base del código
- **SS (Stack Segment):** para la dirección base de la pila
- **DS (Data Segment):** para la dirección base de los datos

## Función Principal
El módulo deja leer dos segmentos al mismo tiempo: uno desde el puerto de ejecución (`RE`) y otro desde el puerto de interfaz (`RI`). Solo hay un puerto de escritura, y ese se usa con `opE` y `WR`.

## Puertos de Entrada

| Puerto | Tamaño | Descripción |
|--------|--------|-------------|
| `CLK` | 1 bit | Reloj del sistema (activo en flanco positivo) |
| `RST` | 1 bit | Reset en alto - reinicializa todos los registros a 0x0000 |
| `A[15:0]` | 16 bits | Dato de entrada para escritura en registros de segmento |
| `opE[1:0]` | 2 bits | Selector del registro a leer en puerto de ejecución (RE) |
| `opI[1:0]` | 2 bits | Selector del registro a leer en puerto de interfaz (RI) |
| `WR` | 1 bit | Write Enable - habilita la escritura en el registro seleccionado |

## Puertos de Salida

| Puerto | Tamaño | Descripción |
|--------|--------|-------------|
| `RE[15:0]` | 16 bits | Salida del registro seleccionado por opE (lectura ejecución) |
| `RI[15:0]` | 16 bits | Salida del registro seleccionado por opI (lectura interfaz) |

## Funcionalidad

### Selección de Registros (opE y opI)
Los valores de `opE` y `opI` (2 bits) seleccionan los registros de segmento:

| opE/opI | Registro | Nombre |
|---------|----------|--------|
| 00 | ES | Extra Segment |
| 01 | CS | Code Segment |
| 10 | SS | Stack Segment |
| 11 | DS | Data Segment |

### Operaciones Principales

1. **Escritura de Registros (opE + WR)**
   - Cuando `WR=1`, se escribe el dato de entrada `A[15:0]` en el registro seleccionado por `opE`
   - La ROM de selección decodifica `opE` y genera una señal de escritura única
   - Los especiales: RegCS utiliza módulo `Reg16bitsEnaDownCS` 

2. **Lectura Simultánea Dual**
   - Dos multiplexoreses de 4:1 independientes
   - `MuxSalEjecucion` lee el registro seleccionado por `opE` → salida `RE`
   - `MuxSalInterfaz` lee el registro seleccionado por `opI` → salida `RI`
   - Permite leer desde diferentes segmentos en paralelo

3. **Comportamiento en Reset**
   - Cuando `RST=1`, todos los registros (ES, CS, SS, DS) se reinicializan a 0x0000
   - Las salidas RE y RI reflejan este estado (ambas = 0x0000)

## Casos de Uso

### Caso 1: Lectura Dual Simultánea
- Entrada: `opE = 01` (CS), `opI = 11` (DS)
- Resultado: 
  - `RE` contiene el valor de CS
  - `RI` contiene el valor de DS
- Esto permite acceder a ambos segmentos simultáneamente sin conflictos

### Caso 2: Escritura en ES
- Entrada: `A[15:0] = 0x2000`, `opE = 00` (ES), `WR = 1`
- Resultado: El registro ES se carga con 0x2000
- En el próximo ciclo, si `opE = 00` o `opI = 00`, la salida es 0x2000

### Caso 3: Protección de CS
- El registro CS puede tener protección especial mediante `Reg16bitsEnaDownCS`
- La escritura en CS puede requerir condiciones específicas

## Restricciones de Diseño

1. El módulo utiliza lógica combinacional para multiplexación de lectura
2. El almacenamiento de datos depende de registros síncronos con CLK
3. Las escrituras se producen en el flanco positivo del reloj
4. El reset `RST=1` limpia todos los registros a 0x0000
5. Las dos lecturas son independientes y pueden se acceder al mismo registro simultáneamente

## Módulos Internos 
- `Reg16bitsEnaDown`: Registro síncrono de 16 bits con enable
- `Reg16bitsEnaDownCS`: Registro especial para CS 
- `Mux4a1de16bits`: Multiplexor 4:1 de 16 bits
- `RomSeleccionBancoDeInterfaz`: Decodificador ROM para selección de escritura
