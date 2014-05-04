function [lon,lat,depth] = grid_gebco(lonr,latr)
%
%  lonr   NUMERIC  1x2 array for range of lon . ex. [-79.5 -66]
%  latr   NUMERIC  1x2 array for range of lat  
% ----------------------------------------------------------------
%pdir = '/mnt/CHL_WIS_1/Bathymetry/GEBCO/';
pdir = '/home/thesser1/roams/coupling/general/bathy/';
pname = [pdir,'gebco_08.nc'];
x_range = ncread(pname,'x_range');
y_range = ncread(pname,'y_range');
spacing = ncread(pname,'spacing');

if lonr(2) == 180
    lonr(2) = (180*3600-30)/3600;
end

if lonr(2) < 0 & lonr(1) > 0
    nrun = 2;
else
    nrun = 1;
end
%xxfile = x_range(1)*3600+(spacing*3600):30:x_range(2)*3600;
%yyfile = y_range(2)*3600-(spacing*3600):-30:y_range(1)*3600;
xxfile = x_range(1)*3600:30:x_range(2)*3600-(spacing*3600);
yyfile = y_range(2)*3600:-30:y_range(1)*3600+(spacing*3600);
xlen = length(xxfile);
ylen = length(yyfile);

for jr = 1:nrun
    if nrun > 1
        if jr == 1
            lonr1 = lonr(1);
            lonr2 = (180*3600-30)/3600;
        else
            lonr1 = -180.0;
            lonr2 = lonr(2);
        end
    else
        lonr1 = lonr(1);
        lonr2 = lonr(2);
    end
    
    dxsec = fix(spacing(1)*3600);
    dysec = fix(spacing(2)*3600);
    ii1 = find(xxfile > fix((lonr1*3600) - dxsec) & xxfile <= fix(lonr1*3600));
    ii2 = find(xxfile >= fix(lonr2*3600) & xxfile < fix(lonr2*3600 + dxsec));
    numx = ii2 - ii1 + 1;

    jj1 = find(yyfile >= fix(latr(2)*3600) & yyfile < fix(latr(2)*3600 + dysec));
    jj2 = find(yyfile <= fix(latr(1)*3600) & yyfile > fix(latr(1)*3600 - dysec));
    numy = jj2 - jj1 + 1;

    for jj = 1:numy
        start = (jj1 + (jj-1))*xlen + ii1;
        dep(jj,:) = ncread(pname,'z',start,numx);
    end
    dep = flipud(dep);

    lon1 = (xxfile(ii1):30:xxfile(ii2))./3600;
    lat1 = (yyfile(jj2):30:yyfile(jj1))./3600;
    if jr == 1
        depth = dep;
        lon = lon1;
        lat = lat1;
    else
        depth = [depth,dep];
        lon = [lon,lon1];
    end
    clear ii1 ii2 jj1 jj2 numx numy dep lon1 lat1
end