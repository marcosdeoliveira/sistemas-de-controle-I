#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Marcos vinícius Fabiano de Oliveira
  11067212
  Noturno
  
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}

%% limpa todos os dados, o terminal e fecha todas as janelas abertas
clc;
close all;
clear all;

%%  configurações para a simulação
t_max = 20;
% vetor de tempo
t = 0:0.01:t_max; 
% pacote de controle
pkg load control;
% operador de Laplace
s = tf('s');

%%  dados do enunciado
m= 1000;
b = 400;
t_estab = 10;
pss = 0.07;
vel_kmh = 90;
vel_ms = vel_kmh/3.6;

%%  modelado a partir do enunciado
P = (1) / (1*(m*s + b))
H=1;

%  determinados a partir de análise
ganho_estatico = 1;
fator_amort = 0.7; 
freq_nat = 0.65;


#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      Determinando K para o sistema
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}
    K_num = (m*ganho_estatico*freq_nat^2)*s + b*ganho_estatico*freq_nat^2;
    K_den = s^2 + 2*(fator_amort*freq_nat)*s +freq_nat^2 -ganho_estatico*freq_nat^2;

    K = K_num / K_den;

    %% Funções de transferencia
    % função de transferencia COM o controlador K calculado
    T_ck = K / (m*s + b + K);
    % função de transferencia SEM o controlador K calculado
    K_i =1;
    T_sk = feedback(K_i*P,H);

#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      Resposta ao degrau unitário
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}
    Y_sk = step(T_sk,t);
    Y_ck = step(T_ck,t);

    %% gráfico de resposta SEM o controlador calculado
    figure, plot(t, Y_sk, "-b;Malha fechada sem controlador;");
    % adiciona informações ao gráfico
    grid on;
    title('Resposta ao degrau unitário', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    axis([0 20 0 0.003]);

    %% gráfico de resposta COM o controlador calculado
    figure, plot(t, Y_ck, "-b",[min(t), max(t)],[1 1], '--r',[min(t), max(t)],[1+pss 1+pss], "--g" );
    % adiciona informações ao gráfico
    grid on;
    legend("Malha fechada com controlador","Degrau unitário","Máximo sobresinal",'location','southeast', 'orientation','vertical');
    title('Resposta ao degrau unitário', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    axis([0 20 0 1.2]);

    %% gráfico de resposta COM o controlador calculado na região de sobressinal
    figure, plot(t, Y_ck, "-b",[min(t), max(t)],[1 1], '--r')
    hold on;
    plot([min(t), max(t)],[1+pss 1+pss], "--g",[min(t), max(t)],[1+0.02 1+0.02], "-y",[min(t), max(t)],[1-0.02 1-0.02], "-y");
    % adiciona informações ao gráfico
    grid on;
    legend("Malha fechada com controlador","Degrau unitário","Máximo sobresinal","T_{2%}",'location','southeast', 'orientation','vertical');
    title('Resposta ao degrau unitário', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    % configura a exibição na região de interesse
    axis([2 20 0.9 1.1]);
    xticks([3:1:20]);
    yticks([0.95 0.98 1 1.02 1.05 1.07]);
    hold off;


    %% Gráfico de erro estacionario
    % sinal de referencia [degrau unitário]
    sig_ref = impulse(1/s,t);
    Y_erro = sig_ref - Y_ck;
    figure, plot(t, Y_erro,"-b");
    % adiciona informações ao gráfico
    grid on;
    legend("Malha fechada com controlador");
    hold on;
    plot([min(t), max(t)], [0 0], "--r");
    title_h = title('Erro estacionario', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    hold off;


#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      Enfim aplicando ao nosso problema
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}
    %% Resposta a entrada de velocidade
    Y_ck = step(vel_ms*T_ck,t);

    %% gráfico de resposta COM o controlador calculado
    figure, plot(t, Y_ck, "-b",[min(t), max(t)],[vel_ms vel_ms], '--r')
    hold on;
    plot([min(t), max(t)],[vel_ms*(1+pss) vel_ms*(1+pss)], "--g",[min(t), max(t)],[vel_ms*(1+0.02) vel_ms*(1+0.02)], "-y",[min(t), max(t)],[vel_ms*(1-0.02) vel_ms*(1-0.02)], "-y");
    % adiciona informações ao gráfico
    grid on;
    legend("Malha fechada com controlador","Degrau unitário","Máximo sobresinal","T_{2%}",'location','southeast', 'orientation','vertical');
    title('Resposta a entrada de velocidade', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    ##axis([0 20 0 1.2]);

    %% gráfico de resposta COM o controlador calculado na região de sobressinal
    figure, plot(t, Y_ck, "-b",[min(t), max(t)],[vel_ms vel_ms], '--r')
    hold on;
    plot([min(t), max(t)],[vel_ms*(1+pss) vel_ms*(1+pss)], "--g",[min(t), max(t)],[vel_ms*(1+0.02) vel_ms*(1+0.02)], "-y",[min(t), max(t)],[vel_ms*(1-0.02) vel_ms*(1-0.02)], "-y");
    % adiciona informações ao gráfico
    grid on;
    legend("Malha fechada com controlador","Degrau unitário","Máximo sobresinal","T_{2%}",'location','southeast', 'orientation','vertical');
    title('Resposta a entrada de velocidade', 'fontsize', 15);
    ylabel('Amplitude', 'fontsize', 15);
    xlabel('Tempo(s)', 'fontsize', 15);
    % configura a exibição na região de interesse
    axis([3 13 19.5 28]);
    xticks([4:1:12]);
    yticks([20 21 22 23 24 vel_ms*(1-0.02) 25 vel_ms*(1+0.02) 26 vel_ms*(1+pss) 27]);
    hold off;
