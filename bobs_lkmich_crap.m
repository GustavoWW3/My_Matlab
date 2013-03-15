% load in lake michigan station onlns files at all storms and 
% store in a mat file
clear all

stations = ['ST00010';'ST00046';'ST00088';'ST00098';'ST00175'; ...
    'ST00201';'ST00289';'ST00337';'ST00492';'ST00529'];
dataset = [3,7,8,12,13,14,15,16,17,18,19];
storms = dir('STO*');
for zz = 1:size(storms,1)
    fprintf(1,'Storm number: %6s\n',storms(zz).name);
    cd([storms(zz).name,'/outdat']);
    tarfile = ls('*onlns.tgz');
    untar(tarfile);
    
    if zz == 1
        for qq = 1:size(stations,1)
            aa = load([stations(qq,:),'.onlns']);
            bb{qq} = aa(:,dataset);
        end
    else
        for qq = 1:size(stations,1)
            aa = load([stations(qq,:),'.onlns']);
            bb{qq} = [bb{qq};aa(:,dataset)];
        end
    end
    cd ../../
end
for qq = 1:size(stations,1)
   eval(['cc.',stations(qq,:),'=bb{qq}']);
end
    

    
        
        
    
    