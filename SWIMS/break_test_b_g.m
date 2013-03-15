clear all

load('Hmo_comp_low_water_25_smooth.dat')
load('Setup_low_water_25_smooth.dat')
load('Wave_low_water_25_smooth.dat')

xx = [0:0.01:1565*0.01-0.01];
gauge_x = [4.82 5.13 5.74 9.72 10.64 10.84 11.02 11.35 11.66 12.83 14.68 17.73];
%Tp = [1.0 1.0 1.41 1.41 1.41 1.8 1.8 1.8 2.2 2.2 2.2 2.8 2.8 2.8];
read_stwave_dep
x = [0:0.01:size(depth,2)*0.01-0.01];
x = x + 5.13;
nx = size(x,2);
xlocate = floor(gauge_x./0.01) - 513;

BB = [0.1:0.1:4.0];
gg = [0.1:0.1:2.0];
col = ['bx','rx','gx','kx','mx','bo','ro','go','ko','mo','b^'];
%B = 1;
for aa = 1:2
for nn = 1:size(Hmo_comp_low_water_25_smooth,1)
    yi = interp1(gauge_x,Setup_low_water_25_smooth(nn,2:13),x);
    bb = isnan(yi);
    pp = find(bb == 1);
    yi(pp) = yi(pp(1)-1);
    
    H1(nn) = mean(Hmo_comp_low_water_25_smooth(nn,2:4));
    Ho = H1(nn);
    T = Wave_low_water_25_smooth(nn,3);
    %T = Tp(nn);
    depth2 = depth(2,:) + yi;
    dep = max(depth2,0.01); 
    for qq = 1:size(BB,2)
        B = BB(qq);
        for rr = 1:size(gg,2)
        gamma = gg(rr);
        if aa == 1
        %wave1d_simp_JB07_kamp
        %wave1d_simp_TG83_beta_stwave
        wave1d_simp_TG83
        else
        %wave1d_simp_JB07_stwave
        wave1d_simp_JB07
        %wave1d
        end
        H_tot(:,rr,qq,nn,aa) = H*sqrt(2);
        %S(nn,qq,:) = So;
  
            for mm = 1:9
                error(mm,rr,qq,nn,aa) = (Hmo_comp_low_water_25_smooth(nn,mm+4) - H_tot(xlocate(mm+3),rr,qq,nn,aa))/Hmo_comp_low_water_25_smooth(nn,mm+4);
                error_abs(mm,rr,qq,nn,aa) = Hmo_comp_low_water_25_smooth(nn,mm+4) - H_tot(xlocate(mm+3),rr,qq,nn,aa);
            end
        end
    end
end
%     figure(nn)
%    % plot(gauge_x,Hmo_comp_low_water_25_smooth(nn,2:13),'kx')
%     hold on
%     plot(gauge_x(4:12),error(nn,:),'gx','MarkerSize',8,'LineWidth',2)
%     axis([9 18 -1.5 1.5])
%     grid
    clear yi bb jj Ho T depth2 dep
end
zzl = find(H1 < 0.1);
zzm = find(H1 >= 0.1 & H1 <= 0.12);
zzh = find(H1 > 0.12);
%figure('inverthardcopy','off','color','white')
for aa = 1:2
for qq = 1:size(BB,2)
    for rr = 1:size(gg,2)
        for mm = 1:9
               error_ave(mm,rr,qq,aa) = mean(error(mm,rr,qq,:,aa));
               error_abs_ave(mm,rr,qq,aa) = mean(error_abs(mm,rr,qq,:,aa));
           
           error_ave_07(mm,rr,qq,aa) = mean(error(mm,rr,qq,1:2,aa));
           error_ave_10(mm,rr,qq,aa) = mean(error(mm,rr,qq,3:5,aa));
           error_ave_13(mm,rr,qq,aa) = mean(error(mm,rr,qq,6:8,aa));
           error_ave_16(mm,rr,qq,aa) = mean(error(mm,rr,qq,9:11,aa));
           error_ave_20(mm,rr,qq,aa) = mean(error(mm,rr,qq,12:14,aa));
           
           error_ave_lo(mm,rr,qq,aa) = mean(error(mm,rr,qq,zzl,aa));
           error_ave_mi(mm,rr,qq,aa) = mean(error(mm,rr,qq,zzm,aa));
           error_ave_hi(mm,rr,qq,aa) = mean(error(mm,rr,qq,zzh,aa));
       end  
       
%     plot(gauge_x(4:12),error_ave(qq,:),col(2*qq-1:2*qq),'MarkerSize',8,'LineWidth',2)
%     %error_B(1,mm) = mean(error_ave(1,:,mm));
%     hold on
    error_tot(rr,qq,aa) = mean(error_ave(1:8,rr,qq,aa));
    error_tot2(rr,qq,aa) = sqrt(mean(error_ave(1:8,rr,qq,aa).^2));
    error_abs_tot(rr,qq,aa) = sqrt(mean(error_abs_ave(1:8,rr,qq,aa).^2));
    
    error_off(rr,qq,aa) = sqrt(mean(error_ave(1,rr,qq,aa).^2));
    error_break(rr,qq,aa) = sqrt(mean(error_ave(2:3,rr,qq,aa).^2));
    error_diss(rr,qq,aa) = sqrt(mean(error_ave(4:6,rr,qq,aa).^2));
    error_reef(rr,qq,aa) = sqrt(mean(error_ave(7:8,rr,qq,aa).^2));
    
    error_tot_07(rr,qq,aa) = sqrt(mean(error_ave_07(1:8,rr,qq,aa).^2));
    error_tot_10(rr,qq,aa) = sqrt(mean(error_ave_10(1:8,rr,qq,aa).^2));
    error_tot_13(rr,qq,aa) = sqrt(mean(error_ave_13(1:8,rr,qq,aa).^2));
    error_tot_16(rr,qq,aa) = sqrt(mean(error_ave_16(1:8,rr,qq,aa).^2));
    error_tot_20(rr,qq,aa) = sqrt(mean(error_ave_20(1:8,rr,qq,aa).^2));
    
    error_tot_lo(rr,qq,aa) = sqrt(mean(error_ave_lo(1:8,rr,qq,aa).^2));
    error_tot_mi(rr,qq,aa) = sqrt(mean(error_ave_mi(1:8,rr,qq,aa).^2));
    error_tot_hi(rr,qq,aa) = sqrt(mean(error_ave_hi(1:8,rr,qq,aa).^2));
end
end
end
save error_only_5.mat error -V6
save error_5.mat error_tot error_tot2 error_off error_break error_diss error_reef BB gg gauge_x x -V6
save error_per_5.mat error_tot_07 error_tot_10 error_tot_13 error_tot_16 error_tot_20 -V6
save error_hig_5.mat error_tot_lo error_tot_mi error_tot_hi -V6
%hold off
 figure('inverthardcopy','off','color','white')
bg = error_tot2;
% %bg2(:,:) = error_tot2(:,:,2);
for aa = 1:2    
    for qq = 1:size(BB,2)
        for rr = 1:size(gg,2)
            if error_tot2(rr,qq,aa) > 1.0;
                bg(rr,qq,aa) = 1.0;
            end
        end
    end
    [X Y] = meshgrid(BB(1):0.1:BB(40),gg(1):0.1:gg(20));
    subplot(2,1,aa)
    contour(Y,X,bg(:,:,aa),30)
    t = colorbar('peer',gca);
    set(get(t,'ylabel'),'String','rms error','VerticalAlignment','bottom','rotation',270);
    xlabel('\gamma');
    ylabel('B');
    grid
end    
    
    