function get_FEMA(diamname,filediam,outdir)

%year = 2001;
%monlist = (11:1:12);
%monlist = 1;
%for zz = 1:size(monlist,2);
    %if zz > 1
%        if monlist(zz) < 10
%            monc = ['0',num2str(monlist(zz))];
%        else
%            monc = num2str(monlist(zz));
%        end
%        filediam = [num2str(year),monc,filediam(7:end)];
    %end
outfile = [outdir,'\',filediam,'\WAM\'];
if ~exist(outfile,'dir')
mkdir(outfile)
end
fdir = ('C:\Program Files (x86)\HPCMP Kerberos');
cd(fdir);
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*ONLNS.tgz ',outfile];
system(fname);
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*SPE.tgz ',outfile];
system(fname);
fname = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',diamname,'/',filediam,'/*MMd.tgz ',outfile];
system(fname);


% fname2 = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',dirname,'/',filen,'/*onlns.tgz ',outfile];
% system(fname2);
% 
% fname3 = ['pscp.exe thesser1@diamond03.erdc.hpc.mil:',dirname,'/',filen,'/*MMt.tgz ',outfile];
% system(fname3);
loc1 = pwd;
cd(outfile);

read_astar3
cd(loc1);
end