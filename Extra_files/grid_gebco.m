function [lon,lat,depth] = grid_gebco(lonr,latr)
%
%  lonr   NUMERIC  1x2 array for range of lon . ex. [-79.5 -66]
%  latr   NUMERIC  1x2 array for range of lat  
% ----------------------------------------------------------------
pdir = '/mnt/CHL_WIS_1/Bathymetry/GEBCO/';
pname = [pdir,'gebco_08.nc'];
x_range = ncread(pname,'x_range');
y_range = ncread(pname,'y_range');
spacing = ncread(pname,'spacing');

xxfile = x_range(1)*3600+(spacing*3600):30:x_range(2)*3600;
yyfile = y_range(2)*3600-(spacing*3600):-30:y_range(1)*3600;
xlen = length(xxfile);
ylen = length(yyfile);

ii1 = find(xxfile == lonr(1)*3600);
ii2 = find(xxfile == lonr(2)*3600);
numx = ii2 - ii1 + 1;

jj1 = find(yyfile == latr(2)*3600);
jj2 = find(yyfile == latr(1)*3600);

numy = jj2 - jj1 + 1;
for jj = 1:numy
    start = (jj1 + (jj-1))*xlen + ii1;
    dep(jj,:) = ncread(pname,'z',start,numx);
end
depth = flipud(dep);

lon = lonr(1):30/3600:lonr(2);
lat = latr(1):30/3600:latr(2);