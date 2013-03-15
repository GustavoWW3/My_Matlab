function [tpair_out] = time_pair_fix(buoy)


bloc = [buoy];


bb = load(bloc);
year = buoy(8:11);
mon = buoy(13:14);
wloc = [num2str(year),'-',num2str(mon),'/'];

bnum = buoy(2:6);
files = dir('S*.onlns');
for zz = 1:size(files,1)
fname = files(zz).name;
ww = load(fname);

mn = regexp(fname,'[-_]+');
for qq = 1:size(mn,2);
    if fname(mn(qq)+1:mn(qq)+4) == 'CFSR'
        windc{zz} = 'CFSR';
        break
    elseif fname(mn(qq)+1:mn(qq)+3) == 'OWI'
        windc{zz} = 'OWI';
        break
    else
        windc{zz} = 'NNM';
    end
end
yrnd=bb(:,2);
mtnd=bb(:,3);
dynd=bb(:,4);
hrnd=bb(:,5);
mnnd=60*round(bb(:,6)/60);

timndb_D=datenum(yrnd,mtnd,dynd,hrnd,mnnd,0);
TMNDB_D=datevec(timndb_D);
timbuoy=datenum(TMNDB_D);

if ww(1,1) < 1000
  TM1=datenum(ww(:,3));
else
    TM1=datenum(ww(:,1));
end
TM1S=int2str(TM1);
%
tm1yr=str2num(TM1S(:,1:4));
tm1mt=str2num(TM1S(:,5:6));
tm1dy=str2num(TM1S(:,7:8));
tm1hr=str2num(TM1S(:,9:10));
timwam=datenum(tm1yr,tm1mt,tm1dy,tm1hr,0,0);

nlb = size(timbuoy,1);
nlm = size(timwam,1);

iwnd=find(bb(:,15) > 0 & bb(:,18) > -100 & bb(:,19) > -100);
jwnd=find(bb(:,18) <= -999 & bb(:,19) <= -999);
kwnd=find(bb(:,15) <= -999);
clear u10buoy; clear air_sea;
u10buoy=zeros(size(bb(:,1)));
ele=zeros(size(bb(:,1)));
ielez=find(bb(:,14) == 0.0);
if isempty(ielez)
    ele=bb(:,14);
else
    ele(1:length(bb(:,1)),1)=5.0;
end
air_sea(iwnd,1)=bb(iwnd,18)-bb(iwnd,19);
temdifa=length(find(bb(:,18) == 0));
temdifs=length(find(bb(:,19) == 0));
if temdifa > 0.5*nlb | temdifs > 0.5*nlb
    air_sea(1:nlb,1)=0.;
end

[u10buoy(iwnd)]=windp(100*bb(iwnd,15),100*ele(iwnd,1),air_sea(iwnd,1),100*ele(iwnd,1));
u10buoy(jwnd)= bb(jwnd,15).*(ele(jwnd,1) / 10.).^(-1/7);
u10buoy(kwnd) = bb(kwnd,15);
kbadu10=find(imag(u10buoy));
u10buoy(kbadu10)=bb(kbadu10,15);
thresh=floor(0.05*length(u10buoy));
if length(iwnd) < thresh
    u10buoy(1:length(u10buoy)) = NaN;
    windB(1:length(u10buoy)) = NaN;
end
%
%   Pull out the Wave Parameters for Time Plots
%       Control Missing Buoy Data using axis in plotting.
%       Remove when time paired obs.
%
%   1.  Wave Height:
%           Buoy Col    21
%           WAM  Col    10
%
hgtB=bb(:,21);
ihgB = find(bb(:,21) > 0);
nodir(1)=isempty(ihgB);
hgtM=ww(:,10);
hmax=ceil(max(max(hgtM),max(hgtB)));
comp(1) =struct('name','H_{mo} [m]','y1',hgtM,'y2',hgtB,'max',hmax);

%
%   2.  Peak Period  (Parabolic Fit)
%           Buoy Col    23
%           WAM  Col    13
%
tppfB=bb(:,23);
itpB=find(bb(:,23) > 0);
nodir(2)=isempty(itpB);
tppfM=ww(:,11);
itpM=find(ww(:,11) > 0);
tppmax=ceil(max(max(tppfM(itpM,:)),max(tppfB(itpB))));
comp(2) = struct('name','T_{p} [s]','y1',tppfM,'y2',tppfB,'max',tppmax);
%
%  3.  Mean Wave Period  (inverse 1st moment)
%           Buoy Col    24
%           WAM  Col    14
%
tmnB=bb(:,24);
ltmnB=find(bb(:,24) > 0);
nodir(3)=isempty(ltmnB);
tmnM=ww(:,12);
if ~isempty(ltmnB)
    tmnmax2=ceil(max(max(tmnM),max(tmnB)));
    tmnmax = tmnmax2;
else
    tmnmax2=ceil(max(tmnM));
    tmnmax=5*ceil(tmnmax2/5);
end
%tmnmax=ceil(max(max(tmnM),max(tmnB)));
comp(3) = struct('name','T_{m} [s]','y1',tmnM,'y2',tmnB,'max',tmnmax);
%
%
%  4.  Mean Wave Direction  Overall Vector Mean  Transform to Geophys Met.
%                           ADJUST THE WAM RESULTS
%
%           Buoy Col    25  (Meteorological 0 from   North / 90 from   East)
%           WAM  Col    17  (Oceanographic  0 toward North / 90 toward East)
%
%   NOTE:  Determine if Buoy has Directional Information (look for finite directions)
%                       If have flag to produce "No Directional Buoy Data")
%                       called "nodir"
%
%
iwavB=find(bb(:,25) >= 0);
wavdB=bb(:,25);
nodir(4)=isempty(iwavB);
wavdM=ww(:,15);
comp(4) = struct('name','\theta_{wave}','y1',wavdM,'y2',wavdB,'max',360);
%
%  5.  Wind Speed   U10
%       Buoy        From Above (tranform to 10 m)
%       WAM         Column 5
%
wsM=ww(:,5);
iu10 = find(u10buoy > 0);
nodir(5)=isempty(iu10);
wsmax=ceil(max(max(wsM),max(u10buoy)));
comp(5) = struct('name','WS [m/s]','y1',wsM,'y2',u10buoy,'max',wsmax);
%
%  6.  Wind Direction  (Use Meteorlogical coordinate)
%
%       Buoy  Col       17  (Meteorological 0 from   North / 90 from   East)
%       WAM   Col        6  (Oceanographic  0 toward North / 90 toward East)
%
windB=bb(:,17);
nowndB=find(windB == 0);
iwdB=length(nowndB);
iwdB2 = find(bb(:,17) >= 0);
nodir(6)=isempty(iu10);
if iwdB > 0.5*nlb
    windB(nowndB)=-999.;
end
windM=ww(:,6);
comp(6) = struct('name','\theta_{wind}','y1',windM,'y2',windB,'max',360);

tol=1.0e-8;
if nlm < nlb
    [kkB,kkM]=mpair(timbuoy,timwam,tol);
else
    [kkM,kkB]=mpair(timwam,timbuoy,tol);
end
bpair=[timbuoy(kkB),comp(5).y2(kkB),comp(6).y2(kkB),comp(1).y2(kkB), ...
    comp(2).y2(kkB),comp(3).y2(kkB),comp(4).y2(kkB)];
wpair=[timwam(kkM),comp(5).y1(kkM),comp(6).y1(kkM),comp(1).y1(kkM),...
    comp(2).y1(kkM),comp(3).y1(kkM),comp(4).y1(kkM)];

yearmon = [year,'-',mon];
if ~exist('../Time_pair','dir')
    mkdir('../Time_pair');
end
dname  = ['../Time_pair/',yearmon];
if ~exist(dname,'dir')
    mkdir(dname);
end
yearmondir = ['../Time_pair/',yearmon,'/ST',bnum,'-',yearmon,'-',windc{zz}];
tpair_out = struct('wind',windc{zz},'stat',bnum,'date',yearmon,'buoy',bpair,'wam',wpair);
eval(['save ',yearmondir,'.mat  tpair_out ;']);
end