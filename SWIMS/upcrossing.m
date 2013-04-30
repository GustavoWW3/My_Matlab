function aa = upcrossing(aa)

dti=0.01;
ti=(0:dti:max(aa.time))';
nogage = size(aa.wave,2);
nwave=zeros(nogage);

for m=1:nogage
    etai=spline(aa.time,aa.wave(:,m),ti)';
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
    aa.H(1,m) = sqrt(mean( wvht.^2));
    aa.T(1,m) = sqrt(mean( periods.^2));
    aa.nwave(m)=size(wvht,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [swvht, inds] = sort(wvht);
    speriods = periods(inds);
    aa.H(2,m) = mean(swvht(ceil(1/2*length(swvht)):length(swvht)));
    aa.H(3,m) = mean(swvht(ceil(2/3*length(swvht)):length(swvht)));
    aa.H(4,m) = mean(swvht(ceil(9/10*length(swvht)):length(swvht)));
    aa.H(5,m)=max(swvht);
    aa.T(2,m) = mean(speriods(ceil(1/2*length(swvht)):length(swvht)));
    aa.T(3,m) = mean(speriods(ceil(2/3*length(swvht)):length(swvht)));
    aa.T(4,m) = mean(speriods(ceil(9/10*length(swvht)):length(swvht)));
    aa.T(5,m)=speriods(length(speriods));
end