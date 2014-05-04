function get_alt_daily(date_start,date_end,coord,res)
%read_alt_daily - reads GlobWave daily altimeter files and places it on
%   a grid
%
% Syntax:  [sat_data] = read_alt_daily(date_start,date_end,coord)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: TJ Hesser
% Work address: USACE ERDC
% email: tyler.hesser@usace.army.mil
% May 2004; Last revision: 12-May-2004

%------------- BEGIN CODE --------------
ftpg = 'ftp.ifremer.fr';
ftppath = 'ifremer/cersat/products/swath/altimeters/waves/data/';

long = coord(1):res:coord(2);
latg = coord(3):res:coord(4);

year1 = date_start(1:4);
mon1 = date_start(5:6);
day1 = date_start(7:8);

year2 = date_end(1:4);
mon2 = date_end(5:6);
day2 = date_end(7:8);

f = ftp(ftpg);
cd(f,ftppath);
for iyear = str2num(year1):str2num(year2)
    year = num2str(iyear);
    cd(f,year);
    if iyear ~= str2num(year2) & str2num(year1) ~= str2num(year2)
        mons = str2num(mon1);
        mone = 12;
    elseif iyear == str2num(year2) & str2num(year1) ~= str2num(year2)
        mons = 1;
        mone = str2num(mon2);
    else
        mons = str2num(mon1);
        mone = str2num(mon2);
    end

    for imon = mons:mone
        if imon < 10
            mon = ['0',num2str(imon)];
        else
            mon = num2str(imon);
        end
        cd(f,mon);
        if imon ~= str2num(mon2) & str2num(mon1) ~= str2num(mon2)
            days = str2num(day1);
            daye = day_in_mon(year,mon);
        elseif imon == str2num(mon2) & str2num(mon1) ~= str2num(mon2)
            days = 1;
            daye = str2num(day2);
        else
            days = str2num(day1);
            daye = str2num(day2);
        end
        for iday = days:daye
            if iday < 10
                day = ['0',num2str(iday)];
            else
                day = num2str(iday);
            end
            fname = ['wm_',year,mon,day,'.nc.bz2'];
            mget(f,fname);
        end
        cd(f,'../');
    end
    cd(f,'../');
end

end


function nday = day_in_mon(year,mon)
    year = str2num(year);
    mon = str2num(mon);
    
    daylp = [31,29,31,30,31,30,31,31,30,31,30,31];
    daynlp = [31,28,31,30,31,30,31,31,30,31,30,31];
    
    if leapyear(year)
        nday = daylp(mon);
    else
        nday = daynlp(mon);
    end
end
%------------- END OF CODE --------------
