function [lon_new,lat_new,dep_new] = new_grid_res(lon,lat,depth,res)

resx = (lon(2)-lon(1))*3600;
resy = (lat(2)-lat(1))*3600;

stepx = round(res/resx);
stepy = round(res/resy);

lon_new = lon(1:stepx:end);
lat_new = lat(1:stepy:end);
dep_new = depth(1:stepy:end,1:stepx:end);

