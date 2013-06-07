function ww3_grid_create(fdir,fname,lon,lat,dep,res)
%

m = dep;
m(dep >= 0) = 0;
m(dep < 0) = 1;

% ii = lon < 0;
% lon(ii) = lon(ii) + 360;

coord = [min(lat) min(lon) max(lat) max(lon)];

load('/home/thesser1/My_Matlab/make_grid/reference_data/coastal_bound_full.mat');

tol = res/3600 * 4;
if tol <= 2.0 
    tol = 2.0;
end

[b,nn] = compute_boundary(coord,bound,0);

b2 = split_boundary(b,tol,0);

m2 = clean_mask(lon,lat,m,b2,0.2);

m3 = remove_lake(m2,3,0);

[Sx, Sy] = create_obstr(lon,lat,b,m3,1,1);

write_ww3meta([fdir,'/',fname],lon,lat,0.001,0.01);
d = round(dep*1000);
write_ww3file([fdir,'/',fname,'.grd'],d);
write_ww3file([fdir,'/',fname,'.mask'],m3);
d1 = round(Sx*100); d2 = round(Sy*100);
write_ww3obstr([fdir,'/',fname,'.obst'],d1,d2);
