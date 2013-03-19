function [tit,outdir] = EXP_longterm_names(year1,year2,model,grid) 

tit1 = ['Example Basin Longterm Analysis'];
tit2 = ['Model = ',model];
tit3 = ['Grid = ',gridc];
tit4 = ['Time = ',year1,' - ',year2];
tit = {tit1;tit2;tit3;tit4};

outdir = ['/Example/location/of/Validation/mat/files/'];
if ~exist(outdir,'dir');
    mkdir(outdir);
end

