function [cc p] = get_NDBC_spec(fname,payload)

try 
    dep = h5readatt(fname,'/','sea_floor_depth_below_sea_level');
catch
    dep = -999.00;
end
% get frequency bands for spectra
try 
    freq = h5read(fname,'/wave_wpm');
    dft = h5read(fname,'/_nc4_non_coord_wave_wpm_bnds');
    df = dft(2,:) - dft(1,:);
catch
   try
        freq = h5read(fname,'/wave_wa');
        dft = h5read(fname,'/_nc4_non_coord_wave_wa_bnds');
        df = dft(2,:) - dft(1,:);
   catch
       freq = repmat(-99.00,[48 1]);
       df = repmat(-99.00,[48 1]);
   end
end
for jj = 2:length(freq)
    si(jj,1) = freq(jj) - freq(jj-1);
end
si(1,1) = freq(1);


% get c11 from file
try
    c11 = h5read(fname,['/',payload,'/wave_sensor_1/c11']);
    c11_info = h5info(fname,['/',payload,'/wave_sensor_1/c11']);
catch
    fprintf(1,'Wave Spectra information not available for station %5s\n', ...
        fname(6:10));
    times = double(h5read(fname,'/time'));
    c11 = repmat(-999.00,[length(freq) length(times)]);
    c11_info.FillValue = 0.0;
end
for zz = 1:size(c11,2)
ii = c11(:,zz) == c11_info.FillValue;
c11(ii,zz) = -999.;
end
% check to see if direction components are available
try
    r1 = h5read(fname,['/',payload,'/wave_sensor_1/r1']);
    r2 = h5read(fname,['/',payload,'/wave_sensor_1/r2']);
    alpha1 = h5read(fname,['/',payload,'/wave_sensor_1/alpha1']);
    alpha2 = h5read(fname,['/',payload,'/wave_sensor_1/alpha2']);
    p = 2;
    fprintf(1,'Direction information available for %5s \n\n',fname(6:10));
catch
    fprintf(1,'No direction information available for %5s\n\n',fname(6:10));
    p = 1;
    r1 = repmat(0,size(c11));r2 = repmat(0,size(c11));
    alpha1 = repmat(0,size(c11));alpha2 = repmat(0,size(c11));
end

% for zz = 1:size(c11,2)
%     if c11(:,zz) == c11_info.FillValue
%         hmo = -999.00;
%         fpp = -999.00;fm = -999.00;fp = -999.00;mp = -1;
%         tpp = -999.00;tm = -999.00;tp = -999.00;
%     elseif sum(c11(:,zz)) > 1000.0 | c11(:,zz) < 0
%         hmo = -999.00;
%         fpp = -999.00;fm = -999.00;fp = -999.00;mp = -1;
%         tpp = -999.00;tm = -999.00;tp = -999.00;
%     else
%         hmo = 4.0*sqrt(sum(c11(:,zz).*df'));
%         [fpp,fm,fp,mp] = periods(c11(:,zz),freq,df');
%         tpp = 1./(fpp + 1.0e-10);
%         tm = 1./(fm + 1.0e-10);
%         tp = 1./(fp + 1.0e-10);
%     end
% end
%     
%     if mp > 0
%         [delhmo,delttp,deltm,deltm1,deltm2, ...
%             delfspr] = delftsums(c11(:,zz),freq,df');
%     else
%         delhmo = -999.00;delttp = -999.00;deltm = -999.00;
%         deltm1 = -999.00;deltm2 = -999.00;delfspr = -999.00;
%     end
% 
%      
%     if exist('r1','var');
%         if mp > 0
%         [ef2d] = twodgen(c11(:,zz),freq,df,r1(:,zz), ...
%             r2(:,zz),alpha1(:,zz),alpha2(:,zz),dep);
%         [wavdvt,wavdvfm,wavpd,wavdmx,wavfmx ...
%             ,sumefx,sumefy,summfx,summfy] = ...
%             directns(ef2d,freq,df,360,1,mp,dep);
%         [delftmdr,delftpdr,delftsprd] = ...
%             delftsdrs(ef2d,freq,df,360,1);
%         else
%         wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
%         wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
%         sumefy = -999.00;summfx = -999.00;summfy = -999.00;
%         delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
%         end
%     else
%         wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
%         wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
%         sumefy = -999.00;summfx = -999.00;summfy = -999.00;
%         delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
%     end
%     bb(zz,:) = [hmo,tp,tpp,tm,wavdvt,wavdvfm,wavpd,wavdmx,delhmo,delttp,deltm, ...
%     deltm1,deltm2,delfspr,delftmdr,delftpdr,delftsprd,sumefx,sumefy, ...
%     summfx,summfy];
%     if c11(:,zz) == c11_info.FillValue;
%         bb(zz,:) = -999.00;
%         c11(:,zz) = -999.00;r1(:,zz) = -9.9999;r2(:,zz) = -9.9999;
%         alpha1(:,zz) = -999.00;alpha2(:,zz) = -999.00;
%     end
%end
cc = struct('freq',freq,'si',si,'c11',c11,'r1',r1,'r2',r2,'alpha1',alpha1,'alpha2',alpha2);


