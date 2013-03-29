function [decideg] = dms2ddeg(deg,min,sec)
% converts degrees minutes seconds to decimal degrees
% written 6/29/11 TJ Hesser

decideg = deg + min./60 + sec./3600;

end