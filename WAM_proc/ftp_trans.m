f = ftp('134.164.34.99','chluser','5kit5kat');
%f = ftp('134.164.34.99','chlguest','3bit5map');
cd(f,'thesser/Lake_Stclair');
h = dir(f);
%for zz = 1:size(h,1)
%    fname = getfield(h,'name');
    cd(f,getfield(h,'name'));
binary(f);
mget(f,'*.tgz');

delete(f,'*.tgz');
cd(f,'../');
rmdir(f,getfield(h,'name'));
close(f);