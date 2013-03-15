function timeplt_WAM2_mich2(yrin, mntin,res,nw)
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
%       type:       NUMERIC  : 1 = CFSR, 2 = NN
%       pathNDBC;   CHARACTER:  FULL PATH NAME 
%                               (e.g. D:\WIS\PACIFIC_FORENSICS\WAM_1DEG\OUTPUT\NDBC\2000_01)
%-----------------------------------------------------------------------------------------
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
filesb = dir('n*.onlns');
filesw = dir('WIS*.onlns');
totlocs=size(filesb,1);
%for zz = 1:size(filesw,1)
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
    buoy2 = str2num(buoylocs2(kkk,:));
    %
    %  Load in the NDBC BUOY DATA
    %
    a = load(filename);
    totobsB=size(a,1);
    %
    %  Now Load in the ENTIRE WAM oneline file
    %
    for ii = 1:nw
        filename2 = getfield(filesw(ii,1),'name')
        AAtot = load(filename2);
%         if length(AAtot{3}(:,2)) > size(AAtot{3},1)
%            Btot(:,:,1) = AAtot(1:end-1,1);
%            Btot(:,:,2) = AAtot(1:end-1,2);
%            for jj = 3:size(AAtot,2)
%                Btot(:,jj,ii) = AAtot{jj};
%            end
%         else
            for jj = 1:size(AAtot,2)
                Btot(:,jj,ii) = AAtot(:,jj);
            end
        %end
    end
       %
    %  Split out the proper WAM Save pt for the buoy comparison
    %
    %       NOW BASED ALL ON THE BUOY NUMBER LOCATED IN THE ONELINE FILE 
    %                ***** (RECORD 4)  *****
    %
    istn=find(Btot(:,4,1) == buoy) ;  
    if ~isempty(istn);
        %
        %  Open up the ascii file containing various stat data and QQ results
        %
        for jjj = 1:nw
            filestats{jjj} = ['stats',num2str(buoy),'-',YRMT,'.asc'];
            fidstats{jjj} = fopen(filestats{jjj},'w');
        %
        %  Now get the appropriate station information out of the SUM file
        %       Key off of the element number (Column 3)
        %
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
        %  Split Dates out of WAM
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
        totobsM=length(timwam);
        %
        %  Grab the Long and Lat from Buoy/WAM
        %
        latbn = sprintf('%4.2f',a(1,7) + (a(1,8)/60 + a(1,9)/3600));
        latb=num2str(latbn);%a(1,7) + (a(1,8)/60 + a(1,9)/3600));
        lonbn = sprintf('%4.2f',(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
        lonb=['-',num2str(lonbn)];%(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
        latM=num2str(B1(1,5,1));
        lonM=num2str(B1(1,6,1)-360);
        LONout=B1(1,6,1)-360;
        LATout=B1(1,5,1);
        DEPout=a(1,13);
        depb=num2str(a(1,13));
        
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
        ihgB = find(a(:,21) > 0);
        nodir(1)=isempty(ihgB);
        for jjj = 1:nw
            hgtM(:,jjj)=B1(:,12,jjj);
        end
        hmax=ceil(max(max(max(hgtM)),max(hgtB)));
        comp(1) =struct('name','H_{mo} [m]','y1',hgtM,'y2',hgtB,'max',hmax);
        
        %
        %   2.  Peak Period  (Parabolic Fit)
        %           Buoy Col    23
        %           WAM  Col    13
        %
        tppfB=a(:,22);
        itpB=find(a(:,22) > 0);
        nodir(2)=isempty(itpB);
        for jjj=1:nw
            tppfM(:,jjj)=B1(:,13,jjj);
        end
        itpM=find(B1(:,13) > 0);
        tppmax=ceil(max(max(max(tppfM(itpM,:))),max(tppfB(itpB))));
        comp(2) = struct('name','T_{p} [s]','y1',tppfM,'y2',tppfB,'max',tppmax);
        %
        %  3.  Mean Wave Period  (inverse 1st moment)
        %           Buoy Col    24
        %           WAM  Col    14
        %
        tmnB=a(:,24);
        ltmnB=find(a(:,24) > 0);
        nodir(3)=isempty(ltmnB);
        for jjj=1:nw
            tmnM(:,jjj)=B1(:,15,jjj);
        end
        if ~isempty(ltmnB)
             tmnmax2=ceil(max(max(max(tmnM(:))),max(tmnB)));
              tmnmax = tmnmax2;
         else
          tmnmax2=ceil(max(max(tmnM(:))));
         tmnmax=5*ceil(tmnmax2/5);
        end
        %tmnmax=ceil(max(max(tmnM),max(tmnB)));
        comp(3) = struct('name','T_{m} [s]','y1',tmnM,'y2',tmnB,'max',tmnmax);
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
        %
        iwavB=find(a(:,25) >= 0);
        wavdB=a(:,25);
        nodir(4)=isempty(iwavB);
        for jjj=1:nw
            wavdM(:,jjj)=180+B1(:,17,jjj);
            i1=find(wavdM(:,jjj) >= 360);
            wavdM(i1,jjj)=wavdM(i1,jjj)-360;
        end
        clear i1;
        comp(4) = struct('name','\theta_{wave}','y1',wavdM,'y2',wavdB,'max',360);
        %
        %  5.  Wind Speed   U10
        %       Buoy        From Above (tranform to 10 m)
        %       WAM         Column 5 
        %
        for jjj=1:nw
            wsM(:,jjj)=B1(:,7,jjj);
        end
        iu10 = find(u10buoy > 0);
        nodir(5)=isempty(iu10);
        wsmax=ceil(max(max(max(wsM)),max(u10buoy)));
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
        iwdB2 = find(a(:,17) >= 0);
        nodir(6)=isempty(iu10);
        if iwdB > 0.5*totobsB
            windB(nowndB)=-999.;
        end
        for jjj=1:nw
            windM(:,jjj)=180+B1(:,8,jjj);
            i1=find(windM(:,jjj) >=360);
            windM(i1,jjj) = windM(i1,jjj)-360.;
        end
        comp(6) = struct('name','\theta_{wind}','y1',windM,'y2',windB,'max',360);

      
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
        for jjj = 1:nw
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
        AM=[timwam(kkM),comp(5).y1(kkM,jjj),comp(6).y1(kkM,jjj),comp(1).y1(kkM,jjj),...
                comp(2).y1(kkM,jjj),comp(3).y1(kkM,jjj),comp(4).y1(kkM,jjj)];
        %
        for jj = 1:size(AB,2)
            for ii = 1:size(AB,1)
                if isnan(AB(ii,jj)) == 1
                    AB(ii,jj) = -999.99;
                end
            end
        end
        fouttp = ['n',num2str(buoy),'_',YRMT,'.mat'];
        save(fouttp,'AB','AM');
        
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
        
        %  First Write To File
        %       Wave Height Statistics and QQ results  'filestats'
        %       Mean Buoy, Mean Model, Bias, abs(error), rms(error) [1:5]
        %       SI, SS, Corr, Sym r,                                {6:9]
        %       Prin r, Slope, intercept, Sys Error Usys Error      [10:14]
        %       RMSE-slope, Std-a, Std-b, Number Pts                [15:18]
        %
        fprintf(fidstats{jjj},'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,ii,buoy);
        fprintf(fidstats{jjj},'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(ii+1,1:5));
        fprintf(fidstats{jjj},'  %3.0f  %5.2f  %6.2f  %6.2f',se(ii+1,6:9));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(ii+1,10:14));
        fprintf(fidstats{jjj},'  %6.3f  %6.4f  %6.4f  %6.0f',se(ii+1,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %       
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        
        clear qqB; clear qqM;
  
        %end
  
        %
        %  Page 2  Wind Speed and Directional plots
        %           Q-Q on Wind Speed
        %           Directional Difference on Wind and Wave Directions.
        %
        %
        %
        %
        %
        %  Write to Stats file
        %
        fprintf(fidstats{jjj},'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno4,buoy);
        fprintf(fidstats{jjj},'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(1,1:5));
        fprintf(fidstats{jjj},'  %3.0f  %5.2f  %6.2f  %6.2f',se(1,6:9));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(1,10:14));
        fprintf(fidstats{jjj},'  %6.3f  %6.4f  %6.4f  %6.0f',se(1,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        %
        fprintf(fidstats{jjj},'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno5,buoy);
        fprintf(fidstats{jjj},'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f',sd(1,1:5));
        fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f  %6.0f',sd(1,6:11));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
        fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar2(1:5));
        clear qqB; clear qqM;
        %
        %  Wave Direction Plots Scatter and Cumulative Distribution
        %       FIRST CHECK ON THE BUOY DATA IF THERE IS DATA
        %           1.  IF the number of observations are zero then skip plotting.
        %
        if isempty(iwadg) == 0
            
            fprintf(fidstats{jjj},'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno6,buoy);
            fprintf(fidstats{jjj},'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
            fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f',sd(2,1:5));
            fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f  %6.1f  %6.0f',sd(2,6:11));
            fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
            fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar1(1:5));
            %
        else
            fprintf(fidstats{jjj},'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno6,buoy);
            fprintf(fidstats{jjj},'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
            fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f %6.1f',sd(2,1:5));
            fprintf(fidstats{jjj},'  %6.1f  %6.1f  %6.1f  %6.1f %6.1f',sd(2,6:10));
            fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',dmyvar1(1:5));
            fprintf(fidstats{jjj},'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',dmyvar1(1:5));  
        end 
        fclose(fidstats{jjj});
        end
        clear a; clear B1; clear Btot; clear timwam; clear timbuoy;
        clear totobsM; clear totobsB;
    else
        disp('NO SAVE POINT EXISTS FOR NDBC BUOY ')
        disp(buoylocs(kkk,:))
    end
end
end
