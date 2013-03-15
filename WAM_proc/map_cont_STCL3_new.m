function map_cont_STCL3_new(pars,ice_coverin,storm,...
    track,modelnm)
%
%
%  This is a generic contouring routine that generates movie loops
%   from MAP files built by WAM.
%
%   INPUT:
%   -----
%           1.  xlonw       = NUMERIC       west longitude (deg W)
%           2.  xlone       = NUMERIC       east longitude (deg W)
%           3.  xlats       = NUMERIC       southern latitude (deg N)
%           4.  xlatn       = NUMERIC       northern latitude (deg N)
%           5.  res         = NUMERIC       grid resolution (IN MINUTES)
%           6.  pars        = NUMERIC       Sampling of vectors
%                                           (= 0 for NO vectors)
%           7.  ice_coverin   = CHARACTER     For Ice Coverage REQUIRES
%                                                3  CHARACTERS
%                                           000: for NO Ice Coverage
%                                           NUMERICAL VALUE (Percentage
%                                           setting water to land  and
%                                           Canadian Ice Data Base i.e. 70C)
%           8.  storm       = CHARACTER     Hurricane Storm Name (alpha, use single quotes)
%           9.  track       = CHARACTER     e.g. A93E  OFCL [OUTPUT FILES]
%          10.  modelnm     = CHARACTER     e.g. OWI-NRAQ, WAVEWATCH III
%          11.  field       = CHARACTER     field identifier
%                                               Used to set the range for plotting,
%                                                   Titles, and legends
%                                               w = wave height
%                                               p = peak period
%                                               s = wind speed
%                                               c = drag coeficient
%                                               a = wind-sea wave height
%                                               l = swell wave height
%
%   REQUIREMENTS:
%   ------------
%           1.  Requires an input file containing the dates "mapcont.dat"
%           2.  The full shoreline(s) files from the data base.
%
%
%
%
clf;
set(gcf,'Color',[1,1,1])
%
FILE1=fopen('Max_mean.dat','r');
data = fscanf(FILE1,'%f',8);
res = data(3);
xlats = data(5);
xlatn = data(6);
xlonw = data(7);
xlone = data(8);
TIME1 = num2str(data(1));
TIME2 = num2str(data(2));
date = [TIME1(1:end-2),' - ',TIME2(1:end-2)];

resd = res ;
x=xlonw:resd:xlone;
y=xlats:resd:xlatn;
[xx,yy]=meshgrid(x,y);

nx = length(x);
ny = length(y);
domain='Basin';
%
%  Split the input ice cover into 2 parts
%
ice_cover=str2double(ice_coverin(1:2));
ice_flg=ice_coverin(3:3);
ice_flg2(1:3) = 'CIS';
if ice_flg == 'N'
    ice_flg2(1:3) = 'NIC';
end
%
%
colposit = [0.2982 0.038 0.4500 0.0300];
legboxx=0.55;legboxy=0.93;
project_in = 'mercator';
custerC=[1.,1.,1.];
%
fieldname{1} ='Maximum Total   Height H_{mo} ';
displname{1} ='H_{total}  ';
filename{1} ='HMOTOT';
fieldname{2} ='Mean Total   Height H_{mo} ';
displname{2} ='H_{total}  ';
filename{2} ='HMOTOT';

fieldname{3} ='Maximum Total   Period T_{m}  ';
displname{3} ='T_{total}  ';
filename{3} ='TMMTOT';
fieldname{4} ='Mean Total   Period T_{m}  ';
displname{4} ='T_{total}  ';
filename{4} ='TMMTOT';

fieldname{5} ='Maximum Wind-Sea   Height H_{mo} ';
displname{5} ='H_{sea}  ';
filename{5} ='HMOSEA';
fieldname{6} ='Mean Wind-Sea   Height H_{mo} ';
displname{6} ='H_{sea}  ';
filename{6} ='HMOSEA';

fieldname{7} ='Maximum Wind-Sea   Period T_{m}  ';
displname{7} ='T_{sea}  ';
filename{7} ='TMMSEA';
fieldname{8} ='Mean Wind-Sea   Period T_{m}  ';
displname{8} ='T_{sea}  ';
filename{8} ='TMMSEA';

fieldname{9} ='Maximum Swell   Height H_{mo} ';
displname{9} ='H_{swell} ';
filename{9} ='HMOSWL';
fieldname{10} ='Mean Swell   Height H_{mo} ';
displname{10} ='H_{swell} ';
filename{10} ='HMOSWL';

fieldname{11} ='Maximum Swell   Period T_{m}  ';
displname{11} ='T_{swell} ';
filename{11} ='TMMSWL';
fieldname{12} ='Mean Swell   Period T_{m}  ';
displname{12} ='T_{swell} ';
filename{12} ='TMMSWL';

fieldname{13} ='Maximum Wind   U_{10}  ';
displname{13} ='U_{10} ';
filename{13} = 'WNDTOT';
fieldname{14} ='Mean Wind   U_{10}  ';
displname{14} ='U_{10} ';
filename{14} = 'WNDTOT';

% if ice_coverin(3:3) == 'C' || ice_coverin(3:3) == 'N';
%     ice_date=int2str(TIME(:,2));
% end
 startdate=TIME1;
 enddate=TIME2;
xlonwp=xlonw;
xlonep=xlone;
xlatsp=xlats;
xlatnp=xlatn;

long = [xlonw xlonw xlone xlone];
latg = [xlats xlatn xlatn xlats];
%
units = {'m';'m';'s';'s';'m';'m';'s';'s';'m';'m';'s';'s';'m/s';'m/s'};
for zz = 1:14
    
    field=fscanf(FILE1,'%10f',[nx,ny]);
    FIELD=flipud(field');
    maxfld=max(max(FIELD));
    [kmaxpt,kmaxpty]=find(FIELD == maxfld);

    titlefld1= fieldname{zz};
    titlefld2= displname{zz};
    titfile=filename{zz};
    unts = units{zz};
    if mod(zz,2) == 0
        mm = '-MEAN';
    else
        mm = '-MAX';
    end
    %
    %  Generate Mean Field Matrix

%
%  Plot up the Maximum Wave Heights for the given time period
%
dmnt=str2double(TIME1);
yrmnt=int2str(floor(dmnt/100000000));
YRMNT=floor((dmnt/100000000));
mtst=3*rem(YRMNT,100)-2;
yrr=floor(YRMNT/100);

% Storm Output only 1 Ice Field Mean Monthly
%
monchk=YRMNT-100*yrr;
if monchk <= 9
    mntchar=['0',int2str(monchk)];
else
    mntchar=int2str(monchk);
end
%
%  Setting up the file name and movie titles
%
fileout1=[titfile,'-',modelnm,track,'-',storm,mm]
titlnam1A=[modelnm,' ',storm,'  (Res ',num2str(resd),'\circ',...
    ' )'];
titlnam1B=['  ',titlefld1,'  RESULTS:   ',track];
titlnam1=[{titlnam1A};{titlnam1B}];
    

    RANGMM=maxfld;
    
    disp([titlefld1,'  ',num2str(RANGMM)]);
    interv=0.005*RANGMM;
    %v=[-1:interv/2:RANGMM];
    v = [-1,0:interv:RANGMM];
    nummax=length(kmaxpt);
    %
    load cmap.mat
    colormap(cmap)
    
    for jj = 1:nx
        ll = find(FIELD(:,jj) < v(7) & FIELD(:,jj) > v(1));
        FIELD(ll,jj) = v(7);
    end
    %
    % find where wave heights are zero to not plot the wave
    %  direction vectors.
    %
     in=FIELD==0;
    %  Open and read Overall VECTOR MEAN WAVE DIRECTION files
    %   Note that the WAM directional output is Oceanographic
    %   "Toward which" where 0 is to the north.
    %                   thus translating the u and v component
    %                   below in pol2cart routine.
    %
    if pars > 0
        wdir=[dirstr,int2str(TIME(kk))];
        FILE2=fopen(wdir,'r');
        vmwdir=fscanf(FILE2,'%10f',[nx,ny]);
        vmwdir2=flipud(vmwdir');
        rad2deg = pi / 180.;
        %
        [vc,uc]=pol2cart(rad2deg*vmwdir2,1);
        %
        %  Set Up for Plotting every 1.0 deg
        %
        [X,Y]=meshgrid(x,y);
        i1=mod(1:length(x),pars)==0;
        i2=mod(1:length(y),pars)==0;
        [I1,I2]=meshgrid(i1,i2);
        in2=~in & I1 &I2;
        fclose(FILE2);
    end
    %

    load_coast
    m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);

    [CMCF,hh]=m_contourf(x,y,FIELD,v);
    hold on
    caxis([0,RANGMM]);
    set(hh,'EdgeColor','none');
    nco = size(lon_coast,2);

    set(gca,'Position',[0.13 0.17 0.775 0.725]);
    xlabel('Longitude','FontWeight','bold')
    ylabel('Latitude','FontWeight','bold')
    m_grid('box','fancy','tickdir','in','FontWeight','Bold');
    hcc=get(gca,'children');
    tags=get(hcc,'Tag');
    k=strmatch('m_grid',tags);
    hgrd=hcc(k);
    hp=findobj(gca,'Tag','m_grid_color');
    set(hp,'Visible','off');
    set(hgrd,'HandleVisibility','off');
    %  Plot the max condition in the map
    %
%     for ii = 1:size(kmaxpt,1)
%     m_plot(xx(kmaxpt(ii),kmaxpty(ii)),yy(kmaxpt(ii),kmaxpty(ii)),'.','Color',[1,1,1],'MarkerSize',12);
%     end
    xlocmax = xx(kmaxpt(1),kmaxpty(1))-360;
    deg4lon=' \circ W / ';
    if xlocmax < -180;
        xlocmax = xlocmax + 360;
        if xlocmax > 0
            deg4lon=' \circ E / ';
        else
            deg4lon=' \circ W / ';
        end
    end
    %  Plot the Vectors
    %
    if pars > 0
        hq=m_quiver(X(in2),Y(in2),uc(in2),vc(in2),0.5);
        set(hq,'color',custerC);
    end
    %
    %  Setting of the Text for max, location and dates of simulation
    %
    textstg1=[titlefld2,sprintf('%5.2f',maxfld),' [',unts,']'];
    textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
        num2str(yy(kmaxpt(1),kmaxpty(1))),'\circ N'];
    textstg3=['DATE: ',date];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    %
    %  Plot the ice when applicable
%     %
    if ice_cover > 0
        %ice_file=['ICEFLD-',track,'.CUM'];
        ice_file = ['ICEFLD-',track(1:6),'.CUM'];
        [sLong sLat zero7] = textread(ice_file,'%f%f%f');
        ice=find(zero7 == 1);
        m_plot(sLong(ice),sLat(ice),'s','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8],'MarkerSize',4);
%         ice_type(kk,1) = ice_date(kk,end);
%         if ice_type(kk,1) == '0'
%             ice_ch='NODATA';
%         elseif ice_type(kk,1) == '1'
%             ice_ch='INTERP';
%         else
%             ice_ch=' DATA ';
%         end
        textstg4=['ICE Conc (',ice_flg2,'):  ',num2str(ice_cover), '%  '];
        textstrt=[{textstg1};{textstg2};{textstg3};{textstg4}];
    end
    %
    for ii = 1:nco
        m_plot(lon_coast{ii},lat_coast{ii},'y','LineWidth',1);
    end
    %  Colorbar
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit,'FontSize',8)
    textcolbr=[titlefld1,'  [',unts,']'];
    text(0.34,-.116,textcolbr,'FontWeight','bold','FontSize',8,'units','normalized');
    title(titlnam1,'FontWeight','bold');
    %text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
    %
    
    pos=get(gcf,'Position');
    pos(3:4)=[649,664];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
    %
    eval(['print -dpng -r600 ',fileout1]);
    clf
    clear CMCF hh kmaxpt kmaxpty maxfld;

%   
end
fclose(FILE1);
end


    

