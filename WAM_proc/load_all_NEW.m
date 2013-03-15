function load_all_NEW(buoyid)
%
%  buoyid       NUMERIC
%
   buoyin = int2str(buoyid);
%
%  Loop over 2 input file sets OWI and CFSR

for mm=1:1
     if mm == 1
         files = dir('*OWI.asc');
     else
         files = dir('*OWI.asc');
     end
for zz = 1:size(files,1)
    filename1 = files(zz).name;
    fid1= fopen(filename1);
    data = textscan(fid1,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',4);
    for jj = 1:35
        wave{zz}(:,jj) = data{jj};
    end
        for qq = 1:4
            if wave{zz}(qq,25) < 100.0
                wave{zz}(qq,8:end) = NaN;
            end
        end
    fclose(fid1);
end
nmo = wave{1}(4,2) - 1;
if mm == 1
  fname=['stats_',buoyin,'_WW3-ST4.All'];
  fid = fopen(fname,'wt');
else
  fname=['stats_',buoyin,'_WAMCY452C-060.All'];
  fid = fopen(fname,'wt');
 end
for zz = 1:size(files,1)
  for qq = 1:5
    if (wave{zz}(4,2) ~= nmo+1)
        for ii = 1:4
            fprintf(fid,'%6i%6i%6i%6i',wave{zz-1}(ii,1),nmo+1,wave{zz-1}(ii,3),wave{zz-1}(ii,4));
            for jj = 5:34
                fprintf(fid,'%8.2f',NaN);
            end
            fprintf(fid,'%8.2f\n',NaN);
        end
        nmo = nmo + 1;
        if nmo == 12
            nmo = 0;
        end
    else
        break
    end
  end
    
    for ii = 1:4
        for jj = 1:35
            if jj <= 4
                fprintf(fid,'%6i',wave{zz}(ii,jj));
            elseif jj == 35
                fprintf(fid,'%8.2f\n',wave{zz}(ii,jj));
            else
                fprintf(fid,'%8.2f',wave{zz}(ii,jj));
            end
        end
    end
nmo = wave{zz}(4,2);
if nmo == 12
    nmo = 0;
end
end

fclose(fid);
end