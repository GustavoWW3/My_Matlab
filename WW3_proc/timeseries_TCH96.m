function timeseries_TCH96(year,mon)
%
%  year and mon are characters
yearm = [year,'-',mon];
%dir1 = ['C:/PACIFIC/WW3/Arun/',yearm];
dir1 = ['C:/PACIFIC/WW3/TCH96-Arun-CFSR/',yearm];
cd(dir1);
file = dir('*TC96-onlns.tgz');
untar(file.name)
%dirname = ['C:/PACIFIC/WW3/Arun/Validation/',yearm];
dirname = ['C:/PACIFIC/WW3/TCH96-Arun-CFSR/Validation/WIS/',yearm];
if ~exist(dirname,'dir')
    mkdir(dirname);
end
copyfile('*.onlns',dirname);

cd('C:/PACIFIC/NDBC')
fid = fopen('WAM_OUTPUT-LOCS.txt','r');
data = textscan(fid,'%f%f%f','headerlines',3);
stations = data{3}; 
cd(yearm);
for zz = 1:size(stations,1)
    cd(num2str(stations(zz,1)));
    fname=['n',num2str(stations(zz,1)),'_',year,'_',mon,'.onlns'];
    if exist(fname,'file');
       copyfile(fname,dirname);
    end
    cd('../')
    
end
cd(dirname);