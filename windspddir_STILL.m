function windspddir_STILL(xlonw,xlone,xlats,xlatn,res_in,pars,storm,track,field,MAXVAL)
%   INPUT:
%   -----
%           1.  xlonw       = NUMERIC       west longitude (deg W)
%           2.  xlone       = NUMERIC       east longitude (deg W)
%           3.  xlats       = NUMERIC       southern latitude (deg N)
%           4.  xlatn       = NUMERIC       northern latitude (deg N)
%           5.  res_in         = NUMERIC       grid resolution (IN MINUTES)
%           6.  storm       = CHARACTER     Name for COASTLINE FILE
%           7.  track       = CHARACTER     e.g. A93E  OFCL Used for titles
%           8.  MAXVAL      = NUMERIC       maximum expected value.
%
mstr='JanFebMarAprMayJunJulAugSepOctNovDec';
set(gcf,'Color',[1,1,1])
resd = res_in / 60.;
x=xlonw:resd:xlone;
y=xlats:resd:xlatn;
nx = length(x);
ny = length(y);

domain='Basin';
project_in='mercator';
if field == 's'
  wavstr='s';
  dirstr='t';
  titl2b='Wind Spd and Dir';
  filnmm='WSWD';
end
if field == 'b'
    wavstr='b'
    titl2b='Barom Pressure';
    filnmm='SLPP';
end

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
%
%  Date in
%
load stills_date.dat
ntot = length(stills_date);
for m=1:ntot
dmnt=stills_date(m);

wwav=[wavstr,int2str(dmnt)];
FILE1=fopen(wwav,'r');
WHGT=fscanf(FILE1,'%10f',[nx,ny]);
fclose(FILE1);
whgt2=flipud(WHGT');
if wavstr == 's'
wdir=[dirstr,int2str(dmnt)];
file3=fopen(wdir,'r');
vmwdir=fscanf(file3,'%10f',[nx,ny]);
fclose(file3);
end
%
titlnam2=[storm,' ',track,' ',domain,'  (Res ',num2str(resd),'  \circ )'];
titlnam2b=[titl2b,'  at DATE:  ',int2str(dmnt)];
titlnamt=[{titlnam2};{titlnam2b}];
if wavstr == 's'
disp(['MAXWS:', num2str(ceil(max(max(whgt2))))]); %debug feature --njw 16 Feb 2004
intrv=ceil(MAXVAL)/50;
v=[0:intrv:ceil(MAXVAL)];
custerC=[0 0 0];
in=whgt2==0;
vmwdir2=flipud(vmwdir');
rad2deg = pi / 180.;
%
[vc,uc]=pol2cart(rad2deg*vmwdir2,1);
[X,Y]=meshgrid(x,y);
i1=mod(1:length(x),pars)==0;
i2=mod(1:length(y),pars)==0;
[I1,I2]=meshgrid(i1,i2);
in2=~in & I1 &I2;
else
MINVAL=floor(min(min(whgt2)));
MAXVAL=ceil(max(max(whgt2)));
intrv=ceil(MAXVAL-MINVAL)/50;
disp(['MIN BARO PRESS:  ', num2str(floor(min(min(whgt2))))]); %debug feature --njw 16 Feb 2004
if intrv < 2.5
    intrv == 2.5;
end
v=[MINVAL:intrv:MAXVAL]; 
end
%
m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
m_patch(shr_x,shr_y,[.0 .5 .0]);
m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
hcst=findobj(gca,'Tag','m_gshhs_f');
set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in','fontweight','bold');
hold on
%
m_contour(x,y,whgt2,v,'LineWidth',1);
if wavstr == 's'
set(gca,'Clim',[0.,ceil(MAXVAL)]);
else
  set(gca,'Clim',[floor(MINVAL),MAXVAL]); 
end

m_grid('box','fancy','tickdir','in','fontweight','bold');
xlabel('Longitude','fontweight','bold')
ylabel('Latitude','fontweight','bold')
title(titlnamt,'fontweight','bold')
hcolmax=colorbar('horizontal');
if wavstr == 's' 
set(hcolmax,'xtick',0:2:ceil(MAXVAL));
colposit = [.275 .05 .45 .03];
set(hcolmax,'Position',colposit);
hold on
hq=m_quiver(X(in2),Y(in2),uc(in2),vc(in2),0.5);
set(hq,'color',custerC);
else
set(hcolmax,'xtick',floor(MINVAL):2.5:MAXVAL);
colposit = [.275 .05 .45 .03];
set(hcolmax,'Position',colposit);
end
pos=get(gcf,'Position');
pos(3:4)=[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
%
fileout1=[filnmm,'_CFSR_',int2str(dmnt)];
eval(['print -dpng -r600 ',fileout1]); 
clf
end

