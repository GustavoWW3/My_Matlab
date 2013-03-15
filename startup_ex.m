% startup file 

% Set up some default fonts and sizes for plotting
 
set(0,'DefaultTextFontSize',12);
set(0,'DefaultAxesFontSize',12);
set(0,'DefaultAxesFontname','Times');
set(0,'DefaultTextFontname','Times');
set(0,'DefaultAxesBox','off');

% Set any local user paths
%   such as your home Matlab directory)
%dplocal = '/net/massey/export/data/blue/disk1/massey/My_Matlab/';
dplocal = '/home/thesser1/My_Matlab/';
path(path,[dplocal,'m_map']);
path(path,[dplocal,'googleearth']);
path(path,[dplocal,'ice_matlab']);
path(path,[dplocal,'SWIMS']);
path(path,[dplocal,'Altimeter']);
path(path,[dplocal,'Buoy_analysis']);
path(path,[dplocal,'WAM_proc']);
path(path,[dplocal,'WW3_proc']);
path(path,[dplocal,'NDBC_hdf5_2_vsp']);
path(path,[dplocal,'NDBC_hdf5']);
path(path,[dplocal,'Wis_plot']);
path(path,[dplocal]);
cd(dplocal);
clear dplocal
