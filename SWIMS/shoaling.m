%shoaling coefficent
function [Ho] = shoaling(H2,T,dep);

g = 9.81;
Co = g/(2*pi)*T;
[k n c] = dispersion((2*pi)/T,dep);
Cg2 = n*c;

Ho = H2/sqrt(Co/(2*Cg2));

clear Co k n c Cg2
