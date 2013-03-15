fid = fopen('basin_test.dep','r');
nsnaps = 1;

data = fgetl(fid);
header = str2num(data);
nx = header(1);
ny = header(2);
dx = header(3);
%dy = header(4);
clear data

for k=1:nsnaps
    
   
    for j=ny:-1:1
        data = fscanf(fid,'%f\n',nx);
        depth(j,:,k) = data;
    end

end


fclose(fid);
