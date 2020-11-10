close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');

t = 0:0.05:10; %tempo em analise

%dados do enunciado:
P = ( 400/(s^2 + 30*s + 200) ) %modelo da planta
Eest = 0.1; %erro estacionário desejado
R = 1/s^2

%encontrouse um controlador proporcional
%que garante o erro estacionario com valor desejado
K = 230*Eest/400 

G = P*K

T = G/(1+G) %funcao de transferencia no ramo direto

Y = ramp(T,t);

plot(t, Y, "-b", t,t,"--r")
