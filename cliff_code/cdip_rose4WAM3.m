function cdip_rose4WAM3(filein, pltflag, typein,syr,eyr)

%function cdip_rose4WAM3(filein, yrflag, mntflag, typein)
%-------------------------------------------------------------------------------
% Name:
%   .dbase/web_programs/plotpro/matlab_scripts/cdip_rose.m
% Description:
%   Creates a rose plot using parameter file data, for either
%   wind speed and wind direction, wave hs and wave direction, or
%   peak period and wave direciton.
%   Calls rose_polar.m to plot lines on polar plot.
%
% DEVELOPED BY Grant A. Cameron (from CDIP)
% MODIFIED BY   A.Cialone for WISWAVE OUTPUT.
%               Augmented changes for WAM
%
%  This function loads in the full 20-year hindcast station file
%   and selects the appropriate time period to generate wind/wave
%   roses.
%   The input file contains the date in the first column (14 characters)
%
% --------------------------------------------------------------------
%  INPUT DEFINITIONS:
%       yrflag      NUMERIC     YEAR FLAG      (4 digits)
%                                   1985 thru 2004
%                                   8888 selects all years for defined month
%                                   9999 selects all years all months
%       mntflag     NUMERIC     FLAG TO PROCESS MONTH
%                                    1 thru 12  Individual months.
%                                   13          Year defined by yrstr
%                                   99          All months All years
%       stnm       CHARACTER   STATION NUMBER to Process
%       type    CHARACTER   wind, wave, peri
%-------------------------------------------------------------------------------
%
%  Get to the proper working directory based on station name
%
stnm=filein(3:7);            %string
stin=str2double(filein(3:7));   %numeric
if(stin<50000) ;return; end

if(stin>60000); iceflag=0; ocean='Atlantic'; pathin='D:\Inetpub\wwwroot\wis\atl\onlns\raw'; end
if(stin>70000); iceflag=0; ocean='Gulf of Mexico'; pathin='D:\Inetpub\wwwroot\wis\gom\onlns\raw'; end
if(stin>80000); iceflag=0; ocean ='Pacific'; pathin='D:\Inetpub\wwwroot\wis\pac\onlns\raw'; end
if(stin>=82000 &&  stin<82500); iceflag=1; ocean ='Alaska'; pathin='D:\Inetpub\wwwroot\wis\alaska\onlns\raw'; end
if(stin>91000); iceflag=1; ocean ='Lake Ontario'; pathin='D:\Inetpub\wwwroot\wis\ont\onlns\raw'; end
if(stin>92000); iceflag=1; ocean ='Lake Erie'; pathin='D:\Inetpub\wwwroot\wis\erie\onlns\raw'; end
if(stin>93000); iceflag=1; ocean ='Lake Huron'; pathin='D:\Inetpub\wwwroot\wis\huron\onlns\raw'; end
if(stin>94000); iceflag=1; ocean ='Lake Michigan'; pathin='D:\Inetpub\wwwroot\wis\mich\onlns\raw'; end
if(stin>95000); iceflag=1; ocean ='Lake Superior'; pathin='/mnt/CHL_WIS_1/CliffsProducts/Tyler/';end;%pathin=['D:\Inetpub\wwwroot\wis\super\onlns\raw']; end
if(stin>96000); iceflag=1; ocean ='Lake St. Clair'; pathin='D:\Inetpub\wwwroot\wis\stclair\onlns\raw'; end






%yrflag=str2num(yrflag);
%mntflag=str2num(mntflag);

% changed to str2double because it is faster TJ Hesser 05/28/12
pltflag=str2double(pltflag);
typein=str2double(typein);
yr1=str2double(syr);
yr2=str2double(eyr);


%yr1=filein(9:12);
%yr2=filein(14:17);


if typein == 1
    type = 'wave';
    typef= 'WAVE';
elseif typein == 2
    type = 'wind';
    typef='WIND';
    iceflag=0;
elseif typein == 3
    type = 'peri';
    typef='PERIOD';
end



%
% LOAD IN THE 20-YEAR HINDCAST FILE
% ---------------------------------
%
fprintf(1,'File in = %s \n',filein);
% removed eval statements because they are stupid TJ Hesser 05/28/13
IDX = load([pathin,'/',filein,'.onlns']);
%
%  Pull out data for processing
%
ddate=int2str(IDX(:,1));
%
%  Generate the date for datvec
%
B1 = zeros(length(ddate),6);
B1(:,1)=sscanf(ddate(:,1:4)','%4d');
B1(:,2)=sscanf(ddate(:,5:6)','%2d');
B1(:,3)=sscanf(ddate(:,7:8)','%2d');
B1(:,4)=sscanf(ddate(:,9:10)','%2d');
B1(:,5)=sscanf(ddate(:,11:12)','%2d');
B1(:,6)=sscanf(ddate(:,13:14)','%2d');

%clear ddate;
long=IDX(1,4);
lat=IDX(1,3);


%yr1= min(B1(:,1));
%yr2= max(B1(:,1));   %-1

%%%%%%%%%%%%%%%%%%%%%
%tmyr = B1(:,1);
%x = length(tmyr);
%yr1 = num2str(tmyr(1))
%yr2 = num2str(tmyr(x))
%%% check for extra record in onlns file %%%
%ydif = tmyr(x)-tmyr(x-1);
%if(ydif>0)
%  yr2 = num2str(tmyr(x-1))
%end
%%%%%%%%%%%%%%%%%%%%%%%%%


%
%  Big loop reading information from filein.dat
%   All values in filein are NUMERIC.
%       Transform station number and type to CHARACTER
%

%%% eval(['load ',pathin,'\Table_All_Stns.dat'])

ttbl = strcat(pathin,'/Table_All_Stns.dat');
b=load(ttbl);
% gg=b(:,1);
% dp=b(:,4);
x = b(:,1) == stin;
% x = gg == stin;
% %%%depth = dp(x);
if(b(x,4)==-9999)
    depth = 'N/A';
else
    depth = num2str(abs(b(x,4)));
end
%
% fixed up to here --------------------------------------------------
%
%%% this is the  .onlns file

if pltflag == 2		% 1yr (annuals)
    xx1 = yr1;    %str2num(yr1);
    xx2 = yr2;    %str2num(yr2);
end
if pltflag == 3		%month loop (1mo/all years)
    xx1 = 1;
    xx2 = 12;
end
if pltflag == 4		%all years (no loop)
    xx1 = 1;
    xx2 = 1;
end

figure('position',[10 10 700 800],'visible', 'off');
for xlp=xx1:xx2  %%%%%%%%%
    
    %    if(pltflag == 2); yrflag=xlp; end
    
    clear idx;
    clear val;
    clear dir;
    
    if pltflag == 2		% 1 yr
        iproc=B1(:,1) == xlp;		%xlp is year
        idx=IDX(iproc,:);
        yearchr=int2str(xlp);
        mntchr='01_12';
    end
    
    if pltflag == 3	% 1mo/all yrs
        iproc=B1(:,2) == xlp;		%xlp is month
        idx=IDX(iproc,:);
        yearchr=[num2str(yr1),'_',num2str(yr2)];
        %yearchrX2=[num2str(yr1),'-',num2str(yr2)];
        if xlp < 10
            mntchr=['0',int2str(xlp)];
        else
            mntchr=int2str(xlp);
        end
    end
    
    if pltflag == 4		% all mo/all yrs     #4
        idx=IDX;
        yearchr=[num2str(yr1),'_',num2str(yr2),'ALL'];
        mntchr='NA';
    end
    
    ddate=int2str(idx(:,1));
    %
    %  Find the TOTAL NUMBER OF OBSERVATIONS INCLUDING ICE
    %
    num_obsORIG = length(idx);
    %
    %  Generate the date for datvec
    %
    yr=sscanf(ddate(:,1:4)','%4d');
    mo=sscanf(ddate(:,5:6)','%2d');
    da=sscanf(ddate(:,7:8)','%2d');
    hr=sscanf(ddate(:,9:10)','%2d');
    %
    %  FIND AND REPLACE ALL FLAGGED (ICE COVERAGE) CONDITIONS WITH 0.
    %
    icecv=idx(:,5) < 0;
    idx(icecv,5:end)=0.;
    num_iceobs=length(idx(icecv,5));
    
    % SET PARAMETERS FOR ROSE TYPE
    
    if strcmp(type,'wind')
        amplitude_label = 'WIND SPEED (m/s)';
        graph_title = 'WIND ROSE';
        val = idx(:,5);
        dir = idx(:,6);
        radial_edge = 5:5:30; % bins for speed
        line_len = 0.09;
        width_delta = 5;
        
    elseif strcmp(type,'wave')
        amplitude_label = 'SIG WAVE HEIGHT (m)';
        graph_title = 'WAVE ROSE';
        val = idx(:,10);
        dir = idx(:,16);  %  new file format NOV2011
        
        if  max(val) > 4
            radial_edge = [1:1:5,7.5:2.5:20]; % bins for wave height
            line_len = 0.085;
            width_delta = 3;
        else
            %if max(val) <= 4
            line_len = 0.09;
            width_delta = 3;
            radial_edge = .5:.5:4; % bins for wave height
        end
        
        %    elseif ( type == 'peri')
        %        amplitude_label = 'PEAK PERIOD (s)';
        %        graph_title = 'PERIOD ROSE';
        %        val = idx(:,11);
        %        dir = idx(:,15);
        %        radial_edge = 5:5:30; % bins for peak period
        %        line_len = 0.09;
        %        width_delta = 2;
    end
    
    tmod=datenum(yr,mo,da,hr,0,0);
    lastdate=length(tmod)-1;         % use next to last record; last record is into next year
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BIG IF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = val > 0.1;
    if (length(val(k)) > 12)
        val = val(k);    % wave heights
        dir = dir(k);
        
        num_observations = length(val);
        deg_interval = 22.5;
        centers = deg_interval:deg_interval:360;
        num_bins = length(centers);
        
        % Note: this defines an extra bin
        upper_edge = [deg_interval/2:deg_interval:360,360];
        
        
        % TAG DIRECTION INTO BINS
        
        [dir_sorted,I] = sort(dir);
        dir_tag = repmat(-1,[num_observations,1]);
        %k = 1;
        for i=1:length(upper_edge)
            %             for j=k:num_observations
            %                if ( dir_sorted(j) <= upper_edge(i) && dir_tag(I(j)) < 0 )
            %                    dir_tag(I(j)) = i;
            %                else
            %                    k = j;
            %                    break;
            %                end
            %            end
            ii = dir_sorted <= upper_edge(i) & dir_tag(I) < 0;
            dir_tag(I(ii)) = i;
            clear ii
        end
        
        % TAG SPEED/HS INTO BINS
        
        [val_sorted,I] = sort(val);
        val_tag = repmat(-1,[num_observations,1]);
        %k = 1;
        for i=1:length(radial_edge)
            %             for j=k:num_observations
            %                if ( val_sorted(j) <= radial_edge(i) && val_tag(I(j)) < 0 )
            %                    val_tag(I(j)) = i;
            %                else
            %                    k = j;
            %                    break;
            %                end
            %             end
            ii = val_sorted <= radial_edge(i) & val_tag(I) < 0;
            val_tag(I(ii)) = i;
            clear ii
        end
        
        % tag those > our max hs.
        
        %         for i=1:num_observations
        %            if ( val_tag(I(i)) < 0 )
        %                val_tag(I(i)) = length(radial_edge) + 1;
        %            end
        %         end
        val_tag(val_tag(I(i)) < 0) = length(radial_edge) + 1;
        
        
        % MAKE A COUNT OF EACH COMBINATION, DIRECTION AND SPEED/HS
        
        bins = zeros(length(upper_edge),length(radial_edge)+1);
        for i=1:num_observations
            bins(dir_tag(i),val_tag(i)) = bins(dir_tag(i),val_tag(i)) + 1;
        end
        %bins(dir_tag,val_tag) = bins(dir_tag,val_tag) + 1;
        
        % COMBINE FIRST ROW INTO LAST ROW
        
        bins(length(upper_edge),:) = bins(length(upper_edge),:) + bins(1,:);
        
        
        % CREATE RELATIVE FREQUENCIES
        % bins =
        %	row - direction: 1=22.5, 2=45, ... last=360.(direction)
        %	col - speed: 1=0-2, 2=2-4, ... last=18-20.  (linewidth)
        %	val - frequency:                            (linelength)
        %bins = bins/bin_sum;  FORCES the TOTAL TO BE 100%
        %
        %bin_sum = sum(sum(bins));
        bins=bins/num_obsORIG;
        max_rho = max(sum(bins,2));
        start_rho = .20 * max_rho;
        
        % CREATE INPUTS AND RUN ROSE_POLAR FOR EACH SPEED OR HEIGHT
        % ----------------------------------------------------------
        
        %        if ishandle(1)
        %            figure(1),clf
        %        else
        %figure('position',[10 10 700 800],'visible', 'off');
        %        end
        linewidths = 2:width_delta:2+(length(radial_edge))*width_delta;
        colors = colormap(lines(length(radial_edge)+1));
        colors(4,1) =  .5;
        colors(4,3) =  .9;
        centers_rad = (centers / 360) * 2 * pi;
        
        max_col = 0;
        for col=1:length(radial_edge)+1
           %  rho = [];
           %  theta = [];
            if any(bins(:,col))
                max_col = max(col,max_col);
               rho = NaN(1,(length(upper_edge)-1)*3);
               theta = NaN(1,(length(upper_edge)-1)*3);
               nn = 0;
                for row=2:length(upper_edge)
                    if bins(row,col) > 0
                        nn = nn + 1;
                        if ( col > 1 )
                            prev = start_rho + sum(bins(row,1:(col-1)));
                        else
                            prev = start_rho;
                        end
            %            rho = [rho prev prev+bins(row,col) NaN];
            %            theta = [theta centers_rad(row-1) centers_rad(row-1) NaN];
                        rho(1,nn*3-2:nn*3) = [ prev ...
                            prev+bins(row,col) NaN ];
                        theta(1,nn*3-2:nn*3) = [centers_rad(row-1) ...
                            centers_rad(row-1) NaN ];
                    end
                end

                ph = rose_polar(theta, rho, '-', num_bins, max_rho+start_rho);
                hold on;
                set(ph,'linewidth',linewidths(col));
                set(ph,'color',colors(col,:));
            end
        end
        
        % RE-ORIENT AXIS SO 0=NORTH, 90=EAST (i.e. increasing clockwise)
        set(gca,'cameraposition',[ 0.01 0 -100]);
        
        % RE-ORIENT WHEEL ON FIGURE WINDOW
        
        set(gcf,'paperposition',[.25 .5 8 10]);
        set(gca,'position',[.14 .13 .70 .736129]);
        
        % WRITE TEXT ON FIGURE, FIRST SET AXES FOR ENTIRE FIGURE REGION
        
        %%% WIS logo %%%
        hi=gca;
        uistack(hi,'bottom');
        hi2=axes('position',[0.08,  0.89,  0.15,  0.070]);  %xpos  ypos  xlen  ylen
        % 	[xx, map]=imread('D:/Inetpub/wwwroot/wis/thumbs/WISlogo.png');
        % 	image(xx)
        % 	colormap (map)
        set(hi2,'handlevisibility','off','visible','off') 			%close axis. No more writing to axis!
        
        %%% Alaska logo %%%
        if(strcmp(ocean,'Alaska'))
            hi=gca;
            uistack(hi,'bottom');
            hi2=axes('position',[0.825,  0.81,  0.12,  0.15]);  %xpos  ypos  xlen  ylen
            [xx, map]=imread('D:/Inetpub/wwwroot/wis/thumbs/alaska110.png');
            image(xx);
            colormap (map);
            set(hi2,'handlevisibility','off','visible','off'); 			%close axis. No more writing to axis!
        end
        
        
        %%% Station Title %%%
        ah_text = axes('position',[0 0 1 1], 'units', 'normal', 'visible', 'off');
        th=text(.5,.86,graph_title, 'fontsize',14,'color',[1, .3 .3], 'horizontalalignment','center','fontweight','bold');
        text(.5,.95,[ocean,' WIS Station ',stnm], 'fontsize',14,'color','blue','horizontalalignment','center');
        
        
        %%% CREATE START/END DATE STRING %%%
        start_string = datestr(tmod(1),1);
        end_string = datestr(tmod(lastdate),1);
        start_string(3) = '-'; start_string(7) = '-';
        end_string(3) = '-'; end_string(7) = '-';
        date_string = [start_string,'  thru  ', end_string];
        if pltflag == 2
            date_string = ['ANNUAL ', start_string(8:11)];
        end
        if pltflag == 3
            date_string = ['ALL ',end_string(4:6),'s: ',start_string(8:11),' - ',num2str(yr2)];
        end
        
        
        
        
        
        
        % PUT NUMBER OF OBSERVATIONS
        textln1=['Long:  ',num2str(long),'\circ   Lat: ',num2str(lat),'\circ'];
        %%%	if (type == 'wave')  textln1=strcat(textln1, '   Depth:   ', num2str(abs(depth)), ' m' );  end
        if strcmp(type,'wave') ; textln1=strcat(textln1, '   Depth:   ',depth, ' m' );  end
        textln2=['Total Obs : ',num2str(num_obsORIG)];
        if(iceflag==1)
            textln2=['Total Obs / Total Ice : ',num2str(num_obsORIG),' / ',num2str(num_iceobs)];
        end
        textlnT=[{date_string};{textln1};{textln2}];
        text(.5,.905,textlnT,'fontsize',12,'color','blue','horizontalalignment','center');
        
        % PUT A LEGEND ON THE PLOT
        
        %ah_wheel = gca;  % save wheel axis for later
        
        ax_pos = [ .03 .10 .8 .1 ];
        leg_ah = axes('position',ax_pos,'visible','off','box','on');
        
        left_start = .05;
        line_height = 0;
        text_y = 0;
        start_line = left_start;
        line_y = [ line_height line_height ];
        for col=1:max_col
            if ( col == length(radial_edge)+1 )
                leg_entry = ['>',num2str(radial_edge(col-1))];
            elseif ( col == 1 )
                leg_entry = ['0-', num2str(radial_edge(col))];
            else
                leg_entry = [num2str(radial_edge(col-1)),'-',num2str(radial_edge(col))];
            end
            line_x = [start_line start_line + line_len];
            start_line = start_line + line_len;
            text_x = mean(line_x);
            text_y = linewidths(col)/65 + .15;
            th = text(text_x,text_y,leg_entry,'fontsize',8,'horizontalalignment','center');
            ph = line(line_x,line_y);
            set(ph,'linewidth',linewidths(col));
            set(ph,'color',colors(col,:));
        end
        
        text(left_start,text_y+0.5,amplitude_label,'fontsize',12,...
            'horizontalalignment','left');
        set(gca,'xlim',[0 1.15]);
        set(gca,'ylim',[-1 1]);
        ax_pos(2) = .12 - linewidths(max_col)/650;
        set(gca,'position',ax_pos);
        %
        %  Generate the plot
        %
        %         eval(['print -dpng -r600 ALASKA_ST',stnm,'_',typef,'_',yearchr,'_',mntchr]);
        %        print('-dpng', '-r600', sprintf('ALASKA_ST%s_%s_%s_%s',stnm,typef,yearchr,mntchr))
        
    else      %%%%%%%%%%%%%%%%%% ICE ICE ICE  ICE ICE ICE ICE ICE ICE ICE ICE ICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %  Still plot out the HEADINGS and IDENTIFY THAT THE PERIOD IS FULLY ICE COVERED
        %  Procedure to follow:
        %   1.  Call rose_polar first with dummy variables
        %   2.  Then re-orient the plot
        %   3.  Followed by the anotation
        
        %figure('position',[10 10 700 800],'visible', 'off');
        
        %%% WIS logo %%%
        hi=gca;
        uistack(hi,'bottom');
        hi2=axes('position',[0.08,  0.89,  0.15,  0.070]);  %xpos  ypos  xlen  ylen
        [xx, map]=imread('D:/Inetpub/wwwroot/wis/thumbs/WISlogo.png');
        image(xx);
        colormap (map);
        set(hi2,'handlevisibility','off','visible','off'); 			%close axis. No more writing to axis!
        
        %%% Alaska logo %%%
        if strcmp(ocean,'Alaska')
            hi=gca;
            uistack(hi,'bottom');
            hi2=axes('position',[0.825,  0.81,  0.12,  0.15]);  %xpos  ypos  xlen  ylen
            [xx, map]=imread('D:/Inetpub/wwwroot/wis/thumbs/alaska110.png');
            image(xx);
            colormap (map);
            set(hi2,'handlevisibility','off','visible','off'); 			%close axis. No more writing to axis!
        end
        
        
        %
        %  Where the rose_polar call goes.....
        %
        num_obsers = num_obsORIG;
        deg_interval = 22.5;
        centers = deg_interval:deg_interval:360;
        num_bins = length(centers);
        radial_edge = .5:.5:4;
        upper_edge = [deg_interval/2:deg_interval:360,360];
        bins = zeros(length(upper_edge),length(radial_edge)+1);
        bins(1:17,1)=1;
        
        bins(length(upper_edge),:) = bins(length(upper_edge),:) + bins(1,:);
        bins=0.00001*bins/num_obsers;
        max_rho = max(sum(bins,2));
        start_rho = .20 * max_rho;
        width_delta = 1;
        linewidths = 1:width_delta:2+(length(radial_edge))*width_delta;
        centers_rad = (centers / 360) * 2 * pi;
        
        max_col = 0;
        col=1;
        rho = [];
        theta = [];
        if ( any(bins(:,col)) )
            max_col = max(col,max_col);
            rho = NaN(1,(length(upper_edge)-1)*3);
            theta = NaN(1,(length(upper_edge)-1)*3);
            nn = 0;
            for row=2:length(upper_edge)
                if ( bins(row,col) > 0 )
                    if ( col > 1 )
                        prev = start_rho + sum(bins(row,1:(col-1)));
                    else
                        prev = start_rho;
                    end
                    %rho = [  rho prev prev+bins(row,col) NaN ];
                    %theta = [  theta centers_rad(row-1) centers_rad(row-1) NaN ];
                    rho(1,nn*3-2:nn*3) = [ prev ...
                        prev+bins(row,col) NaN ];
                    theta(1,nn*3-2:nn*3) = [centers_rad(row-1) ...
                        centers_rad(row-1) NaN ];
                end
            end
            ph = rose_polar2(theta, rho, '-', num_bins, max_rho+start_rho);
            hold on;
            set(ph,'linewidth',linewidths(col));
            set(ph,'color',[0 0 0]);
            set(ph,'LineStyle',':');
        end
        set(gca,'cameraposition',[ 0. 0 100]);
        view([450,-90])
        
        
        
        
        
        % RE-ORIENT WHEEL ON FIGURE WINDOW
        set(gcf,'paperposition',[.25 .5 8 10]);
        set(gca,'position',[.14 .13 .70 .736129]);
        
        
        
        
        %%%%%%%%%%%%%% Title - WRITE TEXT ON FIGURE, FIRST SET AXES FOR ENTIRE FIGURE REGION %%%%%%%%%%%%%%%%%%%%%%%
        
        ah_text = axes('position',[0 0 1 1], 'units', 'normal', 'visible', 'off');
        th=text(.5,.86,graph_title, 'fontsize',14,'color',[1, .3 .3], 'horizontalalignment','center','fontweight','bold');
        text(.5,.95,[ocean,' WIS Station ',stnm], 'fontsize',14,'color','blue', 'horizontalalignment','center');
        
        %%% string for last date
        start_string = datestr(tmod(1),1);
        end_string = datestr(tmod(lastdate),1);
        start_string(3) = '-'; start_string(7) = '-';
        end_string(3) = '-'; end_string(7) = '-';
        date_string = [start_string,'  thru  ', end_string];
        
        if pltflag == 2
            date_string = ['ANNUAL ', start_string(8:11)];
        end
        
        if pltflag == 3
            date_string = ['ALL ',end_string(4:6),'s: ',start_string(8:11),' - ',num2str(yr2)];
        end
        
        textln1=['Long:  ',num2str(long),'\circ   Lat: ',num2str(lat),'\circ'];
        %%%	textln1=strcat(textln1, '   Depth:   ', num2str(abs(depth)), ' m' );
        textln1=strcat(textln1, '   Depth:   ', depth, ' m' );
        textln2=['Total Obs : ',num2str(num_obsORIG)];
        
        if(iceflag==1)
            textln2=['Total Obs / Total Ice : ',num2str(num_obsORIG),' / ',num2str(num_iceobs)];
        end
        
        textlnT=[{date_string};{textln1};{textln2}];
        text(.5,.905,textlnT,'fontsize',12,'color','blue','horizontalalignment','center');
        set(ah_text,'handlevisibility','off','visible','off')			%close axis. No more writing to axis!
        
        if(iceflag==1)
            ha9=axes('position',[0.25, 0.5, 0.5, 0.5]);
            text(.5, .001,'ICE COVERED FOR DATA SET', 'fontsize',14,'color','blue', 'horizontalalignment','center','fontweight','bold');
            set(ha9,'handlevisibility','off','visible','off')			%close axis. No more writing to axis!
        end
        
    end
    
    
    %%% watermark %%%
    ha=gca;
    uistack(ha,'bottom');
    ha2=axes('position',[0.1, 0.015, .1,.04,]);  %xpos  ypos  xlen  ylen
    %     [x, map]=imread('D:/Inetpub/wwwroot/wis/thumbs/ERDClogo.png');
    %     image(x)
    %     colormap (map)
    set(ha2,'handlevisibility','off','visible','off') 			%close axis. No more writing to axis!
    
    ha3=axes('position',[0.25, 0.015, 0.5, 0.04]);  %xpos  ypos  xlen  ylen
    text(0.005,0.5,'US Army Engineer Research & Development Center');
    
    %str=datestr(now);
    %    text(0.90,0.5,str(1:11),'FontSize',8);
    text(0.90,0.5,filein,'FontSize',8,'interpret','none');
    set(ha3,'handlevisibility','off','visible','off')			%close axis. No more writing to axis!
    
    %
    
    
    %fout = sprintf('%s%s_%s_%s_%s','/mnt/CHL_WIS_1/CliffsProducts/Tyler/new_out/ST',stnm,typef,yearchr,mntchr);
    fout = ['/mnt/CHL_WIS_1/CliffsProducts/Tyler/new_out/ST',stnm,'_',typef,'_',yearchr,'_',mntchr];
    % fout = sprintf('%s%s_%s_%s_%s','D:/Inetpub/wwwroot/wis/matlab/output/ST',stnm,typef,yearchr,mntchr);
    % %if(yrflag == 9999)
    % if pltflag == 4
    %    fout = sprintf('%s%s_%s_%s','D:/Inetpub/wwwroot/wis/matlab/output/ST',stnm,typef,'allyrs');
    % end;
   print('-dpng', '-r400', fout);
   clf 
    
end


close('all');
return;

