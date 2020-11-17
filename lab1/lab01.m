t = 0:0.005:20;
amp =  2.5;
w = 6.28;

f = exp(-0.3*t);
r = amp*sin(w*t);
g = f.*r;

hold on

plot_h = plot(t,f,'-r','linewidth',2,t,r,'-b','linewidth',2,t,g,'-g','linewidth',2);
set(plot_h, 'visible','off');

#grafico da questao01
set(plot_h(1), 'visible','on');

#informaçoes para o grafico da questao01
grid minor on
xlabel_h = xlabel('tempo', 'fontsize',15)
ylabel_h = ylabel('resposta no tempo', 'fontsize',15);
title_h = title('Funcao exponencial','fontsize',20);
legend_h = legend('f(t)=e^(-0,3t)', 'location','northeast', 'orientation','vertical');
axis([0,20, 0, 1]);

#salva resultado da questao01
print -dpng questao_01.png;


#grafico da questao02
set(plot_h(2), 'visible','on')

#informaçoes para o grafico da questao02
grid minor on
xlabel_h = xlabel('tempo', 'fontsize',15)
ylabel_h = ylabel('resposta no tempo', 'fontsize',15)
title_h = title('Funcoes exponencial e senoidal','fontsize',20);
legend_h = legend('f(t)=e^(-0,3t)', 'r(t)=2.5sen(6.28t)' , 'location','northeast', 'orientation','vertical');
axis([0,10, -3, 4]);

#salva resultado da questao02
print -dpng questao_02.png;

set(plot_h, 'visible','off');
set(plot_h(3), 'visible','on');

grid minor on
xlabel_h = xlabel('tempo', 'fontsize',15);
ylabel_h = ylabel('resposta no tempo', 'fontsize',15);
title_h = title ('Funcao composta', 'fontsize', 20);
legend_h = legend('g(t)=[e^(-0.3t)]*[2.5sin(6.28t)]', 'location', 'northeast', 'orientation', 'vertical');
axis([0,20,-2.2,3]);

#salva resultado da questao03
print -dpng questao_03.png;

close all;