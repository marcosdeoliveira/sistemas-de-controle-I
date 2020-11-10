close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');

t_1ordem = 0:0.05:18;

%do enunciado para o sistema de 1 ordem
cte_tempo =  2-0.271;
gama_1ordem = 0.5;

P_1ordem = gama_1ordem/(cte_tempo*s +1)

y_1ordem = step(P_1ordem,t_1ordem);

figure,plot(t_1ordem,y_1ordem);

hold on

%adiciona ponto na primeira constante de tempo
px_1ordem = cte_tempo;
py_1ordem = gama_1ordem*0.63212;
ponto_h = plot(px_1ordem,py_1ordem,'sk','markerfacecolor','k');

%informacoes no grafico
title_h = title('Resposta ao degrau', 'fontsize', 20);
xlabel_h = xlabel('Tempo(s)', 'fontsize', 15);
ylabel_h = ylabel('Amplitude', 'fontsize', 15);

%adiciona representação da entrada
eixox_h = plot([0,18],[gama_1ordem gama_1ordem], '--r','linewidth',0.5);
axis([0,18, 0,0.55]);
hold off
