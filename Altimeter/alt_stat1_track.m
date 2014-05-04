function [mod_track,mod_bias,track_lon,track_lat,yearmon] = alt_stat1(alt_data,nlon,nlat)

fname = dir('*-hss.tgz');
%untar(fname.name)
yearmon = fname.name(1:6);
bbop = dir('*.hs');

% mod_bias = cell(bbop-1);alt_out = cell(bbop-1); mod_rmse =cell(bbop-1);
% blah = cell(bbop-1);
for zz = 1:size(bbop,1)-1
    fid = fopen(bbop(zz).name);
    data = fgetl(fid);
    
    for jj = 1:nlat
        data = fscanf(fid,'%f',nlon);
        hs(jj,:) = data;
    end
    fclose(fid);
    
     mod_out(:,:,zz) = hs'*0.01;
    
     %for qq = 1:size(alt_data,2)
         for it = 1:length(alt_data(1).alt_data(zz).lonind)
             mod_track{zz}(it) = mod_out(alt_data.alt_data(zz).lonind(it), ...
                 alt_data.alt_data(zz).latind(it),zz);
         end
%         alt_out{qq}(:,:,zz) = alt_data(qq).alt_data(zz).Hs_grid;
%      %mod_bias{qq}(:,:,zz) = hs*0.01 - alt_data(qq).alt_data(zz).Hs_grid;
%         mod_bias{qq}(:,:,zz) = mod_out(:,:,zz) - alt_out{qq}(:,:,zz);
%         mod_rmse{qq}(:,:,zz) = (mod_out(:,:,zz) - alt_out{qq}(:,:,zz)).^2;
%         blah{qq}(zz) = max(max(alt_out{qq}(:,:,zz)));
%         for jj = 1:size(alt_out{qq},2)
%             pp = (isnan(alt_data(qq).alt_data(zz).Hs_grid(:,jj))  | hs(:,jj) == -999);
%             mod_bias{qq}(pp,jj,zz) = NaN;
%             alt_out{qq}(pp,jj,zz) = NaN;
%             mod_rmse{qq}(pp,jj,zz) = NaN;
%             clear pp
%         end
        mod_bias{zz} = mod_track{zz}' - alt_data.alt_data(zz).Hs;
        track_lon{zz} = alt_data.alt_data(zz).lon;
        track_lat{zz} = alt_data.alt_data(zz).lat;
        clear it
     % end    
end
 
1