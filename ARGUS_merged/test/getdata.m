test=ftp('cil-ftp.oce.orst.edu','ftp','Katherine.L.Brodie@usace.army.mil');

nowtime=now;
stime=datestr(nowtime);
month=stime(4:6);
[yr,mn,dayofmonth]=datevec(nowtime);
dayofyear=nowtime-datenum(yr,0,0);

if yr==2013
    cd(test,'pub/argus02a/2013/cx')
else
    cd(test,'pub/argus02a/2012/cx')
end

foldername=[sprintf('%.0f',dayofyear-1) '_' month '.' sprintf('%02.0f',dayofmonth)];
fprintf('%s\n',foldername);
mkdir(foldername);

cd(test,foldername)
mget(test,'*.var.merge.png',foldername)
mget(test,'*.timex.merge.png',foldername)
mget(test,'*.bright.merge.png',foldername)
mget(test,'*.dark.merge.png',foldername)

close(test)