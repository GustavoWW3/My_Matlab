% Find Lake St. Clair buoy locations in CFSR winds

%files = dir('WIS*CFSR*.WND');
files = dir('WIS*CPRE*.PRE');
for zz = 1:size(files,1)
    filename = getfield(files(zz),'name');

fid = fopen(filename,'r');
data = fgetl(fid);
time1 = str2num(data(56:65));
time2 = str2num(data(71:80));
dt = num2str(time2 - time1);
nt = str2num(dt(1:2))*24+1;
data = fgetl(fid);

ly = str2num(data(8:9));
lx = str2num(data(18:19));
dy = str2num(data(23:28));
dx = str2num(data(32:37));
lats = str2num(data(44:51));
lonw = str2num(data(58:65));
time = data(69:80)

for kk = 1:1000
    nn = kk;
    for jj = 1:ly
        temp1 = fscanf(fid,'%f',lx);
        lsc_u(jj,:) = temp1 ;
    end
%     for jj = 1:ly
%         temp2 = fscanf(fid,'%f',lx);
%         lsc_v(jj,:) = temp2;
%     end
%    lsc{kk} = struct('t',time,'u',lsc_u,'v',lsc_v);
    lsc{kk} = struct('t',time,'p',lsc_u);
    data = fgetl(fid);
    data = fgetl(fid);
    if data ~= -1
    time = data(69:80)
    else
        break
    end
end
fclose(fid);
lon = [lonw:dx:lonw+((lx-1)*dx)];
lat = [lats:dy:lats+((ly-1)*dy)];


lat_st = [42.43;42.465;42.471];
lon_st = [-82.68;-82.755;-82.877]; 
stat(:,1) = lat_st;
stat(:,2) = lon_st;
[nlon dlon] = kNearestNeighbors(lon',lon_st,1);
[nlat dlat] = kNearestNeighbors(lat',lat_st,1);
%fileout = ['LSC-station-CFSR.dat'];
fileout = ['LSC-station-CPRE.dat'];
if zz > 1
    fid = fopen(fileout,'at');
    for kk = 1:nn
%     fprintf(fid,'%s %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n',lsc{kk}.t, ...
%         lsc{kk}.u(nlat(1),nlon(1)),lsc{kk}.v(nlat(1),nlon(1)),lsc{kk}.u(nlat(2),nlon(2)), ...
%         lsc{kk}.v(nlat(2),nlon(2)),lsc{kk}.u(nlat(3),nlon(3)),lsc{kk}.v(nlat(3),nlon(3)));
        fprintf(fid,'%s %10.4f %10.4f %10.4f\n',lsc{kk}.t, ...
        lsc{kk}.p(nlat(1),nlon(1)),lsc{kk}.p(nlat(2),nlon(2)),lsc{kk}.p(nlat(3),nlon(3)));
    end
else
    fid = fopen(fileout,'wt+');
    for kk = 1:nn
     fprintf(fid,'%s %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n',lsc{kk}.t, ...
         lsc{kk}.u(nlat(1),nlon(1)),lsc{kk}.v(nlat(1),nlon(1)),lsc{kk}.u(nlat(2),nlon(2)), ...
         lsc{kk}.v(nlat(2),nlon(2)),lsc{kk}.u(nlat(3),nlon(3)),lsc{kk}.v(nlat(3),nlon(3)));
%    fprintf(fid,'%s %10.4f %10.4f %10.4f\n',lsc{kk}.t, ...
%        lsc{kk}.p(nlat(1),nlon(1)),lsc{kk}.p(nlat(2),nlon(2)),lsc{kk}.p(nlat(3),nlon(3)));
    end
end
fclose(fid);
clear lsc
end


