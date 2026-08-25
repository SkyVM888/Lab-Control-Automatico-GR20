# Proyecto Individual 2
Análisis de estabilidad de una planta mediante el criterio de Routh-Hurwitz y el lugar geométrico de las raíces (Root Locus) utilizando un script en MATLAB.

## Requisitos
- MATLAB con **Control System Toolbox**.

## Instrucciones de uso
1. Abra el archivo del proyecto en MATLAB.
2. Ejecute el script.
3. Cuando la consola solicite un parámetro, ingrese su valor y presione **Enter**.
   - Para polos complejos, ingrese el polo correspondiente, presione **Enter**, y luego incluya también su conjugado.

## Resultados
Al finalizar la ejecución, el programa mostrará:
- La función de transferencia de la planta \(G(s)\).
- La función de transferencia de lazo cerrado \(T(s)\).
- Los coeficientes de la ecuación característica.
- La matriz de Routh-Hurwitz.
- El gráfico del lugar geométrico de las raíces.
- El estado de estabilidad del sistema para \(K=1\).
- En caso de inestabilidad, la cantidad de polos ubicados en el semiplano derecho.

## Consideraciones
- La cantidad de ceros debe ser un entero mayor o igual que cero.
- La cantidad de polos debe ser un entero mayor que cero.
- Los polos pueden ser reales o complejos.
- En caso de utilizar polos complejos, se debe ingresar también su conjugado.
- La ganancia de lazo cerrado está establecida en \(K=1\).
