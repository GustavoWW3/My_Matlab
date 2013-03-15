function sta_locs(yrinch,julinch)
%
%     INPUT:
%     -----
%       yrinch:  YEAR TO PROCESS           CHARACTER
%       julinch  STARTING JULIAN DAY       CHARACTER
%
%  Matlab routine to plot the active stations (from STNLOC file)
%   Then plot the input to metedit meteorlogical data 
%   For each of the active stations.
%
%       Wind Speed
%       Wind Direction
%       Barometric Pressure
%
%
%  Constants used for map plotting.
%
%xlonw = input('West longitude : ');
%xlone = input('East longitude : ');
%xlats = input('South latitude : ');
%xlatn = input('North latitude : ');
xlonw = -83.50;
xlone = -81.50;
xlats = 41.50;
xlatn = 43.50;
delx  = 0.01;
dely  = 0.01;
%  Set up background Green
%
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

project_in = 'mercator';
% yrinch = '1992';
% julinch= '296';
%
%  Input Station Location File FORMAT
%  (I1.1,A8,I4.4,I3.3,A20,2I4.4,I1.1,I4,I3,1X,A8)
%  COLUMN 1
%       flag (1)
%       STATION ID
%  COLUMN 2
%       YEAR (1-4)
%       JULIAN DAY (5-7)
%       STATION NAME (8-27)
%  COLUMN 3
%       LATITUDE  (1-5)
%       LONGITUDE (6-9)
%  COLUMN 4
%       STATION ELEVATION ((1-3)
%  COLUMN 5
%       ANEMOMETER ELEVATION (1-2)
ii=0;
filein=['STNLOC-',yrinch,'-',julinch,'.dat']
fid=fopen(filein);
while 1
    ii=ii+1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    stnnum(ii,:) = sscanf(tline(:,2:7),'%c');
    yrjul(ii,:) = sscanf(tline(:,10:16),'%c');
    stnid(ii,:)=  sscanf(tline(:,17:36),'%c');
    lat(ii,:) = sscanf(tline(:,37:40),'%c');
    long(ii,:) = sscanf(tline(:,41:44),'%c');
end
fclose(fid);
clear ii;
%  Covert from character to numerical values
%
xlat=str2num(lat)/100.;
xlong=-str2num(long)/100.;
yearin=str2num(yrjul(:,1:4));
juldate=str2num(yrjul(:,5:7));
usafid=stnnum(:,:);
%
%  -----------------------------------------------------------------------
%  Open the Input file containing land based met station data
%    1.  Column 1:                          (1:18)
%       a.  Date: (YYYY,JJJ,HH,MM)          (1:4, 5:7, 8:9, 10:11)
%       b.  FLAG FOR STATION (Airways == 6) (12:12)
%       c.  USAF ID NUMBER                  (13:18)
%   2-Blanks
%   2.  Column 2:
%       a.  Lake Flag  (Lake Michigan == 1) (21:21)
%       b.  Format Flag (LMD == 9)          (22:22)
%   3.  Column 3:  Air Temperature      (Deg C)
%   4.  Column 4:  Dew Point            (Deg C)
%   5.  Column 5:  Wind Direction       (Meteorlogical 0-deg from the north)
%   6.  Column 7:  Wind Speed           (m/s)
%   7.  Column 8:  Wind Gust            (m/s)
%   8.  Column 9:  Cloud Cover          (percent)
%   9.  Column 10:  Solar Radiation     (watts/m^2)
%  10.  Column 11:  Barometric Pressure (mb)
%  11.  Column 12:  Water Temp          (Deg C)
%  12.  Column 13:  Significant Height  (m)
%  13.  Column 14:  Wave Period         (s)
%  -----------------------------------------------------------------------
%
filein1=['METOBS-',yrinch,'-',julinch,'-TSMTH.dat'];
fid=fopen(filein1,'rt');
fmt0='%11c%*c%7c %f %f %f %f %f %f %f %f %f %f %f %f';
dat0=textscan(fid,fmt0);
fclose(fid);
%Parse data
dum=dat0{1};
yr2prc=str2num(dum(:,1:4));
jul2prc=str2num(dum(:,5:7));
hr2prc =str2num(dum(:,8:9));
mn2prc =str2num(dum(:,10:11));
usaf2prcC=dat0{2};
%usaf2prc=cell2mat(usaf2prcC);
%  Fill flagged (missing data with NaN's)
wnddprc = dat0{6};
ifx=find(wnddprc == 999);
wnddprc(ifx) = NaN;
clear ifx;
spdprc  = dat0{7};
ifx = find(spdprc == 99.9);
spdprc(ifx) = NaN;
clear ifx;
barpprc = dat0{11};
ifx=find(barpprc == 9999.9);
barpprc(ifx) = NaN;
clear dum dat0;
%
%  Determine which stations in Location file are used
%  Look at only the first set of information
%       the First JULIAN DAY / HR=0 / MIN=0
%
julstrt = str2num(julinch);
active  = find(jul2prc == julstrt & hr2prc == 0 & mn2prc == 0);
%
%  Ready to plot the map with the Met Stations used
%
m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
m_patch(shr_x,shr_y,[.0 .5 .0]);
m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
hcst=findobj(gca,'Tag','m_gshhs_f');
set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in','fontweight','bold');
hold on
%
m_grid('box','fancy','tickdir','in','fontweight','bold');
xlabel('Longitude','fontweight','bold')
ylabel('Latitude','fontweight','bold')

for jj=1:length(active)
    m_plot(xlong(jj), xlat(jj),'r.','Markersize',15)
    m_text(xlong(jj)+0.05, xlat(jj),stnnum(jj,:),'Fontsize',8,...
        'FontWeight','Bold')
end

titlchr1=['Active Station Locations for STORM: ',yrinch,'-',julinch];
titlchr2=['Number of Stations:  ',int2str(length(active))];
titlchT=[{titlchr1};{titlchr2}];
title(titlchT,'Fontweight','Bold');

pos=get(gcf,'Position');
pos(3:4)=[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
print(gcf,'-dpng','-r600',['STLOCS_',yrinch,'_',julinch,'.png']);
clf
%
%  Now to plot the individual station met data.
%     What came into METEDIT.f and what came out.
%     The input file is already loaded.
%  Need to load in the output file ===== metobs.dat
%   FORMAT:
%       Column 1: (YYY,JJJ,HR,MN,F,USAFID)
%               o  Again num2str decompose the values
%               o  Generate appropriate numerical values.
%       Column 2:  Observation Value (in hours)
%       Column 3:  Longitude (ignore this)
%       Column 4:  Latitude  (ignore this)
%       Column 5:  U component of wind speed (m/s)
%       Column 6:  V component of wind speed (m/s)
%       Column 7:  W sqrt(U*U + V*V) (magnitude m/s)
%       Column 8:  Air Temperature (Deg C)
%       Column 9:  Dew Point (Deg C)
%       Column 10:  Cloud Cover (percent)
%       Column 11:  Barometric Pressure (mb) <<<< to be added..
% NOTE:  MISSING DATA == 999.9
%
%   Multiple panels
%       Wind Speed
%       Wind Direction
%       Barometric Pressure
%       (need to add barometric pressure to output file)
%

%Load Data
filein2=['metobs-',yrinch,'-',julinch,'-TSMTH2NN.dat'];
fid=fopen(filein2,'rt');
fmt='%11c%*c%6c %f %f %f %f %f %f %f %f %f %f';
dat=textscan(fid,fmt);
fclose(fid);
%Parse data
date=dat{1};
yr_met=str2num(date(:,1:4));
jul_met=str2num(date(:,5:7));
hr_met = str2num(date(:,8:9));
mn_met = str2num(date(:,10:11));
usaf_met= dat{2};
lon_met=dat{4};
lat_met=dat{5};
u_met = dat{6};
v_met = dat{7};
dir_met = 180*atan2(v_met,u_met) / pi;
dir_met = 270 - dir_met;
ifx=find(dir_met < 0);
dir_met(ifx)=dir_met(ifx) + 360;
clear ifx;
ifx2=find(dir_met >= 360);
dir_met(ifx2) = dir_met(ifx2) - 360;
clear ifx2;
spd_met = dat{8};
ifx=find(spd_met == 999.9);
spd_met(ifx)= NaN;
dir_met(ifx) = NaN;

%slp_met = date{9};
clear date dat
%
%  Now pull appropriate station and then plot up the wind speed, direction
%      times are equilivant for both sets.
%      Have place holder for the barometric pressure
%
for k1=1:length(active)
    pltfile=[yrinch,'_',julinch,'_',stnnum(k1,:)];
    titch1=['Comparison Met Station Input and MetEdit Modifications'];
    titch2=['Station Number:  ',stnnum(k1,:)];
    titch3=['Station:  ',stnid(k1,:)];
    titch4=['Location:  Long / Lat :  ',num2str(xlong(k1)),'\circ  /  ',...
        num2str(xlat(k1)),'\circ'];
    titlT = [{titch1};{titch2};{titch3};{titch4}];
    xlabT = ['Month/Day in  ',yrinch];
    k21=strmatch(usafid(k1,:),usaf2prcC(:,1:6),'exact');
%     k21=find(usaf2prc == usafid(k1));
    k22=strmatch(usafid(k1,:),usaf_met(:,1:6),'exact');
%    k22=find(usaf_met == usafid(k1));
    mtime=datenum(yr_met(k22),1,0) + jul_met(k22) + hr_met(k22)/24;
    minxx=floor(min(mtime));
    maxxx=ceil(max(mtime));
    xlimxx=[minxx, maxxx];
    subplot(3,1,1)
    H=plot(mtime,spdprc(k21),'.b-',mtime,spd_met(k22),'.r-');
    ymax=ceil(max(max(spdprc(k21)),max(spd_met(k22))));
    mm=find(isnan(spdprc(k21)));
    datchk=length(mm)-length(spdprc(k21));
    if datchk == 0;
        xticks=get(gca,'XTick');
        xx=datestr(xticks,6);
        set(gca,'XTick',xticks,'XTicklabel',xx);
        ylimyy=[0,10];
        set(gca,'Ylim',ylimyy);
        set(gca,'Xlim',xlimxx);
        text(xticks(2),5,'NO WIND SPEED DATA','Color',[1,0,0]);
    else
        xticks=get(gca,'XTick');
        xx=datestr(xticks,6);
        set(gca,'XTick',xticks,'XTicklabel',xx);
        ylimyy=get(gca,'Ylim');
        ylimmy=[0,ymax];
        set(gca,'Ylim',ylimyy);
        set(gca,'Xlim',xlimxx);
    end
    grid
    ylabel('Wind Spd [m/s]');
    title(titlT)
    hleg=legend(H,'Raw Met Data','Output Metedit');
    po=get(hleg,'position');
    po=[0.825 0.925 0.08 0.03];
    set(hleg,'position',po);
    clear H; clear mm; clear datchk;
    
    %  Wind Direction (Meteorological)
    subplot(3,1,2)
    H=plot(mtime,wnddprc(k21),'.b-',mtime,dir_met(k22),'.r-');
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    ylimy=get(gca,'Ylim');
    ylimmx=[0,360];
    mm=find(isnan(wnddprc(k21)));
    datchk=length(mm)-length(wnddprc(k21));
    if datchk == 0;
        text(xticks(2),180,'NO WIND DIRECTION DATA','Color',[1,0,0]);
    end
    set(gca,'Ylim',ylimmx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('Wind Dir [\circ-MET]');
    %  Barometric Pressure (add in the Metedit results when ready)
    subplot(3,1,3)
    plot(mtime,barpprc(k21),'.b-')
    xticks=get(gca,'XTick');
    xx=datestr(xticks,6);
    mm=find(isnan(barpprc(k21)));
    datchk=length(mm)-length(barpprc(k21));
    if datchk == 0;
        ylimm=[900,1060];
        set(gca,'Ylim',ylimm)
        text(xticks(2),980,'NO SEA LEVEL PRESSURE DATA','Color',[1,0,0]);
    end
    set(gca,'XTick',xticks,'XTicklabel',xx);
    set(gca,'Xlim',xlimxx);
    grid
    ylabel('Sea Level Press [mb]');
    xlabel(xlabT);
    eval(['print -dpng -r600 timplt_',pltfile]);
    clf
end