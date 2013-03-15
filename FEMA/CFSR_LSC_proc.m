clear all

cd ('G:\CFSR Great Lakes\winpre');

files = dir('*.pre.gz');

for zz = 1:size(files,1)
    filename = getfields(files(zz),'name');
    if filename(1:4) >= 2000
        filenamew = [filename(1:21),'win.gz']
         gunzip(filename);
        % gunzip(filenamew);                
        
        fid = fopen('fort.15','wt');
        fprintf(fid,'%10.5f %9.5f %9.5f %9.5f %9.5f %9.5f\n', ...
            0.02000,0.02000,42.25000,42.75000,-83.00000,-82.35000);
        
        fname = filename(1:24);
       % fnamew = filenamew(1:24);
        mon = filename(5:6);
        monnum = str2num(mon);
        if monnum < 9
            mon2 = ['0',num2str(monnum+1)];
        else
            mon2 = num2str(monnum+1);
        end
        date1 = [filename(1:6),'0100'];
        date2 = [filename(1:4),mon2,'0100'];
        name = ['WIS-LKSTCL-CPRE',filename(1:4),'-',mon];
        
        fprintf(fid,'%11s %10s %22s\n',date1,date2,name);
        %fprintf(fid,'%24s\n',fnamew);
        fprintf(fid,'%24s',fname);
        
        fclose(fid)
        
        system('C:\Great_lakes\CFSR_Met_Data_Prep\CFSR-SUBS-V2')
        
        delete fort.15
        delete(fname)
        delete(fnamew)
        
        namep = [name,'.PRE'];
        namew = [name,'.WND'];
        
        delete(namew)
        
        movefile(namep,'F:\LAKESTCLAIR')
    end
end