function [mod_out,mod_bias,mod_rmse,alt_out,blah,yearmon] = alt_WAM_stat1( ...
    alt_data)

fname = ls('*_Hst.tgz');
untar(fname)
yearmon = fname(end-13:end-8);
bbop = dir('c*0');

for zz = 1:size(bbop,1) - 1
    fid = fopen(bbop(zz).name);
    
    for jj = 257:-1:1
        data = fscanf(fid,'%10f',381);
        hs(:,jj) = data;
    end
    fclose(fid);
     hs2 = hs';
     mod_out(:,:,zz) = hs2;%*0.01;
     for qq = 1:size(alt_data,2)
     mod_bias{qq}(:,:,zz) = hs2 - alt_data(qq).alt_data(zz).Hs_grid;
     alt_out{qq}(:,:,zz) = alt_data(qq).alt_data(zz).Hs_grid;
     mod_rmse{qq}(:,:,zz) = (mod_out(:,:,zz) - alt_out{qq}(:,:,zz)).^2;
     blah{qq}(zz) = max(max(alt_out{qq}(:,:,zz)));
     for jj = 1:size(alt_out{qq},2)
         pp = (alt_data(qq).alt_data(zz).Hs_grid(:,jj) == -999 | hs2(:,jj) == -999);
         mod_bias{qq}(pp,jj,zz) = NaN;
         alt_out{qq}(pp,jj,zz) = NaN;
         mod_rmse{qq}(pp,jj,zz) = NaN;
         clear pp
     end
     end    
end