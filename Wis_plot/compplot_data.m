function compplot_WIS(id,stations,data,coord,tit1,track,saven)

f = figure('visible','off');
%clf
orient tall
subplot(8,3,[2 6])
m_proj('mercator','long',[coord(1) coord(2)],'lat',[coord(3) coord(4)]);
%m_patch(shr_x,shr_y,[.0 .5 .0]);
m_gshhs_i('patch',[.0 .5 .0],'edgecolor','k');
hcst=findobj(gca,'Tag','m_gshhs_i');
set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in','fontweight','bold','fontsize',8);
hcc=get(gca,'children');
tags=get(hcc,'Tag');
k=strmatch('m_grid',tags);
hgrd=hcc(k);
hp=findobj(gca,'Tag','m_grid_color');
set(hp,'Visible','off');
set(hgrd,'HandleVisibility','off');
k2=strmatch('m_gshhs_i',tags);
h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
set(h_water,'FaceColor','none');
hold on
for jj = 1:length(data)
    lon = data(jj).mlon;lat = data(jj).mlat;
    lon(lon < 0) = lon(lon < 0) + 360;
%m_plot(track(:,1),track(:,2),'b-','LineWidth',1);
    m_text(lon,lat,num2str(stations(jj)),'VerticalAlignment','Bottom', ...
        'backgroundcolor',[1 1 1],'fontsize',8,'HorizontalAlignment','left')
    m_plot(lon,lat,'r.','MarkerSize',12)
end
hold off

for jj = 1:length(data)
    maxhs(jj) = max(max(data(jj).bwvht),max(data(jj).mwvht));
    textdt = ['Buoy: ',num2str(stations(jj)),' at [', ...
        num2str(data(jj).mlon),', ',num2str(data(jj).mlat),']'];
    if jj == 1;
        textd = {textdt};
    else
        textd = vertcat(textd,textdt);
    end
end
hsmaxt = max(maxhs);
for jj = 1:length(data)
    pt(jj) = subplot(8,3,3*jj+4:3*jj+6);
    ii = data(jj).bwvht ~= -999 & data(jj).btime >= data(jj).mtime(1) & ...
        data(jj).btime <= data(jj).mtime(end);
    plot(data(jj).btime(ii),data(jj).bwvht(ii),'r.',data(jj).mtime, ...
        data(jj).mwvht,'b','Markersize',8,'linewidth',1);
    grid;
    set_WIS_xtick(min(data(jj).mtime),max(data(jj).mtime));
    ylabel(['H_{s} (m)'],'fontweight','bold');
    set_WIS_ytick(0,hsmaxt);
    if jj == 1
        hleg = legend('Buoy','Model');
        yimit = get(gca,'ylim');
        %tit = vertcat(tit1);
        text(min(data(jj).mtime),yimit(2)*4.0,tit1,'fontweight','bold');
        text(min(data(jj).mtime),yimit(2)*3.0,textd,'fontweight','bold', ...
            'fontsize',11)
        po=get(hleg,'position');
        po=[0.3 0.74 0.08 0.03];
        set(hleg,'position',po);
    end
    text(max(data(jj).mtime)-3.0,yimit(2),num2str(stations(jj)), ...
        'verticalalignment','top')
end
xlabel(['Month/Day in Year ',datestr(data(jj).mtime(1),'yyyy')], ...
    'fontweight','bold');



ffout = [saven,'-comp',num2str(id)];
saveas(f,ffout,'png')
clear f
