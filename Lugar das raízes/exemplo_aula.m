clc;
close all;
clear all;

pkg load control;
s = tf('s');
## para a simulação
t = 0:0.01:6;

## do enunciado:
P = 10 / (s*(s+1))
H = 1;
f_amort = 0.5; %subamortecido
freq_nat = 3;

##polos necessários para satisfazer freq_nat e cte_tempo
polo_desejado = -f_amort*freq_nat + freq_nat*sqrt(1-f_amort^2)*j
polo_desejado_02 = -f_amort*freq_nat - freq_nat*sqrt(1-f_amort^2)*j;

## É necessario alterar o lugar das raízes para usar os polos desejados
## O primeiro passo é determinar o angulo que falta para os polos desejados
## fazerem parde do lugar das raízes

## substituindo o polo_desejado na malha fechada [P(s)*H(s)]
malha_fechada = (10/(polo_desejado*(polo_desejado+1)))*H;
## encontrando algulo que deve ser corrigido
ang_correcao = 180 - rad2deg(angle(malha_fechada))

## trigonometria para encontrar um par de zero e polo contoladores
x = abs(imag(polo_desejado)*tan(deg2rad(ang_correcao)));
y = abs(real(polo_desejado));
polo_controlador = -(x+y)
zero_controlador = real(polo_desejado)

## Determinando Kc pela condição de modulo |Ks*P*H|=1 no polo desejado
Ks_aux = (polo_desejado + (-1*zero_controlador))/(polo_desejado+(-1*polo_controlador));
Kc = 1/ abs(Ks_aux * malha_fechada)

##fechando a malha COM o controlador
Ks = (s + (-1*zero_controlador))/(s +(-1*polo_controlador));
rlocus(Ks*P);
Ks = Ks*Kc;

G = Ks*P;
T = G/(1+G*H);
## resposta em malha fechada com o controlador
Y_ks = step(T,t);


##fechando a malha SEM o controlador
K = 1;

G = K*P;
T = G/(1+G*H)
printf("polos do sistema controlado\n");
pole(T)
## resposta em malha fechada sem o controlador
Y_k1 = step(T,t);


## grafico com as respostas com e sem o controlador
figure,plot(t,Y_ks,"-b",t,Y_k1,"-g", [min(t), max(t)],[1 1], '--r','linewidth',1);
legend("com contolador","sem controlador",'location','northeast', 'orientation','vertical');

## sinal de saída do do controlador
T_ctrl_input = Ks / (1+Ks*P*H);
Y_sig = step(T_ctrl_input,t);
figure,plot(t, Y_sig,[min(t), max(t)],[0 0], '--r','linewidth',1);