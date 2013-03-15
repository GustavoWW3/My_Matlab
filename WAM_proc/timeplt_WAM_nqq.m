function timeplt_WAM_nqq(yrin, mntin, domain)
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
%		domain:		NUMERIC  :  basin (1)  region (2)  subreg (3)
%       pathNDBC;   CHARACTER:  FULL PATH NAME 
%                               (e.g. D:\WIS\PACIFIC_FORENSICS\WAM_1DEG\OUTPUT\NDBC\2000_01)
%-----------------------------------------------------------------------------------------
%
recno1=1;
recno2=2;
recno3=3;
recno4=4;
recno5=5;
recno6=6;
dmyvar1=zeros(1:5);
dmyvar2=zeros(1:5);

xlonw = -205.00;
xlone = -155.00;
xlats = 50.00;
xlatn = 74.00;
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
xtitl=['Days in ',montit,'  ',int2str(yr)];
    if mtt < 10
        MTT=['0',int2str(mtt)];
        YRMT=[YR1,MTT];
    end 
    %
    %  Start Looking for the WAM Results
    %
    if domain == 1;
        titdom=['BASIN'];
        titdom2=titdom;
        filedom=['BAS'];
    end
    if domain == 2;
        titdom=['REGION'];
        titdom2=titdom;
        filedom=['REG'];
    end
    
    if domain == 2.5;
        titdom=['REGION'];
        titdom2=['REGION (70% Ice)'];
        filedom=['REG_70ICE'];
    end
    
    if domain == 3;
        titdom=['SUBREGION'];
        titdom2=titdom;
        filedom=['SUBREG'];
    end
%
%  Load in the buoy location data to be processed.
%  And Read in the list of buoy locations
%
% ii=0;
% fid=fopen('buoylocsin.dat');
% while 1
%     ii=ii+1;
%     tline = fgetl(fid);
%     if ~ischar(tline), break, end
%     buoylcn(ii,1:20)=sscanf(tline,'%c');
% end
% fclose(fid);
filesb = dir('n*.onlns');
filesw = dir('w*.onlns');
totlocs=size(filesb,1);
for kkk=1:totlocs
    filename = getfield(filesb(kkk,1),'name');
    buoylocs(kkk,:)= filename(2:6);
%end
%
%  Process all BUOY LOCATIONS 
%       BIG LOOP OVER ENTIRE MATLAB ROUTINE
%
%for kkk=1:totlocs
    buoy=str2num(buoylocs(kkk,:));
    %
    %  Load in the NDBC BUOY DATA
    %
    a = load(filename);
    totobsB=size(a,1);
    %
    %  Now Load in the ENTIRE WAM oneline file
    %
    filename2 = getfield(filesw(1,1),'name');
    Btot = load(filename2);
       %
    %  Split out the proper WAM Save pt for the buoy comparison
    %
    %       NOW BASED ALL ON THE BUOY NUMBER LOCATED IN THE ONELINE FILE 
    %                ***** (RECORD 4)  *****
    %
    istn=find(Btot(:,4) == buoy) ; 
    if ~isempty(istn);
        %
        %  Open up the ascii file containing various stat data and QQ results
        %
        filestats = ['stats',filedom,int2str(buoy),'_',YRMT,'.asc'];
        fidstats = fopen(filestats,'w');
        %
        %  Now get the appropriate station information out of the SUM file
        %       Key off of the element number (Column 3)
        %
        B1=Btot(istn,:) ;
        
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
        %  Split Dates out of WAM
        %           NOTE:   DATE IS Y2K (year = 4 digits)
        %                   DATE is in column 3
        %
        TM1=datenum(B1(:,3));
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
        totobsM=length(timwam);
        %
        %  Grab the Long and Lat from Buoy/WAM
        %
        latb=num2str(a(1,7) + (a(1,8)/60 + a(1,9)/3600));
        lonb=num2str(-(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
        latM=num2str(B1(1,5));
        lonM=num2str(B1(1,6)-360);
        LONout=B1(1,6)-360;
        LATout=B1(1,5);
        DEPout=a(1,13);
        depb=num2str(a(1,13));
        %
        %  Set the Title of plot
        %
        titcharpt1=['Alaska 25-yr Hindcast Study [OWI Winds]   '];
        titcharpt15=[titdom2,'   WAM4.5.1C [ ',lonM,' \circ / ',latM,'\circ ] '];
        titcharpt2=['NDBC = ',int2str(buoy),' [ ',lonb,...
                '\circ / ',latb,' \circ ]'];
        titcharpt25=['at h= ',depb,'m'];
        titchar=[{titcharpt1;titcharpt15;titcharpt2;titcharpt25}];
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
        clear u10buoy; clear air_sea;
        u10buoy=zeros(size(a(:,1)));
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
        thresh=floor(0.05*length(u10buoy));
        if length(iwnd) < thresh
            u10buoy(1:length(u10buoy)) = NaN;
            windB(1:length(u10buoy)) = NaN;
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
        hgtM=B1(:,12);
        hmax=ceil(max(max(hgtM),max(hgtB)));
        comp(1) =struct('name','H_{mo}','y1',hgtM,'y2',hgtB,'max',hmax);
        
        %
        %   2.  Peak Period  (Parabolic Fit)
        %           Buoy Col    23
        %           WAM  Col    13
        %
        tppfB=a(:,23);
        itpB=find(a(:,23) > 0);
        tppfM=B1(:,13);
        itpM=find(B1(:,8) > 0);
        tppmax=ceil(max(max(tppfM(itpM)),max(tppfB(itpB))));
        comp(2) = struct('name','T_{p}','y1',tppfM,'y2',tppfB,'max',tppmax);
        %
        %  3.  Mean Wave Period  (inverse 1st moment)
        %           Buoy Col    24
        %           WAM  Col    14
        %
        tmnB=a(:,24);
        tmnM=B1(:,14);
        tmnmax=ceil(max(max(tmnM),max(tmnB)));
        comp(3) = struct('name','T_{m}','y1',tmnM,'y2',tmnB,'max',tmnmax);
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
        wavdM=180+B1(:,17);
        i1=find(wavdM >= 360);
        wavdM(i1)=wavdM(i1)-360;
        clear i1;
        comp(4) = struct('name','Wave Dir.','y1',wavdM,'y2',wavdB,'max',360);
        %
        %  5.  Wind Speed   U10
        %       Buoy        From Above (tranform to 10 m)
        %       WAM         Column 7 
        %
        wsM=B1(:,7);
        wsmax=ceil(max(max(wsM),max(u10buoy)));
        comp(5) = struct('name','Wind Spd.','y1',wsM,'y2',u10buoy,'max',wsmax);
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
        windM=180+B1(:,8);
        i1=find(windM >=360);
        windM(i1) = windM(i1)-360.;
        comp(6) = struct('name','Wind Dir.','y1',windM,'y2',windB,'max',360);
        %
        %  Time Plots
        %       6 panels        Height,        Peak Period, Mean Period, 
        %                       Mean Wave Dir, Wind Speed,  Wind Direction
        %       WAM Results     BLUE LINE
        %       Buoy Dara       RED +'s
        %       For the X axis use the Model time to set the ticks and labels (always constant)
        %       For the Y axis use the max determined from above (5 ticks).
        %
        figure(1)
        subplot(8,3,[2 6])
        m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
        %m_patch(shr_x,shr_y,[.0 .5 .0]);
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
        m_plot(lonmp,latmp,'r.','MarkerSize',12)
        set(gca,'Position',[0.4 0.74 0.7 0.25]);
        hold off
        for ii = 1:6
            orient('Tall')
            subplot(8,3,3*ii+4:3*ii+6)
            if ii == 5
                qq = find(comp(ii).y2 == 0);
                comp(ii).y2(qq) = -1.0;
            end
            H=plot(timwam,comp(ii).y1,'b',timbuoy,comp(ii).y2,'r+','markersize',4); 
            xticks=get(gca,'XTick');
            xx=datestr(xticks,6);
            set(gca,'XTick',xticks,'XTicklabel',xx);
            ylimmx=[0,comp(ii).max];
            set(gca,'Ylim',ylimmx);
            set(gca,'Xlim',xlimxx);
            grid
            ylabel(comp(ii).name);
           
            if ii == 1
                text(timwam(1),comp(ii).max*3.0,titchar,'FontWeight','bold','EdgeColor','black','LineWidth',2);
                hleg=legend(H,'WAM','BUOY');
                po=get(hleg,'position');
                po=[0.3 0.74 0.08 0.03];
                set(hleg,'position',po);
            end
            if ii == 6
                xlabel(xtitl)
            end
            clear H;
        end
        %
        %  Print out the file 
        %
        ffout = [filedom,int2str(buoy),'_',YRMT];
        print(gcf,'-dpng','-r400',ffout)
        clf
    end