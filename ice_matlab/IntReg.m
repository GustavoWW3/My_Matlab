function m=IntReg(bbox)
%IntReg function to interactively select registration points for icemaps
%
%

%% Parameters
%bounding lat/lon for m_map
%blon=[-89,-84];
%blat=[41,46.5];
blon=bbox.blon;
blat=bbox.blat;

%% Load IceField
m=load_ice;

%% Create m_map shoreline
figure(1),clf
m_proj('lambert','lat',blat,'lon',blon)
m_gshhs_h
m_grid

%% Create icemap shoreline
figure(2),clf
% hpc=pcolor(m.x,m.y,m.iceval);
hpc=scatter(m.x(:),m.y(:),30,m.iceval(:),'filled');
% set(hpc,'EdgeColor','none');
set(gca,'clim',[-1,1])
axis equal

%% Give user opportunity to adjust figures
R=input('Adjust figures if necessary.  Press Return to continue.\n\n','s');

%% Collect registration points
N=input('How many registration points?  Min=4.\n');
fprintf(1,'Select %g registration points.\n Alternate between Fig 1 & 2, starting with Fig 1.\n',...
   N);

%%select registration points and display
X1=ones(N,2);
X2=ones(N,2);
figure(1)
hold on
figure(2)
hold on
for k=1:N
   figure(1)
   X1(k,:)=ginput(1);
   plot(X1(k,1),X1(k,2),'m+')
   text(X1(k,1),X1(k,2),num2str(k),...
      'Color','m',...
      'FontWeight','bold',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top');
   figure(2)
   X2(k,:)=ginput(1);
   plot(X2(k,1),X2(k,2),'m+')
   text(X2(k,1),X2(k,2),num2str(k),...
      'Color','m',...
      'FontWeight','bold',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top');
end
figure(1)
hold off
figure(2)
hold off


%% Determine Affine transformation from Reg pts
% X1 = X2*A (matrix multiplication)
% A = X2^-1 * X1
A=[X2,ones(N,1)]\[X1,ones(N,1)];

%% Transform Icemap coordinates to LCC, then to LatLon
X2lcc=[m.x(:),m.y(:),ones(numel(m.x),1)]*A;
[lon,lat]=m_xy2ll(X2lcc(:,1),X2lcc(:,2));
%reshape the output
m.lon=reshape(lon,size(m.x));
m.lat=reshape(lat,size(m.y));

%% Check IceMap
figure(3),clf
m_proj('lambert','lat',blat,'lon',blon)
in=m.iceval>=0;
m_plot(m.lon(in),m.lat(in),'.')
m_gshhs_h
hcst=findobj(gca,'tag','m_gshhs_h');
set(hcst,'Color','k','LineWidth',2)
m_grid

