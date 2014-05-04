function [mod_out,mod_bias,mod_rmse,alt_out,blah,yearmon] = alt_stat1(alt_data)

fname = dir('*-hss.tgz');
untar(fname.name)
yearmon = fname.name(1:6);
bbop = dir('*.hs');

% mod_bias = cell(bbop-1);alt_out = cell(bbop-1); mod_rmse =cell(bbop-1);
% blah = cell(bbop-1);
for zz = 1:size(bbop,1)-1
    fid = fopen(bbop(zz).name);
    data = fgetl(fid);
    nlon = str2num(data(48:50));
    nlat = str2num(data(68:70));
    
    for jj = 1:nlat
        data = fscanf(fid,'%f',nlon);
        hs(jj,:) = data;
    end
    fclose(fid);
    
     mod_out(:,:,zz) = hs*0.01;
     for qq = 1:size(alt_data,2)
        alt_out{qq}(:,:,zz) = alt_data(qq).alt_data(zz).Hs_grid;
     %mod_bias{qq}(:,:,zz) = hs*0.01 - alt_data(qq).alt_data(zz).Hs_grid;
        mod_bias{qq}(:,:,zz) = mod_out(:,:,zz) - alt_out{qq}(:,:,zz);
        mod_rmse{qq}(:,:,zz) = (mod_out(:,:,zz) - alt_out{qq}(:,:,zz)).^2;
        blah{qq}(zz) = max(max(alt_out{qq}(:,:,zz)));
        for jj = 1:size(alt_out{qq},2)
            pp = (isnan(alt_data(qq).alt_data(zz).Hs_grid(:,jj))  | hs(:,jj) == -999);
            mod_bias{qq}(pp,jj,zz) = NaN;
            alt_out{qq}(pp,jj,zz) = NaN;
            mod_rmse{qq}(pp,jj,zz) = NaN;
            clear pp
        end
     end    
end