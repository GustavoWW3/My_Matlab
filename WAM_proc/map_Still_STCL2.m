function map_Still_STCL2(xlonw,xlone,xlats,xlatn,res,pars,ice_coverin,storm,...
    track,modelnm,field)
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
resd = res / 60.;
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
%
%  WIND SPEED PREFIX
%
if field == 'c'
    wavstr='c';
    dirstr='d';
    titlefld1='       Total      Height H_{mo}';
    titlefld2='H_{total}  ';
    titfile='HMOFLD';
    unts = 'm';
end
if field == 'a'
    wavstr='a';
    titlefld1='       Wind-Sea    Height H_{mo}';
    titlefld2='H_{sea} :  ';
    titfile='HSEFLD';
    unts = 'm';
end
if field == 'm'
    wavstr='m';
    titlefld1='       Swell      Height H_{mo}';
    titlefld2='H_{swell} :  ';
    titfile='HSWFLD';
    unts = 'm';
end
if field == 's'
    wavstr='s';
    titlefld1='        Wind Speed     U_{10}';
    titlefld2='U_{10}  ';
    titfile='WSDFLD';
    unts = 'm/s';
end
if field == 'r'
    wavstr='r';
    titlefld1='     Total: Mean Period T_{mean}';
    titlefld2='T_{mean}  ';
    titfile='TMMFLD';
    unts = 's';
end
%
%
%
%  Load in the List of dates to generate the wave and direction file names.
%  NOTE:  For Ice Coverage there are two dates to read
%eval(['load mapcont_',domain,'.dat']);
fin = ['mapcont_',domain,'.dat'];
[aa] = importdata(fin);
for pp = 1:size(aa,1)
  TIME(pp,1) = str2num(aa{pp}(2:end));
end
%eval(['TIME = mapcont_',domain,';'])
%eval(['clear mapcont_',domain,';'])
if ice_coverin(3:3) == 'C' || ice_coverin(3:3) == 'N';
    ice_date=int2str(TIME(:,2));
end
xlonwp=xlonw;
xlonep=xlone;
xlatsp=xlats;
xlatnp=xlatn;
maxfld = 0;
kkk=length(TIME);
for kk = 1:kkk
    wwav = [wavstr,int2str(TIME(kk))];
    FILE1=fopen(wwav,'r');
    field = fscanf(FILE1,'%10f',[nx,ny]);
    FIELD=flipud(field');
    maxfld1=max(max(FIELD));
    if maxfld1 > maxfld
        maxfld = maxfld1;
    end
    %[kmaxpt]=find(FIELD == maxfld);
    date=wwav(2:end);
    fclose(FILE1);
end
%
%kkk=length(TIME);
for kk=1:kkk
    wwav=[wavstr,int2str(TIME(kk))];
    FILE1=fopen(wwav,'r');
    field=fscanf(FILE1,'%10f',[nx,ny]);
    FIELD=flipud(field');
    maxfld2=max(max(FIELD));
    [kmaxpt,kmaxpty]=find(FIELD == maxfld2);
    date=wwav(2:end);
    fclose(FILE1);
    %
    %
    %  Setting up the file name and movie titles
    %
    fileout1=[titfile,date,'_',int2str(pars)];
    titlnam1A=[modelnm,' ',storm,'-',track,'  (Res ',num2str(resd),'\circ',...
        ' )'];
    titlnam1B=['  MAXIMUM ',titlefld1,'  RESULTS:   ',date];
    titlnam1=[{titlnam1A};{titlnam1B}];
    if pars == 0
    movflnam=['WAM_',titfile,'_',storm,'_',track,'_',int2str(pars),'_',unts,'_01.avi'];
    end
    %
    RANGMM=maxfld;
    
    disp([titlefld1,'  ',num2str(maxfld2),'   Time = ',num2str(TIME(kk))]);
    interv=0.005*RANGMM;
    v=[-1,0:interv:RANGMM];
    %v = [0:interv:RANGMM];
    nummax=length(kmaxpt);
    %
    load cmap.mat
    colormap(cmap)
    %
    for jj = 1:nx
        qq = find(FIELD(:,jj) < v(10) & FIELD(:,jj) > v(1));
        FIELD(qq,jj) = v(10);
    end
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
    nco = size(lon,2);
    for ii = 1:nco
        m_plot(lon{ii},lat{ii},'y','LineWidth',1);
    end
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
    for ii = 1:size(kmaxpt,1)
    m_plot(xx(kmaxpt(ii),kmaxpty(ii)),yy(kmaxpt(ii),kmaxpty(ii)),'.','Color',[1,1,1],'MarkerSize',12);
    end
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
    textstg1=[titlefld2,sprintf('%5.2f',maxfld2),' [',unts,']'];
    textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
        num2str(yy(kmaxpt(1),kmaxpty(1))),'\circ N'];
    textstg3=['DATE: ',date];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    %
    %  Plot the ice when applicable
    %
    if ice_cover > 0
        ice_file=['I',ice_date(kk,:),ice_flg2,'.ice'];
        [lat long gpt sLat sLong Zang Depth Ice zero7] = textread(ice_file,'%f%f%f%f%f%f%f%f%f','headerlines',1);
        ice=find(zero7 == 1);
        m_plot(sLong(ice),sLat(ice),'s','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8],'MarkerSize',2);
        ice_type(kk,1) = ice_date(kk,end);
        if ice_type(kk,1) == '0'
            ice_ch='NODATA';
        elseif ice_type(kk,1) == '1'
            ice_ch='INTERP';
        else
            ice_ch=' DATA ';
        end
        textstg4=['ICE Conc (',ice_flg2,'):  ',num2str(ice_cover), '%  ',ice_ch];
        textstrt=[{textstg1};{textstg2};{textstg3};{textstg4}];
    end
    %
    %  Colorbar
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit,'FontSize',8)
    textcolbr=[titlefld1,'  [',unts,']'];
    text(0.34,-.116,textcolbr,'FontWeight','bold','FontSize',8,'units','normalized');
    title(titlnam1,'FontWeight','bold');
    text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
    %
    
    pos=get(gcf,'Position');
    pos(3:4)=[649,664];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
    %
%     if kk==1,
%       set(1,'Position',[50 75 pos(3) pos(4)]);  %modified by njw 4 Feb 2004
%       haviobj=avifile(movflnam,...
%             'colormap',cmap,...
%             'compression','Indeo5',...
%             'quality',100,...
%             'fps',4);
%     end
%          F=getframe(gcf);
%     haviobj=addframe(haviobj,F);
%     %fclose(file2);
%     if pars > 0
%        fclose(file3);
%     end
%     clf
% end
%      haviobj=close(haviobj);
     eval(['print -dpng -r600 ',fileout1]);
%     clf
     fclose('all');
     clf;
      end
 close;
