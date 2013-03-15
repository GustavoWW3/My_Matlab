function get_WIS_GOM(outfile)

%get_file = ['X:\Atlantic\Evaluation\WW3\Model\',outfile(end-6:end),'\'];
get_file = ['/mnt/CHL_WIS_1/GOM/Evaluation/WW3/Model/',outfile(end-6:end),'/'];
if ~exist(outfile,'dir')
    mkdir(outfile);
end
cd(outfile);
loc{1} = [outfile,'/LEVEL1'];
loc{2} = [outfile,'/LEVEL2'];
loc{3} = [outfile,'/LEVEL3W'];
loc{4} = [outfile,'/LEVEL3C1'];
loc{5} = [outfile,'/LEVEL3C2'];
loc{6} = [outfile,'/LEVEL3E'];

for zz = 1:length(loc)
%     if ~exist(loc{zz},'dir')
%         mkdir(loc{zz});
%     end
    cd (loc{zz})
%     ii = strfind(loc{zz},'level');
%    copyfile([get_file,'*-LEVEL',loc{zz}(ii+5:end),'-MMt.tgz'],'.');
%    copyfile([get_file,'*-LEVEL',loc{zz}(ii+5:end),'-ST-onlns.tgz'],'.');
    ww3_read_GOM
    
end
year = outfile(end-6:end-3);
mon = outfile(end-1:end);
archive_gom(year,mon);

end
