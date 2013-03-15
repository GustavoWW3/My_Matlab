function findstorms_bob(startdate,enddate,t,h,Tp,THM,hcrit,stnam,...
                        hmean,hvar,varargin)
%function findstorms(t,h,hcrit,target)
%FINDSTORMS is a function to delineate the beginning and ending
%           times of a storm event
%
%SYNTAX:  findstorms(t,h,hcrit,.....)
% where
%         startdate     = start date in year of file
%         enddate       = enddate in file 
%         t             = time array,
%         h             = array of wave heights or any other scalar quantity
%         Tp            = array of peak spectral periods or any other scalar quantity
%         THM           = array of mean wave directions or any other scalar quantity
%         stnam         =  station name (CHARACTER STRING FOR FILE NAMING)
%         hcrit         = critical quantity that defines storms
%         flag          = optional string argument:
%         varargin      = character, and use 'sort','peak' for input.
%                         ENTER INDIVIDIUAL flags..
%
%OPTIONAL ARGUMENTS (one of the following two options)
% 'Target',target time(s)
% 'Sort','peak' or 'energy'

%check input arguments
nvarg=max(size(varargin));
stype='none';
target=[];
if nvarg~=2 && nvarg~=0,
    disp('ERROR.  Only one option with paired argument allowed.')
    return
elseif nvarg==2,
    if strcmp(lower(varargin{1}),'target'),
        target=varargin{2};
    elseif strcmp(lower(varargin{1}),'sort'),
        if strcmp(lower(varargin{2}),'peak'),
            stype='peak';
        elseif strcmp(lower(varargin{2}),'energy'),
            stype='energy';
        end
    end
end
%
%  OUTPUT FILE NAME AND OPEN.
%
str=['EXTM_ST',stnam,'_',startdate,'_',enddate,'.dat'];
fid=fopen(str,'w');
%
%set flags for conditions exceeding hcrit
in=h>=hcrit;

if isempty(target),  %search all data if no targets specified
    din=diff(in);
    i1=find(din==1); %storm starting index
    if in(end), i1(end)=[];end
    i1=i1+1;
    tmin=t(i1);
    i2=find(din==-1); %storm ending index
    if in(1), i2(1)=[];end
 %   i2=i2-1;
    tmax=t(i2);
    nevent=max(size(i1));
    
    hpeak=zeros(size(i1));
    Tpeak=zeros(size(i1));
    THMpk=zeros(size(i1));
    estorm=hpeak;
    tpeak=hpeak;
    for i=1:nevent;
        in2=t>=tmin(i) & t<=tmax(i);
        hpeak(i)=max(h(in2));
        i3=min(find(h(in2)==hpeak(i)));
        tpeak(i)=t(i1(i)+i3-1);
        Tpeak(i)=Tp(i1(i)+i3-1);
        THMpk(i)=THM(i1(i)+i3-1);
%        estorm(i)=1.025/8*24*9.81*trapz(t(in2),h(in2).^2);  %Total Energy of storm (KJ.hr/m^2)
    end
    %output
%    disp('PROCESSING OF ALL EVENTS')
%    fprintf('EVENTS WITH H >= %5.2f\r\n',hcrit);
    fprintf(fid,'EXTREMES FOR ST = %s\r\n',stnam);
    fprintf(fid,'EVENTS WITH H >= %5.2f\r\n',hcrit);
    fprintf(fid,'MEAN and VARIANCE = %5.2f   %5.2f\r\n',hmean,hvar);
    switch(stype),
    case 'none'
        disp('NO SORTING')
        disp('Event  Start              End                Peak               PeakValue      TP    THETA')
        for i=1:nevent,
            fprintf('%5.0f %s %s   %s %s   %s %s   %9.2f     %5.2f   %5.1f\r\n',...
                i,...
                datestr(tmin(i),23),datestr(tmin(i),15),...
                datestr(tmax(i),23),datestr(tmax(i),15),...
                datestr(tpeak(i),23),datestr(tpeak(i),15),...
                hpeak(i),Tpeak(i),THMpk(i));
        end
    case 'peak'
        [dum,i1]=sort(hpeak);
        i1=flipud(i1);
%        disp('SORTING ON PEAK VALUES.')
        fprintf(fid,'SORTING ON PEAK VALUES.\r\n');
%        disp('Rank Start              End                Peak               PeakValue      TP    THETA')
        fprintf(fid,'Rank Start              End                Peak               PeakValue      TP    THETA\r\n');
        for i=1:nevent,
%           fprintf('%4.0f %s %s   %s %s   %s %s   %9.2f    %5.2f   %5.1f\r\n',...
%               i,...
%               datestr(tmin(i1(i)),23),datestr(tmin(i1(i)),15),...
%               datestr(tmax(i1(i)),23),datestr(tmax(i1(i)),15),...
%               datestr(tpeak(i1(i)),23),datestr(tpeak(i1(i)),15),...
%               hpeak(i1(i)),Tpeak(i1(i)),THMpk(i1(i)));
%  TO FILE:
             fprintf(fid,'%4.0f %s %s   %s %s   %s %s   %9.2f    %5.2f   %5.1f\r\n',...
                i,...
                datestr(tmin(i1(i)),23),datestr(tmin(i1(i)),15),...
                datestr(tmax(i1(i)),23),datestr(tmax(i1(i)),15),...
                datestr(tpeak(i1(i)),23),datestr(tpeak(i1(i)),15),...
                hpeak(i1(i)),Tpeak(i1(i)),THMpk(i1(i)));
        end
    case 'energy'
        [dum,i1]=sort(estorm);
        i1=flipud(i1);
        disp('SORTING ON INTEGRATED ENERGY OF STORM.')
        disp('Rank Start              End                Peak               PeakValue      TP    THETA');
        for i=1:nevent,
            fprintf('%4.0f %s %s   %s %s   %s %s   %9.2f    %5.2f    %5.1f\r\n',...
                i,...
                datestr(tmin(i1(i)),23),datestr(tmin(i1(i)),15),...
                datestr(tmax(i1(i)),23),datestr(tmax(i1(i)),15),...
                datestr(tpeak(i1(i)),23),datestr(tpeak(i1(i)),15),...
                hpeak(i1(i)),Tpeak(i1(i)),THMpk(i1(i)));
        end
    end        
                
            
    
else,  %search for targets if given as input
    disp('PROCESSING OF TARGETED EVENTS')
    fprintf('EVENTS WITH H >= %5.2f\r\n',hcrit);   
    for i=1:max(size(target)),
        i1=min(find(abs(t-target(i))==min(abs(t-target(i)))));
        
        if in(i1)~=1,
            fprintf('No storm at the target date: %s %s\r\n',datestr(target(i),23),datestr(target(i),15));
        else
            i2=max(find(in==0 & t<target(i)));
            tmin=t(i2);
            tmax=t(min(find(in==0 & t>target(i))));
            in2=t>=tmin & t<=tmax;
            hpeak=max(h(in2));
            Tpeak=Tp(in2);
            THMpk=THM(in2);
            i1=min(find(h(in2)==hpeak));
            tpeak=t(i2+i1-1);
            estorm=1.025/8*24*9.81*trapz(t(in2),h(in2).^2);  %Total Energy of storm (KJ.hr/m^2)
            if i==1,
                disp('Target# Start              End                Peak               PeakValue    TP    THETA');
            end
            fprintf('%8.0f %s %s   %s %s   %s %s   %5.2f  %5.2f   %5.1f\r\n',...
                i,...
                datestr(tmin,23),datestr(tmin,15),...
                datestr(tmax,23),datestr(tmax,15),...
                datestr(tpeak,23),datestr(tpeak,15),...
                hpeak,Tpeak,THMpk);
        end
    end
end
fclose(fid);
return
