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
polos = [];
i = 1;
while length(polos) < cantidad_polos
    nuevo_polo = input(sprintf('Ingrese la ubicación del polo %d: ', i));

    % Verificar si el nuevo polo es complejo
    if abs(imag(nuevo_polo)) > 1e-10

        % Verificar si todavía hay espacio para el conjugado
        if length(polos) + 2 > cantidad_polos
            error(['El polo introducido es complejo y requiere su conjugado. ' ...
                   'La cantidad de polos debe permitir formar el par conjugado.']);
        end

        % Agregar el polo complejo
        polos(end+1) = nuevo_polo;

        % Agregar automáticamente su conjugado
        polos(end+1) = conj(nuevo_polo);
        fprintf('Se agregó automáticamente el conjugado: %.4f %+.4fi\n',real(conj(nuevo_polo)), imag(conj(nuevo_polo)));
    else
        % Agregar polo real
        polos(end+1) = nuevo_polo;
    end

    % Siguiente entrada solicitada al usuario
    i = i + 1;
end

% Planta ------------------------------------------------------------------

% Construcción de la planta
fprintf('\n----- Planta G(s) -----\n');
G = zpk(ceros, polos, 1)

[num, den] = tfdata(G, 'v');    % Extraer numerador y denominador de G(s)

% Ecuación característica de lazo cerrado
fprintf('\n----- Ecuación característica -----\n');
disp(den);

% Root Locus --------------------------------------------------------------

figure;

% Dibujar lugar de las raíces
rlocus(G);
hold on;

% Crear objeto gráfico ficticio para la leyenda
h_root = plot(nan, nan, 'k-', 'LineWidth', 1.5);

% Marcar ceros de lazo abierto en AZUL
if cantidad_ceros > 0
    h_ceros = plot(real(ceros), imag(ceros), 'o','Color', 'b','MarkerSize', 10,'LineWidth', 2);
else
    h_ceros = [];
end

% Marcar polos de lazo abierto en ROJO
h_polos = plot(real(polos), imag(polos), 'x','Color', 'r','MarkerSize', 10,'LineWidth', 2);
grid on;
xlabel('Parte Real');
ylabel('Parte Imaginaria');
title('Lugar Geométrico de las Raíces');

% Crear la leyenda
if cantidad_ceros > 0
    legend([h_root, h_ceros, h_polos],'Root Locus','Ceros de lazo abierto','Polos de lazo abierto');
else
    legend([h_root, h_polos],'Root Locus','Polos de lazo abierto');
end
hold off;

% Modificación de polos ---------------------------------------------------

respuesta = input('\n¿Desea mover algún polo? (s/n): ', 's');

while lower(respuesta) == 's'

    % Mostrar los polos actuales
    fprintf('\n----- Polos actuales -----\n');
    for i = 1:length(polos)
        fprintf('%d: %.4f %+.4fi\n',i, real(polos(i)), imag(polos(i)));
    end

    % Seleccionar el polo que se desea mover
    indice = input('\nIngrese el número del índice del polo que desea mover (1, 2, 3, ...): ');

    % Verificar que el índice sea válido
    if indice < 1 || indice > length(polos) || mod(indice,1) ~= 0
        fprintf('Índice de polo no válido.\n');
    else
        polo_anterior = polos(indice);

        % Nueva ubicación del polo
        nuevo_polo = input('Ingrese la nueva ubicación del polo: ');

        % -----------------------------------------------------------------
        % Caso 1: El polo anterior es real
        % -----------------------------------------------------------------

        if abs(imag(polo_anterior)) < 1e-10

            % Si el nuevo polo también es real, se hace el cambio
            if abs(imag(nuevo_polo)) < 1e-10
                polos(indice) = nuevo_polo;

            % Si el nuevo polo es complejo
            else
                % Se reemplaza el polo original real por el nuevo polo complejo
                polos(indice) = nuevo_polo;

                % Se agrega automáticamente su conjugado
                polos(end+1) = conj(nuevo_polo);
            end

        % -----------------------------------------------------------------
        % Caso 2: El polo anterior es complejo
        % -----------------------------------------------------------------

        else
            % Buscar el conjugado del polo anterior
            indice_conjugado = find(abs(polos - conj(polo_anterior)) < 1e-10,1);

            % Si el nuevo polo es real
            if abs(imag(nuevo_polo)) < 1e-10

                % Reemplazar el polo complejo seleccionado
                polos(indice) = nuevo_polo;

                % Eliminar su conjugado
                if ~isempty(indice_conjugado) && indice_conjugado ~= indice
                    polos(indice_conjugado) = [];
                end

            % Si el nuevo polo es complejo
            else
                % Reemplazar ambos polos por el nuevo par conjugado
                polos(indice) = nuevo_polo;
                if ~isempty(indice_conjugado) && indice_conjugado ~= indice
                    polos(indice_conjugado) = conj(nuevo_polo);
                else
                    % Por seguridad, agregar el conjugado si no existe
                    polos(end+1) = conj(nuevo_polo);
                end
            end
        end
    end

    % $$$$$$$$$$$$$$$$$ Regraficación con los nuevo polos $$$$$$$$$$$$$$$$$
    
    % Actualizar la planta con los nuevos polos
    G = zpk(ceros, polos, 1);
    figure;
    
    % Dibujar lugar de las raíces
    rlocus(G);
    hold on;
    
    % Crear objeto gráfico ficticio para la leyenda
    h_root = plot(nan, nan, 'k-', 'LineWidth', 1.5);
    
    % Marcar ceros de lazo abierto en AZUL
    if cantidad_ceros > 0
        h_ceros = plot(real(ceros), imag(ceros), 'o','Color', 'b','MarkerSize', 10,'LineWidth', 2);
    else
        h_ceros = [];
    end
    
    % Marcar polos de lazo abierto en ROJO
    h_polos = plot(real(polos), imag(polos), 'x','Color', 'r','MarkerSize', 10,'LineWidth', 2);
    grid on;
    xlabel('Parte Real');
    ylabel('Parte Imaginaria');
    title('Lugar Geométrico de las Raíces');
    
    % Ajustar automáticamente los límites de los ejes
    axis padded;
    
    % Crear la leyenda
    if cantidad_ceros > 0
        legend([h_root, h_ceros, h_polos],'Root Locus','Ceros de lazo abierto','Polos de lazo abierto');
    else
        legend([h_root, h_polos],'Root Locus','Polos de lazo abierto');
    end
    hold off;

    % $$$$$$$$$$$$$$$$$ Fin de la regraficación $$$$$$$$$$$$$$$$$

    % Actualización de la lista de polos
    fprintf('\nPolos actualizados:\n');
        for i = 1:length(polos)
            fprintf('%d: %.4f %+.4fi\n',i, real(polos(i)), imag(polos(i)));
        end

    % Preguntar si desea mover otro polo
    respuesta = input('\n¿Desea mover otro polo? (s/n): ', 's');
end

% Compensador -------------------------------------------------------------

% Cantidad de polos
cantidad_polos_compensador = input('Ingrese el número de polos del compensador C(s): ');

% Verificación de la cantidad de polos del compensador
if ~isreal(cantidad_polos_compensador) || cantidad_polos_compensador < 0 || mod(cantidad_polos_compensador,1) ~= 0
    error(['El número de polos del compensador debe ser un entero real mayor o igual que cero.']);
end

% Ubicación de los polos del compensador
polos_compensador = [];
i = 1;

while length(polos_compensador) < cantidad_polos_compensador
    nuevo_polo_comp = input(sprintf('Ingrese la ubicación del polo del compensador %d: ', i));

    % Verificar si el nuevo polo del compensador es complejo
    if abs(imag(nuevo_polo_comp)) > 1e-10

        % Verificar si todavía hay espacio para el conjugado
        if length(polos_compensador) + 2 > cantidad_polos_compensador
            error(['El polo introducido es complejo y requiere su ' ...
                   'conjugado. La cantidad de polos del compensador ' ...
                   'debe permitir formar el par conjugado.']);
        end

        % Agregar el polo complejo del compensador
        polos_compensador(end+1) = nuevo_polo_comp;

        % Agregar automáticamente su conjugado
        polos_compensador(end+1) = conj(nuevo_polo_comp);

        fprintf(['Se agregó automáticamente el conjugado: %.4f %+.4fi\n'],real(conj(nuevo_polo_comp)),imag(conj(nuevo_polo_comp)));
    else
        % Agregar el polo real del compensador
        polos_compensador(end+1) = nuevo_polo_comp;
    end
    % Siguiente entrada
    i = i + 1;
end

% Mostrar los polos del compensador
fprintf('\n----- Polos del compensador C(s) -----\n');
for i = 1:length(polos_compensador)
    fprintf('%d: %.4f %+.4fi\n',i,real(polos_compensador(i)),imag(polos_compensador(i)));
end

% Construcción del compensador 
fprintf('\n----- Compensador C(s) -----\n');
C = zpk([], polos_compensador, 1)

% Sistema compensado ------------------------------------------------------

% Construcción del sistema compensado
fprintf('\n----- Sistema G(s)C(s) -----\n');
G_compensado = G*C

% Función de transferencia de lazo cerrado
fprintf('\n----- Sistema Compensado en lazo cerrado -----\n');
T = feedback(G_compensado, 1)

% Ecuación característica
[num_T, den_T] = tfdata(T, 'v');

fprintf('\n----- Ecuación característica del sistema compensado -----\n');
disp(den_T);

% Respuesta de los 3 sistemas al escalón unitario  ------------------------

% Respuesta al escalón de la planta G(s)
figure;
step(G);
grid on;
title('Respuesta al escalón de la planta G(s)');

% Respuesta al escalón del compensador C(s)
figure;
step(C);
grid on;
title('Respuesta al escalón del compensador C(s)');

% Respuesta al escalón del sistema compensado
figure;
step(T);
grid on;
title('Respuesta al escalón del sistema compensado');