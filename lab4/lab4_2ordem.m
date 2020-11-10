close all; %fecha todas as figuras
clear all; %limpa todas as variáveis
clc; %limpa o terminal

pkg load control;
s = tf('s');

t = 0:0.01:5;

%do enunciado:
gama = 1.5;
yp =  2.2900;
t_esstab = 3.98;

pss = 100* (yp - gama)/gama;
E = (log(100/pss)/(sqrt(pi^2+(log(100/pss))^2)));
wn = 4/(t_esstab*E);
wd = wn*sqrt(1-E^2);
t_pico = pi/wd;

T = 1/E*wn;

P = gama*wn^2/(s^2+2*E*wn*s+wn^2)

y = step(P,t);
plot(t,y);
hold on;
grid minor on;
px1 = t_pico;
py1 = yp;
ponto_h = plot(px1,py1,'sk','markerfacecolor','k');

px2 = t_esstab;
py2 = gama;
ponto2_h = plot(px2,py2,'sk','markerfacecolor','k');

%text_h = text(px1+0.05,py1+0.05, "yp=2.29");

title_h = title('Resposta ao degrau', 'fontsize', 20);
xlabel_h = xlabel('Tempo(s)', 'fontsize', 15);
ylabel_h = ylabel('Amplitude', 'fontsize', 15);

eixox_h = plot([0,5],[gama gama], '--r','linewidth',0.5);

