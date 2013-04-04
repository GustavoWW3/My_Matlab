function out_xyz(dirn,fname,x,y,z)
%
%  out_xyz
%    - created 01/29/2013 by TJ Hesser
%    - creates ascii file with 3 columns x, y, z
%
%  INPUT:
%    dirn   -  (Character) Directory structure for file placement
%    fname  -  (Character) Filename for output file
%    x      -  (Array) Diminsion 1 in z array
%    y      -  (Array) Diminsion 2 in z array
%    z      -  (Array) (LEN(x) x LEN(y))
%
% ---------------------------------------------------------------------
if ~exist(dirn,'dir')
    mkdir(dirn);
end
cd(dirn);
fid = fopen(fname,'w');

for jj = 1:length(y)
    for ii = 1:length(x)
        fprintf(fid,'%12.6f %12.6f %12.6f\n',x(ii),y(jj),z(ii,jj));
    end
end
fclose(fid);