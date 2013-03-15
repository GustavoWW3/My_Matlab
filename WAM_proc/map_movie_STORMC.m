function map_movie(xlonw,xlone,xlats,xlatn,res,pars,leg_loc,unitflag,storm,track,domain,project_in,field,hurrname)
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
%           6.  pars        = NUMERIC       subsample for wave direction
%                                           vectors
%                                           0 = no vectors to be plotted
%                                           N = subsampling interval
%           7.  leg_loc     = NUMERIC       Location of the legend box
%                                           1 = lower left corner
%                                           2 = upper left corner
%                                           3 = upper right corner
%                                           4 = lower right corner
%           8.  unitflag    = NUMERIC       1 = meters (MGS)
%                                           2 = feet (FPS)
%           7.  storm       = CHARACTER     Hurricane Storm Name (alpha, use single quotes)
%           8.  track       = CHARACTER     e.g. A93E  OFCL [OUTPUT FILES]
%           9.  domain      = CHARACTER     e.g. basin, region ...
%                                           [FOR DATE FILE INPUT]
%           10.  project_in  = CHARACTER     map projection
%           11. field       = CHARACTER     field identifier
%                                               Used to set the range for plotting,
%                                                   Titles, and legends
%                                               w = wave height
%                                                   and d = vector mean
%                                                   wave direction
%                                               s = wind speed
%                                                   and t = wind direction
%
%
%   REQUIREMENTS:
%   ------------
%           1.  Requires an input file containing the dates "mapcont.dat"
%           2.  The full shoreline(s) files from the data base.
%
%
%
%
set(gcf,'Color',[1,1,1])
%
resd = res / 60.;
x=xlonw:resd:xlone;
y=xlats:resd:xlatn;
nx = length(x);
ny = length(y);
xlim=[min(x),max(x)];
ylim=[min(y),max(y)];
%
%  COLOR BAR POSITION VARIABLE BASED ON THE DOMAIN TO BE PLOTTED.
%
colposit = [0.2982 0.110 0.4500 0.0300];
colpositm=[0.2982 0.110 0.4500 0.0300];

%
%  LEGEND BOX LOCATION  5 is the special one.
%
if leg_loc == 1
    legboxx=.025;legboxy=0.15;
elseif leg_loc == 2
    legboxx=0.0125;legboxy=0.925;
elseif leg_loc == 3
    legboxx=0.66;legboxy=0.85;
elseif leg_loc == 4
    legboxx=0.66;legboxy=0.15;
elseif leg_loc == 5
    legboxx=0.025;legboxy=0.65;
end
%
%

if field == 'c'
    wavstr='c';
    dirstr='d';
    titlefld1='              TOTAL H_{mo}';
    titlefld2='H_{tot}:  ';
    titfile='HMO';
    if unitflag == 1
        unts='m';
        RS=1.0;
    else
        unts='ft';
        RS=3.28;
    end
end
if field == 's'
    wavstr='s';
    dirstr='t';
    titlefld1='              WIND SPEED';
    titlefld2='U_{10}:  ';
    titfile='WSS';
    if unitflag == 1
        unts='m/s';
        RS=1.0;
    else
        unts='kt';
        RS=1.944;
    end
end
%
%  Load in the Special colormap colors for contouring
%
load cmap.mat
colormap(cmap)
%
%  Load in the List of dates to generate the wave and direction file names.
%
eval(['load mapcont_',domain,'.dat']);
eval(['TIME = mapcont_',domain,';'])
eval(['clear mapcont_',domain,';'])
mapcont=sort(TIME);
startdate=int2str(floor(min(mapcont)));
enddate=int2str(ceil(max(mapcont)));
%
%
kkk=length(mapcont);
MAXHGT=0.;
MINHGT=0.;
maxhgtmt(nx,ny)=0;
minhgtmt(nx,ny)=0;
min_maxhgt(nx,ny)=0;
for kk=1:kkk
    wwav=[wavstr,int2str(mapcont(kk))];
    FILE1=fopen(wwav,'r');
    WHGT=fscanf(FILE1,'%10f',[nx,ny]);
    WHGT = RS*WHGT;
    maxhtc=max(max(abs(WHGT)));
    MAXHGT = max(maxhtc,MAXHGT);
    maxhgtmt = max(maxhgtmt,WHGT);
    minhtc= min(min(WHGT));
    MINHGT = min(minhtc,MINHGT);
    minhgtmt = min(minhgtmt,WHGT);
    fclose(FILE1);
end
%
min_maxhgt=max(abs(maxhgtmt),abs(minhgtmt));
min_maxhgt=min_maxhgt.*sign(minhgtmt+maxhgtmt);
%
%  Plot up the Maximum Wave Heights for the given time period
%
min_maxhgt=flipud(min_maxhgt');
dmnt=mapcont(1);
%
%  Setting up the file name and movie titles
%
fileout1=[titfile,domain,track,storm,'_',hurrname];
if pars == 0
    movflnam=['WAM_',storm,'_',track,domain,'_',titfile,'_',int2str(pars),'_',unts,'_01.avi'];
end
if pars > 0
    movflnam=['WAM_',storm,'_',track,domain,'_',titfile,'_',int2str(pars),'_',int2str(pars),'_',unts,'.avi'];
end
%
titlnam1A=['WAM4.5.2 ',storm,' ',domain,'  (Res ',num2str(resd),'\circ',...
    ' )  TEST CASE:  ',  track];
titlnam1B=['  MAXIMUM ',titlefld1,'  RESULTS:   ',hurrname];
titlnam1Bm=[titlefld1,'  RESULTS:   ',hurrname];
titlnam1=[{titlnam1A};{titlnam1B}];
titlnam1m=[{titlnam1A};{titlnam1Bm}];

%
%  add third variable v = contour levels rather than automatically
%   setting the number of contours based on maximum....
%
%
xx_MM=range(min_maxhgt);
MAXMINHT=xx_MM(2);
if abs(xx_MM(1)) > xx_MM(2)
    MAXMINHT=xx_MM(1);
end
RANGMM=abs(MAXMINHT);
%
disp([titlefld1, num2str(ceil(RANGMM))]); %debug feature --njw 16 Feb 2004
%
%  Find the location of the overall maximum wave height
%  NEED TO FLIP THE JJ since the matrix is coming in from North to South
%
[ii,j1]=find(MAXHGT == maxhgtmt);
jj= ny - j1 + 1;
nummax=length(ii);
%
interv=0.01*RANGMM;
if field == 's'
    interv=0.02*RANGMM;
end
v=[0:interv:RANGMM];
custerC=[1.,1.,1.];
%
m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
if domain(1) == 'B'
  m_gshhs_c('patch',[.0 .5 .0],'edgecolor','k');
  hcst=findobj(gca,'Tag','m_gshhs_c');
end
if domain(1) == 'R'
  m_gshhs_h('patch',[.0 .5 .0],'edgecolor','k');
  hcst=findobj(gca,'Tag','m_gshhs_h');
  colposit = [0.2982 0.035 0.4500 0.0300];
  colpositm=[0.2982 0.035 0.4500 0.0300];
end
set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in');
colormap(cmap)
hold on
%
%  Wave Height Contouring.
%
m_contour(x,y,min_maxhgt,50);
caxis([0,RANGMM]);
m_plot(x(ii),y(jj),'k.','MarkerSize',12);
%
%  Setting of the Text for max, location and dates of simulation
%
textstg1=[titlefld2,num2str(sprintf('%5.1f',MAXMINHT)),' [',unts,']'];
textstg2=['LOC:  ' ,num2str(sprintf('%7.2f',x(ii(1)))),'\circ W / ',...
    num2str(sprintf('%7.2f',y(jj(1)))),'\circ N'];
textstg3=['DAT:  ',startdate(1:10),' - ',enddate(1:10)];
textstrt=[{textstg1};{textstg2};{textstg3}];
%
%  Colorbar
hcolmax=colorbar('horizontal');
set(hcolmax,'Position',colposit)
textcolbr=[titlefld1,'  [',unts,']'];
if domain(1) == 'B'
hcbtxt=text(0.3,-.25,textcolbr,'FontWeight','bold','units','normalized');
end
title(titlnam1,'FontWeight','bold');
%
%  Generate the legend containing the Max Wave Height Location
%
text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
%
pos=get(gcf,'Position');
pos(3:4)=0.85*[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
%eval(['print -dpng -r600 ',fileout1]);
clear H;
clf
%
m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
set(gca,'NextPlot','add');

if domain(1) == 'B'
  m_gshhs_c('patch',[.0 .5 .0],'edgecolor','k');
  hcst=findobj(gca,'Tag','m_gshhs_c');
end
if domain(1) == 'R'
  m_gshhs_h('patch',[.0 .5 .0],'edgecolor','k');
  hcst=findobj(gca,'Tag','m_gshhs_h');
end


set(hcst,'HandleVisibility','off');

m_grid('box','fancy','tickdir','in','fontweight','bold');
hcc=get(gca,'children');
tags=get(hcc,'Tag');
k=strmatch('m_grid',tags);
hgrd=hcc(k);
hp=findobj(gca,'Tag','m_grid_color');
set(hp,'Visible','off');
set(hgrd,'HandleVisibility','off');
%
%  Setting the colormap range and the colorbar
%
whitezero2(0);
caxis([0,RANGMM]);
%hcol=colorbar('horizontal');
%set(hcol,'Position',colposit)
%
%
pos=get(gcf,'Position');
pos(3:4)=0.85*[648,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
%
kkk = 5;
for kk=1:kkk
    wwav1=[wavstr,int2str(mapcont(kk))];
    wdir=[dirstr,int2str(mapcont(kk))];
    date=wwav1(2:14);
    file2=fopen(wwav1,'r');
    whgt=fscanf(file2,'%10f',[nx,ny]);
    whgt2=RS*flipud(whgt');
    whgt2MAX=max(max(whgt2));
    %
    %  Note that the matrix is inverted and flipped
    %
    [jj,ii]=find(whgt2MAX == whgt2);
    %
    %
    %
    % find where wave heights are zero to use as a mask
    % when plotting wind speeds so there are no wind speeds
    %showing over land.
    %
    in=whgt2==0;
    %
    %
    %
    %  Open and read Overall VECTOR MEAN WAVE DIRECTION files
    %   Note that the WAM directional output is Oceanographic
    %   "Toward which" where 0 is to the north.
    %                   thus translating the u and v component
    %                   below in pol2cart routine.
    %
    if pars > 0
        file3=fopen(wdir,'r');
        vmwdir=fscanf(file3,'%10f',[nx,ny]);
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
    end
    %
    %  Contour the waves
    %  Then coast
    %
    cla
    [CMCF,hh]=m_contourf(x,y,whgt2,v);
    caxis([0.,RANGMM]);
    set(hh,'EdgeColor','none');
    %
    %   keep coast and grid on top
    %
    hc=get(gca,'children');
    hc = [hgrd;hcst;hc];
    set(gca,'children',hc);
    title(titlnam1m,'FontWeight','bold');
    %
    %  Set Text Box and INFORMATION
    %
    textstg1=[titlefld2,num2str(sprintf('%5.1f',whgt2MAX)),' [',unts,']'];
    textstg2=['LOC :  ' ,num2str(sprintf('%7.2f',x(ii(1)))),'\circ W / ',...
        num2str(sprintf('%7.2f',y(jj(1)))),'\circ N'];
    textstg3=['DATE:  ',num2str(date)];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',9,'units','normalized','BackgroundColor','w');
    %
    %  Set Colorbar position and legend
    %
    hcol=colorbar('horizontal');
    set(hcol,'Position',colpositm)
    textcolbr=[titlefld1,'  [',unts,']'];
    hcbtxt=text(0.3,-.2,textcolbr,'FontWeight','bold','units','normalized');
   
    title(titlnam1m,'FontWeight','bold');

    %
    %  Plot the MAX HEIGHT
    %
    m_plot(x(ii),y(jj),'k.','MarkerSize',12);
    %
    %  Plot the Vectors
    %
    if pars > 0
        hq=m_quiver(X(in2),Y(in2),uc(in2),vc(in2),0.5);
        set(hq,'color',custerC);
    end
    %
    %  Put In the Movie Generator
    %
    if kk==1,
        set(1,'Position',[50 75 pos(3) pos(4)]);  %modified by njw 4 Feb 2004
        haviobj=avifile(movflnam,...
            'colormap',cmap,...
            'compression','Indeo5',...
            'quality',100,...
            'fps',4);
            end
%         F=getframe(gcf);
        haviobj=addframe(haviobj,1);
        fclose(file2);
        if pars > 0
            fclose(file3);
        end
    end
    haviobj=close(haviobj);
    clf;
    close