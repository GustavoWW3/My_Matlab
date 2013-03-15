function get_WIS(diamname,filediam,outfile)

year = 2001;
monlist = (11:1:12);
%monlist = 1;
% for zz = 1:size(monlist,2);
%     %if zz > 1
%         if monlist(zz) < 10
%             monc = ['0',num2str(monlist(zz))];
%         else
%             monc = num2str(monlist(zz));
%         end
%         filediam = [num2str(year),monc,filediam(7:end)];
    %end
if ~exist(outfile,'dir')
    mkdir(outfile);
end
fdir = ('C:\Program Files (x86)\HPCMP Kerberos');
cd(fdir);
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*-grd1*.tgz ',outfile];
system(fname);
loc2 = [outfile,'/nest1'];
if ~exist(loc2,'dir')
    mkdir(loc2);
end
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*-grd2*.tgz ',[outfile,'/nest1']];
system(fname);
loc3 = [outfile,'/nest2'];
if ~exist(loc3,'dir')
    mkdir(loc3);
end
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*-grd3*.tgz ',[outfile,'/nest2']];
system(fname);
% fname2 = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',dirname,'/',filen,'/*onlns.tgz ',outfile];
% system(fname2);
% 
% fname3 = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',dirname,'/',filen,'/*MMt.tgz ',outfile];
% system(fname3);
loc1 = pwd;
cd(outfile);

ww3_read

cd(loc3) 
ww3_read_01

cd(loc2)
ww3_read_025

cd(loc1);
end