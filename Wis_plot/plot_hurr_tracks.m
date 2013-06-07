function [lonf,latf] = plot_hurr_tracks(yr,mn,lonc,latc)

year = num2str(yr);
fname = ['Year.',year,'.ibtracs_all.v03r04.nc'];
% get time from netcdf file
time = ncread(fname,'source_time');

% set baseline time as described in file
tt1 = datenum(1858,11,17,0,0,0);
% add baseline to time to get matlab time 
tt = time + tt1;

% set time domain to analyze
t1 = datenum(yr,mn,01,0,0,0);
if mn == 12
    yr2 = yr + 1;
    mn = 1;
else
    yr2 = yr;
    mn = mn + 1;
end
t2 = datenum(yr2,mn,01,0,0,0);
ii = tt >= t1 & tt <= t2;

lo = ncread(fname,'lon_for_mapping');
la = ncread(fname,'lat_for_mapping');
iis = sum(ii);
jj = iis > 1;
lon = lo(:,jj);
lat = la(:,jj);

lonc(lonc>180) = lonc(lonc>180) - 360;
ilon = lon >= lonc(1) & lon <= lonc(2);
ilat = lat >= latc(1) & lat <= latc(2);
ilo = sum(ilon);
ila = sum(ilat);
iboth = ila > 0 & ilo > 0;
lonf = lon(:,iboth);
latf = lat(:,iboth);
