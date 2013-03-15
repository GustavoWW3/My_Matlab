function AAtot = WAM_spec_onlns(buoyname,fmin,fmax)

buoy = buoyname(2:6);
specf = ['ST',buoy,'.spe2d'];

[aout] = read_WAM_spe2d(specf);
fcut = aout(1).freq >= fmin-0.01 & aout(1).freq <= fmax+0.01;

freq = aout(1).freq(fcut);

delth = aout(1).ang(2) - aout(1).ang(1);
col1 = 0.5*((aout(1).freq(2:end)./aout(1).freq(1:end-1))-1)*delth;
dfim(1,1) = col1(1)*aout(1).freq(1);
flen = length(freq);
dfim(2:flen-1,1) = col1(2:flen-1).*(aout(1).freq(2:flen-1) + ...
    aout(1).freq(1:flen-2));
dfim(flen,1) = col1(flen-1)*aout(1).freq(flen-1);

th = (0:1:length(aout(1).ang)-1).*delth + 0.5.*delth;
sinth = sin(th);
costh = cos(th);

AAtot = zeros(length(aout),33);

% hm = zeros(length(aout),1);
% tp = zeros(length(aout),1);
% tpp = zeros(length(aout),1);
for zz = 1:length(aout)
    AAtot(zz,3) = aout(zz).time;
    AAtot(zz,7) = aout(zz).u10;
    AAtot(zz,8) = aout(zz).udir;
    AAtot(zz,6) = aout(zz).lon;
    AAtot(zz,5) = aout(zz).lat;
    % sum the direction components of energy
    ef = sum(aout(zz).ef2d(fcut,:),2);
        
    % solve for wave height adding the parametric tail
    temp = dot(ef,dfim);
    del25 = 0.25*freq(flen)*delth;
    temp2 = temp + del25*ef(flen);
    AAtot(zz,12) = 4.0*sqrt(temp2);
    
    % solve for peak period 
    ipeak = flen;
    ef1d = ef.*delth;
    [epeak ipeak] = max(ef1d);
    tp = 1./freq(ipeak);
    if (ipeak == 1) 
       %AAtot(zz,13) = 1.0;
       ipeak = flen;
    end
    AAtot(zz,13) = tp;
     
    % solve for peak period of the parabolic fit
    ppf = tp;
    ipk = ipeak;
    ipkp1 = ipk +1;
    ipkm1 = ipk -1;
    
    if (ipk ~= flen) 
        ppf = freq(ipk);
        eneck = ef1d(ipkp1) + ef1d(ipk) + ef1d(ipkm1);
        
        if (eneck > 1.0e-10)
            v1 = (freq(ipk) - freq(ipkp1)).*(freq(ipkm1) - freq(ipk));
            v2 = (ef1d(ipkm1) - ef1d(ipkp1)).*(freq(ipkm1) - freq(ipk))./ ...
                (freq(ipkm1) - freq(ipkp1));
            
            if (v2 ~= 0)
                a = (ef1d(ipkm1) - ef1d(ipk) - v2)./v1;
                b = (ef1d(ipkm1) - ef1d(ipkp1))./(freq(ipkm1) - freq(ipkp1)) ...
                    - a.*(freq(ipkm1) + freq(ipkp1));
                if (a ~= 0.0) 
                    ppf = -0.5.*b./a;
                end
            end
        end
    end
    AAtot(zz,14) = 1./(ppf + -1.0e-10);
    
    % calculate mean period
    dfimofr = dfim./freq';
    fmm = dot(ef,dfimofr);
    del25 = 0.2.*delth;
    fmm = fmm + del25.*ef(flen);
    fm = temp2./max(fmm,1.0e-12);
    if AAtot(zz,12) ~= 0
        AAtot(zz,15) = 1./fm;
    else
        AAtot(zz,15) = 1.0;
    end
    
    % mean direction
    temp = aout(zz).ef2d(fcut,:)'*dfim;
    si = dot(temp,sinth);
    ci = dot(temp,costh);
    
    if (ci == 0) 
        ci = 0.1e-30;
    end
    thq = atan2(si,ci);
    if (thq < 0)
        thq = thq + 2.0*pi/360.0;
    end
    AAtot(zz,18) = thq*360/(2*pi);
    
end

