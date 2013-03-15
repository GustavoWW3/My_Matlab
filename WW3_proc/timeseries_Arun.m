function timeseries_Arun(year,mon)
%
month = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'};
%  year and mon are characters
yearm = [year,'-',mon];
dirh = '/home/thesser1/Pacific/WW3_multi_tst/';
dir1 = [dirh,yearm];
dirh1 = [dir1,'/grd1'];
%dir1 = ['E:/PACIFIC/WW3/Default_Arun/',yearm];
cd(dirh1);
file = dir('*ST-onlns.tgz');
untar(file.name)
fname = dir('*.onlns');
% if ~strcmp(fname(1).name(end-9:end-6),'grd1')
% for zz = 1:size(fname,1)
%     movefile(fname(zz).name,[fname(zz).name(1:end-6),'-grd1.onlns']);
% end
% tar(file.name,'*.onlns');
% end
copyfile('*.onlns','../');
dir2 = [dir1,'/grd3'];
cd(dir2);
file2 = dir('*ST-onlns.tgz');
untar(file2.name)
fname = dir('*.onlns');
% if ~strcmp(fname(1).name(end-9:end-6),'grd2')
% for zz = 1:size(fname,1)
%     movefile(fname(zz).name,[fname(zz).name(1:end-6),'-grd2.onlns']);
% end
% tar(file2.name,'*.onlns');
% end
copyfile('*.onlns','../');
delete *.onlns
dir3 = [dir1,'/grd4'];
cd(dir3);
file3 = dir('*ST-onlns.tgz');
untar(file3.name)
fname = dir('*.onlns');
copyfile('*.onlns','../');
delete *.onlns
cd(dir1);
% system('type *Pac*06*.onlns > WW3-Pac-9906.onlns');
% system('type *PACIFIC*06*.onlns > WW3-PACIFIC-Basin-1999-06.onlns');
% delete *grd1.onlns *grd2.onlns
dirname = ['/home/thesser1/Pacific/WW3_multi_tst/Validation/WIS/',yearm,'/'];
%dirname = ['C:/PACIFIC/WW3/Default_Arun/Validation/WIS/',yearm];
if ~exist(dirname,'dir')
    mkdir(dirname);
end
copyfile('*.onlns',dirname);
delete *.onlns
cd(dirh)
data = load('OUTPUT-LOCS.txt','r');
stations = data(:,3);

cd(['/mnt/CHL_WIS_1/NDBC/',year,'/',month{str2num(mon)}]);
for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
    fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
    if exist(fname,'file');
       copyfile(fname,dirname);
    end
    %cd('../')
    
end


cd(['/mnt/CHL_WIS_1/CANADIAN_BUOY_PAC/']);
for zz = 1:size(stations,1)
    if exist(num2str(stations(zz,1)),'dir')
        cd(num2str(stations(zz,1)));
        fname = ['n',num2str(stations(zz,1)),'_',year,'.onlns'];
        if exist(fname,'file')
            copyfile(fname,dirname);
        end
        cd ../
    end
end
if exist(['/mnt/CHL_WIS_1/NDBC_CDIP/',year,'/',month{str2num(mon)}],'dir')
cd(['/mnt/CHL_WIS_1/NDBC_CDIP/',year,'/',month{str2num(mon)}]);
for zz = 1:size(stations,1)
    %cd(num2str(stations(zz,1)));
    fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
    if exist(fname,'file');
       copyfile(fname,dirname);
    end
    %cd('../')
    
end
else
cd(['/mnt/CHL_WIS_1/CDIP/spc_',year]);
istats = data(:,4) ~= 999;
stats = data(istats,4);
statsnd = data(istats,3);
for zz = 1:size(stats,1)
    if stats(zz,1) < 10
        statst = ['00',num2str(stats(zz,1))];
    elseif stats(zz,1) < 100
        statst = ['0',num2str(stats(zz,1))];
    else
        statst = num2str(stats(zz,1));
    end
    if exist(statst,'dir')
    cd(statst);
    if exist(month{str2num(mon)},'dir')
    cd(month{str2num(mon)});
    cd('01')
    aa = read_cdip_sp('/mnt/CHL_WIS_1/CDIP/');
    savename = [dirname,'s',num2str(statsnd(zz,1)),'_',year,'_',mon,'.mat'];
    save(savename,'aa');
    cd ../../../
    else
        cd ../
    end
    end
end
end
cd(dirname);
