
fid = fopen('C:\Great_lakes\Lake_Stclair\Bathy\Lake_St_Clair_Coastline2.d');

blah = fgetl(fid);

for ii = 1:123
    data = textscan(fid,'%f%c%f');
    lon_coast{ii} = data{1};
    lat_coast{ii} = data{3};
    %if ii < 123
        blah = fgetl(fid);
        blah = fgetl(fid);
    %end
end
fclose(fid);