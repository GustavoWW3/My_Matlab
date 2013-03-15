function WIS_2_imeds(fname,var,unit)
%matlab code WIS_2_imeds.m
% convert a WIS onlns format to imeds generic file
% hs = wave height
% u10 = wind speed

aa = load(fname);
if aa(1,1) == 1
    ii = aa(:,3) == aa(1,3);
    stat = aa(ii,4);
    lat = aa(ii,5);
    lon = aa(ii,6);
    jj = aa(:,4) == aa(1,4);
    time = num2str(aa(jj,3));
else
    time = num2str(aa(:,1));
end

fid = fopen([fname(1:end-6),'-imeds.dat'],'wt');
fprintf(fid,'%% IMEDS generic format version 3.1 \n');
textt = ['%% year month day hour min ',var,' (',unit,') \n'];
fprintf(fid,textt);
fprintf(fid,'WIS UTC \n');

if ~exist('stat','var')
fprintf(fid,'%5s%8.3f%8.3f\n',num2str(aa(1,2)),aa(1,3),aa(1,4));

if var == 'u10'
    bb = 7;
elseif var == 'hs'
    bb = 12;
end

for zz = 1:length(aa)
    fprintf(fid,'%4s%3s%3s%3s%3s %6.2f \n',time(zz,1:4),time(zz,5:6), ...
        time(zz,7:8),time(zz,9:10),time(zz,11:12),aa(zz,bb));
end
else
    for qq = 1:length(stat)
        fprintf(fid,'%5s%8.3f%8.3f\n',num2str(stat(qq)),lat(qq),lon(qq));
        pp = aa(:,4) == stat(qq);
        wvht = aa(pp,12);
        for zz = 1:length(wvht)
            fprintf(fid,'%4s%3s%3s%3s%3s %6.2f \n',time(zz,1:4),time(zz,5:6), ...
            time(zz,7:8),time(zz,9:10),time(zz,11:12),wvht(zz));
        end
    end
end
fclose(fid);
