# Introdução ao octave

## Referência

[https://www.youtube.com/watch?v=ymMU8fbMbUU](https://www.youtube.com/watch?v=ymMU8fbMbUU)

## Principais comandos

### **Vetores**

---

Criar um vetor t de 0 até 20 com espaçamento de 0.005 é simples assim:

```matlab
t = 0:0.005:20;
```

Para criar um vetor linearmente espaçado entre 100 pontos que vai de 0 até 20:

```matlab
t = linspace(0,20,100);
```

Existem diversas funções que podem ser utilizadas no Octave, algumas delas são:

- seno: sin(x)
- cosseno: cos(x)
- e^x: exp(x)
- fazer o quadrado de cada termo em x: x.*x

### Gráficos

---

Os gráficos podem ser plotados por diferentes comandos. Se considerarmos as funções y,h e z em função do vetor x

```matlab
x = linspace(-2*pi, 2*pi, 100);
y = sin(x);
h = cos(x);
z = exp(x);
```

Podemos plotar um gráfico simples

```matlab
plot(x,y);
```

Mas também podemos exibir mais de um deles em nossa tela

```matlab
plot(x,y);
hold on;
plot(x,h);

//ou ainda

plot(x,y, x,h);
```

As funções podem ser agrupadas em uma matriz **A** e depois plotadas todas de uma vez em função de **x**:

```matlab
A = [y;h;z];

plot(x,A)
```

Podemos editar as grades utizando

```matlab
grid on;
grid minor on;

grid off;
grid minor off;
```

E ajustar os limites de cada eixo

```matlab
axis([x_min, x_max, y_min, y_max]);
```

### Adicionando Informações

---

### 1- Ponto

Agora que já sabemos como plotar um gráfico de diferentes maneiras precisamos entender como adicionar informações importantes para o leitor.

A primeira informação importante é ressaltar um **ponto** em nosso gráfico. Para isso vamos utilizar um manipulador, para facilitar mudar a posição e os atributos do nosso **ponto**

```matlab
px = 0;
py = 1;

//adicionando nosso ponto a um manipulador na hora de plotar
ponto_h = plot(px,py)
```

isso nos permite deletar apenas o ponto que foi plotado

```matlab
delete(ponto_h)
```

Também podemos modificar a maneira como o ponto será representado. Inicialmente não escolhemos nem a cor nem sei seu "tamanho", mas podemos fazer utilizando:

```matlab

ponto_h = plot(px,py,'ok','markerfacecolor','k');
```

Sobre os parâmetros utilizados:

**'ok'**

**o** - fará um círculo em volta do ponto px,py

**k** - fará o círculo na cor preta. Poderia ser **r** , **g** , **y** , **b** ...

'markerfacecolor'

pinta o interior do círculo 

### 2- Texto

De maneira semelhante podemos adicionar um **texto** 

```matlab
text_h = text(px,py, "this is a text");
```

### 3- Linhas personalizadas

Podemos add parâmetros à função plot() para personalizar as linhas e pontos em nossos graficos.
Considere as mesmas funções **y**, **z** e **h** em função de **x**

```matlab
plot_h = plot(x,y, '-r','linewidth', 3,'marker', 'o', 'markerfacecolor','r')
```

**' -r '** : linha continua vermelha

' **-** ' linha contínua

'**- -** ' linha tracejada

' ***** ' sem linha, somente asteriscos

' **p** ' sem linha, somente pentagrama

' **b** ' linha azul

' **k** ' linha preta

' **g** ' linha verde

A vantagem de usar o manipulador plot_h é que torna possível ocultar funções

```matlab
plot_h = plot(x,y, x,z, x,h);

//ocultar tudo
set(plot_h, 'visible', 'off')

//reaparecer com tudo
set(plot_h, 'visible', 'on')

//desaparecer somente com a primeira função plotada (x,y)
set(plot_h(1), 'visible', 'off')
```

### 4- Título para a imagem

```matlab
title_h = title('Funcoes elementares', 'fontsize', 20)
```

### 5- Label para os eixos

```matlab
xlabel_h = xlabel('título eixo x', 'fontsize', 20)
```

```matlab
ylabel_h = ylabel('título eixo y', 'fontsize', 20)
```

### 6- Legenda para as funções

É importante inserir os parâmetros na mesma ordem utilizada na hora de plotar

```matlab
legend_h = legend('primeira_func', 'segunda_func' , 'terceira_func')
```

Podemos modificar a localização e orientação da legenda com os parâmetros

```matlab
'location' < 'northeast', 'northwest', 'southeast', 'southwest' >
'orientation' < 'horizontal' , 'vertical' >

legend_h = legend('sen(x)','cos(x)','exp(x)', 'location','northeast', 'orientation','vertical')
```

### 7- Eixos X e Y

Não existe uma função específica para traçar os eixos, assim sobra a gambiarra

```matlab
hold on

eixox_h = plot([x_min, x_max],[0 0], '-k','linewidth',2)
eixoy_h = plot([0 0],[y_min, y_max], '-k','linewidth',2)

axis([x_min,x_max , y_min,y_max])
```

### Salvando o gráfico final

---

Pode ser feito clicando em salvar na janela que apresenta o gráfico ou través dos comandos:

```matlab
print -dpng umNome.png
print -djpg umNome.jpg
print -dpdf umNome.pdf
```