function load4findstorms_ish(filein,startdate,enddate)

%filein=['n',stnam,'_',startdate,'_',enddate];
%filein = [stnam,'-',startdate,'.OUT']
%A = eval(['load ',filein,'.ALL']);
fid = fopen(filein,'r');
A = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
    'headerlines',3);
fclose(fid)
stnam = filein(1:12);
%eval(['A=',filein,';']);
eval(['clear ',filein]);
years = num2str(A{3});
h=A{11};
Tp=A{12};
THM=A{13};
inanTH=find(A{13} < 0);
THM(inanTH)=NaN;
inanTp=find(A{11} < 0);
Tp(inanTp)=NaN;
inan=find(A{12} < 0);
%
%  Have to keep height 0 for no entries.  Mean and Var doesn't work
%
%for ii = 1:size(A{1},1)
    year(:,1) = str2num(years(:,1:4));
    month(:,1) = str2num(years(:,5:6));
    day(:,1) = str2num(years(:,7:8));
    hour(:,1) = str2num(years(:,9:10));
    min(:,1) = str2num(years(:,11:12));
    for ii = 1:size(min,1)
        sec(:,1) = 0.0;
    end
%end
h(inan)=0;
%t = str2num(years);
t = datenum(year,month,day,hour,min,A{4});
%t=datenum(A(:,2),A(:,3),A(:,4),A(:,5),A(:,6),A(:,7));
%
%  Scale to nonzero wave heights
%
hmean=(length(h)*mean(h))/(length(h)-length(inan));
hvar=(length(h)*var(h))/(length(h)-length(inan));
hcrit=hmean+0.5*hvar;

findstorms_bob3(startdate,enddate,t,h,Tp,THM,hcrit,stnam,...
                        hmean,hvar,'sort','peak')


