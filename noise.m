function [f,Axk,Ayk]=noise(d)

x = d;
fs = 12000;   					%Sampling rate
n = 0:1:19999;

N = length(x)						  %20000
f = [0:N/2]*fs/N;
Axk = 2*abs(fft(x))/N;Axk(1)=Axk(1)/2;  	

freqz(x,1)


 blo = fir1(133,0.14,chebwin(134,30));
 outlo = filter(blo,1,x);
 subplot(2,1,1);
t = (0:length(x)-1)/fs;
 
 ys = ylim;;
 subplot(2,1,2)

 ylim(ys);

figure(4)
Axk = 2*abs(fft(x))/N;Axk(1)=Axk(1)/2;  	

 Ayk = 2*abs(fft(outlo))/N;Ayk(1) = Ayk(1)/2;
 
end