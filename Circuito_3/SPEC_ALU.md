 # ESPECIFICACIÓN: UNIDAD ARITMÉTICA Y LÓGICA (ALU)

 Esta especificación presenta una explicación para comprender el diseño de la ALU. Incluye la descripción de las
 entradas/salidas, las operaciones principales, y notas 
 para probar el módulo.

 ## ¿Qué hace la ALU?
 La `ALU` hace operaciones aritméticas y lógicas sobre datos de 16 bits.
 Tiene muchas instrucciones (salen más de 30), como sumar, restar,
 desplazamientos, rotaciones, multiplicar y dividir. También guarda
 banderas (`FLAGS`) que nos dicen el estado después de una operaciónn.

 ## Entradas 
 - `CLK`: reloj
 - `RST`: reset (limpia todo)
 - `A[15:0]`: dato de entrada (lo usamos para cargar registros o flags)
 - `V`: carry in de entrada
 - `op[5:0]`: código de la operación que quiero ejecutar
 - `WA`, `WB`, `WD`: señales para escribir en los registros A, B, D
 - `ENADi`: habilita funciones de división/multiplicación largas, señal de enable
 - `WR[1:0]`: control para escribir las banderas
 - `opFL[2:0]`: selección de operaciones especiales sobre flags

 ## Salidas 
 - `R1[15:0]`: resultado principal
 - `R2[15:0]`: resultado secundario (por ejemplo en multiplicación)
 - `FLAGS[15:0]`: registro completo de flags
 - `FL[5:0]`: versión corta de las banderas, se utiliza en otras secciones
 - `FINP`: indica fin de operaciones largas (div/mul), es básicamente otraa bandera
 - `IF`: copia de la bandera de interrupciones

 ## Operaciones 

 - `000000` ADD: suma (R1 = A + B)
 - `000010` ADC: suma con carry (R1 = A + B + CF)
 - `000101` SUB: resta (R1 = A - B)
 - `000111` CMP: compara A y B (calc A-B, no guarda en registros)
 - `001100` SHL: shift left (desplazamiento lógico)
 - `001101` SHR: shift right (desplazamiento lógico)
 - `001000` ROL: rotación izquierda
 - `100001` MUL 16B: multiplicación 16 bits (usa `R2` también)
 - `100101` DIV 16B: división 16 bits
 - `101000` NOT: inversor de bits
 - `101001` NEG: cambio de signo (complemento a dos)



 ## Banderas
 Las banderas son bits indican coosas, como si hubo acarreo, cero,
 overflow, etc. Las más importantes:
 - `CF` (carry): hubo acarreo/borrow
 - `ZF` (zero): el resultado fue cero
 - `SF` (sign): el resultado es negativo (bit 15 = 1)
 - `OF` (overflow): hubo desbordamiento en operación con signo
 - `PF` (parity): paridad del resultados

 Es posible escribir las banderas desde `A` usando `WR`:
 - `WR = 00`: no se escriben
 - `WR = 01` o `11`: se escriben las banderas básicas (CF, PF, AF, ZF, SF)
 - `WR = 10`: se permiten escrituras completas (incluye DF, IF, OF)

 ## Estructura interna 
 - Hay registros `REGA`, `REGB`, `REGD` que guardan los operandos.
 - El diseño tiene varios bloques: un bloque principal (ALU1) para
    suma/resta/AND/OR/XOR, otro (ALU2) para shifts/rotates, y una unidad
    de producto/división para multiplicar/dividir.
 - Al final se usan multiplexores para elegir qué resultado sale por `R1`.

 ## Ejemplos 
 - ADD: si `A=0x0005`, `B=0x0003` y `op=000000`, entonces `R1=0x0008`.
 - ADC: si `A=0xFFFF`, `B=0x0001` y no hay `CF`, al sumar da `R1=0x0000`
    y `CF=1`.
 - SHL: si `A=0x0080` y desplazamos 1, sale `R1=0x0100`.

