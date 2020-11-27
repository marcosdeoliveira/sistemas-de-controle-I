#{
massa_veiculo = m;
forca_motor = u(t);
forca_atrito = b*v(t);

sáida = v(t) [velocidade do carro]
entrada = u(t) [força resultante]
m = 1000 kg;
b = 400 Ns/m; [coeficiente de atrito viscoso]

1 - Determinar a função de transferencia

2 - Projete um controlador com:
      sobresinal: 7%;
      t_estab: 2% menor que 10s;
      erro estacionario nulo ao degrau -> pelo menos um sistema tipo 1
    Mostre a eficacia do sistema
3 - Simule o sistema para velocidade ref de 90Km/h com vel inicial 0Km/h
#}

clc;
close all;
clear all;

pkg load control;
s = tf('s');

## para a simulação
t_max = 50;
t = 0:0.01:t_max; %vetor de tempo

m= 1000;
b = 400;
vel_kmh = 90;
vel_ms = vel_kmh*3.6;

f_amort = 0.7; 
freq_nat = 0.65;

P = (1) / (1*(m*s + b))

##P = 0.1/((s+1)*(s+0.5))
K=1;


#{ 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Calculando a posição dos polo e zero para o controlador por avanço
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}


## polos necessários para satisfazer freq_nat e cte_tempo
  polo_desejado_01 = -f_amort*freq_nat + freq_nat*sqrt(1-(f_amort^2))*j
  polo_desejado_02 = -f_amort*freq_nat - freq_nat*sqrt(1-f_amort^2)*j;

#{
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  É necessario alterar o lugar das raízes para usar os polos desejados
  O primeiro passo é determinar o angulo que falta para os polos desejados
  fazerem parde do lugar das raízes. Então iremos determinar:
    - comportamento em malha aberta para os polos desejados
    - graus que o controlador deve adicionar para satisfazer a condição
    de angulo
    - posição no eixo real do zero do controlador
    - posição no eixo real do polo do controlador
   Ao posicionar o polo e o zero no local projetado teremos alterado o 
   lugar das raízes restando por fim o calculo do ganho Kc que posiciona os
   polos do sistema proximos dos polos desejados
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#}

## resposta do sistema em malha aberta para os polos desejados [P(s)*H(s)]
%escolhendo o polo com parte imaginaria positiva e considerando
% a realimentação unitária teremos:
% P = 1 / (m*s + b)
H=1
malha_fechada = 1 / (m*polo_desejado_01 + b);

%% encontrando algulo que deve ser corrigido
  ang_correcao = 180 - rad2deg(angle(malha_fechada))
##  ang_correcao = ang_correcao * (rad2deg(angle(malha_fechada))/(abs(rad2deg(angle(malha_fechada)))))

%% Determinando a posição do 'zero' e do 'polo' para o controlador

  % Calculamos a distancia entre o zero do controlador e o eixo imaginario
  % forçamos que ele fique na projeção no eixo real do polo desejado
  distZeroYImg = abs(real(polo_desejado_01));
  % Calculamos distancia entre o polo e o zero para o controlador
  distPoloZero = abs(imag(polo_desejado_01)*tan(deg2rad(ang_correcao)));
  
  % Por fim:
  zero_controlador = real(polo_desejado_01)
  polo_controlador = -(distPoloZero+distZeroYImg)

%% Determinando Kc pela condição de modulo |Ks*P*H|=1 no polo desejado
Ks_aux = (polo_desejado_01 + (-1*zero_controlador))/(polo_desejado_01+(-1*polo_controlador));
Kc = 1/ abs(Ks_aux * malha_fechada)
%% Finalmente nosso controlador:
Ks = (s + (-1*zero_controlador))/(s +(-1*polo_controlador));
Ks = Ks*Kc

##rlocus(Ks*P);
Gks = Ks*P
##T_ks = Gks/(1+Gks*H);
T_ks = feedback(Ks*P,H);
polos_sist = pole(T_ks); %polos dos sistema controlado
printf("polos do sistema controlado =\n");
disp(polos_sist);
## resposta em malha fechada COM o controlador
Y_ks = step(T_ks,t);

## Fechando a malha SEM o controlador
K = 1;
Gk1 = K*P
##T_k1 = Gk1/(1+Gk1*H);
T_k1 = feedback(K*P,H);
## resposta em malha fechada SEM o controlador
Y_k1 = step(T_k1,t);

## grafico com as respostas com e sem o controlador
figure
plot_h = plot(t,Y_ks,"-b",t,Y_k1,"-g", [min(t), max(t)],[1 1], '--r','linewidth',1);
set(plot_h(2), 'visible','off');
## adiciona informações ao gráfico
legend("com contolador","sem controlador",'location','northeast', 'orientation','vertical');
title_h = title('Resposta ao degrau', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);

%% sinal de referencia [degrau unitário]
sig_ref = impulse(1/s,t);

%% erro estacionario
y_erro =sig_ref - Y_ks;
figure, plot(t, y_erro,"-b");
legend("PID calibrado");
hold on;
plot([min(t), max(t)], [0 0], "--r");
title_h = title('Erro estacionario', 'fontsize', 15);
xlabel('Tempo(s)', 'fontsize', 15);
ylabel('Amplitude', 'fontsize', 15);
hold off;

##%% Lugar das raízes para a planta + polos desejados
##rlocus(P);
##hold on;
##px1 = -0.455;
##py1 = 0.494;
##px2 = px1;
##py2 = -py1;
##plot(px1,py1,'ok;polos desejados;','markerfacecolor','r');
##plot(px2,py2,'ok','markerfacecolor','r');
##axis([-0.46 -0.4 -0.52 0.52]);
