% program wam_2_ww3_grid.m
%
%  Converts WAM *.dep file to WW3 grid information
%     Created 10/16/2012 by TJ Hesser
% 
%  Reads in *.dep file from present directory
%    Outputs a *.grd and *.mask with same name as *.dep file into same
%    directory
%
% ------------------------------------------------------------------------
% Check directory for *.dep file
wamfile = dir('*.dep');

% Read WAM *.dep file and send back grid information
[dep,lat,lon] = read_WAM_dep(wamfile(1).name);

% Create mask with depth set to 1 and land set to 0
mask = dep;
mask(deptext == 'D') = 1;
mask(deptext == 'E') = 0;
obst = zeros(size(mask));
% make WW3 grid file and mask file based on *.dep file name
fid = fopen([wamfile(1).name(1:end-3),'grd'],'w');
fid2 = fopen([wamfile(1).name(1:end-3),'obst'],'w');
fid3 = fopen([wamfile(1).name(1:end-3),'mask'],'w');

% loop through and output free format files for WW3
for jj = 1:length(lat)
    % write out depth file with a multiplier of 0.001 to remove integer
    % dependencies
    a = fix(dep(:,jj)'./0.001);
    fprintf(fid,' %d ',a);
    fprintf(fid,'\n');
    b = fix(obst(:,jj)');
    fprintf(fid2,' %d ',b);
    fprintf(fid2,'\n');
    c = fix(mask(:,jj)');
    % write out mask file 
    fprintf(fid3,' %d ',c);
    fprintf(fid3,'\n');
end
for jj = 1:length(lat)
    b = fix(obst(:,jj)');
    fprintf(fid2,' %d ',b);
    fprintf(fid2,'\n');
end
% close both files
fclose(fid);fclose(fid2);fclose(fid3);
