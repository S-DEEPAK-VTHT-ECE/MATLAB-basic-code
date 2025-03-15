function[y,M1]=idft(x,s,n_c)
%QAM Modulation in binary encoded
dataMod = qammod(x,n_c,'bin');


m=length(s);
xk=zeros(1,m);
for k=0:m-1;
 for n=0:m-1;
xk(k+1)=xk(k+1)+(1/m)*x(n+1)*exp((i)*2*pi*k*n/m);
 end
end
y=xk
M=sqrt(real(y).^2+imag(y).^2)
M1=abs(y)

end