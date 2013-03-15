fid = fopen('fort.61','r')

data = fgetl(fid);
date = str2num(data(35:50));
starttime = [data(35:39),data(41:42),data(44:45)];
timestep = date(4);
data = fscanf(fid,'%f',2);
nx = data(1);
nstat = data(2);
data = fgetl(fid);
data = fscanf(fid,'%f',2);
time(1) = data(1);
tstep(1) = data(2);

for ii = 1:nx
    data = textscan(fid,'%f%f',nstat);
    point(:,ii) = data{1};elev(:,ii) = data{2};
    
    if ii ~= nx
        data = fscanf(fid,'%f',2);
        time(ii+1) = data(1);
        tstep(ii+1) = data(2);
    end
end
fclose(fid);