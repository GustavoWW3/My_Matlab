function [depth,lat,lon] = read_WAM_dep(fname)

fid = fopen(fname);
data = textscan(fid,'%f%f%f%f%f%f',1);
numlat = fix((data{4} - data{3})./data{1} + 1);
numlon = fix((data{6} - data{5})./data{2} + 1);
lat = data{3}:data{1}:data{4};
lon = data{5}:data{2}:data{6};

for jj = 1:numlat
    for ii = 1:numlon
        data = textscan(fid,'%5f',1);
        depth(ii,jj) = data{1};
        data = textscan(fid,'%1c',1);
        deptp(ii,jj) = data{1};
    end
end
fclose(fid);