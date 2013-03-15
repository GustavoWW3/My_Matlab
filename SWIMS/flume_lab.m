%%
clear all
%[fnt,pnt]=uigetfile('*.bin','Select MTS Binary File:');
%nt=fullfile(pnt,fnt);
files = dir('*.bin');
for zz = 1:size(files,1)
file_name = getfield(files(zz,1),'name');
[ts,dt,desc,units,fileInfo,fileDate,header,isText] = loadbin(file_name);
lts=((size(ts,1)-1)*dt);
tstep=(0:dt:lts)';
% Determine water depth from file name
a = {'lo','id','hi'};
d=[0.415 0.439 0.490];
I=strcmp(a,file_name(end-8:end-7));
h=d(I);
%runid = input('What is the run number:   ')
% Number of seconds to skip
skip=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Upcrossing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t=ts(:,1);
t=(skip:dt:(tstep(end,1)));
dti=0.01;
ti=(skip:dti:max(t))';
[nt n2]=size(ts);
nogage=n2-2;
skipno=(skip/dt)+1;
eta=ts(skipno:end,:);
eta1st=mean(ts(1:100,1:13));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Runup data is in feet (6/16/2010)
slope = 1/10;
%eta(:,nogage)=eta(:,nogage)*0.3048;
eta(:,nogage) = eta(:,nogage)*0.3048*sin(slope);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eta_full = ts;
eta3 = eta(:,1:13);
% for mm = 1:nogage
% eta3(:,mm) = eta3(:,mm) - eta1st(1,mm);
% [fff sss ft st fh sh fl sl] = spec_sep(eta3(:,mm),dt);
% ffreq(:,mm,zz) = fff;
% all_data(:,mm,zz) = ft;
% all_f(:,mm,zz) = st;
% high_data(:,mm,zz)= fh;
% high_f(:,mm,zz) = sh;
% low_data(:,mm,zz) = fl;
% low_f(:,mm,zz) = sl;
%    ft = fnn;
%    ind = find(fff>2.0);ft(1,ind);
%    ant = 2*real(ft(2:reclen/2))/reclen;
%    bnt = -2*imag(ft(2:reclen/2))/reclen;
%    stempt = 2*abs((ant + 1i*bnt)./2).^2/dff;
%    ssmootht = ssmootht + stempt;
%    st(:,mm,zz) = ssmootht;
%    
%    fh = ft;
%    fl = ft;
%    ind = find(fff>fpp*3);fh(1,ind)=0;
%    ind = find(fff<fpp/2);fh(1,ind)=0;
%    ind = find(fff>fpp/2);fl(1,ind)=0;
%    ind = find(fff<0.005);fl(1,ind)=0;
%    
%    %high pass analysis
%    high_data(:,mm,zz) = ifft(fh);
%    fh = fh';
%    anh = 2*real(fh(2:reclen/2))/reclen;
%    bnh = -2*imag(fh(2:reclen/2))/reclen;
%    stemph = 2*abs((anh+1i*bnh)./2).^2/dff;
%    ssmoothh = ssmoothh + stemph;
%    sh(:,mm,zz) = ssmoothh;
%    
%    %low pass analysis 
%    low_data(:,mm,zz) = ifft(fl);
%    fl = fl';
%    anl = 2*real(fl(2:reclen/2))/reclen;
%    bnl = -2*imag(fl(2:reclen/2))/reclen;
%    stempl = 2*abs((anl+1i*bnl)./2).^2/dff;
%    ssmoothl = ssmoothl + stempl;
%    sl(:,mm,zz) = ssmoothl;
%end
%eta3 = detrend(eta,'constant');
%H=zeros(5,length(nogage)); T=zeros(length(nogage));
nwave=zeros(length(nogage));

for m=1:nogage
    etai=spline(t,eta(:,m),ti)';
    n=size(ti,1);
    eta2 = etai-mean(etai);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    etashift1 = eta2(1:n-1);
    etashift2 = eta2(2:n);
    crsspt = find(etashift1.*etashift2<0&etashift2-etashift1>0);
    periods = ((crsspt(2:length(crsspt))-crsspt(1:length(crsspt)-1))*dti)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    maxfile = zeros(1,length(crsspt)-1);
    minfile = zeros(1,length(crsspt)-1);
    for j = 1:length(crsspt)-1
        maxfile(j) = max(etai(crsspt(j):crsspt(j+1)));
        minfile(j) = min(etai(crsspt(j):crsspt(j+1)));
    end
    wvht=(maxfile-minfile);
    H{zz}(1,m) = sqrt(mean( wvht.^2));
    T{zz}(1,m) = sqrt(mean( periods.^2));
    nwave(m)=size(wvht,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [swvht, inds] = sort(wvht);
    speriods = periods(inds);
    H{zz}(2,m) = mean(swvht(ceil(1/2*length(swvht)):length(swvht)));
    H{zz}(3,m) = mean(swvht(ceil(2/3*length(swvht)):length(swvht)));
    H{zz}(4,m) = mean(swvht(ceil(9/10*length(swvht)):length(swvht)));
    H{zz}(5,m)=max(swvht);
    T{zz}(2,m) = mean(speriods(ceil(1/2*length(swvht)):length(swvht)));
    T{zz}(3,m) = mean(speriods(ceil(2/3*length(swvht)):length(swvht)));
    T{zz}(4,m) = mean(speriods(ceil(9/10*length(swvht)):length(swvht)));
    T{zz}(5,m)=speriods(length(speriods));
end

%%Spectral Analysis
nfft = 1024;
fs = 1/dt;
fcut1 = 0.005;
fcut2 = 1.5;
for ii = 1:nogage
    etas = detrend(eta(:,ii));
    [px,f] = pwelch(etas,[],[],nfft,fs);
    jj = find(f <= fcut1 & f >= fcut2);
    px(jj) = 0.0;
    px_welch(:,ii,zz) = px;
    f_welch(:,ii,zz) = f;
    df = f(2)-f(1);
    Hmo(ii,zz) = 4.0*sqrt(df*sum(px_welch(:,ii,zz))); 
    tt = find(px_welch(:,ii,zz)==max(px_welch(:,ii,zz)));
    Tp(ii,zz) = 1./f(tt);
    Fp(ii) = f(tt);
end

fpp = mean(Fp(1:3));
for mm = 1:nogage
eta3(:,mm) = eta3(:,mm) - eta1st(1,mm);
%[fff sss ft st fh sh fl sl flow] = spec_sep(eta3(:,mm),dt,fpp);
[ss] = bandpass(eta3(:,mm),dt,0.005,2.0);
[sh] = bandpass(ss,dt,fpp/1.5,2.0);
[sl] = bandpass(ss,dt,0.005,fpp/1.5);
% ffreq(:,mm,zz) = fff;
all_data(:,mm,zz) = ss;
% all_f(:,mm,zz) = st;
high_data(:,mm,zz)= sh;
% high_f(:,mm,zz) = sh;
low_data(:,mm,zz) = sl;
% low_f(:,mm,zz) = sl;
% low_f_raw(:,mm,zz) = flow;
eta3m(mm,zz) = mean(eta3(:,mm));
end

%%
%Reflection Analysis
grav = 9.81;
numrec = 1;
g=ts(skipno:end,1:3);
an=zeros(size(g,1)/2-1,3); bn=zeros(size(g,1)/2-1,3);
sn=zeros(size(g,1)/2-1,3);
for jj = 1:3
    reclen = max(floor(size(g)/2)*2)/numrec;
    df = 1/(reclen*dt);
    f = (1:reclen/2-1).*df;
    fn = fft(eta3(:,jj),reclen);
    a0 = fn(1)/reclen;
    an(:,jj) = 2*real(fn(2:reclen/2))/reclen;
    bn(:,jj) = -2*imag(fn(2:reclen/2))/reclen;
    sn(:,jj) = 2*abs((an(:,jj)+1i*bn(:,jj))./2).^2 /df;
end
%--------------------------------------------------------------------------
%Solve the linear dispersion relation for all frequencies
w = [];k = [];
for ii = 1:size(f,2);
    w(ii) = 2*pi*f(ii);
    kk = w(ii)/sqrt(grav*h);
    while(abs(w(ii)^2-grav*kk*tanh(kk*h))>0.0001),
        kk = kk-(w(ii)^2 - grav*kk*tanh(kk*h))/(-grav*tanh(kk*h) - grav*kk*...
            h*sech(kk*h)^2);
    end
    k(ii) = kk;
end
%--------------------------------------------------------------------------
%Solve for inceident and reflected amplitudes at each frequency
ind=cell(3,1);
pos=[0 0.3048 0.9144];
g1 = [1 1 2];
g2 =[2 3 3];
ainc=zeros(3,length(k)); binc=zeros(3,length(k));
aref=zeros(3,length(k)); bref=zeros(3,length(k));
for j = 1:3
    teman1=an(:,g1(j));
    teman2=an(:,g2(j));
    tembn1=bn(:,g1(j));
    tembn2=bn(:,g2(j));
    tems1=sn(:,g1(j));
    tems2=sn(:,g2(j));
    pos1=pos(g1(j));
    pos2=pos(g2(j));
    ainc(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        -teman2'.*sin(k*pos1) + teman1'.*sin(k*pos2) + ...
        tembn2'.*cos(k*pos1) - tembn1'.*cos(k*pos2)  );
    binc(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        +teman2'.*cos(k*pos1) - teman1'.*cos(k*pos2) + ...
        +tembn2'.*sin(k*pos1) - tembn1'.*sin(k*pos2)  );
    aref(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        -teman2'.*sin(k*pos1) + teman1'.*sin(k*pos2) + ...
        -tembn2'.*cos(k*pos1) + tembn1'.*cos(k*pos2)  );
    bref(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        teman2'.*cos(k*pos1) - teman1'.*cos(k*pos2) + ...
        -tembn2'.*sin(k*pos1) + tembn1'.*sin(k*pos2)  );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %find the appropriate range to be seperated
    ind{j} = find(k*(pos2-pos1)<= .9*pi&k*(pos2-pos1)>=pi/10);
    %        eval(['ind',num2str(j),'=ind;']);
    if(j==1); maxind = max(ind{j});minind = min(ind{j});end
    maxind = max([maxind ind{j}]);minind = min([minind ind{j}]);
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Average the above overlapping results
    indtot = (minind:maxind);
    anincav = zeros(1,length(ainc(j,:)));anrefav = anincav;
    bnincav = anincav;bnrefav = anincav;
    countnum = zeros(1,length(ainc(j,:)));
    for j = 1:3;
%         eval(['ind = ind',num2str(j),';'])
        aninc=ainc(j,:);
        anref=aref(j,:);
        bninc=binc(j,:);
        bnref=bref(j,:);

        for jj = minind:maxind
            if length(find(ind{j}==jj))==1;
                anincav(jj) = anincav(jj)+aninc(jj);
                anrefav(jj) = anrefav(jj)+anref(jj);
                bnincav(jj) = bnincav(jj)+bninc(jj);
                bnrefav(jj) = bnrefav(jj)+bnref(jj);
                countnum(jj) = countnum(jj)+1;
            end
        end
    end
    anincav(minind:maxind) = anincav(minind:maxind)./countnum(minind:maxind);
    anrefav(minind:maxind) = anrefav(minind:maxind)./countnum(minind:maxind);
    bnincav(minind:maxind) = bnincav(minind:maxind)./countnum(minind:maxind);
    bnrefav(minind:maxind) = bnrefav(minind:maxind)./countnum(minind:maxind);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    refco(zz) = sqrt(sum((anrefav(indtot)).^2+(bnrefav(indtot)).^2) / ...
        sum((anincav(indtot)).^2+(bnincav(indtot)).^2));
    moi = df*sum(1/(2*df)*( (anincav(indtot)).^2+(bnincav(indtot)).^2 ));
    mor = df*sum(1/(2*df)*( (anrefav(indtot)).^2+(bnrefav(indtot)).^2 ));
    motot = df*sum(tems1(indtot));
    [ind22,ind2] = max( (anincav(indtot)).^2+ (bnincav(indtot)).^2);
    f2 = f(indtot);
    Tpi = 1/f2(ind2);
    Hmoi(zz)=4*(moi)^0.5;
    Hmor(zz)=4*(mor)^0.5;
    Hmotot(zz)=4*(motot)^0.5;
    
    %%
    %Low Frequency Oscillations
    fcutlow = 1/Inf;
    fcuthigh = 1/600;
    for ii = 1:nogage
    [low_freq(:,ii)] = bandpass(eta(:,ii),dt,fcutlow,fcuthigh);
    end
    
    %Flume Mean Setup
    gauge_x = [4.82 5.13 5.74 9.72 10.64 10.84 11.02 11.35 11.66 12.83 14.68 17.73];
    
    read_stwave_dep;
    depth2 = (-1.0*depth);
    x = [0:0.01:1565*0.01-0.01];
    x = x + 5.13;
    x_fill = [0:0.01:5.12];
    x_full = [0:0.01:2078*0.01-0.01];
    for ii = 1:length(x_fill)
        depth3(:,ii) = depth2(:,1);
    end
    depth4 = depth3;
    for ii = 1:size(depth2,2)
        depth4 = [depth4 depth2(:,ii)];
    end

    x_locate = floor(gauge_x./0.01) + 1;
    
    for ii = 1:size(x_locate,2)
        h_gauge(1,ii) = depth4(2,x_locate(ii));
        dhdx(1,ii) = (depth4(2,x_locate(ii)+10)-depth4(2,x_locate(ii)-10))/(20*dx);
    end
    
    h_gauge(1,13) = 0.439 - h;
    for ii = 1:nogage
        if h_gauge(1,ii) > 0.0
            h_plus(ii) = h_gauge(1,ii);
        else
            h_plus(ii) = 0.0;
        end
    end
    ts(:,13) = ts(:,13)./3.281 * sin(slope);
    
    %etam=zeros(1,nogage,size(files,1));
    for kk=1:nogage-1
        etam(kk,zz)=mean(eta3(:,kk)) + h_plus(kk);
    end
    etam(nogage,zz)=mean(eta3(:,nogage)) - 0.04 + h_plus(kk);
    
    

        %Wave steepness
    for ii = 1:nogage-1
        wg = (2*pi)./Tp(ii);
        [kg cg ng] = dispersion(wg,(-1.0)*h_gauge(1,ii));
        ll(ii) = (2*pi)/kg;
        kl(ii) = kg;
        clear kg cg ng wg
        Hrms(ii) = 0.71*Hmo(ii);
        steep(ii) = Hrms(ii)./ll(ii);
    end
    

    %% Spectral Output
    px_ave = (px_welch(:,1,zz) + px_welch(:,2,zz) + px_welch(:,3,zz))/3;
    fp = (Fp(1) + Fp(2) + Fp(3))/3;
    low = fp - 0.3;
    high = fp + 0.9;
    if low < 0.25
        high = high + 0.25-low;
        low = 0.25;
    end        
    rr = find(f_welch(:,1,zz) >= low & f_welch(:,1,zz) <= high);
    if size(rr,1) < 62
        rr = [rr(1):rr(end)+(62-size(rr,1))];
    end
    stwave_int = px_ave(rr);
    for ii = 1:12
        px_st(:,ii) = px_welch(rr,ii,zz);
        Hmo_st(ii,zz) = 4*sqrt(sum(px_st(:,ii))*(f_welch(2,1,zz)-f_welch(1,1,zz)));
    end
    freq = f_welch(rr,1,zz);
    if freq(1) == 0.0000
        freq(1) = 0.0001;
    end
    num_freq = size(freq,1);
    num_dir = 35;
    wind = 0.0;
    wind_dir = 0.0;
    welv = 0.0;
    ainc = (pi - 2.0*5*pi/180)/real(num_dir-1);
    for ii = 1:num_freq
       for jj = 1:num_dir
        if jj ==18
            e(jj,ii,zz) = stwave_int(ii,1)/ainc;%*50*50*sqrt(50);%/ainc;
        else
            e(jj,ii) = 0.0;
        end
    end
end
for ii = 1:nogage-1
    Hmo_stwave(ii,zz) = 4.0*sqrt(sum(px_welch(rr,ii,zz))*(freq(2)-freq(1)));
end
    qq = find(f_welch(:,1,zz) <= low);
    for ii = 1:12
        px_low(:,ii) = px_welch(qq,ii,zz);
        Hmo_low(:,ii,zz) = 4*sqrt(sum(px_low(:,ii))*(f_welch(2,1,zz)-f_welch(1,1,zz)));
    end
    clear px_low
    
    spec_int
    
    for ii = 1:nogage
        gauge_error(ii) = mean(civar_3min(ii,:));
    end
    
nfft = 4096;
fs = 1/dt;
%fcut1 = 0.005;
%fcut2 = 1.5;
for ii = 1:nogage
    etas = detrend(high_data(:,ii,zz));
    [px,f] = pwelch(etas,[],[],nfft,fs);
    %jj = find(f <= fcut1 & f >= fcut2);
    %px(jj) = 0.0;
    px_high(:,ii,zz) = px;
    f_high(:,ii,zz) = f;
    df = f(2)-f(1);
    Hmo_high(ii,zz) = 4.0*sqrt(df*sum(px_high(:,ii,zz))); 
    tt = find(px_high(:,ii,zz)==max(px_high(:,ii,zz)));
    Tp(ii,zz) = 1./f(tt);
    Fp(ii) = f(tt);
    
    etas2 = detrend(low_data(:,ii,zz));
    [pxl,f] = pwelch(etas2,[],[],nfft,fs);
    px_l(:,ii,zz) = pxl;
    f_low(:,ii,zz) = f;
    df2 = f(2) - f(1);
    Hmo_low(ii,zz) = 4.0*sqrt(df2*sum(px_l(:,ii,zz)));
    
    etas3 = detrend(all_data(:,ii,zz));
    [pxa,f] = pwelch(etas3,[],[],nfft,fs);
    px_a(:,ii,zz) = pxa;
    f_a(:,ii,zz) = f;
    Hmo_all(ii,zz) = 4.0*sqrt(df*sum(px_a(:,ii,zz)));
    
end  
Hmo_1mean(1,zz) = mean(Hmo_all(1:3,zz));
Tp_1mean(1,zz)= mean(Tp(1:3,zz));
[Hmo_deep(1,zz)] = shoaling(Hmo_1mean(1,zz),Tp_1mean(1,zz),h);
for ii = 1:nogage
etam_nd(ii,zz) = etam(ii,zz)/Hmo_deep(1,zz);
end
    
end