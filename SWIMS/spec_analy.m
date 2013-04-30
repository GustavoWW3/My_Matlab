function aa = spec_analy(aa)

nogage = size(aa.wave,2);
%%Spectral Analysis
nfft = 1024;
fs = 1/aa.dt;
fcut1 = 0.005;
fcut2 = 1.5;
for ii = 1:nogage
    etas = detrend(aa.wave(:,ii));
    [px,f] = pwelch(etas,[],[],nfft,fs);
    jj = find(f <= fcut1 & f >= fcut2);
    px(jj) = 0.0;
    aa.px_welch(:,ii) = px;
    aa.f_welch(:,ii) = f;
    df = f(2)-f(1);
    aa.Hmo(ii) = 4.0*sqrt(df*sum(aa.px_welch(:,ii))); 
    tt = find(aa.px_welch(:,ii)==max(aa.px_welch(:,ii)));
    aa.Tp(ii) = 1./f(tt);
    aa.Fp(ii) = f(tt);
end

fpp = mean(aa.Fp(1:3));
for mm = 1:nogage
%eta3(:,mm) = eta3(:,mm) - eta1st(1,mm);
%[fff sss ft st fh sh fl sl flow] = spec_sep(eta3(:,mm),dt,fpp);
[ss] = bandpass(aa.wave(:,mm),aa.dt,0.005,2.0);
[sh] = bandpass(ss,aa.dt,fpp/1.5,2.0);
[sl] = bandpass(ss,aa.dt,0.005,fpp/1.5);
% ffreq(:,mm,zz) = fff;
aa.all_data(:,mm) = ss;
% all_f(:,mm,zz) = st;
aa.high_data(:,mm)= sh;
% high_f(:,mm,zz) = sh;
aa.low_data(:,mm) = sl;
% low_f(:,mm,zz) = sl;
% low_f_raw(:,mm,zz) = flow;
aa.wave_mean(mm) = mean(aa.wave(:,mm));
end