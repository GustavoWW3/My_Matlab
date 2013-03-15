function read_WAM_spec(fname,station)
%fname = 'ALASKA_20YR_BASIN_2007_03_ST46001.spe2d';
fid = fopen(fname,'r');
nn = 0;
%station = '46001';
for jj = 1:99999
    data = textscan(fid,'%f%f%f%f%f%f%f%f%f',1);
    cont = data{1};
    if size(cont,1) == 0;
        break
    else
    
    time = data{2};
    lon = data{3};
    lat = data{4};
    nf = data{5};
    na = data{6};
    freq1 = data{7};
    dir1 = data{8};
    dird = data{9};
    ang = [dir1:360/na:360];
    
    data = textscan(fid,'%f%f%f',1);
    u10 = data{1};
    udir = data{2};
    ustar = data{3};

    data = textscan(fid,'%5.2f%5.2f%5.2f%5.2f%5.2f%f%f',1);
    hs = data{1};
    tp = data{2};
    tm = data{3};
    tm1 = data{4};
    tm2 = data{5};
    wdir = data{6};
    wspr = data{7};

    for ii = 1:nf
        data = fscanf(fid,'%f',1);
        fr(ii) = data;
        data = fscanf(fid,'%f',na);
        ef(ii,:) = data.*pi/180;
        
    end
        
    ef1d(:,1) = trapz(ang,ef');
    % Make last angle bin the first
    ef = [ef(:,end) ef(:,1:end-1)];
   
    theta1d = trapz(fr,ef); % 1D Directional Spectrum
    [tmax, ind] = max(theta1d);
    thetapeak = ang(ind);
    
    timec = num2str(time);
    yr = str2num(timec(1:4));
    mon = str2num(timec(5:6));
    day = str2num(timec(7:8));
    hour = str2num(timec(9:10));
    min = str2num(timec(11:12));
    sec = str2num(timec(13:14));
%     if mon > 1
%         break
%     end
    nn = nn + 1;
    dtm = datenum(yr,mon,day,hour,min,sec);
    dat.wavedat.time(jj) = dtm;
    dat.wavedat.dwfhz{jj} = fr;
    
    udir = udir + 180;
    if udir > 360
        udir = udir - 360;
    end
    dat.wavedat.dwdeg{jj} = ang;
    dat.wavedat.hs(jj) = hs;
    dat.wavedat.fp(jj) = 1./tp;
    dat.wavedat.winddir(jj) = udir;
    dat.wavedat.windspeed(jj) = u10; 
    dat.wavedat.espt{jj} = ef;
    dat.wavedat.dwAvv{jj} = ef1d;
    dat.wavedat.thetap(jj) = thetapeak;
    end
end
    
    dat.wavedat.file = 'Original';
    dat.wavedat.name = station;
    
%     if lon > 180.0
%         lon = lon - 360.0;
%     end
    dat.wavedat.lat = lat;
    dat.wavedat.lon = lon;
    dat.wavedat.depth = 4888.0;
    dat.wavedat.size = nn;
    
    dat.wavedat.timezone= 0;
    dat.wavedat.magcorr = 0; % Required for WAVES 3.0
    dat.wavedat.file = 'Original';
    dat.wavedat.type = '2D';
    dat.wavedat.notes = ' ';
    dat.wavedat.obsyr = '';
    dat.wavedat.method = ' ';
    dat.wavedat.filename = fname;  % Required for WAVES 3.0
%for jj = 1:n
    wavedat = dat.wavedat;
    fout = [station,'_','WAM_','Dec',num2str(yr),'.mat'];
    save(fout,'wavedat');
%end
fclose(fid);