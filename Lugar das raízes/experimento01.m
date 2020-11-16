clc;
clear all;

pkg load control;
s=tf('s');

K=1;
H=1;
P = 1/(s*(s^2+4*s+5));
##G = P*K;
##T = G/(1+G*H);


##p = pole(T);
##z = zero(T);
##
##if(length(p)>length(z))
##  o = zeros(length(p),1);
##  z_aux = zeros(length(p),1);
##  for(i=1:(length(z)))
##    z_aux(i) = z(i);
##  endfor
##  z = z_aux;
##endif

##p = (sort(p,"descend"));
##z = (sort(z,"descend"));

##for(i=1:(length(p)))
##  if(abs(p(i)-z(i))>0.001)
##    o(i) +=p(i);
##   endif
##endfor;

##o = sort(o,"descend");



##pzmap(T);

%rlocus(P*H);

for(K=0:3)
  G = P*K;
  T = G/(1+G*H);
##  pzmap(T);
  p = pole(T)
  a = zeros(length(p),1);
  b = zeros(length(p),1);
  for(i=1:(length(p)))
    a(i) += real(p(i));
    b(i) += imag(p(i));
  endfor;
  plot(a,b,"*");
  hold on; 
 
endfor

legend("K=0","k=1", "k=2", "K=3") 

##for(K=0:3)
##  v = int2str(K)
##  
##endfor