function archive_atl(year,mon)

yeardmon = [year,'-',mon];
BASE = '/home/thesser1/ATL/model';
BASEA = '/mnt/CHL_WIS_1/Atlantic/Evaluation/WW3';
arcf = [BASEA,'/Figures/',yeardmon];
out = [BASE,'/',yeardmon];


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
    ii = strfind(loc{zz},'level');
    levn = loc{zz}(ii+5:end);
    val = [out,'/','level',levn,'/Validation/'];
    arcv = [BASEA,'/Validation/WIS/',yeardmon,'/','level',levn,'/'];
    arcfl = [arcf,'/level',levn,'/'];
    if ~exist(arcv,'dir')
        mkdir(arcv);
    end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    
    system(['cp ',out,'/level',levn,'/*.png ',arcfl]);
    system(['cp ',val,'/* ',arcv]);
end