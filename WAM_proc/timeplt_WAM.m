function timeplt_WAM(yrin, mntin, domain)
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
        titcharpt1=['Alaska 25-yr Hindcast Study [OWI Winds]   ',titdom2,...
                '   WAM4.5.1C [ ',lonM,' \circ / ',latM,'\circ ] '];
        titcharpt2=['NDBC = ',int2str(buoy),' [ ',lonb,...
                '\circ / ',latb,' \circ ] at h= ',depb,'m'];
        titchar=[{titcharpt1;titcharpt2}];
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
        comp(3) = struct('name','T_{m}','y1',tmnM,'y2',tmnB','max',tmnmax);
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
        for ii = 1:6
            orient('Tall')
            subplot(6,1,ii)
            H=plot(timwam,comp(ii).y1,'b',timbuoy,comp(ii).y2,'r+','markersize',4); 
            xticks=get(gca,'XTick');
            xx=datestr(xticks,6);
            set(gca,'XTick',xticks,'XTicklabel',xx);
            ylimmx=[0,comp(ii).max];
            set(gca,'Ylim',ylimmx);
            set(gca,'Xlim',xlimxx);
            grid
            ylabel(comp(ii).name);
            title(titchar);
        
            if ii == 1
                hleg=legend(H,'WAM','BUOY');
                po=get(hleg,'position');
                po=[0.852 0.928 0.08 0.03];
                set(hleg,'position',po);
            end
            clear H;
        end
        %
%         subplot(6,1,2)
%         plot(timwam,tppfM,'b',timbuoy,tppfB,'r+','markersize',4);
%         xticks=get(gca,'XTick');
%         xx=datestr(xticks,6);
%         set(gca,'XTick',xticks,'XTicklabel',xx);
%         ylimmx=[0,tppmax];
%         set(gca,'Ylim',ylimmx);
%         set(gca,'Xlim',xlimxx);
%         grid
%         ylabel('T_{p}');
%         clear H;
%         %
%         subplot(6,1,3)
%         plot(timwam,tmnM,'b',timbuoy,tmnB,'r+','markersize',4);
%         xticks=get(gca,'XTick');
%         xx=datestr(xticks,6);
%         set(gca,'XTick',xticks,'XTicklabel',xx);
%         ylimmx=[0,tmnmax];
%         set(gca,'Ylim',ylimmx);
%         set(gca,'Xlim',xlimxx);
%         grid
%         ylabel('T_{m} ');
%         clear H;
%         %  
%         subplot(6,1,4)
%         plot(timwam,wavdM,'b',timbuoy,wavdB,'r+','markersize',4);
%         xticks=get(gca,'XTick');
%         xx=datestr(xticks,6);
%         set(gca,'XTick',xticks,'XTicklabel',xx);
%         ylimmx=[0,360];
%         set(gca,'Ylim',ylimmx);
%         set(gca,'Xlim',xlimxx);
%         grid
%         ylabel('Wave Dir.');
%         if nodir == 1
%             text(timwam(1),45,'No Directional Data','Color','r');
%         end
%         clear H;
%         %
%         subplot(6,1,5)
%         plot(timwam,wsM,'b',timbuoy,u10buoy,'r+','markersize',4);
%         xticks=get(gca,'XTick');
%         xx=datestr(xticks,6);
%         set(gca,'XTick',xticks,'XTicklabel',xx);
%         ylimmx=[0,wsmax];
%         set(gca,'Ylim',ylimmx);
%         set(gca,'Xlim',xlimxx);
%         grid
%         ylabel('Wind Spd.');
%         clear H;
%         %
%         subplot(6,1,6)
%         plot(timwam,windM,'b',timbuoy,windB,'r+','markersize',4);
%         xticks=get(gca,'XTick');
%         xx=datestr(xticks,6);
%         set(gca,'XTick',xticks,'XTicklabel',xx);
%         ylimmx=[0,360];
%         set(gca,'Ylim',ylimmx);
%         set(gca,'Xlim',xlimxx);
%         grid
%         ylabel('Wind Dir.');
%         xlabel(xtitl);
        %
        %  Print out the file 
        %
        eval(['print -r600 -dpng timept',filedom,int2str(buoy),'_',YRMT])
        clf
        %
        % -----------------------------------------------------------------
        %  Time Pairing of the Buoy to Model Results
        %   1.  File used for Statistical Testing
        %   2.  File used for Scatter Plots
        %   3.  File used for Q_Q plotting.
        %
        %       NOTE:   timobsB (number of observations in Buoy Record)
        %               timeobsM  (number of observations in Model Record)
        %
        %               using MPAIR largest is first index.
        %                           and Always the Model results
        % -----------------------------------------------------------------
        %
        
        tol=1.0e-8;
        %
        %  More rows goes first in the arguement.
        %       i1= index of larger data set.
        %
        if totobsM < totobsB
            [kkB,kkM]=mpair(timbuoy,timwam,tol);
        else
            [kkM,kkB]=mpair(timwam,timbuoy,tol);
        end
        %
        %  2.1  Generate Clean buoy and model Matrtices
        %       NOTE:   Buoy data set contains the -999 flags.
        %               Also have to replace the original wind speed with the
        %               Adjusted wind based on PBL.
        %               Model directions now adjusted Meteorological like the Buoy.
        %
        AB=[timbuoy(kkB),u10buoy(kkB),windB(kkB),hgtB(kkB), ...
                tppfB(kkB),tmnB(kkB),wavdB(kkB)];
        AM=[timwam(kkM),wsM(kkM),windM(kkM),hgtM(kkM),...
                tppfM(kkM),tmnM(kkM),wavdM(kkM)];
        %
        %  2.1  Call the Statistical Routine
        %           Will Generate the Statistics Table for each comparison period
        %           Will Generate a file containing time paired observations (a "mat").
        %   
        [se,sd]=stats_ftn(AB,AM,buoy,YRMT,montit,YR1,titdom,filedom);
        %
        %  2.2  Generate Scatter Plots
        %       Only Plot up the FINITE Parameters !!
        %       Use the information contained in the SE matrix.
        %           1.  SE(1)   for winds
        %           2.  SE(2)   for wave height
        %           3.  SE(3)   for parabolic fit period
        %           4.  SE(4)   for mean wave period
        %       Means are   for Buoy    2
        %                   for Model   3
        %       Bias                    4
        %       RMSE                    5
        %       Scatter Index           6
        %       Correlation             8
        %       Symmetric Regres        9
        %       Number of Paired Obs    18
        %
        %  ==========================================================
        %
        %  Look for only good wind and wave comparisons....
        %
        %	NOTE:	x = Buoy
        %		    Y = Model
        %
        %               1.  DATE
        %				2.  Wind Speed
        %				3.  Wind Direction and split into components.
        %				4.  Wave Height
        %				5.  Parabolic fit Tp
        %				6.  Mean Wave Period
        %				7.  Vector Mean Wave Direction
        %
        iwsg=find(AB(:,2) > 0 );
        iwdg=find(AB(:,3) > 0 );
        iwhtg=find(AB(:,4) > 0 );
        itpg=find(AB(:,5) > 0 & AM(:,5) > 0 & AB(:,5) ~= Inf & AM(:,5) ~= Inf );
        itmg=find(AB(:,6) > 0 & AM(:,6) > 0 & AB(:,6) ~= Inf & AM(:,6) ~= Inf);
        iwadg=find(AB(:,7) > 0 );
        %
        %   Call Q-Q Processing Routine For Wave Height
        %
        [qqB,qqM]=QQ_proc(AB(iwhtg,4),AM(iwhtg,4));
        %
        orient('tall')
        subplot(3,2,1)
        plot(AB(iwhtg,4),AM(iwhtg,4),'r.',[0 hmax],[0 hmax],'b',...
            [0 se(2,9)*hmax],[0 se(2,9)*hmax],'g--')
        grid
        axis([0,hmax,0,hmax]);
        axis('square')
        ylabel('WAM  H_{mo}');
        xlabel('Buoy H_{mo}');
        titchar1=['WAM4.5.1C  ',titdom2,' at ',int2str(buoy),' ',montit,' ' ,YR1];
        title(titchar1);
        str(1) = {['No Obs = ',int2str(length(iwhtg))]};
        str(2) = {['Bias   = ',num2str(se(2,4))]};
        str(3) = {['RMSE   = ',num2str(se(2,5))]};
        str(4) = {['S.I.   = ',int2str(se(2,6))]};
        str(5) = {['Corr   = ',num2str(se(2,8))]};
        str(6) = {['Sym r  = ',num2str(se(2,9))]};
        text(hmax+ 0.1*hmax,0,str,'FontSize',7);
        clear str; 
        %
        subplot(3,2,2)
        plot(qqB,qqM,'r+',[0 hmax],[0 hmax],'b')
        grid
        axis([0,hmax,0,hmax]);
        axis('square')
        ylabel('WAM  H_{mo}')
        xlabel('Buoy H_{mo}')
        titchar2=['WAM4.5.1C  ',titdom2,' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
        title(titchar2);
        dist(1)= {['%tile  ','BUOY','  WAM']};
        dist(2)= {['  99    ',num2str(qqB(99),'%6.2f'),'      ',num2str(qqM(99),'%6.2f')]};
        dist(3)= {['  95    ',num2str(qqB(95),'%6.2f'),'      ',num2str(qqM(95),'%6.2f')]};
        dist(4)= {['  90    ',num2str(qqB(90),'%6.2f'),'      ',num2str(qqM(90),'%6.2f')]};
        dist(5)= {['  85    ',num2str(qqB(85),'%6.2f'),'      ',num2str(qqM(85),'%6.2f')]};
        dist(6)= {['  80    ',num2str(qqB(80),'%6.2f'),'      ',num2str(qqM(80),'%6.2f')]};
        text(hmax+0.05*hmax,0,dist,'FontSize',7);
        %
        %  First Write To File
        %       Wave Height Statistics and QQ results  'filestats'
        %       Mean Buoy, Mean Model, Bias, abs(error), rms(error) [1:5]
        %       SI, SS, Corr, Sym r,                                {6:9]
        %       Prin r, Slope, intercept, Sys Error Usys Error      [10:14]
        %       RMSE-slope, Std-a, Std-b, Number Pts                [15:18]
        %
        fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno1,buoy);
        fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(2,1:5));
        fprintf(fidstats,'  %3.0f  %5.2f  %6.2f  %6.2f',se(2,6:9));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(2,10:14));
        fprintf(fidstats,'  %6.3f  %6.4f  %6.4f  %6.0f',se(2,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %       
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        
        clear qqB; clear qqM;
        %
        %  Peak Period (parabolic fit)
        %       Call Q-Q Processing Routine For Peak Period
        %
        
        [qqB,qqM]=QQ_proc(AB(itpg,5),AM(itpg,5)); 
        %
        subplot(3,2,3)
        plot(AB(itpg,5),AM(itpg,5),'r.',[0 tppmax],[0 tppmax],'b',...
            [0 se(3,9)*tppmax],[0 se(3,9)*tppmax],'g--')
        grid
        axis([0,tppmax,0,tppmax]);
        axis('square');
        ylabel('WAM  T_{p}');
        xlabel('Buoy T_{p}');
        str(1) = {['No Obs = ',int2str(length(itpg))]};
        str(2) = {['Bias   = ',num2str(se(3,4))]};
        str(3) = {['RMSE   = ',num2str(se(3,5))]};
        str(4) = {['S.I.   = ',int2str(se(3,6))]};
        str(5) = {['Corr   = ',num2str(se(3,8))]};
        str(6) = {['Sym r  = ',num2str(se(3,9))]};
        text(tppmax+ 0.1*tppmax,0,str,'FontSize',7);
        clear str; 
        %
        subplot(3,2,4)
        plot(qqB,qqM,'r+',[0 tppmax],[0 tppmax],'b')
        grid
        axis([0,tppmax,0,tppmax]);
        axis('square');
        ylabel('WAM  T_{p}');
        xlabel('Buoy T_{p}');
        dist(1)= {['%tile  ','BUOY','   WAM']};
        dist(2)= {['  99    ',num2str(qqB(99),'%6.2f'),'   ',num2str(qqM(99),'%6.2f')]};
        dist(3)= {['  95    ',num2str(qqB(95),'%6.2f'),'   ',num2str(qqM(95),'%6.2f')]};
        dist(4)= {['  90    ',num2str(qqB(90),'%6.2f'),'   ',num2str(qqM(90),'%6.2f')]};
        dist(5)= {['  85    ',num2str(qqB(85),'%6.2f'),'   ',num2str(qqM(85),'%6.2f')]};
        dist(6)= {['  80    ',num2str(qqB(80),'%6.2f'),'   ',num2str(qqM(80),'%6.2f')]};
        text(tppmax+ 0.05*tppmax,0,dist,'FontSize',7);
        %
        %  Write to Stats file
        %
        fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno2,buoy);
        fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(3,1:5));
        fprintf(fidstats,'  %3.0f  %5.2f  %6.2f  %6.2f',se(3,6:9));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(3,10:14));
        fprintf(fidstats,'  %6.3f  %6.4f  %6.4f  %6.0f',se(3,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %       
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        %
        clear qqB; clear qqM;
        %
        %  Mean Period (parabolic fit)
        %       Call Q-Q Processing Routine For Peak Period
        %
        [qqB,qqM]=QQ_proc(AB(itpg,6),AM(itpg,6)); 
        %
        subplot(3,2,5)
        plot(AB(itmg,6),AM(itmg,6),'r.',[0 tmnmax],[0 tmnmax],'b',...
            [0 se(4,9)*tmnmax],[0 se(4,9)*tmnmax],'g--')
        grid
        axis([0,tmnmax,0,tmnmax]);
        axis('square');
        ylabel('WAM T_{m}');
        xlabel('Buoy T_{m}');
        str(1) = {['No Obs = ',int2str(length(itmg))]};
        str(2) = {['Bias   = ',num2str(se(4,4))]};
        str(3) = {['RMSE   = ',num2str(se(4,5))]};
        str(4) = {['S.I.   = ',int2str(se(4,6))]};
        str(5) = {['Corr   = ',num2str(se(4,8))]};
        str(6) = {['Sym r  = ',num2str(se(4,9))]};
        text(tmnmax+ 0.1*tmnmax,0,str,'FontSize',7);
        clear str; 
        %
        subplot(3,2,6)
        plot(qqB,qqM,'r+',[0 tmnmax],[0 tmnmax],'b')
        grid
        axis([0,tmnmax,0,tmnmax]);
        axis('square');
        ylabel('WAM  T_{m}');
        xlabel('Buoy T_{m}');
        dist(1)= {['%tile  ','BUOY','   WAM']};
        dist(2)= {['  99    ',num2str(qqB(99),'%6.2f'),'   ',num2str(qqM(99),'%6.2f')]};
        dist(3)= {['  95    ',num2str(qqB(95),'%6.2f'),'   ',num2str(qqM(95),'%6.2f')]};
        dist(4)= {['  90    ',num2str(qqB(90),'%6.2f'),'   ',num2str(qqM(90),'%6.2f')]};
        dist(5)= {['  85    ',num2str(qqB(85),'%6.2f'),'   ',num2str(qqM(85),'%6.2f')]};
        dist(6)= {['  80    ',num2str(qqB(80),'%6.2f'),'   ',num2str(qqM(80),'%6.2f')]};
        text(tmnmax+ 0.05*tmnmax,0,dist,'FontSize',7);
        %
        %  Write to Stats file
        %
        fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno3,buoy);
        fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(4,1:5));
        fprintf(fidstats,'  %3.0f  %5.2f  %6.2f  %6.2f',se(4,6:9));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(4,10:14));
        fprintf(fidstats,'  %6.3f  %6.4f  %6.4f  %6.0f',se(4,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %       
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        %
        clear qqB; clear qqM;
        %
        %
        eval(['print -r600 -dpng scat',filedom,int2str(buoy),'_',YRMT,'p1'])
        clf
        %
        %  Page 2  Wind Speed and Directional plots
        %           Q-Q on Wind Speed
        %           Directional Difference on Wind and Wave Directions.
        %
        %
        %
        orient('tall')
        if ~isempty(iwsg)
            [qqB,qqM]=QQ_proc(AB(iwsg,2),AM(iwsg,2));
            subplot(3,2,1)
            plot(AB(iwsg,2),AM(iwsg,2),'r.',[0 wsmax],[0 wsmax],'b',...
                [0 se(1,9)*wsmax],[0 se(1,9)*wsmax],'g--')
            grid
            axis([0,wsmax,0,wsmax]);
            axis('square');
            ylabel('OWI WS');
            xlabel('Buoy WS');
            titchar1=['OWI ',titdom2,' at ',int2str(buoy),' ',montit,' ' ,YR1];
            title(titchar1);
            str(1) = {['No Obs = ',int2str(length(iwsg))]};
            str(2) = {['Bias   = ',num2str(se(1,4))]};
            str(3) = {['RMSE   = ',num2str(se(1,5))]};
            str(4) = {['S.I.   = ',int2str(se(1,6))]};
            str(5) = {['Corr   = ',num2str(se(1,8))]};
            str(6) = {['Sym r  = ',num2str(se(1,9))]};
            text(wsmax+ 0.1*wsmax,0,str,'FontSize',7);
            clear str;
            %
            subplot(3,2,2)
            plot(qqB,qqM,'r+',[0 wsmax],[0 wsmax],'b')
            grid
            axis([0,wsmax,0,wsmax]);
            axis('square');
            ylabel('OWI WS');
            xlabel('Buoy WS');
            titchar2=['OWI ',titdom2,' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
            title(titchar2);
            %
            %    
            subplot(3,2,3)
            plot(AB(iwdg,3),AM(iwdg,3),'r.',[0 360],[0 360],'b')
            grid
            axis([0,360,0,360]);
            axis('square');
            ylabel('OWI WD');
            xlabel('Buoy WD');
            titchar1=['OWI ',titdom2,' at ',int2str(buoy),' ',montit,' ' ,YR1];
            
            str(1) = {['No Obs = ',int2str(length(iwdg))]};
            str(2) = {['Scl X   = ',num2str(sd(1,1))]};
            str(3) = {['Scl Y   = ',num2str(sd(1,2))]};
            str(4) = {['Vec X  = ',num2str(sd(1,3))]};
            str(5) = {['Vec Y  = ',num2str(sd(1,4))]};
            str(6) = {['Diff   = ',num2str(sd(1,5))]};
            str(7) = {['Sigma  = ',num2str(sd(1,6))]};
            str(8) = {['Rho    = ',num2str(sd(1,7))]};
            str(9) = {['Phase = ',num2str(sd(1,8))]};
            text(360+ 0.075*360,-10,str,'FontSize',7);
            clear str; 
            %
            %  Wind Direction Distribution Scatter Plot
            %
            nbins=36;
            resbins=360/nbins;
            DIRINT=0:resbins:360-resbins;
            NHIB=hist(AB(iwdg,3),nbins);
            NHIM=hist(AM(iwdg,3),nbins);
            cumtotM=cumsum(NHIM)/length(iwdg);
            cumtotB=cumsum(NHIB)/length(iwdg);
            
            subplot(3,2,4)
            HC=plot(DIRINT,cumtotB,'ro',DIRINT,cumtotM,'b*');
            grid
            axis([0,350,0 1]);
            legend(HC,'Buoy','Mod',4);
            axis('square');
            ylabel('Cum. %');
            xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
            xlabel(xchar);
            clear HC; clear NHIB; clear NHIM; clear cumtotM; clear cumtotB;
        else
            qqB=zeros(1,99);
            qqM=zeros(1,99);
            se(1,1:18)=0;
            wsmax=10;
            subplot(3,2,1)
            plot([0 wsmax],[0 wsmax],'b')
            grid
            axis([0,wsmax,0,wsmax]);
            axis('square');
            ylabel('OWI WS');
            xlabel('Buoy WS');
            text(5,5,'NODATA','HorizontalAlignment','center','Color','r');
            titchar1=['OWI ',titdom2,' at ',int2str(buoy),' ',montit,' ' ,YR1];
            title(titchar1);
            %
            subplot(3,2,2)
            plot([0 wsmax],[0 wsmax],'b')
            grid
            axis([0,wsmax,0,wsmax]);
            axis('square');
            ylabel('OWI WS');
            xlabel('Buoy WS');
            text(5,5,'NODATA','HorizontalAlignment','center','Color','r');
            titchar2=['OWI ',titdom2,' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
            title(titchar2);
            %
            subplot(3,2,3)
            plot([0 360],[0 360],'b')
            grid
            axis([0,360,0,360]);
            axis('square');
            ylabel('OWI WD');
            xlabel('Buoy WD');
            text(180,180,'NODATA','HorizontalAlignment','center','Color','r');
            titchar1=['OWI ',titdom2,' at ',int2str(buoy),' ',montit,' ' ,YR1];
            title(titchar1)
            %
            subplot(3,2,4)
            resbins=0;
            plot([0 359],[0 1],'b--');
            grid
            axis([0,350,0 1]);
            axis('square');
            ylabel('Cum. %');
            text(180,.5,'NODATA','HorizontalAlignment','center','Color','r')
            xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
            xlabel(xchar);   
        end
        %
        %
        %  Write to Stats file
        %
        fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno4,buoy);
        fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(1,1:5));
        fprintf(fidstats,'  %3.0f  %5.2f  %6.2f  %6.2f',se(1,6:9));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(1,10:14));
        fprintf(fidstats,'  %6.3f  %6.4f  %6.4f  %6.0f',se(1,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        %
        fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno5,buoy);
        fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f',sd(1,1:5));
        fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f  %6.0f',sd(1,6:11));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
        fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar2(1:5));
        clear qqB; clear qqM;
        %
        %  Wave Direction Plots Scatter and Cumulative Distribution
        %       FIRST CHECK ON THE BUOY DATA IF THERE IS DATA
        %           1.  IF the number of observations are zero then skip plotting.
        %
        if isempty(iwadg) == 0
            
            subplot(3,2,5)
            plot(AB(iwadg,7),AM(iwadg,7),'r.',[0 360],[0 360],'b')
            grid
            axis([0,360,0,360]);
            axis('square');
            ylabel('WAM  WAVE  \theta_{M}');
            xlabel('Buoy WAVE  \theta_{M}');
            %
            str(1) = {['No Obs = ',int2str(length(iwsg))]};
            str(2) = {['Scl X   = ',num2str(sd(2,1))]};
            str(3) = {['Scl Y   = ',num2str(sd(2,2))]};
            str(4) = {['Vec X  = ',num2str(sd(2,3))]};
            str(5) = {['Vec Y  = ',num2str(sd(2,4))]};
            str(6) = {['Diff   = ',num2str(sd(2,5))]};
            str(7) = {['Sigma  = ',num2str(sd(2,6))]};
            str(8) = {['Rho    = ',num2str(sd(2,7))]};
            str(9) = {['Phase = ',num2str(sd(2,8))]};
            text(360+ 0.1*360,-10,str,'FontSize',7);
            clear str; 
            fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno6,buoy);
            fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
            fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f',sd(2,1:5));
            fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f  %6.0f',sd(2,6:11));
            fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
            fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar1(1:5));
            %
            %  Wave Cumulative Distribution Scatter Plot
            %
            nbins=36;
            resbins=360/nbins;
            DIRINT=0:resbins:360-resbins;
            NHIWB=hist(AB(iwadg,7),nbins);
            NHIWM=hist(AM(iwadg,7),nbins);
            cumtotM=cumsum(NHIWM)/length(iwadg);
            cumtotB=cumsum(NHIWB)/length(iwadg);
            
            subplot(3,2,6)
            HC=plot(DIRINT,cumtotB,'ro',DIRINT,cumtotM,'b*');
            grid
            axis([0,350,0 1]);
            legend(HC,'Buoy','Mod',4);
            axis('square');
            ylabel('Cum. %');
            xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
            xlabel(xchar);
            clear HC;
            %
        else
            fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno6,buoy);
            fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
            fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f %6.1f',sd(2,1:5));
            fprintf(fidstats,'  %6.1f  %6.1f  %6.1f  %6.1f %6.1f',sd(2,6:10));
            fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
            fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar1(1:5));  
        end 
        eval(['print -r600 -dpng scat',filedom,int2str(buoy),'_',YRMT,'p2'])
        
        clf
        clear a; clear B1; clear Btot; clear timwam; clear timbuoy;
        clear totobsM; clear totobsB;
        fclose(fidstats);
    else
        disp('NO SAVE POINT EXISTS FOR NDBC BUOY ')
        disp(buoylocs(kkk,:))
    end
end
