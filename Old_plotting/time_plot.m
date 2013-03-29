function time_plot(coor_deg,comp,timbuoy,timwam,coor_buoy,wtype,titchar1,titchar2)
%
%--------------------------------------------------------------------------------
%   TJ Hesser 20120124  created based on timeplt_WAM2
%
%   INPUTS
%       coor_deg          NUMERIC - coordinates of the basin (used to make
%                                    box for location of buoy)
%                               [lone lonw lats latn]
%       comp              NUMERIC - structured array of the six bulk
%                                    parameters
%                               comp(1:6).y1 model value 1
%                               comp(1:6).y2 model value 2
%                               comp(1:6).name type of variable
%                                  (Hs,Tp,Tm,Dir,Ws,Wdir)
%                               comp(1:6).max  max of model values
%                         The 1:6 is for Hs,Tp,Tm,WaveDir,Ws,Wdir in that
%                         order
%       timbuoy           NUMERIC - Matlab time for the buoy results
%       timwam            NUMERIC - Matlab time for the model results
%       coor_buoy         Cell NUMERIC - lat-lon for buoy location
%                                coor_buoy = {lonb;latb};
%       wtype             Cell STRING  - Name of wind type for model run
%                             wtype = {'CFSR';'NNM'}
%       titchar1          STRING -  Main title of plot
%       titchar2          STRING -  Secondary title for more details
%
% ------------------------------------------------------------------------------


figure
% make map in top right corner of figure
subplot(8,3,[2 6])
m_proj('mercator','long',[coor_deg(1) coor_deg(2)],'lat',[coor_deg(3) coor_deg(4)]);
% create coastline 
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
% Add point for the location of the buoy being plotted
lonmp = str2double(coor_buoy{1}(1,:));
latmp = str2double(coor_buoy{2}(1,:));
if lonmp < 0
    lonmp = 360 + lonmp;
end
m_plot(lonmp,latmp,'r.','MarkerSize',12)
% Position for figure (this needs to be standardized)
set(gca,'Position',[0.45 0.74 0.7 0.25]);
hold off

% create six panel plots from the comp structered array
for ii = 1:6
    orient('Tall')
    subplot(8,3,3*ii+4:3*ii+6)
    if ii == 5
        qq = find(comp(ii).y2 == 0);
        comp(ii).y2(qq) = -1.0;
    end
    % setup to plot both a single model case and two model cases versus the
    % buoy
    if size(comp(ii).y1,2) == 1
        H=plot(timbuoy,comp(ii).y2,'r.',timwam,comp(ii).y1(:,1),'b-','MarkerSize',10,'LineWidth',1);
    else
        H=plot(timbuoy,comp(ii).y2,'r.',timwam,comp(ii).y1(:,1),'b-', ...
            timwam,comp(ii).y1(:,2),'k-','MarkerSize',10,'LineWidth',1);
    end
    % adjusting the location and labeling of the ticks
    xticks=get(gca,'XTick');
    xtickdiff = max(timwam) - min(timwam);
    xticks = [min(timwam):ceil(xtickdiff/12):max(timwam)];
    xx=datestr(xticks,7);
    set(gca,'XTick',xticks,'XTicklabel',xx);
    
    % setting the ylimits of each plot
    ylimmx=[0,comp(ii).max];
    if ylimmx(2) <= 2
        ytd1 = ylimmx(2)/4;
        ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
    else
        ytd1 = ceil(ylimmx(2)/4);
        ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
    end
    set(gca,'YTick',ytickm);
    set(gca,'Ylim',ylimmx);
    xlimxx = [min(timwam) max(timwam)];
    set(gca,'Xlim',xlimxx);
    grid
    ylabel(comp(ii).name);
    
    % inserting title for only the top panel and adjusting the height
    if ii == 1
        text(timwam(1),comp(ii).max*4,titchar1,'FontWeight','bold','Fontsize',12);
        text(timwam(1),comp(ii).max*3, titchar2,'FontWeight','bold','Fontsize',11);
        if size(comp(ii).y1,2) == 2
            hleg=legend('BUOY',wtype{1},wtype{2});
        else
            hleg = legend('BUOY',wtype{1});
        end
        po=get(hleg,'position');
        po=[0.3 0.74 0.08 0.03];
        set(hleg,'position',po);
    end
    % filling in no data statement if there is no buoy data
%     if (nodir(ii) == 1)
%         text(timwam(1),ytickm(1),nodata{ii},'Color','red', ...
%             'VerticalAlignment','top');
%     end
    % labeling the xaxis for the sixth panel
    if ii == 6
        yy = datestr(timwam(1),'yyyy');
        xlabel(yy)
    end
    clear H;
end