clear all; close all; clc;

% Laboratorio de Control Automático GR20
% Estudiante: Luis Pablo Vargas Muñoz
% Carnet: 2021490483

% Parámetros de entrada ---------------------------------------------------

% Introducir valores de forma manual en el código (descomentar las líneas
% 11 hasta 15 antes de usar)
% KT = ;
% Ra = ;
% b  = ;
% Kb = ;
% J  = ;

% En caso de estar usando valores escritos de forma manual en el código, 
% comentar las líneas 19 hasta la 23
KT = input('Ingrese el valor de KT: ');
Ra = input('Ingrese el valor de Ra: ');
b  = input('Ingrese el valor de b: ');
Kb = input('Ingrese el valor de Kb: ');
J  = input('Ingrese el valor de J: ');

% Verificación de los parámetros de entrada
parametros = [KT Ra b Kb J];
nombres = {'KT','Ra','b','Kb','J'};

for i = 1:length(parametros)
    if ~isreal(parametros(i)) || parametros(i) <= 0
        error('%s debe ser un número real mayor que cero.', nombres{i});
    end
end

% Planta ------------------------------------------------------------------

% Coeficientes y constantes
KM = (KT)/((Ra*b)+(KT*Kb));     % Coeficiente de ganancia general
tau = (Ra*J)/((Ra*b)+(KT*Kb));  % Constante de tiempo

% Definición de la planta
s = tf('s');
G = KM/((tau*s)+(1));           % Planta G(s)

% Simulación de respuesta al escalón --------------------------------------

figure;
step(G);
grid on;
title('Respuesta al escalón unitario');

% Métricas de la respuesta al escalón unitario
S = stepinfo(G);                            % Información del escalón
valor_final = dcgain(G);                    % Valor final
ess = 1 - valor_final;                      % Error de estado estacionario
valor_tau = KM*(1-exp(-1));                 % Valor a 1 tau
valor_ts = KM*(1-exp(-S.SettlingTime/tau)); % Tiempo de asentamiento

% Graficación de puntos importantes ---------------------------------------

% Punto en tau
hold on
plot(tau, valor_tau, 'bo', 'MarkerFaceColor','b');
text(tau, valor_tau, '  t=\tau','Color','b');

% Punto en 5 tau
hold on
yline(valor_final,'--r')
plot(5*tau, valor_final,'ro', 'MarkerFaceColor','r')
text(5*tau, valor_final, '  t=5\tau','Color','r');

% Punto en tiempo de asentamiento
hold on
xline(S.SettlingTime,'--g')
plot(S.SettlingTime,valor_ts,'go','MarkerFaceColor','g');
text(S.SettlingTime,valor_ts,'  t_s','Color','g');

% Línea de referencia del escalón unitario (entrada = 1)
hold on
yline(1,':k','Referencia al escalón unitario');

% Error de estado estacionario
hold on
line([5*tau 5*tau],[valor_final 1], ...
    'Color','m','LineWidth',2);
text(5*tau*0.98,(1+valor_final)/2,...
    sprintf('e_{ss}=%.1f%%',ess*100),...
    'Color','m','HorizontalAlignment','right');

% Imprimir resultados finales en la consola -------------------------------

fprintf('\n----- Resultados -----\n');
fprintf('KM = %.5f\n', KM);
fprintf('tau = %.5f s\n', tau);
fprintf('\nPlanta G(s):\n'); G = KM/((tau*s)+(1))
fprintf('Valor en 5tau = %.5f s\n', 5*tau);
fprintf('Valor en tau = %.5f\n', valor_tau);
fprintf('Valor final = %.5f\n', valor_final);
fprintf('Tiempo de asentamiento (2%%) = %.5f s\n', S.SettlingTime);
fprintf('Error de estado estacionario = %.2f%%\n', ess*100);