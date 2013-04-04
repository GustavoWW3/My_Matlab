function xy = make_xy(lonw,lone,lats,latn,res)

% creates longitude and latitude coordinates for arc second resolution
%   created 11/16/2012  TJ Hesser

lonsw = lonw*3600;
lonse = lone*3600;
latss = lats*3600;
latsn = latn*3600;

lonsg = lonsw:res:lonse;
latsg = latsn:-res:latss;
xy = zeros(length(lonsg)*length(latsg),2);
latttn = zeros(length(lonsg)*length(latsg),1);

lonnn = repmat(lonsg',length(latsg),1);
for jj = 1:length(latsg)
    latttn(((jj-1)*length(lonsg))+[1:length(lonsg)],1) = latsg(jj);
end
xy = [lonnn,latttn];
