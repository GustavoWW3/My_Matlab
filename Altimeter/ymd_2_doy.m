function [ydayc] = ymd_2_doy(year,mon,day)
%%
%   Converts year mon day to the number of days in that year
%     Created 02/12/2012 by tjh
%   
%   Input:
%       year       (String)  (i.e.  1990)  
%       mon        (String)  (i.e.  05)
%       day        (String)  (i.e.  25)
%

%% Set the days in each month given a leap year or not
daylp = [0,31,60,91,121,152,182,213,244,274,305,335];
daynlp = [0,31,59,90,120,151,181,212,243,273,304,334];

%% Determine a leapyear is being calculated
if leapyear(str2double(year))
    yday = daylp(str2double(mon)) + str2double(day);
else
    yday = daynlp(str2double(mon)) + str2double(day);
end

%% Convert from numeric day to strday
if yday < 10
    ydayc = ['00',num2str(yday)];
elseif yday < 100
    ydayc = ['0',num2str(yday)];
else
    ydayc = num2str(yday);
end