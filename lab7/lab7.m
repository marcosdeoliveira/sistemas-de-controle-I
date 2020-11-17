%% Controlador PID
clc;
close all;
clear all;

pkg load control;

%% operador de Laplace
s = tf('s');

%% imprimir graficos
global print_on = false;

%% vetor de tempo
t = 0:0.01:5;

P_num = 1
P_den = ( 1*( (s+3)*(s+6)*(s+10) ) );

P = P_num / P_den
H=1;

sobresinal = 0.1;
max_sobresinal = [(1+sobresinal) (1+sobresinal)];


%% calcula a função de transferencia para diferentes parametros do PID
function trasFunction = atualizaControlador(kp, ti, td, energy=0)
  s = tf('s');
  t = 0:0.01:5;
  P_num = 1;
  P_den = ( 1*( (s+3)*(s+6)*(s+10) ) );
  P = P_num / P_den;
  
  H=1;
  
  Kcr = 1872;
  freq = sqrt(108);
  Pcr = (2*pi) / freq  
  Kp = kp*0.6*Kcr;
  Ti = ti*0.5*Pcr;
  Td = td*0.125*Pcr;

  K_pid = Kp*( 1+ ( 1/(Ti*s) ) + (Td*s) );

  G = K_pid*P;
  
  if(energy==1)
  %% sinal de saída do do controlador
  %% T_ctrl_input relaciona o sinal saída do controlador [U(s)]
  %% com o sinal entrada do sistema [R(s)]
  
  T_ctrl_input = K_pid / (1+K_pid*P*H);
  
  Y_sig = step(T_ctrl_input,t); % <- acontece algum erro aqui!!!

  %% grafico com a energia demandada do controlador no tempo
  figure,plot(t, Y_sig,[min(t), max(t)],[1 1], '--r','linewidth',1);
  hold on;
  %% adiciona informações ao gráfico
  plot([min(t), max(t)], [0 0], "--r");
  legend("sinal controlador",'location','northeast', 'orientation','vertical');
  title_h = title('Resposta ao Degrau', 'fontsize', 15);
  xlabel('Tempo(s)', 'fontsize', 15);
  ylabel('Amplitude', 'fontsize', 15);
##  if(print_on)
##  print -djpg energiaControlador.jpg
##  endif
  endif

##  trasFunction  = G/(1+G*H);
  trasFunction = feedback(K_pid*P,H);
endfunction


%% parmetros originais
T1 = atualizaControlador(1, 1, 1);
y1 = step(T1,t);

%% ajuste em Kp
T2 = atualizaControlador(0.07, 1, 1);
y2 = step(T2,t);

%% ajuste em Ti
T3 = atualizaControlador(1, 10, 1);
y3 = step(T3,t);

%% ajuste em Td
T4 = atualizaControlador(1, 1, 4);
y4 = step(T4,t);

%% ajuste final
T5 = atualizaControlador(0.9, 1, 4);
y5 = step(T5,t);

%% sinal de referencia [degrau unitário]
sig_ref = impulse(1/s,t);

%% teste de valores de parâmetros
figure, plot(t, y1, "-k", t, y2, "-b",t, y3, "-y",t, y4, "-g");
hold on;
plot([min(t), max(t)], max_sobresinal,"--r", t ,sig_ref,"-r");
legend("sem ajuste","Kp = 0.07", "Ti = 10", "Td = 4", "max sobresinal","degrau");
title_h = title('Ajuste de parametros', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);
hold off;

if(print_on)
  print -djpg testeParametros.jpg
endif

%% valores finais para o controlador PID
figure, plot(t, y5, "-b");
hold  on;
plot([min(t), max(t)], max_sobresinal,"--r", t ,sig_ref,"-r");
legend("Kp=0.9, Ti=1, Td=4","max sobresinal","degrau");
title_h = title('PID calibrado', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);
hold off;

if(print_on)
  print -djpg controladorFinal.jpg
endif

%% erro estacionario
y_erro =sig_ref - y5;
figure, plot(t, y_erro,"-b");
legend("PID calibrado");
hold on;
plot([min(t), max(t)], [0 0], "--r");
title_h = title('Erro estacionario', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);
hold off;

if(print_on)
  print -djpg erroEstacionario.jpg
endif