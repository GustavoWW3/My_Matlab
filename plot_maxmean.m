fid2 = fopen('Max_mean.dat','r');
x = -83.0:0.005:-82.35;
y = 42.25:0.005:42.75;
xlonwp = -83.0;
xlonep = -82.35;
xlatsp = 42.25;
xlatnp = 42.75;
project_in = 'mercator';
for jj = 1:12
    data = fscanf(fid2,'%10f',[131,101]);
    stuff = flipud(data');
    
    RANGMM = max(max(stuff));
    interv=0.005*RANGMM;
    v=[-1,-interv/2,0:interv:RANGMM];
    
    figure
    load cmap.mat
    colormap(cmap)
    
    load_coast
    m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);
    [CMCF,hh]=m_contourf(x,y,stuff,v);
    hold on
    caxis([0,RANGMM]);
    set(hh,'EdgeColor','none');
    for ii = 1:123
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
    hcolmax=colorbar('horizontal');
    %set(hcolmax,'Position',colposit,'FontSize',8)
end
  fclose(fid2)
    
    