
fid = fopen('coast.cst');

blah = fgetl(fid);
num = fscanf(fid,'%f',1);
si = fscanf(fid,'%f',2);

for ii = 1:num
    data = textscan(fid,'%f%f%f',si(1));
    lon{ii} = data{1};
    lat{ii} = data{2};
    if ii < num
      si = fscanf(fid,'%f',2);
       
    end
end
fclose(fid);