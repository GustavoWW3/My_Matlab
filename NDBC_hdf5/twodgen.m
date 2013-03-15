function [ef2d] = twodgen(ef,fr,delf,r1,r2,alp1,alp2,dep)

rad = pi/180;
% angle
nfre = length(fr);
for ii = 1:nfre
    xk = wavnum(fr(ii),dep);
    c22(ii,1) = ef(ii) * (xk*xk)/2 * (1 - r2(ii) * cos(2*alp2(ii)*rad));
    c33(ii,1) = ef(ii) * (xk*xk)/2 * (1 + r2(ii) * cos(2*alp2(ii)*rad));
    c23(ii,1) = ef(ii) * (xk*xk)/2 * r2(ii) .* sin(2.*alp2(ii)*rad);
    q12(ii,1) = -ef(ii) * xk * r1(ii) * sin(alp1(ii)*rad);
    q13(ii,1) = -ef(ii) * xk * r1(ii) * cos(alp1(ii)*rad);
end

ef2d = mlm(fr,ef,c22,c33,c23,q12,q13);