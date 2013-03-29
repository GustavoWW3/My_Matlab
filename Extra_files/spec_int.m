%break up eta by time
% 1 min to 15 minutes
% t_start = [1.0];
% t_end = [19.0];
% 
% fs = 1/dt;
% 
% 
% bb = find(t(1,:) == t_start*60);
% ee = find(t(1,:) == t_end*60);
% ee = ee + 1;
%    
% for ii = 1:nogage
%      eta_int = eta(bb:ee,ii);
%      etas = eta_int - mean(eta_int);
%      nc = size(eta_int,1);
%      win = floor(nc/2);
%      noverlap = floor(nc/4);
%      [px_int,f_int] = pwelch(etas,win,noverlap,nc,fs);
%      df = f_int(2)-f_int(1);
%      tt = find(px_int(:) == max(px_int));
%      Tp_full(ii) = 1/f_int(tt);
%      Hmo_full(ii) = 4*sqrt(df*sum(px_int));
%     end
% clear bb ee nc win noverlap px_int f_int
% 
% % seven minute
% t_start = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0];
% t_end = [8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0];
% 
% for jj = 1:length(t_start)
%     bb = find(t(1,:) == t_start(jj)*60.0);
%     ee = find(t(1,:) == t_end(jj)*60.0);
%     ee = ee + 1;
%     
%     for ii = 1:nogage
%          eta_int = eta(bb:ee,ii);
%          etas = eta_int - mean(eta_int);
%          nc = size(eta_int,1);
%          win = floor(nc/2);
%          noverlap = floor(nc/4);
%          [px_int,f_int] = pwelch(etas,win,noverlap,nc,fs);
%          df = f_int(2)-f_int(1);
%          tt = find(px_int(:) == max(px_int));
%          Tp_7min(ii,jj) = 1/f_int(tt);
%          Hmo_7min(ii,jj) = 4*sqrt(df*sum(px_int));
%     end
%     clear bb ee nc win noverlap px_int f_int
% end
% 
% 
% %five minute intervals
% t_start = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0];
% t_end = [6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0];
% 
% 
% for jj = 1:length(t_start)
%     bb = find(t(1,:) == t_start(jj)*60.0);
%     ee = find(t(1,:) == t_end(jj)*60.0);
%     ee = ee + 1;
%     
%     for ii = 1:nogage
%          eta_int = eta(bb:ee,ii);
%          etas = eta_int - mean(eta_int);
%          nc = size(eta_int,1);
%          win = floor(nc/2);
%          noverlap = floor(nc/4);
%          [px_int,f_int] = pwelch(etas,win,noverlap,nc,fs);
%          df = f_int(2)-f_int(1);
%          tt = find(px_int(:) == max(px_int));
%          Tp_5min(ii,jj) = 1/f_int(tt);
%          Hmo_5min(ii,jj) = 4*sqrt(df*sum(px_int));
%     end
%     clear bb ee nc win noverlap px_int f_int
% end

%three minute intervals
t_start = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0];
t_end = [4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0];

for jj = 1:length(t_start)
    bb = find(t(1,:) == t_start(jj)*60.0);
    ee = find(t(1,:) == t_end(jj)*60.0);
    ee = ee + 1;
    
    for ii = 1:nogage
         eta_int = eta(bb:ee,ii);
         etas = eta_int - mean(eta_int);
         nc = size(eta_int,1);
         win = floor(nc/2);
         noverlap = floor(nc/4);
         [px_int,f_int] = pwelch(etas,win,noverlap,nc,fs);
         df = f_int(2)-f_int(1);
         tt = find(px_int(:) == max(px_int));
         Tp_3min(ii,jj) = 1/f_int(tt);
         Hmo_3min(ii,jj) = 4*sqrt(df*sum(px_int));
    end
    clear bb ee nc win noverlap px_int f_int
end

%one minute
% t_start = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0];
% t_end = [2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0];
% 
% for jj = 1:length(t_start)
%     bb = find(t(1,:) == t_start(jj)*60.0);
%     ee = find(t(1,:) == t_end(jj)*60.0);
%     ee = ee + 1;
%     
%     for ii = 1:nogage
%          eta_int = eta(bb:ee,ii);
%          etas = eta_int - mean(eta_int);
%          nc = size(eta_int,1);
%          win = floor(nc/2);
%          noverlap = floor(nc/4);
%          [px_int,f_int] = pwelch(etas,win,noverlap,nc,fs);
%          df = f_int(2)-f_int(1);
%          tt = find(px_int(:) == max(px_int));
%          Tp_1min(ii,jj) = 1/f_int(tt);
%          Hmo_1min(ii,jj) = 4*sqrt(df*sum(px_int));
%     end
%     clear bb ee nc win noverlap px_int f_int
% end

for ii = 1:nogage
%     std_7min(ii) = std(Hmo_7min(ii,:));
%     num_7min = length(Hmo_7min(ii,:));
%     civar_7min(ii) = 1.96*std_7min(ii)/sqrt(num_7min);
%     ci_7min_hi(ii) = Hmo_full(ii) + civar_7min(ii);
%     ci_7min_lo(ii) = Hmo_full(ii) - civar_7min(ii);
%     
%     std_5min(ii) = std(Hmo_5min(ii,:));
%     num_5min = length(Hmo_5min(ii,:));
%     civar_5min(ii) = 1.96*std_5min(ii)/sqrt(num_5min);
%     ci_5min_hi(ii) = Hmo_full(ii) + civar_5min(ii);
%     ci_5min_lo(ii) = Hmo_full(ii) - civar_5min(ii);
%     
    std_3min(ii,zz) = std(Hmo_3min(ii,:));
    num_3min(zz) = length(Hmo_3min(ii,:));
    civar_3min(ii,zz) = 1.96*std_3min(ii,zz)/sqrt(num_3min(zz));
    %ci_3min_hi(ii,zz) = Hmo_full(ii) + civar_3min(ii,zz);
    %ci_3min_lo(ii,zz) = Hmo_full(ii) - civar_3min(ii,zz);

    
%     std_1min(ii) = std(Hmo_1min(ii,:));
%     num_1min = length(Hmo_1min(ii,:));
%     civar_1min(ii) = 1.96*std_1min(ii)/sqrt(num_1min);
%     ci_1min_hi(ii) = Hmo_full(ii) + civar_1min(ii);
%     ci_1min_lo(ii) = Hmo_full(ii) - civar_1min(ii);
% 
%     num_tot = sum(num_7min + num_5min + num_3min + num_1min);
%     std_ave(ii) = sum(std_7min(ii) + std_5min(ii) + std_3min(ii) + std_3min(ii))/4;
%     civar_tot(ii) = 1.96*std_ave(ii)/sqrt(num_tot);
    
    
end