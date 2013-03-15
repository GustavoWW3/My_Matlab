function get_cfsr(startdate,enddate,cfsrdir)

%  startdate     numeric  yearmon  199904
%  enddate       numeric  yearmon  199905
%  cfsrdir       string   directory for cfsr winds  'E:\'

winddir = [cfsrdir,'winpre'];

start = num2str(startdate);
finish = num2str(enddate);

f1 = dir([winddir,'\',start,'*']);
for zz = 1:2
    copyfile([winddir,'\',f1(zz).name],'.');
end
fname = ls('*.gz');
for ii = 1:2
    gunzip(fname(ii,:));
    delete(fname(ii,:));
end
if ~strcmp(finish,start)
    f2 = dir([winddir,'\',finish,'*']);
    for zz = 1:2
        copyfile([winddir,'\',f2(zz).name],'.');
    end
    fname = ls('*.gz');
    for ii = 1:2
        gunzip(fname(ii,:));
        delete(fname(ii,:));
    end
end
