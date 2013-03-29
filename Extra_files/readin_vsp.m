function [date freq spec] = readin_vsp(fname);

fid = fopen(fname);

data = textscan(fid,'%f%f%f%f%f%f%f',1);
year(1,1) = data{1};
mon(1,1) = data{2};
day(1,1) = data{3};
hour(1,1) = data{4};
min(1,1) = data{5};
if min(1,1) > 30
    hour(1,1) = data{4} + 1;
end
fnum = data{7};

for jj = 1:9999999
    data = textscan(fid,'%f%f%f%f%f%f%f%f',fnum);
    freq(jj,:) = data{1};
    df(jj,:) = data{2};
    spec(jj,:) = data{3};
    a1(jj,:) = data{4};
    a2(jj,:) = data{5};
    b1(jj,:) = data{6};
    b2(jj,:) = data{7};
    
    data = textscan(fid,'%f%f%f%f%f%f%f',1);
    if size(data{1},1) == 0
        break
    end
    year(jj+1,1) = data{1};
    mon(jj+1,1) = data{2};
    day(jj+1,1) = data{3};
    hour(jj+1,1) = data{4};
    min(jj+1,1) = data{5};
    if min(jj+1,1) > 30
        hour(jj+1,1) = data{4} + 1;
    end
end
    date = [year mon day hour];