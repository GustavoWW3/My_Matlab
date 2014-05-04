function sat_data = read_alt_daily(date_start,date_end,coord,res)
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

long = coord(1):res:coord(2);
latg = coord(3):res:coord(4);

year1 = date_start(1:4);
mon1 = date_start(5:6);
day1 = date_start(7:8);

year2 = date_end(1:4);
mon2 = date_end(5:6);
day2 = date_end(7:8);

fnc = dir('wm*.nc');
for zz = 1:size(fnc,1)
    swh = ncread(fnc(zz).name,'swhcor');
    times = ncread(fnc(zz).name,'time');
    lons = ncread(fnc(zz).name,'lon');
    lats = ncread(fnc(zz).name,'lat');
    sat = ncread(fnc(zz).name,'satellite');

    %lons(lons < 0) = lons(lons < 0) + 360;
    gloc = find(lons>=coord(1)&lons<=coord(2)& ...
                lats>=coord(3)&lats<=coord(4));
    if size(gloc,1) == 0
       continue
    else
       tt1 = datenum(1900,1,1,0,0,0); 
       time{zz} = times(gloc) + tt1; 
       lon{zz} = lons(gloc);lat{zz} = lats(gloc);
       Hs{zz} = swh(gloc);
       satl{zz} = sat(gloc);
    end
end


alt_data = time_adjust(date_start,date_end,60,time,lon,lat,Hs,long,latg);
sat_data = struct('sat','All Satellites','alt_data',alt_data,'coord',coord, ...
    'res',res);
%------------- END OF CODE --------------
