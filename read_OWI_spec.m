function [time freq ang ef] = read_OWI_spec(fname)

%%
% read in OWI .asc spectra files
%  input name of spectra file  = fname
%  written TJ Hesser 09/12/11

%%
% import data
aa = importdata(fname);
nfa = size(aa.data,1);
% find time series
ii = find(aa.data(2:end,1) ~= aa.data(1:end-1,1))';
%preallocate
nft = length(ii)+1
time=zeros(nft,1);
ef=cell(nft,1);freq=cell(nft,1);ang=cell(nft,1);

%% Find time and energy for 1st time
ym = aa.data(1,7);
dhm = aa.data(2,7);

datec1 = num2str(ym);
datec2 = num2str(dhm);
year = str2double(datec1(1:4));
mon = str2double(datec1(5:6));
if size(datec2,2) < 6
    day = str2double(datec2(1));    
    hour = str2double(datec2(2:3));
    min = str2double(datec2(4:5));
else
    day = str2double(datec2(1:2));
    hour = str2double(datec2(3:4));
    min = str2double(datec2(5:6));
end

matdat = datenum(year,mon,day,hour,min,0);
time(1) = matdat;
freq{1} = aa.data(1:ii(1)-1,3);
ang{1} = aa.data(1:ii(1)-1,8);
ef{1} = aa.data(1:ii(1)-1,5);

%% Find time and energy for rest of times
for zz = 2:length(ii)
    ym = aa.data(ii(zz-1)+1,7);
    dhm = aa.data(ii(zz-1)+2,7);
    
    datec1 = num2str(ym);
    datec2 = num2str(dhm);
    year = str2double(datec1(1:4));
    mon = str2double(datec1(5:6));
    if size(datec2,2) < 6
        day = str2double(datec2(1));
        hour = str2double(datec2(2:3));
        min = str2double(datec2(4:5));
    else
        day = str2double(datec2(1:2));
        hour = str2double(datec2(3:4));
        min = str2double(datec2(5:6));
    end
    
    matdat = datenum(year,mon,day,hour,min,0);
    time(zz) = matdat;
    freq{zz} = aa.data(ii(zz-1)+1:ii(zz)-1,3);
    ang{zz} = aa.data(ii(zz-1)+1:ii(zz)-1,8);
    ef{zz} = aa.data(ii(zz-1)+1:ii(zz)-1,5);
end
%% Fine time and energy for final time step
ym = aa.data(ii(end)+1,7);
dhm = aa.data(ii(end)+2,7);

datec1 = num2str(ym);
datec2 = num2str(dhm);
year = str2double(datec1(1:4));
mon = str2double(datec1(5:6));
if size(datec2,2) < 6
    day = str2double(datec2(1));    
    hour = str2double(datec2(2:3));
    min = str2double(datec2(4:5));
else
    day = str2double(datec2(1:2));
    hour = str2double(datec2(3:4));
    min = str2double(datec2(5:6));
end

matdat = datenum(year,mon,day,hour,min,0);
time(zz+1) = matdat;
freq{zz+1} = aa.data(ii(end)+1:nfa-1,3);
ang{zz+1} = aa.data(ii(end)+1:nfa-1,8);
ef{zz+1} = aa.data(ii(end)+1:nfa-1,5);

end
