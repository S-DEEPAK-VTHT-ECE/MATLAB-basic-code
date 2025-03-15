
function [y,Et,Et_approx]=LinearWaveProp(a,b);

% Script to model the interference between 2 point sources
% separated by a distance d and on a line parallel to a screen
% at a distance D.
% variables names as in Fig. 1 in the lab. script
%
% CHANGE THESE VALUES ACCORDING TO YOUR EXPERIMENTAL SETUP:
d=a;             % separation between the sources (in m)
D=b;             % distance from sources to screen (in m)
lambda=0.03;        % wavelength (in m)
k=2*pi/lambda;
%
x=-0.5:0.001:0.5;   % to cover 50 cm at either side of the centre
theta1=atan((d/2-x)/D);
theta2=atan((d/2+x)/D);
l1=D./cos(theta1);
l2=D./cos(theta2);
j=0+i;
Et=exp(-j*k*l1)./l1+exp(-j*k*l2)./l2;
Et=Et.*conj(Et)/(max(Et)^2);

Et_approx=2/D*cos((k*d*x)/(2*D)); %code to plot the approximation of the intensity
Et_approx=Et_approx.*conj(Et_approx)/(max(Et_approx)^2);

%
y=x*100;            % converting to cm

% line([-0.5 0.5],[1 1],'linestyle',':')
% text(-0.48, 1.1,'drawn by {\bf <...insert your name here...> }')
end
