function [ef2d] = twodgen(ef,fr,delf,r1,r2,alp1,alp2,dep)

rad = pi/180;
% angle
nfre = length(fr);
%for ii = 1:nfre
xk = wavnum(fr,dep)';
tmp = (xk.*xk)./2;
c22 = ef .* tmp .* (1 - r2 .* cos(2.*alp2.*rad));
c33 = ef .* tmp .* (1 + r2 .* cos(2.*alp2.*rad));
c23 = ef .* tmp .* r2.* sin(2.*alp2.*rad);
q12 = -ef .* xk .* r1 .* sin(alp1.*rad);
q13 = -ef .* xk .* r1 .* cos(alp1.*rad);


c11 = ef;
%find values where c11 is large enough for analysis
ii = c11 >= 1.0e-4;

d = zeros(size(c11));xk = zeros(size(c11));
a0 = zeros(size(c11));a1 = zeros(size(c11));
b1 = zeros(size(c11));a2 = zeros(size(c11));
b2 = zeros(size(c11));

% wave number from spectra
xk(ii) = sqrt((c22(ii) + c33(ii)) ./ c11(ii));

d(ii) = c11(ii).*c22(ii).*c33(ii) - c11(ii).*c23(ii).^2 - ...
    q12(ii).^2.*c33(ii) - q13(ii).^2.*c22(ii) + 2* ...
    q12(ii).*q13(ii).*c23(ii);

a0(ii) = 2*(c22(ii).*c33(ii) - c23(ii).^2)./d(ii) + (c11(ii).*c22(ii) + ...
    c11(ii).*c33(ii) - q12(ii).^2 - q13(ii).^2).*xk(ii).^2./d(ii);
a1(ii) = -2*(q12(ii).*c33(ii) - q13(ii).*c23(ii)).*xk(ii)./d(ii);
b1(ii) = 2*(q12(ii).*c23(ii) - q13(ii).*c22(ii)).*xk(ii)./d(ii);
a2(ii) = 0.5*(c11(ii).*c33(ii) - c11(ii).*c22(ii) - q13(ii).^2 + ...
    q12(ii).^2).*xk(ii).^2./d(ii);
b2(ii) = -(c11(ii).*c23(ii) - q12(ii).*q13(ii)).*xk(ii).^2./d(ii);

ef2d = mlm(fr,c11,a0,a1,b1,a2,b2);
%ef2d = mlm(fr,c11,c22,c33,c23,q12,q13);
%ainc =  pi/180;
%[sint cost sin2t cos2t] = angle_onlns(1,360);
%ef2d = mlm(fr,360,ainc,c11,c22,c33,c23,q12,q13,sint,cost,sin2t,cos2t);