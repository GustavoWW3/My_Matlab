x_range = ncread('gebco_08.nc','x_range');
y_range = ncread('gebco_08.nc','y_range');

% y range actually goes from 89 59 45N to 89 59 45S
% x range goes from 179 59 45W to 179 59 45E
xx = x_range(1)*3600+30:30:x_range(2)*3600-30;
xx = xx/3600;
yy = y_range(2)*3600-30:-30:y_range(1)*3600+30;
yy = yy/3600;

iymax = find(yy >= ymax & yy < ymax+0.0083);
iymin = find(yy <= ymin & yy > ymin-0.0083);

ixmax = find(xx <= xmax & xx > xmax-0.0083);
ixmin = find(xx >= xmin & xx < xmin+0.0083);
nn = 0;
for jj = iymax:iymin
    nn = nn + 1;
    blah(nn,:) = ncread('gebco_08.nc','z',ixmin+((jj-1)*43200),ixmax-ixmin);
end