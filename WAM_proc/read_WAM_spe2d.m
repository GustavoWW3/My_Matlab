function [fileout] = read_WAM_spe2d(fname)
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
    ang = [dir1:360/na:360].*pi/180;
    
    data = textscan(fid,'%f%f%f',1);
    u10 = data{1};
    udir = data{2};
    ustar = data{3};

    data = textscan(fid,'%6.2f%6.2f%6.2f%6.2f%6.2f%6.2f%f%f',1);
    hs = data{1};
    tp = data{2};
    tm = data{4};
    tm1 = data{5};
    tm2 = data{6};
    wdir = data{7};
    wspr = data{8};

    for ii = 1:nf
        data = fscanf(fid,'%f',1);
        fr(ii) = data;
        data = fscanf(fid,'%f',na);
        ef(ii,:) = data;
        
    end
    
    end
    fileout(jj) = struct('time',time,'freq',fr,'ang',ang,'ef2d',ef,'u10',u10, ...
        'udir',udir,'lon',lon,'lat',lat);
end