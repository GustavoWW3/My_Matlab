function aa = read_flume_bathy(slope,dx,fdir)

if isunix 
    slash = '/';
else
    slash = '\';
end
ss = [25,50];
if ~ismember(slope,ss) 
    slope = input('Slope must equal either 25 or 50, please respond: ');
end

fname = [fdir,slash,'flume_mm',num2str(slope),'_xyz.dat'];
if ~exist(fname,'file')
    unzip('2D_bathymetry.zip');
end

try
    bb = load(fname);
catch
    fprintf(1,'Bathy file does not exist in directory listed\n');
    return
end

[X,Y] = meshgrid(min(bb(:,1)):dx:max(bb(:,1)),min(bb(:,2)): ...
    dx:max(bb(:,2)));
depth = griddata(bb(:,1),bb(:,2),bb(:,3),X,Y);

aa.xgrid = X;
aa.ygrid = Y;
aa.zgrid = depth;

center = round(size(aa.xgrid,1)/2);
aa.x1d = X(center,:);
aa.z1d = depth(center,:);



