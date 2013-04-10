function process_NODC_netcdf(year,mon,statname)
% retrieve and process NODC netCDF4 files
% created 07/12 TJ. Hesser
if ~ischar(year)
    yearc = num2str(year);
else
    yearc = year;
end
if ~ischar(mon)
    if mon < 10
        monc = ['0',num2str(mon)];
    else
        monc = num2str(mon);
    end
else
    monc = mon;
end
if ~ischar(statname)
    statc = num2str(statname);
else
    statc = statname;
end
%get_nodc_buoy(year,mon,statname)
pname = 'http://data.nodc.noaa.gov/thredds/dodsC/ndbc/cmanwx/';
try
    fname = [pname,yearc,'/',monc,'/NDBC_',statc,'_',yearc, ...
        monc,'_D1_v00.nc'];
    binfo = ncinfo(fname);
catch
    fname = [pname,yearc,'/',monc,'/NDBC_',statc,'_',yearc, ...
        monc,'_D2_v00.nc'];
    try
        binfo = ncinfo(fname);
    catch
        fprintf(1,'Need specific name\n');
    end
end

onlform = ['%5s%6i%3i%3i%3i%3i%5i%5i%5i%5i%5i%5i%7.1f%6.2f%6.2f%6.2f', ...
    '%6.1f%7.2f%7.2f%7.1f%8.2f%8.2f%8.2f%8.2f%7.1f%7.1f%7.1f%7.1f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%10.4f%7.1f%7.1f%8.2f% 14.5E% 14.5E', ...
    '% 14.5E% 14.5E\n'];
sp1form1 = ['%5s%6i%3i%3i%3i%3i'];
%for zz = 1:size(files,1)
    nn = 1;
    [aa payload] = get_NDBC_air(fname);
%     if zz > 1 & files(zz).name(6:10) == stat
%         nn = 2;
%     end
%   stat = files(zz).name(6:10);
    [bb cc p] = get_NDBC_spec(fname,payload);
     
    fout = ['n',statc,'_',yearc,'_',...
    monc];
    foutone = [fout,'.onlns'];
    if nn == 1
        fid = fopen(foutone,'w');
    else
        fid = fopen(foutone,'a+');
    end
    for qq = 1:size(aa,1)
        fprintf(fid,onlform,statc,aa(qq,:),bb(qq,:));
    end
    fclose(fid);
    % print spec1d file
    if p == 1
        fspec1 = [fout,'.spe1d'];
        if nn == 1
            fid = fopen(fspec1,'w');
        else
            fid = fopen(fspec1,'a+');
        end
        for qq = 1:size(cc.c11,2)
            fprintf(fid,sp1form1,stat,aa(qq,1:5));
            for jj = 1:length(cc.freq)
                fprintf(fid,'%8.4f%12.6f',cc.freq(jj),cc.c11(jj,qq));
            end
            fprintf(fid,'\n');
        end
        fclose(fid);
    else
    % print spec2d file
        fspec1 = [fout,'.spe1d'];
        fspec2 = [fout,'.spe2e'];
        if nn == 1
            fid  = fopen(fspec1,'w');
            fid2 = fopen(fspec2,'w');
        else
            fid = fopen(fspec1,'a+');
            fid2 = fopen(fspec2,'a+');
        end
        for qq = 1:size(cc.c11,2)
            fprintf(fid,sp1form1,stat,aa(qq,1:5));
            fprintf(fid2,sp1form1,stat,aa(qq,1:5));
            for jj = 1:length(cc.freq)
                fprintf(fid,'%8.4f%12.6f',cc.freq(jj),cc.c11(jj,qq));
                fprintf(fid2,'%8.4f%8.4f%8.4f%6.1f%6.1f%12.6f',cc.freq(jj), ...
                    cc.r1(jj,qq),cc.r2(jj,qq),cc.alpha1(jj,qq), ...
                    cc.alpha2(jj,qq),cc.c11(jj,qq));
            end
            fprintf(fid,'\n');
            fprintf(fid2,'\n');
        end
        fclose(fid);
        fclose(fid2);
    end
%end    