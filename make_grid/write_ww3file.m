function [messg,errno] = write_wwIIIfile(fname,d);

% -------------------------------------------------------------------------------------
%|                                                                                     |
%|                          +----------------------------+                             |
%|                          | GRIDGEN          NOAA/NCEP |                             |
%|                          |      Arun Chawla           |                             |
%|                          |                            |                             |
%|                          | Last Update :  31-Jul-2007 |                             |
%|                          +----------------------------+                             |
%|                                    Arun.Chawla@noaa.gov                             |
%|                          Distributed with WAVEWATCH III                             |
%|                                                                                     |
%|                     Copyright 2009 National Weather Service (NWS),                  |
%|       National Oceanic and Atmospheric Administration.  All rights reserved.        |
%|                                                                                     |
%| DESCRIPTION                                                                         |
%| Write the output array into ascii file                                              |
%|                                                                                     |
%| [messg,errno] = write_wwIIIfile(fname,d)                                            |
%|                                                                                     |
%| INPUT                                                                               |
%|  fname       : Output file name                                                     |
%|  d           : Output 2D array                                                      | 
%|                                                                                     |
%| OUTPUT                                                                              |
%|  messg       : Error message. Is blank if no error occurs                           |
%|  errno       : Error number. Is zero for succesful write                            |
% -------------------------------------------------------------------------------------
[Ny,Nx] = size(d);

fid = fopen(fname,'w');

[messg,errno] = ferror(fid);

if (errno == 0)
   for i = 1:Ny
       %a = d(i,:); commented out to remove decimal dependence TJH 20120731
       a = fix(d(i,:));
       fprintf(fid,' %d ',a);
       fprintf(fid,'\n');
   end;
else
   fprintf(1,'!!ERROR!!: %s \n',messg);
end;

fclose(fid);

return;
