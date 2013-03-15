% files1 = dir('*.tgz');
% for zz = 1:size(files1,1);
%     filename1 = getfield(files1(zz,1),'name');
%     untar(filename1);
% end
%untar('*DEP.tar')
% files = dir('a*');
% fid = fopen('mapcont_Basin.dat','wt');
% for zz = 1:size(files,1);
%     filename = getfield(files(zz,1),'name');
%     file = filename(2:end);
%     fprintf(fid,'%14s \n',file);
% end
% fclose(fid);

% files2 = dir('*.dep');
% filename2 = getfield(files2,'name');
% fid = fopen(filename2,'r');
% data = fscanf(fid,'%f',6);

% res = data(1,1).*60;
% xlats = data(3,1);
% xlatn = data(4,1);
% xlonw = data(5,1);
% xlone = data(6,1);
files1 = dir('*MMd.tgz');
filename1 = getfield(files1,'name');
untar(filename1);

storm = 'STCL-FEMA';
%storm = ['CFSR-18S-05D'];
%storm = ['CFSR-18S-05D'];
%storm = 'Gtest';
%track = 'North';
track = [filename1(1:6)];
modelnm = 'WAM-CY451C';
pars = 0;
ice_coverin = '000';

map_cont_STCL3_new(pars,ice_coverin,storm,...
    track,modelnm)

