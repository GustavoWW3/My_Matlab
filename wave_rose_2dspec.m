function wave_rose_2dspec(freq,ang,ef2d)

% plot a 2D spectrum into wave rose
% created TJ Hesser 10/26/11
%
%    freq : 1D array of frequency bands
%    ang  : 1D array of direction bands in radians
%    ef2d : 2D array of energy  ef2d(frequency,direction)

fmax = max(freq);
radcircl=0.02;
radcircl2=fmax;

[X Y] = meshgrid(freq,ang);
x1 = X.*sin(Y);
x2 = X.*cos(Y);

hold off
contour(x1,x2,ef2d','-')
hold on
a=(0:2:359)*pi/180;
plot(radcircl2*0.8*sin(a),radcircl2*0.8*cos(a),':')
a=(0:3:359)*pi/180;
plot(radcircl2*0.6*sin(a),radcircl2*0.6*cos(a),':')
a=(0:4:359)*pi/180;
plot(radcircl2*0.4*sin(a),radcircl2*0.4*cos(a),':')
a=(0:6:359)*pi/180;
plot(radcircl2*0.2*sin(a),radcircl2*0.2*cos(a),':')
r=0.04:radcircl:fmax;
plot(r*sin(pi/6),r*cos(pi/6),'--')
plot(r*sin(pi/3),r*cos(pi/3),'--')
plot(r*sin(5*pi/6),r*cos(5*pi/6),'--')
plot(r*sin(pi/2),r*cos(pi/2),'--')
plot(r*sin(7*pi/6),r*cos(7*pi/6),'--')
plot(r*sin(2*pi/3),r*cos(2*pi/3),'--')
plot(r*sin(4*pi/3),r*cos(4*pi/3),'--')
plot(r*sin(3*pi/2),r*cos(3*pi/2),'--')
plot(r*sin(5*pi/3),r*cos(5*pi/3),'--')
plot(r*sin(pi),r*cos(pi),'--')
plot(r*0.,r*1','--')
plot(r*sin(11*pi/6),r*cos(11*pi/6),'--')
axis('square')
t = colorbar;
set(get(t,'ylabel'),'String','S(f) (m^2/Hz)','VerticalAlignment','bottom','rotation',270);