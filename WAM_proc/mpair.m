function [indx1,indx2]=mpair(t1,t2,tol);
%MPAIR Function to match times of two time vectors 
%within specified tolerance(in minutes).
%
% [indx1,indx2]=mpair(t1,t2,tol)
%
%For best results, make set t1 to the time series
%with the largest time step or coarsest resolution.
%
%Example:  For two timeseries with timestamps, t1 & t2,
%          enter 
%                [i1,i2]=mpair(t1,t2,5);
%          to produce the vectors i1 and i2 that contain
%          the indexes to tn1 and tn2, respectively, that
%          produce a match within the tolerance, 5 minutes.
%          
%
%Jarrell Smith
%Waterways Experiment Station
%

error(nargchk(3,3,nargin));

tol=tol/60/24;

%t1 and t2 are vectors containing date numbers for the two data sets
m=0;
nt=length(t2);
indx2=zeros(size(t1));
indx1=indx2;
for i=1:length(t1),
    if i==1,
        diff=abs(t1(i)-t2(:));
        mindiff=min(diff);
        id=min(find(diff==mindiff));
        idp=id;
    else,
        i2=min(idp+100,nt);     %note:  the 100-element window size is arbitrary
        diff=abs(t1(i)-t2(idp:i2));
        mindiff=min(diff);
        id=min(find(diff==mindiff))+(idp-1);
        idp=id;
    end
    if mindiff<=tol,
        m=m+1;
        indx2(m)=id;
        indx1(m)=i;
    end
end
indx2=indx2(1:m);
indx1=indx1(1:m);