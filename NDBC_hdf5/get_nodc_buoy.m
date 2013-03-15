function get_nodc_buoy(year,mon,stat)
p = inputParser;
p.addRequired('year');
p.addRequired('mon');
p.addOptional('stat','00000');

months = ['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'];
dir1 = num2str(year);
if ~exist(dir1,'dir')
    mkdir(dir1);
end
cd(dir1);
dir2 = months(mon,:);
if ~exist(dir2,'dir')
    mkdir(dir2);
end
cd(dir2);

f = ftp('ftp.nodc.noaa.gov');
cd(f,'pub/data.nodc/ndbc/cmanwx');

if mon < 10
    monc = ['0',num2str(mon)];
else
    monc = num2str(mon);
end
timec = [num2str(year),'/',monc];
cd(f,timec);

if ~exist('stat','var')
    mget(f,'*.nc');
else
    mget(f,['*',stat,'*.nc']);
end
if ~exist('ADCP','dir')
    mkdir('ADCP')
end
adcpfile = dir('*_adcp*');
if ~isempty(adcpfile)
    movefile('*_adcp*','ADCP');
end
close(f);

end