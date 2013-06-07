function hpol = rose_polar(theta,rho,line_style,num_spokes,maxrho)
%
%
% ROSE_POLAR Specialized polar plot for wave/wind roses.
%
%   Modified from matlab's polar.m by GAC (look for GAC tags below).
%
%   ROSE_POLAR(THETA, RHO, LINE_STYLE, NUM_SPOKES) makes a plot 
%   using polar coordinates of the angle THETA, in radians, versus 
%   the radius RHO using string LINE_STYLE with NUM_SPOKES angular 
%   divisions.
%
%   Called by cdip_rose.m

if nargin < 1
    error('Requires 2 or 3 input arguments.')
elseif nargin == 2 
    if isstr(rho)
        line_style = rho;
        rho = theta;
        [mr,nr] = size(rho);
        if mr == 1
            theta = 1:nr;
        else
            th = (1:mr)';
            theta = th(:,ones(1,nr));
        end
    else
        line_style = 'auto';
    end
elseif nargin == 1
    line_style = 'auto';
    rho = theta;
    [mr,nr] = size(rho);
    if mr == 1
        theta = 1:nr;
    else
        th = (1:mr)';
        theta = th(:,ones(1,nr));
    end
end
if isstr(theta) | isstr(rho)
    error('Input arguments must be numeric.');
end
if ~isequal(size(theta),size(rho))
    error('THETA and RHO must be the same size.');
end

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
    hold on;
%    maxrho = max(abs(rho(:)));
    hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
    set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
    v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);

% check radial limits and ticks
% GAC - modified

    minrho = min(abs(rho(:)));
    rmin = minrho; rmax = v(4); 

% GAC - modified
%   rticks = max(ticks-1,2);
    rticks = ticks;
    if rticks > 7   % see if we can reduce the number
        if rem(rticks,2) == 0
            rticks = rticks/2;
        elseif rem(rticks,3) == 0
            rticks = rticks/3;
        end
    end

% define a circle
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if ~isstr(get(cax,'color')),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end

% DRAW RADIAL CIRCLES

    c82 = cos(82*pi/180);
    s82 = sin(82*pi/180);
    rinc = (rmax-rmin)/rticks;

    for i= rmin:rinc:rmax

        hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',1,...
                   'handlevisibility','off');

        if ( i == rmin ) 
          set(hhh,'linestyle','-','linewidth',1) 
        else
          frq = round((i-rmin)*100);
	  frq = frq/100;
          text((i-rmin+rinc)*c82,(i-rmin+rinc)*s82, ...
            num2str(frq),'verticalalignment','bottom',...
            'horizontalalignment','center','color',[0 0 1],...
            'handlevisibility','off')
        end
    end
    text((1.2*rmax)*c82,(1.2*rmax)*s82, {'frequency';'    of';'occurrence'}, ...
            'horizontalalignment','left','color',...
	    [0 0 1],'verticalalignment','bottom', ...
            'handlevisibility','off')

% MAKE OUTSIDE CIRCLE SOLID 

    set(hhh,'linestyle','-','linewidth',1);

% PLOT SPOKES AND ANNOTATE WITH DEGREE MARKERS

    rt = 1.1*rmax;
    rtt = 1.3*rmax;

    for ( th = (1/num_spokes : 1/num_spokes: 1)*2*pi )
      cst = cos(th); snt = sin(th);
      x = [ rmin*cst (rmax)*cst ];
      y = [ rmin*snt (rmax)*snt ];
      plot(x,y,ls,'color',tc,'linewidth',1,...
         'handlevisibility','off')

      spoke_degree = round(th * (180 / pi) * 10)/10;
      if ( spoke_degree == 360 ) spoke_degree = 0; end
      text(rt*cst,rt*snt,num2str(spoke_degree),...
             'horizontalalignment','center',...
             'handlevisibility','off');

    end


% PUT 'N', 'S', 'E', 'W' ON PLOT

    text(rtt*cos(0),rtt*sin(0),'N', ...
            'horizontalalignment','center',...
             'fontsize',16,...
             'color','r',...
             'handlevisibility','off');
    text(rtt*cos(pi/2),rtt*sin(pi/2),'E', ...
             'horizontalalignment','center',...
             'fontsize',16,...
             'color','r',...
             'handlevisibility','off');
    text(rtt*cos(pi),rtt*sin(pi),'S', ...
             'horizontalalignment','center',...
             'fontsize',16,...
             'color','r',...
             'handlevisibility','off');
    text(rtt*cos(-pi/2),rtt*sin(-pi/2),'W', ...
             'horizontalalignment','center',...
             'fontsize',16,...
             'color','r',...
             'handlevisibility','off');

% set view to 2-D
    view(2);

% set axis limits
    axis(rmax*[-1 1 -1.15 1.15]);

end  % if hold_state

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hpol = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')


