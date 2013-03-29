function [deg,min,sec,secd] = ddeg2dms(ddeg)

% converts decimial degrees to degrees minutes seconds
% written 6/29/11 TJ Hesser

deg = fix(ddeg);

min = fix(abs(ddeg - deg).*60);

secd = abs(abs(ddeg - deg).*60 - min).*60;
sec = fix(secd);

end
