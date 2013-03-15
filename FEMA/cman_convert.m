clear all

year1 = input('What is the first year?  ');
year2 = input('What is the last year?  ');
stat = input('What is the station name?  ','s');
lake = input('What is the lake?  ');

years = [year1:1:year2];
for ii = 1:size(years,2)
    cd(num2str(years(ii)))
    unzip_files
    
    fname4 = [stat,'-',num2str(years(ii)),'.ALL'];
    typef = ['type ',stat,'_',num2str(years(ii)),'.* > ',fname4]
    system(typef);
    
    fname = [num2str(years(ii)),'_All']
    fid = fopen(fname,'wt');
    fprintf(fid,'%5s %4i',stat,years(ii));
    fclose(fid);
    
    yearc = [num2str(years(ii)),'_All']
    fid2 = fopen('fort.5','wt');
    fprintf(fid,'%8s',yearc);
    fclose(fid2);
    
    
    
    system('C:\Great_Lakes\ISH_Processing\src\cman_PROC15.exe < fort.5')
    
    fname2 = ['n',stat,'_',num2str(years(ii)),'_ALL.onln']
    fname3 = ['n',stat,'_',num2str(years(ii)),'.ALL']
    
    copyfile(fname2,fname3);
    
    fid3 = fopen('fort.5','wt');
    fprintf(fid3,'%4i %5s \n',years(ii),stat);
    fprintf(fid3,'%1i \n',lake);
    fclose(fid3);
    1
    system('C:\Great_Lakes\ISH_Processing\src\cman2ISH_format.exe < fort.5')
    2
    cd ../
end
    
    