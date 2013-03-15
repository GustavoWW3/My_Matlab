clear all

filesval = dir('*');
nnl = size(filesval,1);
filesbuoy = dir('../NDBC/*');
ntl = size(filesbuoy,1);
for zz = nnl+1:ntl
    dirname = getfield(filesbuoy(zz),'name');
    mkdir(dirname);
    cd(dirname);
    fname1 = ['../../NDBC/',dirname,'/n*'];
    fname2 = ['../../CFSR/',dirname,'/*WIS*'];
    fname3 = ['../../WPL2/',dirname,'/*WIS*'];
    copyfile(fname1,'.');
    copyfile(fname2,'.');
    copyfile(fname3,'.');
    
    year = str2num(dirname(1:4));
    mon = str2num(dirname(6:7));
    
    timeplt_WAM2_Pacific(year,mon,0.5,2)
    
    cd('../')
end