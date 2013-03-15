function unzip_cdip(year,bb)

runcode = 'E:\CDIP\7z';

cd(['spc_',num2str(year)]);
%bo = ls('*');buoy = bo(3:end,:);
if bb < 100
    buoy = ['0',num2str(bb)];
else
    buoy = num2str(bb);
end
for zbuoy = 1:1%length(buoy)
    cd(buoy(zbuoy,:));fprintf(1,'Buoy number: %1s \n',buoy(zbuoy,:));pause(10);
    mo = ls('*'); mon = mo(3:end,:);
    for jmon = 1:length(mon)
        cd(mon(jmon,:));fprintf(1,'Month: %1s \n',mon(jmon,:));pause(10);
        pay = ls('*'); payload = pay(3:end,:);
        for ipay = 1:size(payload,1)
            cd(payload(ipay,:));
            fname = ls('*.Z');
            for qfile = 1:length(fname)
               ftext = [runcode,' e ',fname(qfile,:)];
               system(ftext);
            end
            delete *.Z;
            cd ../
        end
        cd ../
    end
    cd ../
end
