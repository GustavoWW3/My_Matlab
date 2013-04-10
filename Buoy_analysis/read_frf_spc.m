function aa = read_frf_spc(fname)

fid = fopen(fname);
data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f',1);
nn = 0;
while ~isempty(data{1});
    nn = nn+1;
    stat = data{1};
    year = data{2};mon = data{3};day = data{4};hmin = data{5};
    hmo(nn,1) = data{6};tp(nn,1) = data{7};idir(nn,1) = data{8};
    sfratio = data{9};qflag = data{10};
    
    if mon < 10
        monc = ['0',num2str(mon)];
    else
        monc = num2str(mon);
    end
    if day < 10
        dayc = ['0',num2str(day)];
    else
        dayc = num2str(day);
    end
    hminc = num2str(hmin);
    if hmin < 1000
        hourc1 = hminc(1);
        minc = hminc(2:3);
    else
        hourc1 = hminc(1:2);
        minc = hminc(3:4);
    end
    hour = str2num(hourc1);
    if hour < 10
        hourc = ['0',num2str(hour)];
    else
        hourc = num2str(hour);
    end
    minut = str2num(minc);
    if minut < 10
        minutc = ['0',num2str(minut)];
    else
        minutc = num2str(minut);
    end
    
    dates(nn,:) = [num2str(year),monc,dayc,hourc, minutc];
    timemat(nn) = datenum(year,mon,day,hour,minut,0);
    
    if nn == 1
        %load('/home/thesser1/My_Matlab/Buoy_analysis/frf_loc.mat');
        load('C:\matlab\My_Matlab\Buoy_analysis\frf_loc.mat');
        ii = timeref > timemat(nn);
        if ~isempty(timeref(ii))
            jj = find((ii == 1), 1 );
            lat = latref(jj);
            lon = lonref(jj);
        else
            lat = latref(end); %#ok<*COLND>
            lon = lonref(end);
        end
    end
    
    data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
    nrec(nn) = data{1};isegrec = data{2};
    ensembles = data{3};ibandw = data{4};
    deltaf = data{5};idof = data{6};depth = data{7};
    anglefrf = data{8};
    
    data = textscan(fid,'%f%f%f%f%f%f%f',1);
    f1 = data{1};df = data{2};
    nfreq = data{3};
    cohvn = data{4};cohvw = data{5};
    cohnw = data{6};stdk = data{7};
    
    data = textscan(fid,'%f%f%f%f%f%f',nfreq);
    ef(:,nn) = data{1};
    a1(:,nn) = data{2};b1(:,nn) = data{3};
    a2(:,nn) = data{4};b2(:,nn) = data{5};kfac(:,nn) = data{6};
    
    data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f',1);
end
freq = f1:df:f1+((nfreq-1)*df);
aa.stat = stat;
aa.lon = lon;aa.lat = lat;
aa.date = dates;
aa.timemat = timemat;
aa.dep = depth;
aa.hs = hmo';aa.tp = tp';aa.wdir = idir';
aa.freq = freq';aa.df = repmat(df,size(freq))';
aa.c11 = ef;aa.a1 = a1;aa.a2 = a2;
aa.b1 = b1;aa.b2 = b2;
