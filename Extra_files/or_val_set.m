function or_val_set(year,mon)

cd('C:\PACIFIC\WW3\Default_Arun\Validation\OR')
dirname = [year,'-',mon];
if ~exist(dirname)
    mkdir(dirname);
end
ndir = ['C:\PACIFIC\WW3\Default_Arun\Validation\OR\',dirname];

moddir = ['C:\PACIFIC\WW3\Default_Arun\',dirname,'\Spectra'];
cd(moddir)
files = dir('*.spe2d');
for zz = 1:size(files,1)
    filename = files(zz).name;
    wam_2_vsp(filename);
end
movefile('*.vsp',ndir);

buoydir = ['C:\PACIFIC\NDBC\',dirname];
cd(buoydir)
statn = dir('*');
for zz = 3:size(statn,1)
    station = statn(zz).name;
    cd(station)
    spef = dir('*.spe*');
    if size(spef,1) > 0
        if size(spef,1) == 3
            NDBC_spec_vsp(spef(2).name);
        else
            NDBC_spec_vsp(spef(1).name);
        end
       movefile('*.vsp',ndir);
    end
    cd ../
end
    
cd(ndir)
bfname = dir('n*.vsp');
mfname = dir('*ST*.vsp');
for zz = 1:size(bfname,1)
    buoyname = bfname(zz).name;
    for qq = 1:size(mfname,1)
        if strcmp(buoyname(2:6),mfname(qq).name(end-8:end-4)) == 1
            htplot(10,2,buoyname,mfname(qq).name)
            makeplot(1,0.03,0.50,buoyname,mfname(qq).name)
        end
    end
end