files = dir('*t.onlns');
tpmax = 0.0;
tpfmax = 0.0;
tpmin = 100.0;
tpfmin = 100.0;
for zz = 1:size(files,1)
    filename = getfield(files(zz),'name');
    data = load(filename);
    qq = find(data(:,22) >= 0.0);
    max(data(qq,22))
    tpmax = max(tpmax,max(data(qq,22)));
    tpmin = min(tpmin,min(data(qq,22)));
    kk = find(data(:,23) >= 0.0);
    max(data(kk,23))
    tpfmax = max(tpmax,max(data(kk,23)));
    tpfmin = min(tpmin,min(data(kk,23)));
    clear data qq kk
end   
    
    
    