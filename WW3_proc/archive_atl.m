function archive_atl(year,mon)

yeardmon = [year,'-',mon];
BASE = 'C:\WIS\Atlantic\WW3_multi';
BASEA = 'X:\Atlantic\Evaluation\WW3';
arcf = [BASEA,'\Figures\',yeardmon];
out = [BASE,'\',yeardmon];


if ~exist(arcf,'dir')
    mkdir(arcf);
end

loc{1} = 'level1';
loc{2} = 'level2';
loc{3} = 'level3N';
loc{4} = 'level3C';
loc{5} = 'level3S1';
loc{6} = 'level3S2';

for zz = 1:6
    val = [out,'\',loc{zz},'\Validation\'];
    arcv = [BASEA,'\Validation\WIS\',yeardmon,'\',loc{zz},'\'];
    arcfl = [arcf,'\',loc{zz},'\'];
    if ~exist(arcv,'dir')
        mkdir(arcv);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    
    copyfile([out,'\',loc{zz},'\*.png'],arcfl);
    copyfile([val,'\*'],arcv);
end