function archive_pac(year,mon)

yeardmon = [year,'-',mon];
BASE = '/home/thesser1/Pacific/WW3_multi_tst/';
BASEA = '/mnt/CHL_WIS_1/Pacific/Production/';
arcf = [BASEA,'/Figures/',yeardmon];
out = [BASE,'/',yeardmon];
arcm = [BASEA,'/Model/',yeardmon];
if ~exist(arcm,'dir')
    mkdir(arcm);
end

if ~exist(arcf,'dir')
    mkdir(arcf);
end

loc{1} = 'grd1';
loc{2} = 'grd2';
loc{3} = 'grd3';
loc{4} = 'grd4';

for zz = 1:4
    %val = [out,'/',loc{zz},'/Validation/'];
    %arcv = [BASEA,'/Validation/WIS/',yeardmon,'/',loc{zz},'/'];
    arcfl = [arcf,'/',loc{zz},'/'];
    arcml = [arcm,'/',loc{zz},'/'];
    %if ~exist(arcv,'dir')
    %    mkdir(arcv);
    %end
    if ~exist(arcfl,'dir')
        mkdir(arcfl);
    end
    if ~exist(arcml,'dir')
        mkdir(arcml);
    end
    system(['cp ',out,'/',loc{zz},'/*.tgz ',arcml]);
    system(['cp ',out,'/',loc{zz},'/*.png ',arcfl]);
    %system(['cp ',val,'/* ',arcv]);
end
val = [BASE,'/Validation/WIS/',yeardmon];
arcv = [BASEA,'/Validation/WIS/',yeardmon,'/'];
system(['cp ',val,'/* ',arcv]);