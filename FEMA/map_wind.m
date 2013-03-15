clear all
close all
gdir = uigetdir('C:\','Pick storm directory');
cd(gdir);
addpath([gdir,'\Winds\'])
fwnd = ls([gdir,'\Winds\ST*.WND']);
fpre = ls([gdir,'\Winds\ST*.PRE']);
if exist([gdir,'\Ice'],'dir');
    addpath([gdir,'\Ice\']);
    fice = ls([gdir,'\Ice\ICEFLD*.ICE']);
    fid3 = fopen(fice);
else
    fid3 = -1;
end
fid1 = fopen(fwnd);
fid2 = fopen(fpre);


fnmov=([fpre(1:6),'.avi']);
vidObj=VideoWriter(fnmov,'Motion JPEG AVI');
set(vidObj,...
  'FrameRate',4,...
  'Quality',95);
open(vidObj);
data = fgetl(fid1);
qq = 0;
while ~feof(fid1)
    qq = qq+1;
    %data = textscan(fid1,'%*5c%4f%*6c%4f%*3c%6f%*3c%6f%*6c%8f%*6c%8f%*3c%12f',1);
    data = fgetl(fid1);
    ny = str2double(data(7:9));
    nx = str2double(data(17:19));
    dy = str2double(data(23:28));
    dx = str2double(data(32:37));
    lat = str2double(data(44:51));
    lon = str2double(data(58:65));
    time = str2double(data(69:end));
%     ny = imag(data{1});
%     nx = data{2};
%     dy = data{3};
%     dx = data{4};
%     lat = data{5};
%     lon = data{6};
%     time = data{7};

    for jj = 1:ny
        data2 = fscanf(fid1,'%f',nx);
        uxx2(jj,:,qq) = data2;
    end
    for jj = 1:ny
        data2 = fscanf(fid1,'%f',nx);
        uyy2(jj,:,qq) = data2;
    end
    uwndt2 = sqrt(uxx2.^2 + uyy2.^2);
    if qq == 1
       lat1 = lat;
       lon1 = lon;
       dx1 = dx;
       dy1 = dy;
       nx1 = nx;
       ny1 = ny;
       lat2 = lat1 + ny1*dy1 - dy1;
       lon2 = lon1 + nx1*dx1 - dx1;
    end
    if ~isempty(time)
     dtime(qq) = time;
     data = fgetl(fid1);
    end
end
fclose(fid1);
[X2 Y2] = meshgrid(lon1:dx1:lon2,lat1:dy1:lat2);

clear lat1 lon1 lat2 lon2 dy1 dx1 nx1 nx2 data data2
data = fgetl(fid2);
qq = 0;
while ~feof(fid2)
    qq = qq+1;
%     data = textscan(fid2,'%*5c%4f%*6c%4f%*3c%6f%*3c%6f%*6c%8f%*6c%8f%*3c%12f',1);
%     ny = imag(data{1});
%     nx = data{2};
%     dy = data{3};
%     dx = data{4};
%     lat = data{5};
%     lon = data{6};
%     time = data{7};
    data = fgetl(fid2);
    ny = str2double(data(7:9));
    nx = str2double(data(17:19));
    dy = str2double(data(23:28));
    dx = str2double(data(32:37));
    lat = str2double(data(44:51));
    lon = str2double(data(58:65));
    time = str2double(data(69:end));
    for jj = 1:ny
        data2 = fscanf(fid2,'%f',nx);
        pre(jj,:,qq) = data2/10;
    end
    if qq == 1
       lat1 = lat;
       lon1 = lon;
       dx1 = dx;
       dy1 = dy;
       nx1 = nx;
       ny1 = ny;
       lat2 = lat1 + ny1*dy1 - dy1;
       lon2 = lon1 + nx1*dx1 - dx1;
    end
    data = fgetl(fid2);
end
fclose(fid2);


if fid3 > 0
    clear lat1 lon1 lat2 lon2 dy1 dx1 nx1 nx2 data data2
data = fgetl(fid3);
qq = 0;
while ~feof(fid3)
    qq = qq+1;
%     data = textscan(fid3,'%*5c%4f%*6c%4f%*3c%6f%*3c%6f%*6c%8f%*6c%8f%*3c%12f',1);
%     ny = imag(data{1});
%     nx = data{2};
%     dy = data{3};
%     dx = data{4};
%     lat = data{5};
%     lon = data{6};
%     time = data{7};
    data = fgetl(fid3);
    ny = str2double(data(7:9));
    nx = str2double(data(17:19));
    dy = str2double(data(23:28));
    dx = str2double(data(32:37));
    lat = str2double(data(44:51));
    lon = str2double(data(58:65));
    time = str2double(data(69:end));

    for jj = 1:ny
        data2 = fscanf(fid3,'%f',nx);
        ice(jj,:,qq) = data2;
    end
    if qq == 1
       lat1 = lat;
       lon1 = lon;
       dx1 = dx;
       dy1 = dy;
       nx1 = nx;
       ny1 = ny;
       lat2 = lat1 + ny1*dy1 - dy1;
       lon2 = lon1 + nx1*dx1 - dx1;
    end
     data = fgetl(fid3);
end
   fclose(fid3);

else
    ice = repmat(0,size(pre));
end


 [X3 Y3] = meshgrid(lon1:dx1:lon2,lat1:dy1:lat2);

RANGMM1 = (max(max(max(uwndt2))));
RANGMM2 = (max(max(max(pre))));
RANGMIN = (min(min(min(pre))));
RANGMM3 = (max(max(max(ice))));
mdr2(:,1) = max(max(uwndt2));
for zz = 1:size(uxx2,3)
    clf
    ux2(:,:) = uxx2(:,:,zz);
    uy2(:,:) = uyy2(:,:,zz);
    uwnd2(:,:) = uwndt2(:,:,zz);
    
    pre2(:,:) = pre(:,:,zz);
    
    ice2(:,:) = ice(:,:,ceil(zz/24));
    jj = ice2 == -99.00;
    ice2(jj) = 0.0;
      
    interv=0.005*RANGMM1;
    v = [0:interv:RANGMM1];
    
    load_coast
    figure(1);
    subplot(5,4,[1 2 5 6])
    m_proj('mercator','long',[lon1 lon2],'lat',[lat1 lat2]);
    [CMCF,hh]=m_contourf(X2,Y2,uwnd2,v);
    hold on
    caxis([0,RANGMM1]);
    set(hh,'EdgeColor','none');
    nco = size(lon_coast,2);

    %set(gca,'Position',[0.13 0.17 0.775 0.725]);
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
    
    for ii = 1:nco
        m_plot(lon_coast{ii},lat_coast{ii},'k','LineWidth',1);
    end
    
    i1=mod(1:size(X2,2),4)==0;
    i2=mod(1:size(X2,1),4)==0;
    [I1,I2]=meshgrid(i1,i2);
    in2= I1 &I2;
    hq=m_quiver(X2(in2),Y2(in2),ux2(in2),uy2(in2),1);
    colorbar('horizontal')
    title('Wind Field (m/s)','fontweight','bold');
    m_text(max(max(X2))-0.2,max(max(Y2))+0.15,[fwnd(1:6),' Time = ',num2str(dtime(zz))], ...
        'FontWeight','bold');
    
    interv2=0.005*RANGMM2;
    v2 = [RANGMIN:interv:RANGMM2];
    
    subplot(5,4,[3 4 7 8])
    m_proj('mercator','long',[lon1 lon2],'lat',[lat1 lat2]);
    [CMCF,hh]=m_contourf(X2,Y2,pre2,v2);
    hold on
    caxis([RANGMIN,RANGMM2]);
    set(hh,'EdgeColor','none');
    nco = size(lon_coast,2);

    %set(gca,'Position',[0.13 0.17 0.775 0.725]);
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
    
    for ii = 1:nco
        m_plot(lon_coast{ii},lat_coast{ii},'k','LineWidth',1);
    end
    
    colorbar('horizontal');
    title('Pressure Field (Pa/10)','fontweight','bold')

    interv3=0.005*RANGMM3;
    v3 = [0:interv:RANGMM3];
    
    subplot(5,4,[10 11 14 15])
    m_proj('mercator','long',[lon1 lon2],'lat',[lat1 lat2]);
    [CMCF,hh]=m_contourf(X3,Y3,ice2,v3);
    hold on
    caxis([0,RANGMM3]);
    nco = size(lon_coast,2);

    %set(gca,'Position',[0.13 0.17 0.775 0.725]);
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
    
    for ii = 1:nco
        m_plot(lon_coast{ii},lat_coast{ii},'k','LineWidth',1);
    end
    colorbar('horizontal');    
    title('Ice Field','fontweight','bold')
    
    
    subplot(5,4,17:20)
    plot(mdr2,'b-','linewidth',1)
    hold on
    plot(zz,max(max(uwnd2)),'ro')
    grid
    xlabel('Hour of Storm','fontweight','bold')
    ylabel('Wind Speed (m/s)','fontweight','bold')
    
    
    pos=get(gcf,'Position');
    pos(3:4)=[800,900];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
     
     f=extractFrameFromFigure(1);
     writeVideo(vidObj,f)
end
 close(vidObj);

