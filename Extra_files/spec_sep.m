%Calculate the Spectrum of a time series
%function [f,S,Hmo,fp] = spec (eta,dt,numwindows)
% 
% 
%
function [f,s,all_data,st,high_data,sh,low_data,sl,flow] = spec_sep(eta,dt,fpp)

   reclen = floor(length(eta));
   df = 1/(reclen*dt);f=(1:reclen/2-1).*df;
   if size(eta,1)==1;ssmooth = zeros(reclen/2-1,1);ssmootht = ssmooth;
       ssmoothh = ssmooth;ssmoothl = ssmooth;
   else ssmooth = zeros(1,reclen/2-1);ssmootht = ssmooth;ssmoothh = ssmooth;
       ssmoothl = ssmooth;end
   ansmooth = ssmooth;bnsmooth = ssmooth;var1 = 0;
   smalleta =eta;
   smalleta = smalleta-mean(smalleta);
   var1 = var1 + 1/(reclen)*sum(smalleta.^2);
   fn = fft(smalleta,reclen);fr = fn;fn = fn';
   a0 = fn(1)/reclen;
   an = 2*real(fn(2:reclen/2))/reclen;
   bn = -2*imag(fn(2:reclen/2))/reclen;
   stemp = 2*abs((an+1i*bn)./2).^2 /df;
   ssmooth = ssmooth+stemp;
   %end
   s = ssmooth;
   [junk1 junk2]=max(s);
   fp=f(junk2);
   var1 = var1;
   varbart = sum(s)*df;
   mo = df*sum(s);Hmo=4*sqrt(mo);

   ft = fr;
   ind = find(f>2.0);ft(ind,1)=0.0;
   all_data = real(ifft(ft));
   fz = ft;ft = ft';
   ant = 2*real(ft(2:reclen/2))/reclen;
   bnt = -2*imag(ft(2:reclen/2))/reclen;
   stempt = 2*abs((ant + 1i*bnt)./2).^2/df;
   ssmootht = ssmootht + stempt;
   st = ssmootht;
   
   fh = fz;
   fl = fz;
   ind = find(f>fpp*3);fh(ind,1)=0;
   ind = find(f<fpp/2);fh(ind,1)=0;
   ind = find(f>fpp/2);fl(ind,1)=0;
   ind = find(f<0.005);fl(ind,1)=0;
   
   %high pass analysis
   high_data(:,1) = real(ifft(fh));
   fh = fh';
   anh = 2*real(fh(2:reclen/2))/reclen;
   bnh = -2*imag(fh(2:reclen/2))/reclen;
   stemph = 2*abs((anh+1i*bnh)./2).^2/df;
   ssmoothh = ssmoothh + stemph;
   sh = ssmoothh;
   
   %low pass analysis 
   low_data(:,1) = real(ifft(fl));
   flow = fl;
   fl = fl';
   anl = 2*real(fl(2:reclen/2))/reclen;
   bnl = -2*imag(fl(2:reclen/2))/reclen;
   stempl = 2*abs((anl+1i*bnl)./2).^2/df;
   ssmoothl = ssmoothl + stempl;
   sl = ssmoothl;
   