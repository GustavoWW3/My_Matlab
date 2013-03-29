clear all
% Find Lake St. Clair buoy locations in CFSR winds
xlonw = -83.00;
xlone = -82.35;
xlats = 42.25;
xlatn = 42.75;
resd = 0.02;
pars = 1;
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

files = dir('STORM*CFSR*.WND');
%files = dir('STORM*NN.win');
for zz = 1:size(files,1)
    filename = getfield(files(zz),'name');

fid = fopen(filename,'r');
data = fgetl(fid);
time1 = str2num(data(56:65));
time2 = str2num(data(71:80));
dt = num2str(time2 - time1);
nt = str2num(dt(1:2))*24+1;
data = fgetl(fid);

ly = str2num(data(7:9));
lx = str2num(data(17:19));
dy = str2num(data(23:28));
dx = str2num(data(32:37));
lats = str2num(data(44:51));
lonw = str2num(data(58:65));
time = data(69:80)

for kk = 1:1000
    nn = kk;
    for jj = 1:ly
        temp1 = fscanf(fid,'%f',lx);
        lsc_u(jj,:) = temp1 ;
    end
    for jj = 1:ly
        temp2 = fscanf(fid,'%f',lx);
        lsc_v(jj,:) = temp2;
    end
   lsc{kk,zz} = struct('t',time,'u',lsc_u,'v',lsc_v);
%     lsc{kk} = struct('t',time,'p',lsc_u);
    data = fgetl(fid);
    data = fgetl(fid);
    if data ~= -1
    time = data(69:80)
    else
        break
    end
end
fclose(fid);
end

x(:,1)=xlonw:resd:xlone;
x2(:,1) = xlonw:0.02:xlone+0.02;
y(:,1)=xlats:resd:xlatn;
y2(:,1) = xlats:0.02:xlatn;
% for jj = 1:size(lsc,1)
%     ii = find(lsc{jj,1}.t == '198510051400');
% end
% aviobj = avifile('CFSR_contquiv.avi','compression','None');
%for ii = 120:140
ii = 135 
wmag = sqrt(lsc{ii,2}.u.^2 + lsc{ii,2}.v.^2);
    wdir = (1.0*atan2(-lsc{ii,2}.u,1.0*lsc{ii,2}.v))*180/pi;
    vv = find(wdir < 0);
    wdir(vv) = wdir(vv) + 360;
    MINVAL=floor(min(min(wmag)));
    MAXVAL=ceil(max(max(wmag)));
    intrv=ceil(MAXVAL-MINVAL)/50;
    if intrv < 2.5
    intrv == 2.5;
    end
    v=[MINVAL:intrv:MAXVAL]; 
    
    intrv_d=ceil(MAXVAL)/50;
    vd=[0:intrv_d:ceil(MAXVAL)];
    custerC=[0 0 0];
    %in=wmag==0;
    [X2,Y2] = meshgrid(x2,y2);
    %wdir2 = griddata(x,y,wdir,X2,Y2);
    %wmag2 = griddata(x,y,wmag,X2,Y2);
    wdir2 = wdir;
    wmag2 = wmag;
    in=wmag2==0;
    vmwdir2=flipud(wdir2');
    rad2deg = pi / 180.;
%
    
    [vc,uc]=pol2cart(rad2deg*vmwdir2,1);
    [X,Y]=meshgrid(x2,y2);
    i1=mod(1:length(x2),pars)==0;
    i2=mod(1:length(y2),pars)==0;
    [I1,I2]=meshgrid(i1,i2);
    in2=~in & I1 &I2;
    
    figure(1)
    m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
    m_patch(shr_x,shr_y,[.0 .5 .0]);
    m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
    hcst=findobj(gca,'Tag','m_gshhs_f');
    set(hcst,'HandleVisibility','off');
    m_grid('box','fancy','tickdir','in','fontweight','bold','fontsize',8);
    hold on
    
    m_contour(x2,y2,wmag2,v)
    
    hq=m_quiver(X(:),Y(:),uc(:),vc(:),0.5,'k');
    %text(0.55,0.93,lsc{ii,2}.t,'BackgroundColor','w')
   
    xlabel('Longitude','FontWeight','bold')
    ylabel('Latitude','FontWeight','bold')
    tit1 = ['Lake St. Clair 1985 Study Winds (CFSR)'];
    tit2 = ['  Date: ',lsc{ii,2}.t];
    titt = [{tit1;tit2}];
    title(titt,'FontWeight','bold')
    set(gca,'Position',[0.13 0.17 0.775 0.725]);
    colposit = [0.2982 0.038 0.4500 0.0300];
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit)
    %textcolbr=[titlefld1,'  [',unts,']'];
    hcbtxt=text(0.44,-.116,'U_{10} (m/s)','FontWeight','bold','FontSize',8,'units','normalized');
    
    pos=get(gcf,'Position');
    pos(3:4)=[649,664];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
    print(gcf,'-dpng','-r600','STCL_wind_quiv_CFSR')
%     F = getframe(gcf);
%    aviobj = addframe(aviobj,F);
    clf
%end
%aviobj = close(aviobj);