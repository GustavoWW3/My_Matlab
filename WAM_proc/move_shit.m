clear all

fdir = dir('*');
direc = fdir(3:end);
stats = [46001;46002;46005;46006;46023;46063;46047;46059;46066;51001; ...
    51002;51003;51004];

for zz = 1:size(direc,1)
    cd(direc(zz).name);
    for qq = 1:size(stats,1)
        if str2num(direc(zz).name(6:7)) >= 10 %&& str2num(direc(zz).name(1:4)) < 2001
            fname = ['stats',num2str(stats(qq,1)),'-',direc(zz).name(1:4), ...
                '_',direc(zz).name(6:7),'-OWI.asc'];
        else
            fname = ['stats',num2str(stats(qq,1)),'-',direc(zz).name(1:4), ...
                direc(zz).name(6:7),'-OWI.asc'];
        end
        ndir = ['E://PACIFIC/WW3/Long_Term/OWI/',num2str(stats(qq,1))];
        if exist(fname,'file')
        if ~exist(ndir,'dir')
            mkdir(ndir)
        end
        cpf = [ndir,'/',fname(1:end-7),'OWI.asc'];
        copyfile(fname,cpf);
        end
    end
    cd ../
end
    