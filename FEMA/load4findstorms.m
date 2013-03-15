function load4findstorms(stnam,startdate,enddate)

%filein=['n',stnam,'_',startdate,'_',enddate];
filein = ['n',stnam,'-',startdate,'-',enddate,'.ALL'];
%A = eval(['load ',filein,'.ALL']);
A = load(filein);
%eval(['A=',filein,';']);
eval(['clear ',filein]);

h=A(:,21);
Tp=A(:,23);
THM=A(:,25);
inanTH=find(A(:,25) < 0);
THM(inanTH)=NaN;
inanTp=find(A(:,23) < 0);
Tp(inanTp)=NaN;
inan=find(A(:,21) < 0);
%
%  Have to keep height 0 for no entries.  Mean and Var doesn't work
%
h(inan)=0;
t=datenum(A(:,2),A(:,3),A(:,4),A(:,5),A(:,6),A(:,7));
%
%  Scale to nonzero wave heights
%
hmean=(length(h)*mean(h))/(length(h)-length(inan));
hvar=(length(h)*var(h))/(length(h)-length(inan));
hcrit=hmean+4*hvar;

findstorms_bob3(startdate,enddate,t,h,Tp,THM,hcrit,stnam,...
                        hmean,hvar,'sort','peak')


