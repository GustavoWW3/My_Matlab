function new_extrems(stnno,startdate,enddate)
%
%  INPUT:       stnno:      CHARACTER
%               startdate:  CHARACTER
%               enddate:    CHARACTER
%
%    Get the general information Location/Depth
%
%eval(['load ',pathinstrt,'Table_All_Stns.dat']);
load('Table_All_Stns.dat');
stnG=Table_All_Stns(:,1);
stnproc=str2num(stnno(1:5));
ipr=find(stnG == stnproc);
long=Table_All_Stns(ipr,2)-360.;
lat=Table_All_Stns(ipr,3);
dep=Table_All_Stns(ipr,4);
%
%  Now Process the Extremes from the ASCII TABLE CREATED
%               from find_storms
%
filein=['EXTM_',stnno,'_',startdate','_',enddate];
%
fid=fopen(filein)
%
%  Pull out the station number from line 1
tline = fgetl(fid);
stn_chr=tline(end-5:end);
%
%  Skip the next 4 lines (no information required)
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
%
%  Pull out the remaining information from each line for extreme plotting
i=0;
while ~feof(fid)
    tline = fgetl(fid);
    i=i+1;
    rank(i)=str2num(tline(1:4));
    mnt(i)=str2num(tline(44:45));
    day(i)=str2num(tline(47:48));
    yr(i)=str2num(tline(50:53));
    hr(i)=str2num(tline(55:56));
    hgt(i)=str2num(tline(67:71));
    tpp(i)=str2num(tline(76:80));
    thh(i)=str2num(tline(end-5:end));
end
fclose(fid);
%
%  Now process that information RECORD LENGTH IS 20 years
%
reclengt=20;
rtnp=(reclengt +1)./rank;
YI=interp1(hgt,log(rtnp));
p=polyfit(log(rtnp),hgt,1);
YFIT=polyval(p,log(rtnp));
%
%  Generate text box for max height date
%
mtch=int2str(mnt(1));
if mnt(1) <= 9
    mtch=['0',int2str(mnt(1))];
end
dych=int2str(day(1));
if day(1) <= 9
    dych=['0',int2str(day(1))];
end
hrch=int2str(hr(1));
if hr(1) <= 9
    hrch=['0',int2str(hr(1))];
end
text1=['MAX:  ',int2str(yr(1)),'/',mtch,'/',dych,' ',hrch,':00'];
textT=[text1];
%
%  Calculate the 50-yr and 100-yr Events Based on linear fit
%
yfit50 =p(2) + p(1)*log(50);
yfit100=p(2) + p(1)*log(100);
extrpx=[rtnp(1),100];
extrpy=[YFIT(1),yfit100];
%
%  Seive out the Pre-1984 Storms and Continuous Observations
%
pre84=find(yr < 1985);
post84=find(yr >=1985);
%
eqnstr=['H_{mo} = ',num2str(p(2)),' + ',num2str(p(1)),' \bullet ln [ RP(yrs) ]'];
orient('Tall')
subplot(2,1,1)
H=semilogx(rtnp(post84),hgt(post84),'bo',rtnp(pre84),hgt(pre84),'b+',...
    rtnp(1:21),YFIT(1:21),'r',50,yfit50,'g*',100,yfit100,'m*',...
    extrpx,extrpy,'r-.')
grid
axis([0.1 100 0 ceil(yfit100+1)]);
legend(H,'Hindcast','Pre-1985','FIT','50-yr','100-yr','Extrap',4);
xlabel('Return Period [years]');
ylabel('H_{mo}  [m]')
tchar1=['Return Period of 20-yr Alaska Hindcast for ST:  ',stn_chr];
tchar2=['Long / Lat:  ',num2str(long),'\circ / ',num2str(lat),'\circ',...
        '  Dep:  ',num2str(dep),' [m]'];
tcharT=[{tchar1};{tchar2};{eqnstr}];
title(tcharT);
text(25,hgt(1),textT,'FontSize',8,'BackgroundColor',[1 1 1]);
%
%  Add text for the top 10 EVENTS BELOW THE GRAPH
%    DATE  of MAX HEIGHT with PERIOD, DIRECTION
%    FIX THE MONTH/DAY/HOUR TO 2 DIGITS
for ii=1:10
    yrch=int2str(yr(ii));
    mtch=int2str(mnt(ii));
    if mnt(ii) <= 9
        mtch=['0',int2str(mnt(ii))];
    end
    dych=int2str(day(ii));
    if day(ii) <= 9
        dych=['0',int2str(day(ii))];
    end
    hrch=int2str(hr(ii));
    if hr(ii) <= 9
        hrch=['0',int2str(hr(ii))];
    end
    if ii == 10
        texttblst(1,:)=['(',int2str(ii),'):  ',yrch,'/',mtch,'/',dych,' ',...
        hrch,':00  H_{mo} ',num2str(sprintf('%5.2f',hgt(ii))),...
             ' / T_{p}: ',num2str(sprintf('%5.2f',tpp(ii))),...
             ' / \theta_{m}: ',num2str(sprintf('%6.2f',thh(ii)))];
    else
        texttbl(ii,:)=['(0',int2str(ii),'):  ',yrch,'/',mtch,'/',dych,' ',...
        hrch,':00  H_{mo}: ',num2str(sprintf('%5.2f',hgt(ii))),...
             ' / T_{p}: ',num2str(sprintf('%5.2f',tpp(ii))),...
             ' / \theta_{m}: ',num2str(sprintf('%6.2f',thh(ii)))];
    end
end
texttt1=[{texttbl(1,:)};{texttbl(2,:)};{texttbl(3,:)};{texttbl(4,:)};{texttbl(5,:)}];
texttt2=[{texttbl(6,:)};{texttbl(7,:)};{texttbl(8,:)};{texttbl(9,:)};{texttblst(1,:)};];

ymax=-2.5;
ytxt=-4;
if ceil(yfit100+1) > 10
    ymax=-3.5;
    ytxt=-5.5;
end
if ceil(yfit100+1) > 15
    ymax=-4.75;
    ytxt=-8;
end
if ceil(yfit100+1) > 20
    ymax=-6.0;
    ytxt=-10.5;
end
text(0.1,ymax,texttt1,'FontSize',8,'BackgroundColor',[1 1 1],'HorizontalAlignment',...
    'left','EdgeColor','k');
text(100.,ymax,texttt2,'FontSize',8,'BackgroundColor',[1 1 1],'HorizontalAlignment',...
    'right','EdgeColor','k');
texttt3=['Direction Convention FROM WHICH (Meteorological)'];
text(15,ytxt,texttt3,'FontSize',9,'HorizontalAlignment','right')

fileot=['ST',stn_chr(2:6),'_EXTRM'];
eval(['print -dpng -r600 ',fileot]);
%
eval(['cd ',pathinstrt]);
clf
clear

