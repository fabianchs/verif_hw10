# Tarea 10 - Verificacion de bloques 8088

Entrega de la tarea 10 de verificacion para tres bloques del procesador 8088:

- `Circuito_1/tb_BancoDeRegistros.v`: testbench modular del banco de registros (`BancoDeEjecucion` en `BancoDeRegistros.v`).
- `Circuito_2/tb_BancoDeInterfaz.v`: testbench modular del banco de registros de segmento.
- `Circuito_3/tb_ALU.v`: testbench modular de la ALU.

Cada testbench usa elementos avanzados de SystemVerilog:

- `interface` para agrupar las senales del DUT y tareas comunes de inicializacion.
- `typedef struct packed` para capturar muestras observadas de salida.
- `class` para transacciones, generador/tester y scoreboard.
- `mailbox`, pruebas dirigidas, pruebas aleatorias, assertions y covergroups.

## Simulacion

Estos bancos requieren un simulador con soporte completo de SystemVerilog de verificacion, por ejemplo Questa/ModelSim, Xcelium o VCS. Icarus Verilog no soporta completamente `class`, `constraint`, `mailbox` ni `covergroup`, por lo que no es suficiente para ejecutar esta entrega.

Ejemplo de comandos en Questa/ModelSim:

```tcl
cd Circuito_1
vlog -sv +incdir+"Circuito 1" tb_BancoDeRegistros.v
vsim -c tb_BancoDeEjecucion -do "run -all; quit"

cd ../Circuito_2
vlog -sv +incdir+"Circuito 2" tb_BancoDeInterfaz.v
vsim -c tb_BancoDeInterfaz -do "run -all; quit"

cd ../Circuito_3
vlog -sv +incdir+"Circuito 3" tb_ALU.v
vsim -c tb_ALU -do "run -all; quit"
```
