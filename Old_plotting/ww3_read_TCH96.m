%ftp_trans_ww3_TCH96

files1 = dir('*MMt.tgz');
filename1 = getfield(files1,'name');
dirname = [filename1(1:4),'-',filename1(5:6)];
movefile('*.tgz',dirname);
cd(dirname)
untar(filename1);

files2 = dir('*spec.tgz');
untar(files2.name);

mkdir('Spectra');
files3 = dir('*spec-buoy.tgz');
copyfile(files3.name,'Spectra');
cd('Spectra');
untar(files3.name);
cd ../

storm = 'Pacific';
%storm = 'Gtest';
%track = 'North';

if size(filename1,2) > 27
    modelnm = ['WW3-CFSR'];
    track = [filename1(1:4),'-',filename1(5:6)];
else
    modelnm = 'WW3-CFSR';
    track = [filename1(1:4),'-',filename1(5:6)];
end

ww3_cont_pac(storm,track,modelnm)

timeseries_TCH96(filename1(1:4),filename1(5:6))

year = str2num(filename1(1:4));
mon = str2num(filename1(5:6));
timeplt_WW32_Pacific(year,mon,0.5,1,'TCH96-CFSR')

close all

% or_val_set(filename1(1:4),filename1(5:6));
%cd('C:/IMEDS 3.1/src/process');
%imeds

cd('C:/PACIFIC/WW3/TCH96-Arun-CFSR/');