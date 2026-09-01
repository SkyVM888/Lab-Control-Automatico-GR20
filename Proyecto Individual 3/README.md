# Proyecto Individual 3

Diseño de un sistema de control mediante la modificación de polos, el lugar geométrico de las raíces (Root Locus) y la implementación de un compensador utilizando un script en MATLAB.

## Requisitos

* MATLAB con **Control System Toolbox**.

## Instrucciones de uso

1. Abra el archivo del proyecto en MATLAB.
2. Ejecute el script.
3. Cuando la consola solicite un parámetro, ingrese su valor y presione **Enter**.
   * Para polos complejos, ingrese únicamente uno de los polos del par. El programa agregará automáticamente su conjugado.
   * La cantidad total de polos ingresada debe permitir formar los pares conjugados correspondientes.
4. El programa preguntará si desea modificar la ubicación de algún polo.
   * En caso afirmativo, seleccione el polo que desee modificar mediante su índice  (1, 2, 3, ...).
   * Si la nueva ubicación es compleja, el programa agregará automáticamente su conjugado.
   * Si se modifica un polo complejo por uno real, su conjugado será eliminado automáticamente.
5. Una vez finalizada la modificación de los polos, el programa solicitará la cantidad de polos del compensador C(s).
   * Para polos complejos, ingrese únicamente uno de los polos del par. El programa agregará automáticamente su conjugado.

## Resultados

El programa mostrará:

* La función de transferencia de la planta G(s), del compensador C(s) y del sistema compensado.
* La ecuación característica de la planta G(s) y del sistema compensado.
* El gráfico del lugar geométrico de las raíces.
* La ubicación actualizada de los polos después de las modificaciones realizadas.
* La respuesta de la planta G(s), del compensador C(s) y del sistema compensado ante una entrada escalón.

## Consideraciones

* La cantidad de ceros debe ser un entero mayor o igual que cero.
* La cantidad de polos de la planta debe ser un entero mayor que cero.
* La cantidad de polos del compensador debe ser un entero mayor o igual que cero.
* Los polos pueden ser reales o complejos.
* En caso de utilizar un polo complejo, el programa agregará automáticamente su conjugado.
* La cantidad de polos indicada debe permitir formar los pares conjugados necesarios.
* El compensador se construye a partir de los polos ingresados, sin ceros adicionales.
