clc;
close all;

clear all;

pkg load control;
s = tf('s');

%% imprimir graficos
global print_on = false;

## para a simulação
t_max = 6;
t = 0:0.01:t_max; %vetor de tempo

## Do enunciado:
P = 4 / (s*(s+2))
H = 1;
f_amort = 0.5; %subamortecido
cte_tempo = 0.5;

freq_nat = 1/(f_amort*cte_tempo);

## polos necessários para satisfazer freq_nat e cte_tempo
polo_desejado_01 = -f_amort*freq_nat + freq_nat*sqrt(1-f_amort^2)*j
polo_desejado_02 = -f_amort*freq_nat - freq_nat*sqrt(1-f_amort^2)*j;

## É necessario alterar o lugar das raízes para usar os polos desejados
## O primeiro passo é determinar o angulo que falta para os polos desejados
## fazerem parde do lugar das raízes

## resposta do sistema em malha aberta para os polos desejados [P(s)*H(s)]
malha_fechada = (4/(polo_desejado_01*(polo_desejado_01+2)))*H;

## encontrando algulo que deve ser corrigido
ang_correcao = 180 - rad2deg(angle(malha_fechada))

## trigonometria para encontrar o par de 'zero' e 'polo' contoladores
x = abs(imag(polo_desejado_01)*tan(deg2rad(ang_correcao)));
y = abs(real(polo_desejado_01));
polo_controlador = -(x+y)
zero_controlador = real(polo_desejado_01)

## Determinando Kc pela condição de modulo |Ks*P*H|=1 no polo desejado
Ks_aux = (polo_desejado_01 + (-1*zero_controlador))/(polo_desejado_01+(-1*polo_controlador));
Kc = 1/ abs(Ks_aux * malha_fechada)

## Fechando a malha COM o controlador
Ks = (s + (-1*zero_controlador))/(s +(-1*polo_controlador));
##rlocus(Ks*P);
Ks = Ks*Kc;
Gks = Ks*P;
T_ks = Gks/(1+Gks*H);
polos_sist = pole(T_ks); %polos dos sistema controlado
printf("polos do sistema controlado =\n");
disp(polos_sist);
## resposta em malha fechada COM o controlador
Y_ks = step(T_ks,t); 

## Fechando a malha SEM o controlador
K = 1;
Gk1 = K*P;
T_k1 = Gk1/(1+Gk1*H);
## resposta em malha fechada SEM o controlador
Y_k1 = step(T_k1,t);

## grafico com as respostas com e sem o controlador
figure, plot(t,Y_ks,"-b",t,Y_k1,"-g", [min(t), max(t)],[1 1], '--r','linewidth',1);
## adiciona informações ao gráfico
legend("com contolador","sem controlador",'location','northeast', 'orientation','vertical');
title_h = title('Resposta ao degrau', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

if(print_on)
  print -djpg stepResponse.jpg
endif;

## sinal de saída do do controlador
## T_ctrl_input relaciona o sinal saída do controlador [U(s)]
## com o sinal entrada do sistema [R(s)]
T_ctrl_input = Ks / (1+Ks*P*H);
Y_sig = step(T_ctrl_input,t);

## grafico com a energia demandada do controlador no tempo
figure,plot(t, Y_sig,[min(t), max(t)],[0 0], '--r','linewidth',1);
## adiciona informações ao gráfico
legend("sinal controlador",'location','northeast', 'orientation','vertical');
title_h = title('Resposta ao degrau', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

if(print_on)
  print -djpg ctrlSignal.jpg
endif;