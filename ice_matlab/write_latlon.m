function write_latlon(filename,ice)
%% Parameters
fmt=[repmat('%9.5f ',1,512),'\n'];

%% Write to file
fid=fopen(filename,'wt');
fprintf(fid,fmt,flipud(ice.lat)');
fprintf(fid,fmt,flipud(ice.lon)');
fclose(fid);