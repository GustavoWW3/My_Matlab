function ww3_read_ATL
%ftp_trans_ww3
 title1 = ['Atlantic Hindcast Study [OWI Winds]'];
 plotloc = 'C:\A1FRF\Documents\MATLAB\WW3_proc\Atlantic\';
 rdir = 'X:\';
 
files1 = dir('*MMt.tgz');
filename1 = getfield(files1,'name');
%dirname = [filename1(1:4),'-',filename1(5:6)];
% if ~exist(dirname,'dir')
%     mkdir(dirname)
% end
% movefile('*.tgz',dirname);
% cd(dirname)
untar(filename1);
fid = fopen('Max-mean-ww3.dat');
data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
lonw = data{3};lone = data{4};
lats = data{6};latn = data{7};
res = (lone-lonw)./(data{5}-1);
% files2 = dir('*spec.tgz');
% untar(files2.name);
% 
% mkdir('Spectra');
% files3 = dir('*spec-buoy.tgz');
% copyfile(files3.name,'Spectra');
% cd('Spectra');
% untar(files3.name);
% cd ../

storm = 'Atlantic';
%storm = 'Gtest';
%track = 'North';

%if size(filename1,2) > 27
%    modelnm = ['WW3-OWI'];
%    track = [filename1(1:4),'-',filename1(5:6)];
%else
    modelnm = 'WW3-OWI';
    track = [filename1(1:4),'-',filename1(5:6)];
    bbop = pwd;
    ii = strfind(bbop,'level');
    level = bbop(ii:end);
    track = [track,'-',level];
%end

ww3_cont_atl1(storm,track,modelnm,plotloc)
loc = pwd;

timeseries_get(filename1(1:4),filename1(5:6),level, ...
    'C:\WIS\Atlantic\WW3_multi',plotloc,rdir)
% 
% year = str2num(filename1(1:4));
% mon = str2num(filename1(5:6));
load([plotloc,'ATL-',level,'-plot.mat']);

stats = dir('n4*.onlns');
nn = 0;
locb = zeros(size(compend));
loci = locb;
for zz = 1:length(stats)
    buoyc = stats(zz).name(2:6);
    wis = read_WIS_onlns(['ST',buoyc,'.onlns']);
    buoy = read_NDBC_onlns(stats(zz).name);
    [tit1,saven] = ATL_names(buoyc,buoy,wis,track,res);
    timeplot_data(buoyc,buoy,wis,coord,tit1,saven,'m');
    stats_calc(buoyc,buoy,wis,'WW3-ST4','ATL',level,'m');
    ii = str2num(buoyc) == compend;
    if ~isempty(ii)
        nn = nn + 1;
        loci(ii) = 1;
        locb(ii) = nn;
        comp(nn) = struct('btime',buoy.time,'bwvht',buoy.wvht, ...
            'mtime',wis.time,'mwvht',wis.wvht,'mlat',wis.lat,'mlon',wis.lon);
    end
end
loci = logical(loci);
for zz = 1:size(compend,1)
    id = locb(zz,loci(zz,:));
    if ~isempty(id)
        data = comp(id);
        stations = compend(zz,loci(zz,:));
        compc(zz,compc(zz,1:2) < 0) = compc(zz,compc(zz,1:2) < 0) + 360;
        compplot_data(zz,stations,data,compc(zz,:),title1,track)
    end
end
delete *.onlns
close all

%or_val_set(filename1(1:4),filename1(5:6));
%cd('C:/IMEDS 3.1/src/process');
%imeds

% date1 = [filename1(1:6),'01000000'];
% mon2 = str2double(filename1(5:6)) + 1;
% year2 = str2double(filename1(1:4));
% if mon2 > 12
%     mon2 = 1;
%     year2 = str2double(filename(1:4)) + 1;
% end
% if mon2 < 10
%     mon2s = ['0',num2str(mon2)];
% else
%     mon2s = num2str(mon2);
% end
% date2 = [num2str(year2),mon2s,'01000000'];
% alt_data = read_alt(date1,date2,lonw,lone,lats,latn,res);
% ww3_alt(alt_data,loc);
% close all
% delete ww3.*.hs
