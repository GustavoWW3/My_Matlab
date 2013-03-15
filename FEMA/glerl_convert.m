clear all

%Unzip all years
gunzip('*.gz')

%Each lake is given a number
%0 --- Superior
%1 --- Michigan
%2 --- Huron
%3 --- St. Clair
%4 --- Erie
%6 --- Ontario
lake = input('What lake is being processes:  ');

%Load file in one at a time
%Write a fort.5 file for input into glerl2ISH_format.exe
%Run glerl2ISH_format.exe
files = dir('*.txt');
glerlconvert = 'C:\Great_lakes\ISH_Processing\src\glerl2ISH_formatV2.exe < fort.5';
for zz = 1:size(files,1);
    filename = getfield(files(zz,1),'name');
    
    year = str2double(filename(7:10));
    station = filename(1:5);
    stationc = upper(station);
    
    fid = fopen('fort.5','wt');
    fprintf(fid,'%4i %5s %5s \n',year,station,stationc);
    fprintf(fid,'%1i',lake);
    fclose(fid);
    
    system(glerlconvert)   
    
    
end