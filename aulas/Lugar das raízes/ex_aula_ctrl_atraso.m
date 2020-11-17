## Controlador por atraso baseado no lugar das raízes
clc;
close all;
clear all;

pkg load control;
s = tf('s');
## para a simulação
t = 0:0.1:100;
%% imprimir graficos
global print_on = false;


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
##G = Ks*P;
##T = G/(1+(G*H));
T_cc = feedback((Ks*P),H);
y_cc = step(T_cc/s,t);

## resposta em malha fechada sem o controlador
K=1;
##G = Ks*P;
##T = G/(1+(G*H));
T_sc = feedback((K*P),H);
y_sc = step(T_sc/s,t);

## sinal de entrada
y_ref = step(1/s,t);

figure, plot(t,y_ref,"--r",t,y_cc,"-b",t,y_sc,"-g")
legend("referencia", "com controlador", "sem controlador");
title("resposta a rampa unitária");
xlabel("Tempo(s)");
ylabel("Amplitude");

## erro estacionário
erro_sc = y_ref - y_sc;
erro_cc = y_ref - y_cc;
figure, plot(t,erro_sc,"-r", t, erro_cc, "b");
legend("sem controlador", "com controlador");
title("Erro estacionário do sistema para rampa");
xlabel("Tempo(s)");
ylabel("Amplitude");

## resposta ao degrau
y_cc = step(T_cc,t);
y_sc = step(T_sc,t);
figure, plot(t,y_sc,"-r", t, y_cc, "b");
legend("sem controlador", "com controlador");
title("Resposta ao degrau");
xlabel("Tempo(s)");
ylabel("Amplitude");

%% sinal de saída do do controlador
%% T_ctrl relaciona o sinal saída do controlador [U(s)]
%% com o sinal entrada do sistema [R(s)]
T_ctrl = Ks / (1 + Ks*P*H);
Y_sig = step(T_ctrl,t);
figure, plot(t,Y_sig,"b");
legend("sinal de controle");
title("Resposta ao degrau");
xlabel("Tempo(s)");
ylabel("Amplitude");

