function timeplt_WAM2(yrin, mntin,res)
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
%		res:		NUMERIC  :  0.04, 0.005
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

filedom = 'BAS';
titdom=['BASIN'];
xlonw = -88.08;
xlone = -84.48;
xlats = 41.48;
xlatn = 46.24;
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

buoytit{1}= ' ';
buoytit{2}= ' ';
buoytit{3}= ' ';
buoytit{4}= ' ';
buoytit{5}= ' ';
buoytit{6}= ' ';

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
filesw = dir('W*.onlns');
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
    AAtot = load_wam2(filename2,buoylocs(kkk,:),filename2(19:22),filename2(24:25));
    Btot = AAtot;
       %
    %  Split out the proper WAM Save pt for the buoy comparison
    %
    %       NOW BASED ALL ON THE BUOY NUMBER LOCATED IN THE ONELINE FILE 
    %                ***** (RECORD 4)  *****
    %
    istn=[1:1:size(Btot,1)] ; 
    if ~isempty(istn);
        %
        %  Open up the ascii file containing various stat data and QQ results
        %
        filestats = ['stats',int2str(buoy),'_',YRMT,'.asc'];
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
        TM1=datenum(B1(:,1));
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
        latbn = sprintf('%4.2f',a(1,7) + (a(1,8)/60 + a(1,9)/3600));
        latb=num2str(latbn);%a(1,7) + (a(1,8)/60 + a(1,9)/3600));
        lonbn = sprintf('%4.2f',(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
        lonb=['-',num2str(lonbn)];%(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
        latM=num2str(B1(1,3));
        lonM=num2str(B1(1,4)-360);
        LONout=B1(1,4)-360;
        LATout=B1(1,3);
        DEPout=a(1,13);
        depb=num2str(a(1,13));
        %
        %  Set the Title of plot
        %
        titcharpt1=['Lake Michigan 30-yr Hindcast Study [CFSR Winds]   '];
        titcharpt15=['        WAM4.5.1C (Res = ',num2str(res),'\circ)  [ ',lonM,'\circ / ',latM,'\circ ]'];
        titcharpt2=['      NDBC = ',int2str(buoy),' [ ',lonb,...
                '\circ / ',latb,'\circ ], Depth = ',depb,'m'];
        %titcharpt25=['at Depth = ',depb,'m'];
        titchar1=[{titcharpt1}];
        titchar2=[{titcharpt2;titcharpt15}];
        %titchar = [{titcharpt1;titcharpt2}];
        %titchar2 = [{titcharpt15;titcharpt25;'';'';''}];
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
        %           WAM  Col    10
        %  
        hgtB=a(:,21);
        hgtM=B1(:,10);
        hmax=ceil(max(max(hgtM),max(hgtB)));
        comp(1) =struct('name','H_{mo} [m]','y1',hgtM,'y2',hgtB,'max',hmax);
        
        %
        %   2.  Peak Period  (Parabolic Fit)
        %           Buoy Col    23
        %           WAM  Col    11
        %
        tppfB=a(:,23);
        itpB=find(a(:,23) > 0);
        tppfM=B1(:,11);
        itpM=find(B1(:,8) > 0);
        tppmax=ceil(max(max(tppfM(itpM)),max(tppfB(itpB))));
        comp(2) = struct('name','T_{p} [s]','y1',tppfM,'y2',tppfB,'max',tppmax);
        %
        %  3.  Mean Wave Period  (inverse 1st moment)
        %           Buoy Col    24
        %           WAM  Col    12
        %
        tmnB=a(:,24);
        tmnM=B1(:,12);
        tmnmax=ceil(max(max(tmnM),max(tmnB)));
        comp(3) = struct('name','T_{m} [s]','y1',tmnM,'y2',tmnB,'max',tmnmax);
        %
        %           
        %  4.  Mean Wave Direction  Overall Vector Mean  Transform to Geophys Met.
        %                           ADJUST THE WAM RESULTS
        %
        %           Buoy Col    25  (Meteorological 0 from   North / 90 from   East)
        %           WAM  Col    15  (Oceanographic  0 toward North / 90 toward East)
        %
        %   NOTE:  Determine if Buoy has Directional Information (look for finite directions)
        %                       If have flag to produce "No Directional Buoy Data")
        %                       called "nodir"
        %
        iwavB=find(a(:,25) >= 0);
        wavdB=a(:,25);
        nodir=isempty(iwavB);
        %wavdM=180+B1(:,15);
        wavdM = B1(:,15);
        i1=find(wavdM >= 360);
        wavdM(i1)=wavdM(i1)-360;
        clear i1;
        comp(4) = struct('name','\theta_{wave}','y1',wavdM,'y2',wavdB,'max',360);
        %
        %  5.  Wind Speed   U10
        %       Buoy        From Above (tranform to 10 m)
        %       WAM         Column 5 
        %
        wsM=B1(:,5);
        wsmax=ceil(max(max(wsM),max(u10buoy)));
        comp(5) = struct('name','WS [m/s]','y1',wsM,'y2',u10buoy,'max',wsmax);
        %
        %  6.  Wind Direction  (Use Meteorlogical coordinate)
        %
        %       Buoy  Col       17  (Meteorological 0 from   North / 90 from   East)
        %       WAM   Col        6  (Oceanographic  0 toward North / 90 toward East)
        %
        windB=a(:,17);
        nowndB=find(windB == 0);
        iwdB=length(nowndB);
        if iwdB > 0.5*totobsB
            windB(nowndB)=-999.;
        end
        %windM=180+B1(:,6);
        windM = B1(:,6);
        i1=find(windM >=360);
        windM(i1) = windM(i1)-360.;
        comp(6) = struct('name','\theta_{wind}','y1',windM,'y2',windB,'max',360);
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
        m_plot(lonmp,latmp,'r.','MarkerSize',12)
        set(gca,'Position',[0.45 0.74 0.7 0.25]);
        hold off
        for ii = 1:6
            orient('Tall')
            subplot(8,3,3*ii+4:3*ii+6)
            if ii == 5
                qq = find(comp(ii).y2 == 0);
                comp(ii).y2(qq) = -1.0;
            end
            H=plot(timbuoy,comp(ii).y2,'r.',timwam,comp(ii).y1,'b','markersize',8,'LineWidth',1); 
            xticks=get(gca,'XTick');
            xtickdiff = xticks(end) - xticks(1);
            xticks = [xticks(1):ceil(xtickdiff/14):xticks(end)];
            xx=datestr(xticks,7);
            set(gca,'XTick',xticks,'XTicklabel',xx);
            ylimmx=[0,comp(ii).max];
            if ylimmx(2) <= 2
                ytd1 = ylimmx(2)/4;
                ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
            else
                ytd1 = ceil(ylimmx(2)/4);
                ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
            end
            set(gca,'YTick',ytickm);
            set(gca,'Ylim',ylimmx);
            set(gca,'Xlim',xlimxx);
            grid
            ylabel(comp(ii).name);
            
            if ii == 1
                text(timwam(1),comp(ii).max*4,titchar1,'FontWeight','bold','Fontsize',13);
                text(timwam(1),comp(ii).max*3, titchar2,'FontWeight','bold','Fontsize',12);
                hleg=legend(H,'BUOY','WAM');
                po=get(hleg,'position');
                po=[0.3 0.74 0.08 0.03];
                set(hleg,'position',po);
            end
            if (ii == 4 && nodir == 1)
                text(timwam(1),60,'No Directional Data','Color','red');
            end
            if ii == 6
                xlabel(xtitl)
            end
            clear H;
        end
        %
        %  Print out the file 
        %
        ffout = ['BAS',int2str(buoy),'_',YRMT];
        print(gcf,'-dpng','-r400',ffout)
        clf
        
        lonmp2(kkk,1) = str2double(lonb(1,:));
        latmp2(kkk,1) = str2double(latb(1,:));
        if lonmp2(kkk,1) > 0
            lonmp2(kkk,1) = lonmp2(kkk,1) - 360;
        end
        
        if totlocs > 1
        figure(2)
        if kkk == totlocs
        subplot(8,3,[2 6])
        %if kkk == totlocs
           m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
           m_patch(shr_x,shr_y,[.0 .5 .0]);
            m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
            hcst=findobj(gca,'Tag','m_gshhs_f');
            set(hcst,'HandleVisibility','off');
            m_grid('box','fancy','tickdir','in','fontweight','bold','fontsize',8);
            hold on
        %end
        for ii = 1:2
            m_text(lonmp2(ii),latmp2(ii),buoylocs(ii,:),'fontsize',8,'HorizontalAlignment','right', ...
                'VerticalAlignment','Bottom','backgroundcolor',[1 1 1]);
            m_plot(lonmp2(ii),latmp2(ii),'r.','MarkerSize',12)
            hold on
        end
        
        set(gca,'Position',[0.45 0.74 0.7 0.25]);
        end
        orient('Tall')
        subplot(8,3,3*kkk+4:3*kkk+6)
        H=plot(timbuoy,comp(1).y2,'r.',timwam,comp(1).y1,'b','markersize',8,'LineWidth',1); 
        xticks=get(gca,'XTick');
        xtickdiff = xticks(end) - xticks(1);
        xticks = [xticks(1):ceil(xtickdiff/14):xticks(end)];
        xx=datestr(xticks,7);
        set(gca,'XTick',xticks,'XTicklabel',xx);
        ylimmx=[0,comp(1).max];
        set(gca,'Ylim',ylimmx);
        set(gca,'Xlim',xlimxx);
        grid
        ylabel(comp(1).name);
        ylimmax = max(ylimmax,comp(1).max);
   
        %for ii = 1:totlocs
            buoytit{kkk} = ['Station ',buoylocs(kkk,:),' [',lonb,'\circ ,',latb,'\circ ]'];
        %end
        
        if kkk == totlocs
            for ii = 1:totlocs
                subplot(8,3,3*ii+4:3*ii+6)
                ylimmx = [0,ylimmax];
                set(gca,'Ylim',ylimmx);
                text(max(xlimxx)-3.0,ylimmax-0.08*ylimmax,buoylocs(ii,:))
                if ii == totlocs
                    xlabel(xtitl);
                    subplot(8,3,7:9)
                    title1 = ['Lake Michigan 30-yr Hindcast Study [CFSR Winds]   '];
                    title2 = ['                            WAM4.5.1C (Res = ',num2str(res),'\circ)'];
                    title3 = ['                      Wave Heights H_{mo} (m) Analysis'];
                    for jj = 1:6
                        btitle{jj} = ['                      ',buoytit{jj}];
                    end         
                    titletot = [{title1}];
                    titletot2= [{title2;title3;btitle{1};btitle{2};btitle{3};btitle{4}; ...
                        btitle{5};btitle{6}}];
                    text(timwam(1),ylimmax*4.2,titletot,'FontWeight','bold','Fontsize',13);
                    text(timwam(1),ylimmax*3,titletot2,'FontWeight','bold','Fontsize',12);
                    hleg=legend(H,'BUOY','WAM');
                    po=get(hleg,'position');
                    po=[0.3 0.74 0.08 0.03];
                    set(hleg,'position',po);
                end
                
            end
            
            ff15 = ['BAS','buoy_comp_',YRMT];
            print(gcf,'-dpng','-r400',ff15)
            clf
        end
        end
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
        AB=[timbuoy(kkB),comp(5).y2(kkB),comp(6).y2(kkB),comp(1).y2(kkB), ...
                comp(2).y2(kkB),comp(3).y2(kkB),comp(4).y2(kkB)];
        AM=[timwam(kkM),comp(5).y1(kkM),comp(6).y1(kkM),comp(1).y1(kkM),...
                comp(2).y1(kkM),comp(3).y1(kkM),comp(4).y1(kkM)];
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
        vars = {iwsg;iwdg;iwhtg;itpg;itmg;iwadg};
        rr = [4;5;6;2;3];
        %   Call Q-Q Processing Routine For Wave Height
        %
        figure(1)
        for ii = 1:3
        [qqB,qqM]=QQ_proc(AB(vars{rr(ii)-1},rr(ii)),AM(vars{rr(ii)-1},rr(ii)));
        %
        orient('tall')
        subplot(3,2,2*ii-1)
        plot(AB(vars{rr(ii)-1},rr(ii)),AM(vars{rr(ii)-1},rr(ii)),'r.',[0 comp(ii).max],[0 comp(ii).max],'b',...
            [0 se(ii+1,9)*comp(ii).max],[0 se(ii+1,9)*comp(ii).max],'g--')
        grid
        axis([0,comp(ii).max,0,comp(ii).max]);
        axis('square')
        name1 = ['WAM ',comp(ii).name];
        name2 = ['Buoy ',comp(ii).name];
        ylabel(name1);
        xlabel(name2);
        titchar1=['WAM4.5.1C  ',' at ',int2str(buoy),' ',montit,' ' ,YR1];
        if ii == 1
            title(titchar1);
        end
        str(1) = {['No Obs = ',int2str(length(vars{rr(ii)-1}))]};
        str(2) = {['Bias   = ',num2str(se(ii+1,4))]};
        str(3) = {['RMSE   = ',num2str(se(ii+1,5))]};
        str(4) = {['S.I.   = ',int2str(se(ii+1,6))]};
        str(5) = {['Corr   = ',num2str(se(ii+1,8))]};
        str(6) = {['Sym r  = ',num2str(se(ii+1,9))]};
        text(comp(ii).max+ 0.1*comp(ii).max,0,str,'FontSize',7);
        clear str; 
        %
        subplot(3,2,2*ii)
        plot(qqB,qqM,'r+',[0 comp(ii).max],[0 comp(ii).max],'b')
        grid
        axis([0,comp(ii).max,0,comp(ii).max]);
        axis('square')
        ylabel(name1)
        xlabel(name2)
        titchar2=['WAM4.5.1C  ',' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
        if ii == 1
            title(titchar2);
        end
        dist(1)= {['%tile  ','BUOY','  WAM']};
        dist(2)= {['  99    ',num2str(qqB(99),'%6.2f'),'      ',num2str(qqM(99),'%6.2f')]};
        dist(3)= {['  95    ',num2str(qqB(95),'%6.2f'),'      ',num2str(qqM(95),'%6.2f')]};
        dist(4)= {['  90    ',num2str(qqB(90),'%6.2f'),'      ',num2str(qqM(90),'%6.2f')]};
        dist(5)= {['  85    ',num2str(qqB(85),'%6.2f'),'      ',num2str(qqM(85),'%6.2f')]};
        dist(6)= {['  80    ',num2str(qqB(80),'%6.2f'),'      ',num2str(qqM(80),'%6.2f')]};
        text(comp(ii).max+0.02*comp(ii).max,0,dist,'FontSize',7);
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
        %
        end
        ff3 = ['scat',filedom,int2str(buoy),'_',YRMT,'p1'];
        print(gcf,'-dpng','-r400',ff3);
        clf
  
        %
        %  Page 2  Wind Speed and Directional plots
        %           Q-Q on Wind Speed
        %           Directional Difference on Wind and Wave Directions.
        %
        %
        %
        figure(1)
        orient('tall')
        if ~isempty(iwsg)
            [qqB,qqM]=QQ_proc(AB(iwsg,2),AM(iwsg,2));
            subplot(3,2,1)
            plot(AB(iwsg,2),AM(iwsg,2),'r.',[0 wsmax],[0 wsmax],'b',...
                [0 se(1,9)*wsmax],[0 se(1,9)*wsmax],'g--')
            grid
            axis([0,wsmax,0,wsmax]);
            axis('square');
            ylabel('CFSR WS');
            xlabel('Buoy WS');
            titchar1=['CFSR',' at ',int2str(buoy),' ',montit,' ' ,YR1];
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
            ylabel('CFSR WS');
            xlabel('Buoy WS');
            titchar2=['CFSR',' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
            title(titchar2);
            %
            %    
            subplot(3,2,3)
            plot(AB(iwdg,3),AM(iwdg,3),'r.',[0 360],[0 360],'b')
            grid
            axis([0,360,0,360]);
            axis('square');
            ylabel('CFSR WD');
            xlabel('Buoy WD');
            titchar1=['CFSR ',' at ',int2str(buoy),' ',montit,' ' ,YR1];
            
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
            resbins=0;
            xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
            ppr1 = {wsmax;wsmax;360;350};
            ppr2 = {wsmax;wsmax;360;1.0};
            ppy = {'CFSR WS';'CFSR WS';'CFSR WD';'Cum. %'};
            ppx = {'Buoy WS';'Buoy WS';'Buoy WD';xchar};
            titchar1=['CFSR',' at ',int2str(buoy),' ',montit,' ' ,YR1];
            titchar2=['CFSR',' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
            txx = {5;5;180;180};
            txy = {5;5;180;0.5};
            for ii = 1:4
                subplot(3,2,ii)
                plot([0 ppr1{ii}],[0 ppr2{ii}],'b')
                grid
                axis([0,ppr1{ii},0,ppr2{ii}]);
                axis('square');
                ylabel(ppy{ii});
                xlabel(ppx{ii});
                text(txx{ii},txy{ii},'NODATA','HorizontalAlignment','center','Color','r');
                if ii == 1
                    title(titchar1);
                elseif ii == 2
                    title(titchar2);
                end
            end
            
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
        ff2 = ['scat',filedom,int2str(buoy),'_',YRMT,'p2'];
        print(gcf,'-dpng','-r400',ff2);
        
        clf
        clear a; clear B1; clear Btot; clear timwam; clear timbuoy;
        clear totobsM; clear totobsB;
        fclose(fidstats);
    else
        disp('NO SAVE POINT EXISTS FOR NDBC BUOY ')
        disp(buoylocs(kkk,:))
    end
end
