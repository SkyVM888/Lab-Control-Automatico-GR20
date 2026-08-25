clear all; close all; clc;

% Laboratorio de Control Automático GR20
% Estudiante: Luis Pablo Vargas Muñoz
% Carnet: 2021490483

% Parámetros de entrada ---------------------------------------------------

% Cantidad de ceros y polos
cantidad_ceros = input('Ingrese el número de ceros de G(s): ');
cantidad_polos = input('Ingrese el número de polos de G(s): ');

% Verificación de la cantidad de ceros y polos
if ~isreal(cantidad_ceros) || cantidad_ceros < 0 || mod(cantidad_ceros,1) ~= 0
    error('El número de ceros debe ser un entero real mayor o igual que cero.');
end

if ~isreal(cantidad_polos) || cantidad_polos <= 0 || mod(cantidad_polos,1) ~= 0
    error('El número de polos debe ser un entero real mayor que cero.');
end

% Ubicación de los ceros
ceros = zeros(1,cantidad_ceros);
for i = 1:cantidad_ceros
    ceros(i) = input(sprintf('Ingrese la ubicación del cero %d: ', i));
end

% Ubicación de los polos
polos = zeros(1,cantidad_polos);
for i = 1:cantidad_polos
    polos(i) = input(sprintf('Ingrese la ubicación del polo %d (en caso de añadir un polo imaginario, debe añadir su conjugado como otro de los polos): ', i));
end

% Ganancia
K = input('Ingrese el valor de K: ');
% K = 1;

% Verificación de la ganancia K
if ~isreal(K) || K <= 0
        error('K debe ser un número real mayor que cero.');
end

% Planta ------------------------------------------------------------------

% Construcción de la planta
fprintf('\n----- Planta G(s) -----\n');
G = zpk(ceros, polos, 1)

% Función de transferencia de lazo cerrado
fprintf('\n----- Función de transferencia de lazo cerrado -----\n');
T = feedback(K*G, 1)

[num_T, den_T] = tfdata(T, 'v'); % Extraer numerador y denominador de T(s)
grado = length(den_T) - 1;       % Grado de la ecuación característica

% Ecuación característica de lazo cerrado
fprintf('\n----- Ecuación característica -----\n');
disp(den_T);

% Routh-Hurtwitz ----------------------------------------------------------

columnas = ceil((grado + 1)/2);                     % Número de columnas
Routh = zeros(grado + 1, columnas);                 % Inicializar matriz
Routh(1,1:length(den_T(1:2:end))) = den_T(1:2:end); % Primera fila
Routh(2,1:length(den_T(2:2:end))) = den_T(2:2:end); % Segunda fila

% Construir el resto de la tabla
for i = 3:grado+1
    for j = 1:columnas-1
        Routh(i,j) = ...
            (Routh(i-1,1)*Routh(i-2,j+1) - ...
             Routh(i-2,1)*Routh(i-1,j+1)) / ...
             Routh(i-1,1);
    end
end

% Visualizar la Matriz de Routh-Hurwitz
fprintf('\n----- Matriz de Routh-Hurwitz -----\n');
disp(Routh);

% Root Locus --------------------------------------------------------------

figure;
rlocus(G);  % Generar lugar de las raíces
hold on;

% Marcar ceros de lazo abierto
if cantidad_ceros > 0
    plot(real(ceros), imag(ceros), 'o', ...
        'MarkerSize', 10, ...
        'LineWidth', 2);
end

% Marcar polos de lazo abierto
plot(real(polos), imag(polos), 'x', ...
    'MarkerSize', 10, ...
    'LineWidth', 2);

grid on;
xlabel('Parte Real');
ylabel('Parte Imaginaria');
title('Lugar Geométrico de las Raíces');
legend('Root Locus', 'Polos de lazo abierto', ...
    'Ceros de lazo abierto');
hold off;

% Estabilidad -------------------------------------------------------------

primera_columna = Routh(:,1);

% Contar cambios de signo
cambios_signo = sum(primera_columna(1:end-1) .* ...
                    primera_columna(2:end) < 0);
if cambios_signo == 0 && all(primera_columna > 0)
    fprintf('\nEl sistema es ESTABLE para K = %.2f.\n', K);
    fprintf('No hay polos en el semiplano derecho.\n');
else
    fprintf('\nEl sistema es INESTABLE para K = %.2f.\n', K);
    fprintf('Cantidad de polos en el semiplano derecho: %d\n', cambios_signo);
end