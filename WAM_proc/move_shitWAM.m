
dfile = 'G:\PAC-VALIDATION\VALIDATION';
cfile = 'C:\PACIFIC\WAM\Long_Term\CFSR\';
ofile = 'C:\PACIFIC\WAM\Long_Term\OWI\';
dates = dir('*_??');
for zz = 1:size(dates,1)
    cd(dates(zz).name);
    dates(zz).name
    %types = ls('-d *WAM*');
    %for qq = 1:size(types,1)
    types1 = dir('WAMCY451C*');
    for qq = 1:size(types1,1);
        if strcmp(types1(qq).name(end-4:end),'onlns') == 1
            continue
        else
        types = types1(qq).name;
        break
        end
    end
        cd(types);
        bbop = dir('*.asc');
        for ii = 1:size(bbop,1)
            ww = strfind(bbop(ii).name,'CFSR');
            buoy = bbop(ii).name(6:10);
           % bbop2 = [bbop(ii).name(1:end-4),'-WAMCY453P',bbop(ii).name(end-3:end)];
           bbop2 = bbop(ii).name; 
           if size(ww,1) > 0
                cpfile1 = [cfile,buoy];
                if ~exist(cpfile1,'dir')
                    mkdir(cpfile1)
                end
                cpfile = [cpfile1,'\',bbop2];
            copyfile(bbop(ii).name,cpfile);
            else
                opfile1 = [ofile,buoy];
                if ~exist(opfile1,'dir');
                    mkdir(opfile1);
                end
                opfile = [opfile1,'\',bbop2];
                copyfile(bbop(ii).name,opfile);
            end
        end
        cd ../
    cd ../
end
           