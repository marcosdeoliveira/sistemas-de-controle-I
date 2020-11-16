## Controlador por atraso baseado no lugar das raízes
clc;
close all;
clear all;

pkg load control;
s = tf('s');
## para a simulação
t = 0:0.1:50;

P = 1.06 / (s*(s+1)*(s+2));
H = 1;

Kvel_com_ctrl = 5; %constante de erro de velocidade desejado
Kvel_sem_ctrl = 0.53; % lim com s-> 0 de sG(s)  [sem o controlador]

proporcao_Kvel = ceil(Kvel_com_ctrl/Kvel_sem_ctrl);

zero_adotado = -0.05;
polo_adotado = -(-zero_adotado/proporcao_Kvel);

## Determinando Kc
%  sabemos que Kvel_com_ctrl = lim(s->0) (s*Ks*P)
%  Ks = Kc*(s + (-zero_adotado)) / (s+(-polo_adotado))
%  P = 1.06 / (s*(s+1)*(s+2))
%  considerando lim s->0, temos:
%  Kvel_com_ctrl = Kc*10*(1.06/2)

Kc = Kvel_com_ctrl/(10*(1.06/2));

Ks = Kc*(s + (-zero_adotado)) / (s+(-polo_adotado))

## Lugar das raízes
figure, rlocus(P*H);
title("rlocus of P(s)*H(s)");
##hold on;
figure, rlocus(Ks*P*H);
title("rlocus of Ks(s)*P(s)*H(s)");

## resposta em malha fechada com o controlador
G = Ks*P;
T = G/(1+(G*H));
y_cc = step(T/s,t);
## resposta em malha fechada sem o controlador
Ks=1;
G = Ks*P;
T = G/(1+(G*H));
y_sc = step(T/s,t);

## sinal de entrada
y_ref = step(1/s,t);

figure, plot(t,y_ref,"--r",t,y_cc,"-b",t,y_sc,"-g")
legend("referencia", "com controlador", "sem controlador");
title("resposta a rampa unitária");
xlabel("Tempo(s)");
ylabel("Amplitude");
##erro_estacionario = y_ref - y_sc;
##figure, plot(t,erro_estacionario)
