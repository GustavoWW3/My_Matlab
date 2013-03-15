load error_5.mat
load error_per_5.mat
load error_hig_5.mat

figure('inverthardcopy','off','color','white')
error_tot2 = real(error_tot2);
bg = error_tot2;
for kk = 1:2
    for jj = 1:40
        for ii = 1:20
            if error_tot2(ii,jj,kk) > 1.0;
                bg(ii,jj,kk) = 1.0;
            end
        end
    end
    
    [X Y] = meshgrid(BB(1,1):0.1:BB(1,40),gg(1,1):0.1:gg(1,20));
    subplot(2,1,kk)
    contour(Y,X,bg(:,:,kk),30)
    caxis([0 1.0])
    xlabel('\gamma')
    grid
    t = colorbar('peer',gca);
    set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
    ylabel('B','rotation',0,'HorizontalAlignment','right')
    if kk == 1
        text(0.18,4.3,'(A)','clipping','off')
    else
        text(0.18,4.3,'(B)','clipping','off')
    end
    
    %     if kk == 1
%         ylabel('B')
%     end
end

error_off = real(error_off);
error_break = real(error_break);
error_diss = real(error_diss);
error_reef = real(error_reef);

bg_off = error_off;
bg_break = error_break;
bg_diss = error_diss;
bg_reef = error_reef;

for kk = 1:2
    figure('inverthardcopy','off','color','white')
    for jj = 1:40
        for ii = 1:20
            if error_off(ii,jj,kk) > 1.0
                bg_off(ii,jj,kk) = 1.0;
            elseif error_break(ii,jj,kk) > 1.0
                bg_break(ii,jj,kk) = 1.0;
            elseif error_diss(ii,jj,kk) > 1.0
                bg_diss(ii,jj,kk) = 1.0;
            elseif error_reef(ii,jj,kk) > 1.0
                bg_reef(ii,jj,kk) = 1.0;
            end
        end
    end
            [X Y] = meshgrid(BB(1,1):0.1:BB(1,40),gg(1,1):0.1:gg(1,20));
            subplot(4,1,1)
            contour(Y,X,bg_off(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(A)','clipping','off')
            
            subplot(4,1,2)
            contour(Y,X,bg_break(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(B)','clipping','off')
            
            
            subplot(4,1,3)
            contour(Y,X,bg_diss(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(C)','clipping','off')
            
            subplot(4,1,4)
            contour(Y,X,bg_reef(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(D)','clipping','off')
            
            
 end
 
error_07 = real(error_tot_07);
error_10 = real(error_tot_10);
error_13 = real(error_tot_13);
error_16 = real(error_tot_16);
error_20 = real(error_tot_20);

bg_07 = error_07;
bg_10 = error_10;
bg_13 = error_13;
bg_16 = error_16;
bg_20 = error_20;

for kk = 1:2
    figure('inverthardcopy','off','color','white')
    for jj = 1:40
        for ii = 1:20
            if error_07(ii,jj,kk) > 1.0
                bg_07(ii,jj,kk) = 1.0;
            elseif error_10(ii,jj,kk) > 1.0
                bg_10(ii,jj,kk) = 1.0;
            elseif error_13(ii,jj,kk) > 1.0
                bg_13(ii,jj,kk) = 1.0;
            elseif error_16(ii,jj,kk) > 1.0
                bg_16(ii,jj,kk) = 1.0;
            elseif error_20(ii,jj,kk) > 1.0
                bg_20(ii,jj,kk) = 1.0;
            end
        end
    end
            [X Y] = meshgrid(BB(1,1):0.1:BB(1,40),gg(1,1):0.1:gg(1,20));
            subplot(5,1,1)
            contour(Y,X,bg_07(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(A)','clipping','off')
            
            subplot(5,1,2)
            contour(Y,X,bg_10(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(B)','clipping','off')
            
            
            subplot(5,1,3)
            contour(Y,X,bg_13(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(C)','clipping','off')
            
            subplot(5,1,4)
            contour(Y,X,bg_16(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(D)','clipping','off')
            
            subplot(5,1,5)
            contour(Y,X,bg_20(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(E)','clipping','off')
 end
 
 error_low = real(error_tot_lo);
error_mid = real(error_tot_mi);
error_high = real(error_tot_hi);

bg_low = error_low;
bg_mid = error_mid;
bg_high = error_high;

for kk = 1:2
    figure('inverthardcopy','off','color','white')
    for jj = 1:40
        for ii = 1:20
            if error_low(ii,jj,kk) > 1.0
                bg_low(ii,jj,kk) = 1.0;
            elseif error_mid(ii,jj,kk) > 1.0
                bg_mid(ii,jj,kk) = 1.0;
            elseif error_high(ii,jj,kk) > 1.0
                bg_high(ii,jj,kk) = 1.0;
            end
        end
    end
            [X Y] = meshgrid(BB(1,1):0.1:BB(1,40),gg(1,1):0.1:gg(1,20));
            subplot(3,1,1)
            contour(Y,X,bg_low(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(A)','clipping','off')
            
            subplot(3,1,2)
            contour(Y,X,bg_mid(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(B)','clipping','off')
            
            
            subplot(3,1,3)
            contour(Y,X,bg_high(:,:,kk),30)
            caxis([0 1.0]);
            t = colorbar('peer',gca);
            set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
            xlabel('\gamma')
            ylabel('B','rotation',0,'HorizontalAlignment','right')
            grid
            text(0.18,4.3,'(C)','clipping','off')
            
                    
            
 end