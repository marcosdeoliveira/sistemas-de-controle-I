close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control

s = tf('s'); %operador de laplace

% define se os graficos serão salvos
global print_on = false;

P = 1/(s*(s+7)*(s+11)) %planta
t_max = 30
t = 0:0.001:t_max;

% sistema estável: 0<K<1386
K_estavel = randi([1,1385])
G = K_estavel*P;
T_estavel = G/(1+G)
C_estavel = step(T_estavel,t);

plot(t, C_estavel); %resposta no tempo
title_h = title('Sistema estavel', 'fontsize', 20);
xlabel_h = xlabel('Tempo(s)', 'fontsize', 15);
ylabel_h = ylabel('c(t)', 'fontsize', 15);
hold on
eixox_h = plot([0, t_max],[1 1], '--r','linewidth',0.5) %eixo horizontal
hold off
if(print_on)
  print -dpng sistemaEstavel.png
endif;


% sistema instável: K<0 ou K>1386

if(rand()>0.5)
  K_instavel = -1*randi([1, 20])
else
  K_instavel = randi([1387, 1400])
endif

G = K_instavel*P;
T_instavel = G/(1+G)
C_instavel = step(T_instavel,t);

figure,plot(t, C_instavel); %resposta no tempo
title('Sistema instavel', 'fontsize', 20);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('c(t)', 'fontsize', 15);
hold on
plot([0, 30],[1 1], '--r','linewidth',0.5) %eixo horizontal
hold off
if(print_on)
  print -dpng sistemaInstavel.png
endif;

% sistema marginalmente estável: K = 1386
K_m_estavel = 1386
G = K_m_estavel*P;
T_m_estavel = G/(1+G)
C_m_estavel = step(T_m_estavel,t);


figure, plot(t, C_m_estavel); %resposta no tempo
title('Sistema marginalmente estavel', 'fontsize', 20);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('c(t)', 'fontsize', 15);
hold on
plot([0, 30],[1 1], '--r','linewidth',0.5) %eixo horizontal
hold off
if(print_on)
  print -dpng marginalmenteEstavel.png
endif;