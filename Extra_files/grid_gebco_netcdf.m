function [lon,lat,depth] = grid_gebco_netcdf(lonr,latr)
%
%  lonr   NUMERIC  1x2 array for range of lon . ex. [-79.5 -66]
%  latr   NUMERIC  1x2 array for range of lat  
% ----------------------------------------------------------------
blah = netcdf('gebco_08.nc');
x_range = blah.VarArray(1).Data;
y_range = blah.VarArray(2).Data;
spacing = blah.VarArray(4).Data;

xxfile = x_range(1)*3600+(spacing*3600):30:x_range(2)*3600;
yyfile = y_range(2)*3600-(spacing*3600):-30:y_range(1)*3600;
xlen = length(xxfile);
ylen = length(yyfile);

lonrs = lonr*3600;
latrs = latr*3600;
lon1s = lonrs(1);
if mod(lon1s,30)~=0
    lon1s = floor(lon1s/30);
    lonrs(1) = (lon1s*30);
end
lon2s = lonrs(2);
if mod(lon2s,30)~=0
    lon2s = ceil(lon2s/30);
    lonrs(2) = (lon2s*30);
end
lat1s = latrs(1);
if mod(lat1s,30)~=0
    lat1s = floor(lat1s/30);
    latrs(1) = (lat1s*30);
end
lat2s = latrs(2);
if mod(lat2s,30)~=0
    lat2s = ceil(lat2s/30)+1;
    latrs(2) = (lat2s*30);
end
ii1 = find(xxfile == lonrs(1));
ii2 = find(xxfile == lonrs(2));
numx = ii2 - ii1 + 1;

jj1 = find(yyfile == latrs(2));
jj2 = find(yyfile == latrs(1));

numy = jj2 - jj1 + 1;
dep = zeros(numy,numx);
for jj = 1:numy
    start = (jj1 + (jj-1))*xlen + ii1;
    dep(jj,:) = blah.VarArray(6).Data(start:start+numx-1);
end
depth = flipud(dep);

lon = (lonrs(1):30:lonrs(2))/3600;
lat = (latrs(1):30:latrs(2))/3600;