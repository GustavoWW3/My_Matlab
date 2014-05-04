function [mod_bias3,mod_rmse3,alt_out3,mod_si] = alt_stat2(mod_bias, ...
    mod_rmse,alt_out)

 mod_bias2 = zeros(size(mod_bias,1),size(mod_bias,2),25);
 mod_bias3 = zeros(size(mod_bias,1),size(mod_bias,2));
 mod_rmse2 = zeros(size(mod_rmse,1),size(mod_rmse,2),25);
 mod_rmse3 = zeros(size(mod_rmse,1),size(mod_rmse,2));
 alt_out2 = zeros(size(alt_out,1),size(alt_out,2),25);
 alt_out3 = zeros(size(alt_out,1),size(alt_out,2));
 mod_si = zeros(size(mod_rmse,1),size(mod_rmse,2));
 distx = [3 2 1 2 3 3 2 1 2 3 3 2 1 2 3 3 2 1 2 3 3 2 1 2 3];
 disty = [3 3 3 3 3 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3];
 dist = sqrt(distx.^2 + disty.^2);
% 
for jj = 3:size(alt_out,2)-2
    for ii = 3:size(alt_out,1)-2
%        ppx = [ii-1,ii,ii+1,ii-1,ii,ii+1,ii-1,ii,ii+1];
%        ppy = [jj+1,jj+1,jj+1,jj,jj,jj,jj-1,jj-1,jj-1];
       ppx = [ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii, ...
          ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2,ii-2,ii-1,ii,ii+1,ii+2];
       ppy = [jj+2,jj+2,jj+2,jj+2,jj+2,jj+1,jj+1,jj+1,jj+1,jj+1,jj,jj,jj, ...
           jj,jj,jj-1,jj-1,jj-1,jj-1,jj-1,jj-2,jj-2,jj-2,jj-2,jj-2];
       
       for zz = 1:25
           qq = ~isnan(alt_out(ppx(zz),ppy(zz),:));
           mod_bias2(ii,jj,zz) = mean(mod_bias(ppx(zz),ppy(zz),qq));
           alt_out2(ii,jj,zz) = mean(alt_out(ppx(zz),ppy(zz),qq));
           mod_rmse2(ii,jj,zz) = mean(mod_rmse(ppx(zz),ppy(zz),qq));
       end
       clear qq
       qq = ~isnan(alt_out2(ii,jj,:));
       disttot = sum(1./dist(qq).^2);
       aout2(:,1) = alt_out2(ii,jj,qq);
       alt_out3(ii,jj) = sum(aout2./dist(qq)'.^2)./disttot;
       modb2(:,1) = mod_bias2(ii,jj,qq);
       mod_bias3(ii,jj) = sum(modb2./dist(qq)'.^2)./disttot;
       modr2(:,1) = mod_rmse2(ii,jj,qq);
       mod_rmse3(ii,jj) = sum(modr2./dist(qq)'.^2)./disttot;
       %mod_bias3(ii,jj) = mean(mod_bias2(ii,jj,qq));
       %mod_rmse3(ii,jj) = sqrt(sum(mod_rmse2(ii,jj,qq))/length(qq));
       mod_si(ii,jj) = mod_rmse3(ii,jj)./alt_out3(ii,jj).*100;
       clear qq aout2 disttot modb2 modr2
    end
end