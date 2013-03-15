X = [-83.0:0.01:-82.36];
Y = [42.25:0.01:42.74];
[XX YY] = meshgrid(-83:0.01:-82.36,42.25:0.01:42.74);
XX = XX';
YY = YY';
xlats = 42.25;
xlatn = 42.75;
xlonw = -83.0;
xlone = -82.35;

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

fid2 = fopen('fort36.20','r');
for jj = 1:65
    dat = fscanf(fid2,'%1i',50);
    dep10(jj,:) = dat';
end
fclose(fid2);
save_points
% pp = 1;
% for jj = 1:65
%     for ii = 1:50
%         if dep10(jj,ii) == 1;
%             land(pp,1) = jj;
%             land(pp,2) = ii;
%             pp = 
%         end
%     end
% end
bbop = load('coast_peice.txt'); 
bb1 = [-83.0 -83.0 -82.35 -82.35];
bb2 = [42.25 42.75 42.75 42.25];
col = [.0 .5 .0];

bb = load('sta_order_corr.txt');
sta_order = point(bb,:);
figure('inverthardcopy','off','color','white')

m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
m_patch(bb1,bb2,col)
m_patch(bbop(:,1),bbop(:,2),[1 1 1]);
%m_patch(shr_x,shr_y,[.0 .5 .0]);
%m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
%hcst=findobj(gca,'Tag','m_gshhs_f');
%set(hcst,'HandleVisibility','off');
m_grid('box','fancy','tickdir','in','fontweight','bold');
hold on
m_grid('box','fancy','tickdir','in','fontweight','bold');
xlabel('Longitude','fontweight','bold')
ylabel('Latitude','fontweight','bold')
col = [.0 .5 .0];
% for jj = 1:65
%     pp = find(dep10(jj,:) == 1);
%     m_plot(X(jj),Y(pp),'o','Color',col,'MarkerFaceColor',col);
%     clear pp
% end
for ii = 1:size(sta_order,1)
    m_plot(X(sta_order(ii,1)),Y(sta_order(ii,2)),'r.')
    loc = num2str(ii);
    if ii < 100
        if ii < 10
            m_text(X(sta_order(ii,1)),Y(sta_order(ii,2)),loc,'Fontsize',8)
        elseif loc(2) == '0';
            m_text(X(sta_order(ii,1)),Y(sta_order(ii,2)),loc,'Fontsize',8,'Rotation',45)
        else
            m_text(X(sta_order(ii,1)),Y(sta_order(ii,2)),loc(2),'Fontsize',8)
        end
    else
        if loc(3) == '0';
            m_text(X(sta_order(ii,1)),Y(sta_order(ii,2)),loc(2:3),'Fontsize',8,'Rotation',45)
        else
            m_text(X(sta_order(ii,1)),Y(sta_order(ii,2)),loc(3),'Fontsize',8)
        end
    end
end

load_coast

for ii = 1:123
   m_plot(lon{ii},lat{ii},'y','LineWidth',2);
end

pos=get(gcf,'Position');
pos(3:4)=[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
print(gcf,'-dpng','station_order_corr')

fid = fopen('stclair_sta_loc.dat','wt');
for ii = 1:size(sta_order,1)
    loc = num2str(ii);
    if ii < 10 
        loca = ['0000',loc];
    elseif ii < 100
        loca = ['000',loc];
    else
        loca = ['00',loc];
    end
    fprintf(fid,'%9.2f %9.2f %6s \n',X(sta_order(ii,1)),Y(sta_order(ii,2)),loca);
end
fclose(fid);