function [aa, fflag] = read_WIS_onlns(fname)
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
fflag = 1;
try
    data = textscan(fid,['%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',...
    '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f']);
catch
    1;
end
fclose(fid);

timec = num2str(data{1});
year = str2num(timec(:,1:4));
mon = str2num(timec(:,5:6));
day = str2num(timec(:,7:8));
hour = str2num(timec(:,9:10));
min = str2num(timec(:,11:12));
sec = str2num(timec(:,13:14));
mtime = datenum(year,mon,day,hour,min,sec);

lon = data{4}(1);
lat = data{3}(1);
wvht = data{10};
tpp = data{11};
tm1 = data{14};
wavd = data{16};
wspd = data{5};
wdir = data{6};

%wavd = wavd + 180;
%wavd(wavd > 360) = wavd(wavd > 360) - 360;

%wdir = wdir + 180;
%wdir(wdir > 360) = wdir(wdir > 360) - 360;

aa = struct('time',mtime,'lon',lon,'lat',lat,'wvht',wvht,'tpp', ...
    tpp,'tm1',tm1,'wavd',wavd,'wspd',wspd,'wdir',wdir);