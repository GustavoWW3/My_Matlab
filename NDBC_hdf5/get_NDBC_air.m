function [aa payload] = get_NDBC_air(fname)

fprintf(1,'Analyizing Station %5s\n',fname(6:10));
%Get attributes distributed
fileatt = h5info(fname);
fatt = {fileatt.Attributes.Name};

% Get time out of the file and convert to year mon day hour min sec
times = double(h5read(fname,'/time'));
[year,mon,day,hour,min,sec] = datevec( ...
        datenum(1970,1,1)+times./86400);
    
% Get lat and lon out of file and convert to deg min sec  
latm = strcmp(fatt,'nominal_latittude');
lat = h5readatt(fname,'/','nominal_latitude');
[lad,lam,las] = deg2dms(abs(lat));
lam = abs(lam);las = round(las);las = abs(las);
lad = repmat(lad,[length(year) 1]);lam = repmat(lam,[length(year) 1]);
las = repmat(las,[length(year) 1]);
lon = h5readatt(fname,'/','nominal_longitude');
[lod,lom,los] = deg2dms(abs(lon));
lom = abs(lom);los = abs(los);los = round(los);
lod = repmat(lod,[length(year) 1]);lom = repmat(lom,[length(year) 1]);
los = repmat(los,[length(year) 1]);
if lon < 0
    lod = -lod;
end
if lat < 0
    lat = -lat;
end


% Get depth out of file
try
    dep = h5readatt(fname,'/','sea_floor_depth_below_sea_level');
catch
    dep = -999.00;
end
dep = repmat(dep,[length(year) 1]);

% Get windspeed, windgust, wind direction
try
    wspd = h5read(fname,['/payload_1/anemometer_1/wind_speed']);
    payload = 'payload_1';
    payatt = h5readatt(fname,'/payload_1','description');
    np = length(payatt);sp = ['%',num2str(np),'s\n'];
    fprintf(1,'Using payload_1\n');
    fprintf(1,sp,payatt);
catch
    wspd = h5read(fname,['/payload_2/anemometer_1/wind_speed']);
    payload = 'payload_2';
    payatt = h5readatt(fname,'/payload_2','description');
    np = length(payatt);sp = ['%',num2str(np),'s\n'];
    fprintf(1,'Using payload_2\n');
    fprintf(1,sp,payatt);
end
wspd_q = h5read(fname,['/',payload,'/anemometer_1/wind_speed_qc']);
ii = wspd_q ~= 0;
wspd(ii) = -99.99;
if sum(ii) > 0
  wspd2 = h5read(fname,['/',payload,'/anemometer_2/wind_speed']);
  wspd_q2 = h5read(fname,['/',payload,'/anemometer_2/wind_speed_qc']);
  jj = wspd_q2(ii) == 0;
  wspd(ii(jj)) = wspd2(ii(jj));
end
wspd_info = h5info(fname,['/',payload,'/anemometer_1/wind_speed']);
ii = wspd == wspd_info.FillValue;
wspd(ii) = -99.99;

% Get anemometer height
try
    anemh = h5readatt(fname,['/',payload,'/anemometer_1','height_of_instrument']);
catch
    anemh = 'NaN';
    re = 0;
end
if ~isnan(anemh)
    dp = dir('C:\NDBC\alt_height.dat');
    if exist(dp(1).name,'file')
        fid2 = fopen(dp(1).name);
        data = textscan(fid2,'%s%f');
        ii = strcmp(data{1},fname(6:10));
        anemh = data{2}(ii);
    else
        ques = ['What is the anemometer height for buoy ',fname(6:10),': '];
        anemh = input(ques);
    end
end
anemh = repmat(anemh,[length(year) 1]);

wgus = h5read(fname,['/',payload,'/anemometer_1/wind_gust']);
wgus_q = h5read(fname,['/',payload,'/anemometer_1/wind_gust_qc']);
ii = wgus_q ~= 0;
wgus(ii) = -99.99;
if sum(ii) > 0
  wgus2 = h5read(fname,['/',payload,'/anemometer_2/wind_gust']);
  wgus_q2 = h5read(fname,['/',payload,'/anemometer_2/wind_gust_qc']);
  jj = wgus_q2(ii) == 0;
  wgus(ii(jj)) = wgus2(ii(jj));
end
wgus_info = h5info(fname,['/',payload,'/anemometer_1/wind_gust']);
ii = wgus == wgus_info.FillValue;
wgus(ii) = -99.99;

wdir = h5read(fname,['/',payload,'/anemometer_1/wind_direction']);
wdir_q = h5read(fname,['/',payload,'/anemometer_1/wind_direction_qc']);
ii = wdir_q ~= 0;
wdir(ii) = -999.0;
if sum(ii) > 0
  wdir2 = h5read(fname,['/',payload,'/anemometer_2/wind_direction']);
  wdir_q2 = h5read(fname,['/',payload,'/anemometer_2/wind_direction_qc']);
  jj = wdir_q2(ii) == 0;
  wdir(ii(jj)) = wdir2(ii(jj));
end
wdir_info = h5info(fname,['/',payload,'/anemometer_1/wind_direction']);
ii = wdir == wdir_info.FillValue;
wdir(ii) = -999.0;
wdir = single(wdir);

% Get Air temperature and Sea tempurature
atemp = h5read(fname,['/',payload,'/air_temperature_sensor_1/air_temperature']);
atemp_q = h5read(fname,['/',payload,'/air_temperature_sensor_1/air_temperature_qc']);
atemp_info = h5info(fname,['/',payload,'/air_temperature_sensor_1/air_temperature']);
ii = atemp == atemp_info.FillValue;
atemp = atemp - 272.15;
atemp(ii) = -99.99;
ii = atemp_q ~= 0;
atemp(ii) = -99.99;
try
    if sum(ii) > 0
    atemp2 = h5read(fname,['/',payload,'/air_temperature_sensor_2/air_temperature']);
    atemp_q2 = h5read(fname,['/',payload,'/air_temperature_sensor_2/air_temperature']);
    jj = atemp_q2(ii) == 0;
    atemp(ii(jj)) = atemp2(ii(jj));
    end
catch
end

try
    stemp = h5read(fname,['/',payload,'/ocean_temperature_sensor_1/sea_surface_temperature']);
    stemp_q = h5read(fname,['/',payload,'/ocean_temperature_sensor_1/sea_surface_temperature_qc']);
    stemp_info = h5info(fname,['/',payload,'/ocean_temperature_sensor_1/sea_surface_temperature']);
    ii = stemp == stemp_info.FillValue;
    stemp = stemp - 272.15;
    stemp(ii) = -99.99;
    ii = stemp_q ~= 0;
    stemp(ii) = -99.99;
catch
    stemp = repmat(-99.99,[length(times) 1]);
end
% Get barometric pressure from file
barp = h5read(fname,['/',payload,'/barometer_1/air_pressure_at_sea_level']);
barp_q = h5read(fname,['/',payload,'/barometer_1/air_pressure_at_sea_level_qc']);
barp_info = h5info(fname,['/',payload,'/barometer_1/air_pressure_at_sea_level']);
ii = barp == barp_info.FillValue;
barp = double(barp)./100;
barp(ii) = -999.;
ii = barp_q ~= 0;
barp(ii) = -999.;
if sum(ii) ~= 0
    barp2 = h5read(fname,['/',payload,'/barometer_2/air_pressure_at_sea_level']);
    barp_q2 = h5read(fname,['/',payload,'/barometer_2/air_pressure_at_sea_level_qc']);
    jj = barp_q2(ii) == 0;
    barp(ii(jj)) = barp2(ii(jj));
end

aa = [year,mon,day,hour,min,lad,lam,las,lod,lom,los,dep,anemh, ...
    double(wspd),double(wgus),double(wdir),double(atemp),double(stemp), ...
    double(barp)];


