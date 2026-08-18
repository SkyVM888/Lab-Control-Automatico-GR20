# Proyecto Individual 1
Simulación paramétrica de una planta con función de transferencia de un motor CD mediante un script en MATLAB.

## Requisitos
- MATLAB con Control System Toolbox (para utilizar `tf`, `step` y `stepinfo`).

## Instrucciones de uso
1. Abra el archivo del proyecto en MATLAB.
2. Ejecute el script.
3. Cuando la consola solicite un parámetro, ingrese su valor y presione **Enter**.

## Ingreso manual de parámetros (opcional)
Si desea ejecutar el programa sin ingresar los valores desde la consola:

1. Descomente las líneas donde se asignan manualmente los valores de `KT`, `Ra`, `b`, `Kb` y `J` (De la línea 11 hasta la 15).
2. Comente las líneas que utilizan `input()` (De la línea 19 hasta la 23).
3. Guarde el archivo y vuelva a ejecutar el script.
