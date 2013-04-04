% startup file 

% Set up some default fonts and sizes for plotting
 
set(0,'DefaultTextFontSize',10);
set(0,'DefaultAxesFontSize',10);
set(0,'DefaultAxesFontname','Arial');
set(0,'DefaultTextFontname','Arial');
set(0,'DefaultAxesBox','off');
set(0,'DefaultFigureRenderer','painters');

% Set any local user paths
%   such as your home Matlab directory)
%dplocal = '/net/massey/export/data/blue/disk1/massey/My_Matlab/';
dplocal = '/home/thesser1/My_Matlab/';
path(path,[dplocal,'export_fig']);
path(path,[dplocal,'exportfig']);
path(path,[dplocal,'Old_plotting']);
path(path,[dplocal,'utilities']);
path(path,[dplocal,'Extra_files']);
path(path,[dplocal,'utilities/m_map']);
path(path,[dplocal,'utilities/googleearth']);
path(path,[dplocal,'ice_matlab']);
path(path,[dplocal,'SWIMS']);
path(path,[dplocal,'Altimeter']);
path(path,[dplocal,'Buoy_analysis']);
path(path,[dplocal,'WAM_proc']);
path(path,[dplocal,'WW3_proc']);
path(path,[dplocal,'NDBC_hdf5_2_vsp']);
path(path,[dplocal,'NDBC_hdf5']);
path(path,[dplocal,'Wis_plot']);
path(path,[dplocal,'Wis_plot/GOM']);
path(path,[dplocal,'Wis_plot/PAC']);
path(path,[dplocal,'Wis_plot/ATL']);
path(path,[dplocal,'/utilities/matlab-cdi']);
path(path,[dplocal]);
cd(dplocal);
clear dplocal
