function get_WIS_GOM(outfile)

%get_file = ['X:\Atlantic\Evaluation\WW3\Model\',outfile(end-6:end),'\'];
get_file = ['/mnt/CHL_WIS_1/GulfofMexico/Evaluation/WAM451C/Model/',outfile(end-6:end),'/'];
if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
locd{1} = 'L02';
locd{2} = 'L3W';
locd{3} = 'L3C1';
locd{4} = 'L3C2';
locd{5} = 'L3E';
loc{1} = [outfile,'/LEVEL1'];
loc{2} = [outfile,'/LEVEL2'];
loc{3} = [outfile,'/LEVEL3W'];
loc{4} = [outfile,'/LEVEL3C1'];
loc{5} = [outfile,'/LEVEL3C2'];
loc{6} = [outfile,'/LEVEL3E'];

year = outfile(end-6:end-3);
mon = outfile(end-1:end);

for zz = 1:length(locd)
     if ~exist(loc{zz+1},'dir')
         mkdir(loc{zz+1});
     end
    cd (loc{zz+1})
    ii = strfind(loc{zz},'LEVEL');
    %copyfile([get_file,'LEVEL',loc{zz}(ii+5:end),'/*-LEVEL', ...
    %    loc{zz}(ii+5:end),'-MMt.tgz'],'.');
    copyfile([get_file,'/*L',loc{zz+1}(ii+5:end),'*MMd.tgz'],'.');
    %fnamest = [get_file,'LEVEL',loc{zz}(ii+5:end),'/*-LEVEL', ...
    %        loc{zz}(ii+5:end),'-ST-onlns.tgz'];
    fnamest = [get_file,'/*L',loc{zz+1}(ii+5:end),'*onlns.tgz'];
    blah = dir(fnamest);
    if ~isempty(blah)
        copyfile(fnamest,'.');
    end
    ww3_read('GOM',year,mon)
    
end
archive_gom(year,mon);
system(['rm -rf ',outfile]);
end
