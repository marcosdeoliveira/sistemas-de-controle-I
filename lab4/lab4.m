close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');
t_max = 18;
amp_max = 0.55;
resolution = 0.001;
t = 0:resolution:t_max;


%do enunciado para o sistema de 1 ordem
cte_tempo =  2-0.271;
gama_1ordem = 0.5;

P_1ordem = gama_1ordem/(cte_tempo*s +1)

C_1ordem = step(P_1ordem,t);

figure,plot(t,C_1ordem);

hold on

%adiciona ponto na primeira constante de tempo
px = cte_tempo;
py = gama_1ordem*0.63212;
plot(px,py,'sk','markerfacecolor','k');

%adiciona informacoes ao grafico
title('Resposta ao degrau', 'fontsize', 20);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

%adiciona representação da entrada
eixox_h = plot([0,18],[gama_1ordem gama_1ordem], '--r','linewidth',0.5);
axis([0,t_max, 0,amp_max]);
hold off

%do enunciado para o sistema de 2 ordem:
t_max = 5;
amp_max = 3;
t = 0:resolution:t_max;
gama = 1.5;
yp =  2.2900;
t_esstab = 3.98;

pss = 100* (yp - gama)/gama;
E = (log(100/pss)/(sqrt(pi^2+(log(100/pss))^2)));
wn = 4/(t_esstab*E);
wd = wn*sqrt(1-E^2);
t_pico = pi/wd;

cte_tempo = 1/E*wn;

P_2ordem = gama*wn^2/(s^2+2*E*wn*s+wn^2)

C_2ordem = step(P_2ordem ,t);

figure,plot(t,C_2ordem);
hold on;
#grid minor on;
%adiciona marcacao ao promeiro pico
px1 = t_pico;
py1 = yp;
plot(px1,py1,'sk','markerfacecolor','k');

%adiciona marcacao para t com 2% do tempo de estabilizacao
px2 = t_esstab;
py2 = gama;
plot(px2,py2,'sk','markerfacecolor','k');

%adiciona informacoes ao grafico
title_h = title('Resposta ao degrau', 'fontsize', 20);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

%adiciona representação da entrada
eixox_h = plot([0,t_max],[gama gama], '--r','linewidth',0.5);
axis([0,t_max, 0,amp_max]);
hold off;