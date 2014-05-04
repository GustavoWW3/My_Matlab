function [time_mat]=alt_time_con2(year,time)

%% constant days associated with leap year
daylp = [0,31,60,91,121,152,182,213,244,274,305,335];
daynlp = [0,31,59,90,120,151,181,212,243,273,304,334];

yy = 1985:1:year-1;
ht = find(mod(yy,4) == 0);
tts = length(yy)*365*24*3600 + length(ht)*24*3600;
tty = time - repmat(tts,size(time));

%% find day number
tt1 = tty./(24*3600);
ttm = ceil(tt1);
ttsm = (ttm-1)*24*3600;

% find month including leap years
 if leapyear(year) == 1
     mon = find(daylp <= ttm(1), 1, 'last' );
     day = ttm - repmat(daylp(mon),size(ttm));
 else
     mon = find(daynlp <= ttm(1), 1, 'last' );
     day = ttm - repmat(daynlp(mon),size(ttm));
 end

%% use day month to find hr min
tt2 = tty - ttsm;
tt3 = tt2/3600;
tth = floor(tt3);
ttsh = tth*3600;

%% find minutes
tt4 = tty - ttsm - ttsh;
tt5 = tt4/60;
ttm = floor(tt5);
ttsmin = ttm*60;

%% find seconds
tts = floor(tty-ttsm-ttsh-ttsmin);

time_mat = datenum(year,mon,day,tth,ttm,tts);



 