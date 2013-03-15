clear all

files = dir('*.OUT');
for zz = 1:size(files,1)
    filename = getfield(files(zz,1),'name');
    
    year1 = filename(14:17);
   
    load4findstorms_ish(filename,year1,year1);
end