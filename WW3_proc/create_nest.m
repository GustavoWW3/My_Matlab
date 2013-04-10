function create_nest(fdir1,fname1,fdirb,fnameb)

[lon,lat] = read_ww3meta([fdir1,'/',fname1,'.meta']);
Nx = length(lon);
Ny = length(lat);
m = read_mask([fdir1,'/',fname1,'.mask'],Nx,Ny);

[lonb,latb] = read_ww3meta([fdirb,'/',fnameb,'.meta']);
Nxb = length(lonb);
Nyb = length(latb);
mb = read_mask([fdirb,'/',fnameb,'.mask'],Nxb,Nyb);

px = [lon(1) lon(1) lon(end) lon(end) lon(1)];
py = [lat(1) lat(end) lat(end) lat(1) lat(1)];

m_new = modify_mask(m,lon,lat,px,py,mb,lonb,latb,0);

write_ww3file([fdir1,'/',fname1,'.mask'],m_new);
