function ww3_nest_mask(maskfile,coord1,coordn)

fid = fopen(maskfile);

lon = coord1.lonw*60:coord1.lonres*60:coord1.lone*60;
lat = coord1.lats*60:coord1.latres*60:coord1.latn*60;

for jj = 1:length(lat)
    data = fscanf(fid,'%i',length(lon));
    mask(:,jj) = data;
end
fclose(fid);
ii1 = find(round(lon) == coordn.lonw*60);
ii2 = find(round(lon) == coordn.lone*60);

jj1 = find(round(lat) == coordn.lats*60);
jj2 = find(round(lat) == coordn.latn*60);

mask2 = mask;
mask2(ii1:ii2,jj1) = 2;
mask2(ii1:ii2,jj2) = 2;
mask2(ii1,jj1:jj2) = 2;
mask2(ii2,jj1:jj2) = 2;

mask2(mask == 0) = 0;
fout = [maskfile(1:end-5),'new','.mask'];
fid = fopen(fout,'w');
for jj = 1:length(lat)
    fprintf(fid,' %d ',mask2(:,jj));
    fprintf(fid,'\n');
end
fclose(fid);