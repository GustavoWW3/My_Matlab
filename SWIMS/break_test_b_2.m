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
%BB = 1
%gg = [0.1:0.1:2.0];
col = ['bx','rx','gx','kx','mx','bo','ro','go','ko','mo','b^'];
%B = 1;
for aa = 1:3
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
        if aa == 1
            wave1d
        elseif aa == 2
            
        %gamma = gg(qq);
        %wave1d_simp_JB07_kamp
        wave1d_simp_TG83_beta_stwave
        %wave1d_simp_TG83_btest_gamma
        %wave1d_simp_TG83
        else
        wave1d_simp_JB07_stwave
        %wave1d_simp_JB07
        %wave1d_simp_JB07_gamma
        %wave1d
        end
        H_tot(:,qq,nn,aa) = H*sqrt(2);
        %S(nn,qq,:) = So;
  
        for mm = 1:9
            error(mm,qq,nn,aa) = (Hmo_comp_low_water_25_smooth(nn,mm+4) - H_tot(xlocate(mm+3),qq,nn,aa))/Hmo_comp_low_water_25_smooth(nn,mm+4);
            error_abs(mm,qq,nn,aa) = Hmo_comp_low_water_25_smooth(nn,mm+4) - H_tot(xlocate(mm+3),qq,nn,aa);
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
end
zzl = find(H1 < 0.1);
zzm = find(H1 >= 0.1 & H1 <= 0.12);
zzh = find(H1 > 0.12);
%figure('inverthardcopy','off','color','white')
for aa = 1:3
for qq = 1:size(BB,2)
    for mm = 1:9
           error_ave(mm,qq,aa) = mean(error(mm,qq,:,aa));
           error_abs_ave(mm,qq,aa) = mean(error_abs(mm,qq,:,aa));
           
           error_ave_07(mm,qq,aa) = mean(error(mm,qq,1:2,aa));
           error_ave_10(mm,qq,aa) = mean(error(mm,qq,3:5,aa));
           error_ave_13(mm,qq,aa) = mean(error(mm,qq,6:8,aa));
           error_ave_16(mm,qq,aa) = mean(error(mm,qq,9:11,aa));
           error_ave_20(mm,qq,aa) = mean(error(mm,qq,12:14,aa));
           
           error_ave_lo(mm,qq,aa) = mean(error(mm,qq,zzl,aa));
           error_ave_mi(mm,qq,aa) = mean(error(mm,qq,zzm,aa));
           error_ave_hi(mm,qq,aa) = mean(error(mm,qq,zzh,aa));
           
    end
%     plot(gauge_x(4:12),error_ave(qq,:),col(2*qq-1:2*qq),'MarkerSize',8,'LineWidth',2)
%     %error_B(1,mm) = mean(error_ave(1,:,mm));
%     hold on
    error_tot(qq,aa) = mean(error_ave(1:8,qq,aa));
    error_tot2(qq,aa) = sqrt(mean(error_ave(1:8,qq,aa).^2));
    error_abs_tot(qq,aa) = sqrt(mean(error_abs_ave(1:8,qq,aa).^2));
    
    error_off(qq,aa) = sqrt(mean(error_ave(1,qq,aa).^2));
    error_break(qq,aa) = sqrt(mean(error_ave(2:3,qq,aa).^2));
    error_diss(qq,aa) = sqrt(mean(error_ave(4:6,qq,aa).^2));
    error_reef(qq,aa) = sqrt(mean(error_ave(7:8,qq,aa).^2));
    
    error_tot_07(qq,aa) = sqrt(mean(error_ave_07(1:8,qq,aa).^2));
    error_tot_10(qq,aa) = sqrt(mean(error_ave_10(1:8,qq,aa).^2));
    error_tot_13(qq,aa) = sqrt(mean(error_ave_13(1:8,qq,aa).^2));
    error_tot_16(qq,aa) = sqrt(mean(error_ave_16(1:8,qq,aa).^2));
    error_tot_20(qq,aa) = sqrt(mean(error_ave_20(1:8,qq,aa).^2));
    
    error_tot_lo(qq,aa) = sqrt(mean(error_ave_lo(1:8,qq,aa).^2));
    error_tot_mi(qq,aa) = sqrt(mean(error_ave_mi(1:8,qq,aa).^2));
    error_tot_hi(qq,aa) = sqrt(mean(error_ave_hi(1:8,qq,aa).^2));
end
if aa ~= 1
    low(1,aa) = min(error_tot2(:,aa));
    hh(1,aa) = find(error_tot2(:,aa) == low(1,aa));
    error_tot2(hh(1,aa),aa)
    BB(hh(1,aa))
else
    error_tot2(1,aa)
end
end

cc = ['k-','b--','r-.'];

figure('inverthardcopy','off','color','white')
subplot(2,1,1)
plot(gauge_x,Hmo_comp_low_water_25_smooth(7,2:13),'kx','MarkerSize',8,'LineWidth',2)
hold on
grid
xlabel('x (m)')
ylabel('H_{mo} (m)')
text(4.7,0.025,'(A)');
for aa = 1:3
    subplot(2,1,1)
    if aa == 1
        plot(x,H_tot(:,1,7,aa),cc(2*aa-1:2*aa))
         subplot(2,1,2)
        plot(BB,error_tot2(:,aa),cc(2*aa-1:2*aa))
        hold on
    else
        plot(x,H_tot(:,hh(1,aa),7,aa),cc(3*aa-3:3*aa-1))
        subplot(2,1,2)
        plot(BB,error_tot2(:,aa),cc(3*aa-3:3*aa-1))
    end
    
end
subplot(2,1,2) 
text(0.15,0.1,'(B)');
grid
xlabel('B coefficient')
ylabel('rms error')
axis([0 4 0 1])
%hold off



%hold off