%Calculate the Spectrum of a time series
%function [f,S,Hmo,fp] = spec (eta,dt,numwindows)
% 
% 
%
function [f,s,Hmo,fp] = spec (eta,dt,numwindows)

   reclen = floor(length(eta)/numwindows);
   df = 1/(reclen*dt);f=(1:reclen/2-1).*df;
   if size(eta,1)==1;ssmooth = zeros(reclen/2-1,1);
   else ssmooth = zeros(1,reclen/2-1);end
   ansmooth = ssmooth;bnsmooth = ssmooth;var1 = 0;
   for jj = 1:numwindows
     smalleta =eta((jj-1)*reclen+1:jj*reclen);
     smalleta = smalleta-mean(smalleta);
     var1 = var1 + 1/(reclen)*sum(smalleta.^2);
     fn = fft(smalleta,reclen);fn = fn';
     a0 = fn(1)/reclen;
     an = 2*real(fn(2:reclen/2))/reclen;
     bn = -2*imag(fn(2:reclen/2))/reclen;
     stemp = 2*abs((an+1i*bn)./2).^2 /df;
     ssmooth = ssmooth+stemp;
   end
   s = ssmooth/numwindows;
   [junk1 junk2]=max(s);
   fp=f(junk2);
   var1 = var1/numwindows;
   varbart = sum(s)*df;
   mo = df*sum(s);Hmo=4*sqrt(mo);
