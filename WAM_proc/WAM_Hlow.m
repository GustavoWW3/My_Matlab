[fname,pth] = uigetfile('*.spe2d','WAM Spectral Output file: ');

file = [pth,fname];
[time freq ang ef] = read_WAM_spe2d(file);

ln = size(time,2);
for zz = 1:ln
    e1d{zz} = trapz(ang,ef{zz}');
    
    H_lo{zz} = 4.0*sqrt(trapz(freq{zz}(1:4),ef{zz}(1:4)));
    
end