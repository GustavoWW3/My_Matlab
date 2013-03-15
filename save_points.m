nn = 1;
for jj = 1:64
    for ii = 1:50
        if dep10(jj,ii) == 2 
           point(nn,1) = jj;
           point(nn,2) = ii;
           nn = nn + 1;
        end
    end
end

% figure('inverthardcopy','off','color','white')
% 
% m_proj(project_in,'long',[xlonw xlone],'lat',[xlats xlatn]);
% m_patch(shr_x,shr_y,[.0 .5 .0]);
% m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
% hcst=findobj(gca,'Tag','m_gshhs_f');
% set(hcst,'HandleVisibility','off');
% m_grid('box','fancy','tickdir','in','fontweight','bold');
% hold on
% m_grid('box','fancy','tickdir','in','fontweight','bold');
% xlabel('Longitude','fontweight','bold')
% ylabel('Latitude','fontweight','bold')
% 
% for ii = 1:size(point,1)
%     m_plot(X(point(ii,1)),Y(point(ii,2)),'r.')
%     loc = num2str(ii);
%     if ii < 100
%         if ii < 10
%             m_text(X(point(ii,1)),Y(point(ii,2)),loc,'Fontsize',8)
%         elseif loc(2) == '0';
%             m_text(X(point(ii,1)),Y(point(ii,2)),loc,'Fontsize',8,'Rotation',45)
%         else
%             m_text(X(point(ii,1)),Y(point(ii,2)),loc(2),'Fontsize',8)
%         end
%     else
%         if loc(3) == '0';
%             m_text(X(point(ii,1)),Y(point(ii,2)),loc(2:3),'Fontsize',8,'Rotation',45)
%         else
%             m_text(X(point(ii,1)),Y(point(ii,2)),loc(3),'Fontsize',8)
%         end
%     end
% end