function timeplt_WAM_LKMICH(yrin, mntin, runid, hurname, unitflg, timeflg, inputflg)
%
%  Matlab routine to plot (time plot) model and measurement data
%
%-----------------------------------------------------------------------------------------
%
%  REQUIRES:  (GENERIC FILE NAME)
%
%           MUST BE LOCAL TO THE WORKING AREA.
%           ONE FILE (buoylocs.dat) containing the buoy number
%           (dir n*.onlns /B > buoylocs.dat)
%           REMOVE THE LEADING:     "n"
%           REMOVE THE TRAILING _YEAR_MONTH.onlns
%
%  DEFINITIONS:
%
%       yrin;       NUMERIC:    2003 OR 99
%		mntin:		NUMERIC:    01,02,03...
%       runid:    CHARACTER:    name for the run (inputfile/outputfile
%                               naming convention
%       hurname;    CHARACTER:  Hurricane Name for Title. 
%       unitflg:    NUMERIC:    flag for units  ONLY FOR PLOTTING
%                               0 = metric
%                               1 = english (feet, knots on wind speed)
%       timeflg:    NUMERIC:    flag to limit the time plots
%                               0  =    no limit (sets automatically based on
%                                       model and buoy data)
%                               1  =    limit to WAM OUTOUT
%                               2  =    limit to buoy OUTPUT
%       inputflg:   NUMERIC:    flag to indicate one file contains more 
%                               output locations.
%                               This will also require one more input file
%                               to load stalocs.dat
%                               0 = the number of stations are the same.
%                               1 = the number of stations differ.
%
%-----------------------------------------------------------------------------------------
%
dmyvar1=zeros(1:5);
dmyvar2=zeros(1:5);

hgtscal = 1.0;
wsscal = 1.0;
HGTUNT = 'm';
WSSUNT = 'm/s';
if unitflg == 1
    hgtscal = 3.28;
    wsscal = 1.944;
    HGTUNT = 'ft';
    WSSUNT = 'kt';
end

xlonw = -83.00;
xlone = -82.35;
xlats = 42.25;
xlatn = 42.75;
shr_x(1,1) = xlonw;
shr_x(2,1) = xlone;
shr_x(3,1) = xlone;
shr_x(4,1) = xlonw;
shr_x(5,1) = xlonw;

shr_y(1,1) = xlats;
shr_y(2,1) = xlats;
shr_y(3,1) = xlatn;
shr_y(4,1) = xlatn;
shr_y(5,1) = xlatn;
ylimmax = 0;

project_in = 'mercator';
%
%  Load the Buoy Data and Model Data
%
YRMT=[int2str(yrin),'_',int2str(mntin)];
mtt=mntin;
yr=yrin;
mstr='JanFebMarAprMayJunJulAugSepOctNovDec';
mtst=3*(mtt-1) +1;
montit=mstr(mtst:mtst+2);
YR1=int2str(yr);
MTT=int2str(mtt);
xtitl=['Days in ',int2str(yr)];
if yr < 2000
    xtitl=['Days in ',montit,'  ',int2str(yr)];
    MTT=int2str(mtt);
    if mtt < 10
        MTT=['0',int2str(mtt)];
    end
    yrmt=[int2str(yrin),MTT];
else
    YRMT=[YR1,int2str(mtt)];
    if mtt < 10
        MTT=['0',int2str(mtt)];
        YRMT=[YR1,MTT];
    end 
end
%
%  Start Looking for the WAM Result
%
titdom=['BASIN'];
titdom2=titdom;
filedom=['BAS'];
%
%  Load in the buoy location data to be processed.
%  And Read in the list of buoy locations
%
ii=0;
fid=fopen('buoylocsin.dat');
while 1
    ii=ii+1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    buoylcn(ii,1:17)=sscanf(tline,'%c')
end
fclose(fid);
[totlocs,linn]=size(buoylcn);
for kbuoy=1:totlocs
    buoylocs(kbuoy,:)=buoylcn(kbuoy,2:6);
end
clear buoylcn;
clear tline;
clear linn;
[NUMBUOYS,linn]=size(buoylocs);
%
%  Load in the WAM RESIDENT FILES THAT NEED TO BE PROCESSED
%   THE ORDER OF THE FILES IS EXTREMELY IMPORTANT:
%       FILE 1: NO CAP
%       FILE 2-N:  TEST CASES
%
%   See below for legend information USED IN THE TIME PLOTS.
%   AA:     Line Specification
%   legtxt: Specification of the line in the legend.
%
AA={'b-';'k-';'.c-';'.k-.';'.b-.';'y'};
legtxt={' BUOY ';'CFSR';'SMTH'};
%
fid=fopen('wamtest.dat','r');
ii=0;
while 1
    ii=ii+1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    wamfilenam(ii,:)=sscanf(tline,'%c');   
    ss=regexp(tline(1:end-6),'[\_\-]','split');  
    ss3=[ss{5},'-',ss{2},'-',ss{3}];
    I=strmatch(ss{5},legtxt,'exact');
    if isempty(I)
        error('No matching case in legtxt_OLD.')
    end
    legtxt(ii+1)=legtxt(I);
    AA(ii)=AA(I-1);
end
fclose(fid);
%
%  Process all BUOY LOCATIONS 
%       BIG LOOP OVER ENTIRE MATLAB ROUTINE
%
for kkk=1:NUMBUOYS
    buoy=str2num(buoylocs(kkk,:));
    %
    %  Load in the NDBC BUOY DATA
    %      FIXED FOR 00001 Stations
    %
   % eval(['load n',buoylocs(kkk,:),'-',YR1,'.onlns']);
   % eval(['a=n',buoylocs(kkk,:),'-',YR1,';']);
   % eval(['clear n',buoylocs(kkk,:),'-',YR1,';'])
    fname = ['n',buoylocs(kkk,:),'-',YR1,'.onlns'];
    a = load(fname);
    [totobsB,bouym]=size(a);
%
%  Now Load in the ENTIRE WAM oneline files depending on the number 
%   of files loaded to compare.  
% Test the length of Bin to determine if the number of stations output 
%      varies from one test to the next. 
% If it does read in a "stalocs.dat" file containing the reduced list.
%
% NOTE that the first named file is the shortest of all inputs.
%
%
tosuffx=length(wamfilenam)-6;
[wwam1,wwam2]=size(wamfilenam);   
for jjj=1:wwam1
    Bin = load(wamfilenam(jjj,:));
    if jjj >= 2
        wamtst=length((Bin));
        if wamtst > wamTOLD
            load stalocs.dat
            NSTA = length(stalocs);
            in = false(size(Bin,1),1);
            for k3=1:NSTA
                in = in | Bin(:,4) == stalocs(k3);
            end
            B=Bin(in,:);
        else
           B=Bin; 
        end
    else
        B=Bin;
        wamTOLD=length((Bin));    end
    Btot(:,:,jjj) = B;
    clear Bin;
end
clear B;
%
%
%  Split out the proper WAM Save pt for the buoy comparison
%
%       NOW BASED ALL ON THE BUOY NUMBER LOCATED IN THE ONELINE FILE 
%                ***** (RECORD 4)  *****
%
istn=find(Btot(:,4,1) == buoy) ; 
if ~isempty(istn);
    %
    %
    %  Now get the appropriate station information out of the SUM file
    %       Key off of the element number (Column 3)
    %
    for jjj=1:wwam1
        B1(:,:,jjj)=Btot(istn,:,jjj) ;
    end
    %  Set the time
    %   1.  Buoy and then WAM
    %       For WAM need to split out the date into Year,Month,Day,Hour
    %       NOTE  Need to add 2000 to YEAR 
    %
    yrnd=a(:,2);
    mtnd=a(:,3);
    dynd=a(:,4);
    hrnd=a(:,5);
    mnnd=60*round(a(:,6)/60);
    %
    %  Needed to generate the time then transform back because
    %   of the adjustment in the minutes.
    %
    timndb_D=datenum(yrnd,mtnd,dynd,hrnd,mnnd,0);
    TMNDB_D=datevec(timndb_D);
    timbuoy=datenum(TMNDB_D);
    %
    %  Split Dates out of WAM  USE THE FIRST FILE:  
    %           DATES BETWEEN FILES ARE ALL IDENTICAL
    % 
    %           NOTE:   DATE IS Y2K (year = 4 digits)
    %                   DATE is in column 3
    %
    TM1=datenum(B1(:,3,1));
    TM1S=int2str(TM1);
    %
    tm1yr=str2num(TM1S(:,1:4));
    tm1mt=str2num(TM1S(:,5:6));
    tm1dy=str2num(TM1S(:,7:8));
    tm1hr=str2num(TM1S(:,9:10));
    timwam=datenum(tm1yr,tm1mt,tm1dy,tm1hr,0,0);
    clear TM1; clear TM1S; clear tm1yr; clear tm1mt; clear tm1dy;
    clear tm1hr;
    
    minxx=floor(min(min(timwam),min(timbuoy)));
    maxxx=ceil(max(max(timwam),max(timbuoy)));
    xlimxx=[minxx, maxxx];
    if timeflg == 1
        xlimxx = [floor(min(timwam)), ceil(max(timwam))];
    end
    if timeflg == 2
        xlimxx = [floor(min(timbuoy)), ceil(max(timbuoy))];
    end
    totobsM=length(timwam);
    %
    %  Grab the Long and Lat from Buoy/WAM
    %
    latb=num2str(a(1,7) + (a(1,8)/60 + a(1,9)/3600));
    lonb=num2str(-(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
    latM=num2str(B1(1,5,1));
    lonM=num2str(B1(1,6,1)-360);
    LONout=B1(1,6,1)-360;
    LATout=B1(1,5,1);
    DEPout=a(1,13);
    depb=num2str(hgtscal*a(1,13));
    %
    %  Set the Title of plot
    %
 
    titcharpt1=[runid,'  [',hurname,' ',ss{2},'-',ss{3},']'];
    titcharpt1_5=['WAM4.51C [ ',lonM,' \circ / ',latM,'\circ ] '];
    titcharpt2=['NDBC = ',int2str(buoy),' [ ',lonb,...
            '\circ / ',latb,' \circ ]'];
    titcharpt2_5=['at h= ',depb,' ',HGTUNT];
    titchar=[{titcharpt1;titcharpt1_5;titcharpt2;titcharpt2_5}];
    %
    %  ------------------------------------------------------------
    %  Adjust the Buoy Wind Using PBL, (elevation and AIR/SEA Temp)
    %
    %   NOTE:   Works in CGS (must multiply elevation and WS by 100).
    %           Analyze only finite conditions
    %
    %   INPUT TO FUNCTION:
    %   Elevation   Col 14
    %   Wind Speed  Col 15 
    %   Air Temp    Col 18
    %   Sea Temp    Col 19
    %
    %   NOTE:       iwnd    PBL
    %               jwnd    1/7 power law
    %               kwnd    set to -999
    %               Missing either air or sea temp set air_sea=0.
    %  ------------------------------------------------------------
    %
    
    iwnd=find(a(:,15) > 0 & a(:,18) > -100 & a(:,19) > -100);
    jwnd=find(a(:,18) <= -999 & a(:,19) <= -999);
    kwnd=find(a(:,15) <= -999);
    lwnd=find(a(:,15) > 0);
    clear u10buoy; clear air_sea;
    u10buoy=zeros(size(a(:,1)));
    if ~isempty(lwnd)
    ele=zeros(size(a(:,1)));
    ielez=find(a(:,14) == 0.0);
    if isempty(ielez)
        ele=a(:,14);
    else
        ele(1:length(a(:,1)),1)=5.0;
    end
    air_sea(iwnd,1)=a(iwnd,18)-a(iwnd,19);
    temdifa=length(find(a(:,18) == 0));
    temdifs=length(find(a(:,19) == 0));
    if temdifa > 0.5*totobsB | temdifs > 0.5*totobsB
        air_sea(1:totobsB,1)=0.;
    end
    
    [u10buoy(iwnd)]=windp(100*a(iwnd,15),100*ele(iwnd,1),air_sea(iwnd,1),100*ele(iwnd,1));
    u10buoy(jwnd)= a(jwnd,15).*(ele(jwnd,1) / 10.).^(-1/7);
    u10buoy(kwnd) = a(kwnd,15);
    kbadu10=find(imag(u10buoy));
    u10buoy(kbadu10)=a(kbadu10,15);
end
    %
    %   Pull out the Wave Parameters for Time Plots  
    %       Control Missing Buoy Data using axis in plotting.
    %       Remove when time paired obs.
    %
    %   1.  Wave Height:    
    %           Buoy Col    21
    %           WAM  Col    12
    %  
    hgtB=a(:,21);
    for jjj=1:wwam1
        hgtM(:,jjj)=B1(:,12,jjj);
    end
    hmax=ceil(max(max(hgtM(:)),max(hgtB)));
    %
    %   2.  Peak Period  (Parabolic Fit)
    %           Buoy Col    23
    %           WAM  Col    13
    %
    tppfB=a(:,22);
    itpB=find(a(:,22) > 0);
    for jjj=1:wwam1
        tppfM(:,jjj)=B1(:,13,jjj);
    end
    tppmax2=ceil(max(max(tppfM(:)),max(tppfB(itpB))));
    tppmax=ceil(5*tppmax2/5);
    %
    %  3.  Mean Wave Period  (inverse 1st moment)
    %           Buoy Col    24
    %           WAM  Col    15  called TM1 in documentation
    %
    tmnB=a(:,24);
    ltmnB=find(a(:,24) > 0);
    for jjj=1:wwam1
        tmnM(:,jjj)=B1(:,15,jjj);
    end
    if ~isempty(ltmnB)
    tmnmax2=ceil(max(max(tmnM(:)),max(tmnB)));
    tmnmax = tmnmax2;
else
    tmnmax2=ceil(max(tmnM(:)));
    tmnmax=5*ceil(tmnmax2/5);
end
    %
    %           
    %  4.  Mean Wave Direction  Overall Vector Mean  Transform to Geophys Met.
    %                           ADJUST THE WAM RESULTS
    %
    %           Buoy Col    25  (Meteorological 0 from   North / 90 from   East)
    %           WAM  Col    17  (Oceanographic  0 toward North / 90 toward East)
    %
    %   NOTE:  Determine if Buoy has Directional Information (look for finite directions)
    %                       If have flag to produce "No Directional Buoy Data")
    %                       called "nodir"
    %
    iwavB=find(a(:,25) >= 0);
    wavdB=a(:,25);
    nodir=isempty(iwavB);
    for jjj=1:wwam1
        wavdM(:,jjj)=180+B1(:,17,jjj);
        i1=find(wavdM(:,jjj) >= 360);
        wavdM(i1,jjj)=wavdM(i1,jjj)-360;
    end
    clear i1;
    %
    %  5.  Wind Speed   U10
    %       Buoy        From Above (tranform to 10 m)
    %       WAM         Column 7 
    %
    for jjj=1:wwam1
        wsM(:,jjj)=B1(:,7,jjj);
    end
    wsmax2=ceil(max(max(wsM(:)),max(u10buoy)));
    wsmax=ceil(10*ceil(wsmax2/10));
    %
    %  6.  Wind Direction  (Use Meteorlogical coordinate)
    %
    %       Buoy  Col       17  (Meteorological 0 from   North / 90 from   East)
    %       WAM   Col        8  (Oceanographic  0 toward North / 90 toward East)
    %
    windB=a(:,17);
    nowndB=find(windB == 0);
    iwdB=length(nowndB);
    if iwdB > 0.5*totobsB
        windB(nowndB)=-999.;
    end
    for jjj=1:wwam1
        windM(:,jjj)=180+B1(:,8,jjj);
        i1=find(windM(:,jjj) >=360);
        windM(i1,jjj) = windM(i1,jjj)-360.;
    end
    %
    %  Time Plots
    %       6 panels        Height,        Peak Period, Mean Period, 
    %                       Mean Wave Dir, Wind Speed,  Wind Direction
    %       WAM Results     BLUE LINE
    %       Buoy Dara       RED +'s
    %       For the X axis use the Model time to set the ticks and labels (always constant)
    %       For the Y axis use the max determined from above (5 ticks).
    %
    subplot(8,3,[2 6])
        m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
        m_patch(shr_x,shr_y,[.0 .5 .0]);
        m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
        hcst=findobj(gca,'Tag','m_gshhs_f');
        set(hcst,'HandleVisibility','off');
        m_grid('box','fancy','tickdir','in','fontweight','bold','fontsize',8);
        hold on
        lonmp = str2double(lonb(1,:));
        latmp = str2double(latb(1,:));
        if lonmp > 0
            lonmp = lonmp - 360;
        end
        m_text(lonmp,latmp,buoylocs(1,:),'fontsize',8,'HorizontalAlignment','right', ...
                'VerticalAlignment','Bottom','backgroundcolor',[1 1 1]);
        m_plot(lonmp,latmp,'r.','MarkerSize',12)
        set(gca,'Position',[0.4 0.74 0.7 0.25]);
    orient('Tall')
    subplot(8,3,7:9)
    H(1)=plot(timbuoy,hgtscal*hgtB,'r.','markersize',10);
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,hgtscal*hgtM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    %ylimmx=[0,hgtscal*hmax];
    ylimmx = [0,2.0];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabch=['H_{mo} [',HGTUNT,']'];
    ylabel(ylabch);
    %title(titchar);
     text(timwam(1),ylimmx(2)*3.0,titchar,'FontWeight','bold','EdgeColor','black','LineWidth',2);
    hleg=legend(H(1:wwam1+1),legtxt(1:wwam1+1));
    po=get(hleg,'position');
    %po=[0.852 0.928 0.08 0.03];
    po=[0.3 0.74 0.08 0.03];
    set(hleg,'position',po);
    clear H;
    %
    subplot(8,3,10:12)
    H(1)=plot(timbuoy,tppfB,'r.','markersize',10);   
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,tppfM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,tppmax];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('T_{p}');
    clear H;
    
    %
    subplot(8,3,13:15)
     if ~isempty(ltmnB)
    H(1)=plot(timbuoy,tmnB,'r.','markersize',10);
end
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,tmnM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,tmnmax];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('T_{m} ');
    if isempty(ltmnB)
        text(timwam(1),tppmax/10,'No Mean Wave Period Data Collected','Color','r');
    end
    clear H;
    %  
    subplot(8,3,16:18)
    H(1)=plot(timbuoy,wavdB,'r.','markersize',10);
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,wavdM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,360];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('Wave Dir.');
    if nodir == 1
        text(timwam(1),45,'No Directional Data','Color','r');
    end
    clear H;
    %
    subplot(8,3,19:21)
    if ~isempty(lwnd)
    H(1)=plot(timbuoy,wsscal*u10buoy,'r.','markersize',10);
end
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,wsscal*wsM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,wsscal*wsmax];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabch=['Wind Spd. [',WSSUNT,']'];
    ylabel(ylabch);
    if isempty(lwnd)
        text(timwam(1),wsscal*wsmax/10,'No Wind Data Collected','Color','r');
    end
    clear H;
    %
    subplot(8,3,22:24)
    H(1)=plot(timbuoy,windB,'r.','markersize',10);
    hold on
    for jjj=1:wwam1
        AAA=char(AA(jjj));
        H(jjj+1)=plot(timwam,windM(:,jjj),AAA,'LineWidth',1);
    end
    hold off
    set(gca,'Xlim',xlimxx);
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,360];
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('Wind Dir.');
    xlabel(xtitl);
    %
    %  Print out the file 
    %
    eval(['print -dpng timept',filedom,int2str(buoy),'_',YRMT])
    clf
end
end