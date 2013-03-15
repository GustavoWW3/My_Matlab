function wam_alt(alt_data,loc)

%fname = ['E:\Pacific\WW3\ST4-New\',yearmon];
cd(loc)
[mod_out,mod_bias,mod_rmse,alt_out,blah,yearmon] = alt_WAM_stat1(alt_data);
%filed = [yearmon(1:4),yearmon(6:7),'_WIS_PacWW3_OWI_ST4-hss.tgz']
% fname = ls('*-hss.tgz');
% untar(fname)
% yearmon = fname(1:6);
% bbop = dir('*.hs');
% 
% for zz = 1:size(bbop,1)-1
%     fid = fopen(bbop(zz).name);
%     data = fgetl(fid);
%     
%     for jj = 1:257
%         data = fscanf(fid,'%f',381);
%         hs(:,jj) = data;
%     end
%     fclose(fid);
%     
%      mod_out(:,:,zz) = hs'*0.01;
%      for qq = 1:size(alt_data,2)
%      mod_bias{qq}(:,:,zz) = hs'*0.01 - alt_data(qq).alt_data(zz).Hs_grid';
%      alt_out{qq}(:,:,zz) = alt_data(qq).alt_data(zz).Hs_grid';
%      mod_rmse{qq}(:,:,zz) = (mod_out(:,:,zz) - alt_out{qq}(:,:,zz)).^2;
%      blah{qq}(zz) = max(max(alt_out{qq}(:,:,zz)));
%      for jj = 1:size(alt_out,2)
%          pp = (alt_data(qq).alt_data(zz).Hs_grid(jj,:) == -999 | hs(jj,:) == -999);
%          mod_bias{qq}(pp,jj,zz) = NaN;
%          alt_out{qq}(pp,jj,zz) = NaN;
%          mod_rmse{qq}(pp,jj,zz) = NaN;
%          clear pp
%      end
%      end    
% end
%%
%  mod_bias2 = zeros(size(mod_bias,1),size(mod_bias,2),25);
%  mod_bias3 = zeros(size(mod_bias,1),size(mod_bias,2));
%  mod_rmse2 = zeros(size(mod_rmse,1),size(mod_rmse,2),25);
%  mod_rmse3 = zeros(size(mod_rmse,1),size(mod_rmse,2));
%  alt_out2 = zeros(size(alt_out,1),size(alt_out,2),25);
%  alt_out3 = zeros(size(alt_out,1),size(alt_out,2));
%  alt_max = zeros(size(alt_out,1),size(alt_out,2));
%  mod_si = zeros(size(mod_rmse,1),size(mod_rmse,2));
% 
% for jj = 3:size(alt_out,2)-2
%     for ii = 3:size(alt_out,1)-2
% %        ppx = [ii-1,ii,ii+1,ii-1,ii,ii+1,ii-1,ii,ii+1];
% %        ppy = [jj+1,jj+1,jj+1,jj,jj,jj,jj-1,jj-1,jj-1];
%        ppx = [ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii, ...
%           ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2];
%        ppy = [jj+2,jj+2,jj+2,jj+2,jj+2,jj+1,jj+1,jj+1,jj+1,jj+1,jj,jj,jj, ...
%            jj,jj,jj-1,jj-1,jj-1,jj-1,jj-1,jj-2,jj-2,jj-2,jj-2,jj-2];
%        for zz = 1:25
%            qq{zz} = find(isnan(alt_out(ppx(zz),ppy(zz),:)) == 0);
%            mod_bias2(ii,jj,zz) = mean(mod_bias(ppx(zz),ppy(zz),qq{zz}));
%            alt_out2(ii,jj,zz) = mean(alt_out(ppx(zz),ppy(zz),qq{zz}));
%            mod_rmse2(ii,jj,zz) = mean(mod_rmse(ppx(zz),ppy(zz),qq{zz}));
%        end
%        clear qq
%        qq = find(isnan(alt_out2(ii,jj,:)) == 0);
%        alt_out3(ii,jj) = mean(alt_out2(ii,jj,qq));
%        %alt_max(ii,jj) = max(alt_out2(ii,jj,qq));
%        mod_bias3(ii,jj) = mean(mod_bias2(ii,jj,qq));
%        mod_rmse3(ii,jj) = sqrt(sum(mod_rmse2(ii,jj,qq))/length(qq));
%        mod_si(ii,jj) = mod_rmse3(ii,jj)./alt_out3(ii,jj).*100;
%        clear qq
%     end
% end
[mod_bias2,mod_rmse2,alt_mean,mod_si2] = alt_stat2(mod_bias{1},mod_rmse{1}, ...
    alt_out{1});
[X Y] = meshgrid(110:0.5:300,-64:0.5:64.0);

% plot mean statistics
    figure(1)
     orient('tall')
    subplot(2,4,1:2)
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    [CMCF,hh2]=m_contourf(X,Y,alt_mean,15);
    hold on
    caxis([0 max(max(alt_mean))]);
    set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    colorbar('horizontal')
    title('Mean H_{mo} (m)','fontweight','bold')

    subplot(2,4,3:4)
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    [CMCF,hh2]=m_contourf(X,Y,mod_bias2,15);
    hold on
    caxis([-1.0 1.0])
    set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    colorbar('horizontal')
    title('H_{mo} Bias','fontweight','bold');
    
    subplot(2,4,5:6)
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    [CMCF,hh2]=m_contourf(X,Y,mod_rmse2,15);
    hold on
    caxis([0 4])%max(max(mod_rmse2))])
    set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    colorbar('horizontal')
    title('H_{mo} RMSE','fontweight','bold');
    
    subplot(2,4,7:8)
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    [CMCF,hh2]=m_contourf(X,Y,mod_si2,15);
    hold on
    caxis([0 30])
    set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    colorbar('horizontal')
    title('H_{mo} Scatter Index','fontweight','bold');
    
     pos=get(gcf,'Position');
     pos(3:4)=[649,664];
%    set(gcf,'PaperPositionMode','manual');
%    set(gcf,'papersize',[11 8.5]);
%    set(gcf,'Position',[0.5 0.5 10 7.5]);
    fileout = ['WW3-Topex-stats-',yearmon];
    print(gcf,'-dpng','-r500',fileout);
    clf

%bb = find(blah > max(blah)-max(blah)*0.2);
for qq = 1:size(alt_data,2)
hh = find(blah{qq} > 12.0);
%[blahmax hh] = sort(blah(bb));
if ~isempty(hh)
    nh = length(hh);
% if nh > 5
%     nh = 5;
% end

for ii = 1:nh
    figure(1)
    stuff = NaN(size(X));
    for jj = 2:size(alt_out{qq},2)-1
        for rr = 2:size(alt_out{qq},1)-1
            if alt_out{qq}(rr,jj,hh(ii)) <= 0.0;
                stuff(rr,jj) = NaN;
            elseif ~isnan(alt_out{qq}(rr,jj,hh(ii)))
               for pp = 1:3
                   for dd = 1:3
                    stuff(rr-1+(dd-1),jj-1+(pp-1)) = alt_out{qq}(rr,jj,hh(ii));
                   end
               end
            end
        end
    end

   % stuff = griddata(X,Y,alt_out(:,:,hh(ii)),YS,XS);
    maxhs = max(max(max(stuff)),max(max(mod_out(:,:,hh(ii)))));
    subplot(3,2,[3 5])
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    %[CMCF,hh2]=m_contourf(X,Y,alt_out(:,:,hh(ii)),15,'linestyle','none');
    [CMCF,hh2]=m_contourf(X,Y,stuff,15,'linestyle','none');
    hold on
    caxis([0 maxhs])
    %set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    colorbar('horizontal')
    [lon_ord, hhp] = sort(alt_data(qq).alt_data(hh(ii)).lon);
    %m_plot(lon_ord,alt_data(hh(ii)).lat(hhp),'k.','linewidth',2)
    
    subplot(3,2,[4 6])
    m_proj('mercator','long',[110 300],'lat',[-64 64]);
    [CMCF,hh2]=m_contourf(X,Y,mod_out(:,:,hh(ii)),15);
    hold on
    caxis([0 maxhs])
    set(hh2,'EdgeColor','none');
    m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
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
    k2=strmatch('m_gshhs_i',tags);
    h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
    set(h_water,'FaceColor','none');
    m_plot(lon_ord,alt_data(qq).alt_data(hh(ii)).lat(hhp),'k.','linewidth',2)
    
    colorbar('horizontal')
    
    
    
    subplot(3,2,1:2)
    ttt = stuff;
    ttt2 = mod_out(:,:,hh(ii));
    for oo = 1:size(ttt,2)
        hh2 = ~isnan(ttt(:,oo));
        if any(hh2)
            [hoowa(oo),ll] = max(ttt(hh2,oo));
            hoowam(oo) = max(ttt2(hh2,oo));
        else
            hoowa(oo) = NaN;
            hoowam(oo) = NaN;
        end
    end
    %ttt2 = mod_out(:,:,hh(ii));
    %plot(ttt(hh2));
    hh3 = ~isnan(hoowa);
    plot(X(1,hh3),hoowa(hh3));
    hold on
    plot(X(1,hh3),hoowam(hh3),'r');
    %plot(ttt2(hh2),'r');
    grid
    ylim([0 maxhs+1]);
    clear hh2 ttt ttt2 hh3
    legend('Altimeter','WAM','location','best')
    xlabel('Longitude','fontweight','bold');
    ylabel('H_{mo} (m)','fontweight','bold');
    title([alt_data(qq).sat,' ',alt_data(qq).alt_data(hh(ii)).stime],'fontweight','bold')
    pos=get(gcf,'Position');
    pos(3:4)=[649,664];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
    fileout = ['WW3-',alt_data(qq).sat,'-',yearmon,'-',num2str(hh(ii))];
    print(gcf,'-dpng','-r500',fileout);
    clf
end
end
end
% [X Y] = meshgrid(110:0.5:300,-64:0.5:64.0);
% figure(1)
% subplot(1,2,1)
% m_proj('mercator','long',[110 300],'lat',[-64 64]);
% [CMCF,hh]=m_contourf(X,Y,alt_out3',15);
% hold on
% caxis([0 10])
% set(hh,'EdgeColor','none');
% m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
% xlabel('Longitude','FontWeight','bold')
% ylabel('Latitude','FontWeight','bold')
% m_grid('box','fancy','tickdir','in','FontWeight','Bold');
% hcc=get(gca,'children');
% tags=get(hcc,'Tag');
% k=strmatch('m_grid',tags);
% hgrd=hcc(k);
% hp=findobj(gca,'Tag','m_grid_color');
% set(hp,'Visible','off');
% set(hgrd,'HandleVisibility','off');
% k2=strmatch('m_gshhs_i',tags);
% h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
% set(h_water,'FaceColor','none');
% colorbar('horizontal')
% 
% subplot(1,2,2)
% m_proj('mercator','long',[110 300],'lat',[-64 64]);
% [CMCF2,hh2]=m_contourf(X,Y,mod_bias3',15);
% hold on
% caxis([-1.0 1.0])
% set(hh2,'EdgeColor','none');
% m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
% xlabel('Longitude','FontWeight','bold')
% ylabel('Latitude','FontWeight','bold')
% m_grid('box','fancy','tickdir','in','FontWeight','Bold');
% hcc=get(gca,'children');
% tags=get(hcc,'Tag');
% k=strmatch('m_grid',tags);
% hgrd=hcc(k);
% hp=findobj(gca,'Tag','m_grid_color');
% set(hp,'Visible','off');
% set(hgrd,'HandleVisibility','off');
% k2=strmatch('m_gshhs_i',tags);
% h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
% set(h_water,'FaceColor','none');
% colorbar('horizontal')

% subplot(2,2,3)
% m_proj('mercator','long',[110 300],'lat',[-64 64]);
% [CMCF2,hh2]=m_contourf(X,Y,mod_rmse3',15);
% hold on
% caxis([-1.0 1.0])
% set(hh2,'EdgeColor','none');
% m_gshhs_i('patch',[0 0.5 0],'EdgeColor','k');
% xlabel('Longitude','FontWeight','bold')
% ylabel('Latitude','FontWeight','bold')
% m_grid('box','fancy','tickdir','in','FontWeight','Bold');
% hcc=get(gca,'children');
% tags=get(hcc,'Tag');
% k=strmatch('m_grid',tags);
% hgrd=hcc(k);
% hp=findobj(gca,'Tag','m_grid_color');
% set(hp,'Visible','off');
% set(hgrd,'HandleVisibility','off');
% k2=strmatch('m_gshhs_i',tags);
% h_water=findobj(hcc(k2),'FaceColor',[1,1,1]);
% set(h_water,'FaceColor','none');
% colorbar('horizontal')
%     pos=get(gcf,'Position');
%     pos(3:4)=[649,664];
%     set(gcf,'Position',pos,'PaperPositionMode','auto');
% fout2 = ['WW3-Topex-stats-',yearmon];
% print(gcf,'-dpng','-r500',fout2);