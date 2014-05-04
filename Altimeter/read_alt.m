function [sat_data] = read_alt(date_start,date_end,lonw,lone,lats,latn,res)
%% set input parameters
% date_start = input('What is the start date: ','s');
% date_end = input('What is the end date: ','s');
% lonw = 110.0;lone=300.0;lats=-64.0;latn=64.0;
long = lonw:res:lone;
latg = lats:res:latn;

if exist('H:\','dir')
    dird = 'H:\GlobWave';
    cd(dird);
elseif exist('/mnt/CHL_WIS_1/GlobWave/','dir');
    dird = '/mnt/CHL_WIS_1/GlobWave/';
    cd(dird);
else
    dird = '/media/Expansion Drive/GlobWave/Altimeter';
    cd(dird);
    
end
sats = dir('*');
rr = 0;
for qq = 3:size(sats,1)
    if strcmp(sats(qq).name,'get_alt.m')
        continue
    end
    sat = sats(qq).name;
    cd(sat)
    %% constant days associated with leap year
daylp = [0,31,60,91,121,152,182,213,244,274,305,335];
daynlp = [0,31,59,90,120,151,181,212,243,273,304,334];

%% Break down input times to year,mon,day,hour,minsec
year1 = date_start(1:4);
mon1 = date_start(5:6);
day1 = date_start(7:8);
% hour1 = date_start(9:10);
% minsec1 = date_start(11:14);

year2 = date_end(1:4);
mon2 = date_end(5:6);
day2 = date_end(7:8);
% hour2 = date_end(9:10);
% minsec2 = date_end(11:14);

%% Convert day from mon/day to day number

if leapyear(year1) == 1
    dayt1 = daylp(str2double(mon1)) + str2double(day1);
else
    dayt1 = daynlp(str2double(mon1)) + str2double(day1);
end
if leapyear(year2) == 1
    dayt2 = daylp(str2double(mon2)) + str2double(day2);
else
    dayt2 = daynlp(str2double(mon2)) + str2double(day2);
end
dayt2 = dayt2+1;
year = year1;
if exist(year,'dir')
    cd(year)
else
    cd ../
    continue
end
day = dayt1;
nn = 1;

while day ~= dayt2
    if day < 10
        dayc1 = ['00',num2str(day)];
    elseif day >= 10 && day < 100
        dayc1 = ['0',num2str(day)];
    else
        dayc1 = num2str(day);
    end

    if ~exist(dayc1,'dir')
        if str2double(year1) ~= str2double(year2)
            cd ../
            year = year2;
            cd(year)
            dayc1 = '001';
            day = 1;
            if day == dayt2
                break
            end
        else
            break
        end
    end
    cd(dayc1)
   
    
    %gunzip *.gz
    
    pp = 1;
    files = dir('*.nc');
    for zz = 1:size(files,1)
        swq = ncread(files(zz).name,'swh_quality');
        ii = find(swq < 3.0);
        lont = ncread(files(zz).name,'lon');
        latt = ncread(files(zz).name,'lat');
        tt = ncread(files(zz).name,'time');
        Hst = ncread(files(zz).name,'swh_calibrated');
        if size(ii,1) == 0
            continue
        else
            gg = find(lont(ii)>=lonw&lont(ii)<=lone& ...
                latt(ii)>=lats&latt(ii)<=latn);
            if size(gg,1) == 0
                continue
            else
                time{pp,nn} = alt_time_con(str2double(year),tt(ii(gg))); %#ok<*AGROW>
                lon{pp,nn} = lont(ii(gg));lat{pp,nn} = latt(ii(gg));
                Hs{pp,nn} = Hst(ii(gg));%swhq{pp,nn} = swq(ii(gg));
                pp = pp + 1;
            end
        end
    end
    
%% convert time to matlab time

    %delete *.nc
    day = day + 1;
    nn = nn + 1;
    cd ../
end
if exist('time','var')
    [alt_data] = time_adjust(date_start,date_end,60,time,lon,lat,Hs,long,latg);
    rr = rr + 1;
    sat_data(rr) = struct('sat',sat,'alt_data',alt_data); %#ok<AGROW>
    cd(dird);
    clear alt_data time lon lat Hs
else
    cd(dird);
    continue
end
end