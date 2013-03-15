function m=load_ice(fn)
%LOAD_ICE function to load NOAA Ice Fields
%  m = load_ice
%  m = load_ice(fn)
% where,
%  m = struct containing ice data
%  fn = filename
%

%% Check input
error(nargchk(0,1,nargin));
if nargin==0,
   [fn,pn]=uigetfile('*.lce');
   if isnumeric(fn),return,end
   fn=fullfile(pn,fn);
end

%% Open file and load header info
fid=fopen(fn,'rt');
str=fgetl(fid);
m.name=sscanf(str,'%*s %s');
str=fgetl(fid);
m.datestr=sscanf(str,'%*s %s');
m.mtime=datenum(m.datestr,'yyyymmdd');
str=fgetl(fid);
m.ncols=sscanf(str,'%*s %f');
str=fgetl(fid);
m.nrows=sscanf(str,'%*s %f');
str=fgetl(fid);
m.xllcorner=sscanf(str,'%*s %f');
str=fgetl(fid);
m.yllcorner=sscanf(str,'%*s %f');
str=fgetl(fid);
m.cellsize=sscanf(str,'%*s %f');
fgetl(fid); %skip the NODATA line

%%Set Lambert coordinates for map
x=m.xllcorner+ m.cellsize*(0:m.ncols-1);
y=m.yllcorner+ m.cellsize*(0:m.nrows-1);
[m.x,m.y]=meshgrid(x,y);

%%Read the rest of file
dat=textscan(fid,'%f');
m.iceval=reshape(dat{1},m.ncols,m.nrows)';
m.iceval=flipud(m.iceval);
in=m.iceval<-10;
m.iceval(in)=nan;
%close file
fclose(fid);

