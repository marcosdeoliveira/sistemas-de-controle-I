close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');

t = 0:0.01:10; %tempo em analise

%dados do enunciado:
P = ( 400/(s^2 + 30*s + 200) ) %modelo da planta
Eest = 0.1; %erro estacionário desejado
R = 1/s^2

%encontrouse um controlador proporcional
%que garante o erro estacionario com valor desejado
K = 5/s

G = K*P

H=1;

T = G/(1+G*H) %funcao de transferencia no ramo direto

%E = R/(1+G)


Y = step(T/s,t); %

Y2 = step(1/s,t); %erro

E = Y2-Y
figure,plot(t, Y, "-b", t, Y2, "-r")
plot(t,E,"--g")
