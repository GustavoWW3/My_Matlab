files = dir('*.zip');
for zz = 1:size(files,1);
    filename = getfield(files(zz,1),'name');
    unzip(filename);
end