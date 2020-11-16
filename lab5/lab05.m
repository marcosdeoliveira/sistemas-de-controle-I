close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');

t = 0:0.01:10; %tempo em analise

%dados do enunciado:
P = ( 400/(s^2 + 30*s + 200) ) %modelo da planta
Eest = 0.1; %erro estacionário desejado
R = 1/s; %sinal de entrada  

## Encontrouse um controlador proporcional
## que garante o erro estacionario com valor desejado K = 5/s
K = 5/s;
G = K*P;
H=1;
T = G/(1+G*H) %funcao de transferencia no ramo direto

## sinal de resposta do sistema
Y = step(T/s,t); 
## sinal de referencia (rampa unitaria)
Y2 = step(R,t);

## calculo do erro
E = Y2-Y

## Comportamento do sistema
figure,plot(t, Y, "-b", t, Y2, "--r")

legend("resposta do sistema","refer\ência");
title_h = title('Resposta a rampa unitária', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

## Comportamento do valor de erro
figure,plot(t,E,"-b",[min(t), max(t)],[Eest Eest], '--r','linewidth',1);

legend("erro estácion\ário");
title_h = title('Resposta a rampa unitária', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);