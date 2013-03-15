fid = fopen('basin_test.wave.out','r');
nsnaps = input('How many wave conditions: ');
data = fgetl(fid);
header = str2num(data);
nx = header(1);
ny = header(2);
dx = header(3);
%dy = header(4);
clear data

px = floor(nx*dx);
x = [0:0.01:1565*0.01-0.01];
x = x + 5.13;

for k=1:nsnaps
    
   data = fgetl(fid);
    %tval(k) = str2num(data);
   clear data
    
    for j=ny:-1:1
        data = fscanf(fid,'%f\n',nx);
        H(j,:,k) = data;
    end
    %fgetl(fid);
        
    for j=ny:-1:1
        data = fscanf(fid,'%f\n',nx);
        T(j,:,k) = data;
    end
    %fgetl(fid);
        
    for j=ny:-1:1
        data = fscanf(fid,'%f\n',nx);
        Dir(j,:,k) = data;
    end
%    % fget1(fid);
end



fclose(fid);
