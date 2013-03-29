function ly = leapyear(year)

% Determine if a year is a leap year or not
%   Created 11/9/11 TJ Hesser  based off wikipedia page
%     Input
%      year  (Numeric) 
%     Output
%       ly = 1  Leap year
%       ly = 0  Not a Leap year

if mod(year,4) == 0 & mod(year,100) == 0 & mod(year,400) == 0
         ly = 1;
else
         ly = 0;
end