function get_WIS_Pac(filediam,outfile)

cd(outfile);
loc1 = outfile;
loc2 = [outfile,'/nest1'];
loc3 = [outfile,'/nest2'];
loc4 = [outfile,'/nest3'];
ww3_read

cd(loc4) 
ww3_read_015

cd(loc3)
ww3_read_008

cd(loc2)
ww3_read_025

cd(loc1);
system(['/home/thesser1/Pacific/archive_pac.sh ',filediam(1:4),' ', ...
    filediam(5:6)]);
end