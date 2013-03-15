  function compar_MPI(storm_nam,wtype_nam,RES)
%
%  RE Jensen (02/2011)
%
%   storm_nam:      CHARACTER      'STORM01W'
%   LO_RES:         CHARACTER       '72S'   Grid Resolution used
%   HI_RES:         CHARACTER       '144S"  Grid Resolution used
%  Program takes the one line file and tests co-located wave heights
%          surrounding for this example Lake Michigan
%  And tests for quality in the lower resolution results
%  Generates and plots mean, bias, RSME, and SI
%  Generates and plots "0" intercept slope for all co-located and
%  time-paired observations.
%
%
wind_name='Dir';
pdd = 'C:/Great_lakes/Lake_Stclair/WAM_Validation/';
filelow= [pdd,storm_nam,'/MPI/',wtype_nam,'/',storm_nam,'T-',RES,'.onlns'];
a = load(filelow);

filehig= [pdd,storm_nam,'/MPI/',wtype_nam,'/',storm_nam,'T-',RES,'-Dir.onlns'];
b = load(filehig);

for jj = 1:size(a,2)
    ii = find(a(:,jj) == -999.0);
    a(ii,jj) = 0;
    qq = find(b(:,jj) == -999.0);
    b(qq,jj) = 0;
end
astn=a(:,4);
[uA,m]=unique(astn,'rows');
%
clf
nn=0;
for k=1:length(m)
    Ia=find(a(:,4) == uA(k));
    Ib=find(b(:,4) == uA(k));
    if ~isempty(Ib) 
    nn=nn+1;
    Hgt_a(nn,:) = a(Ia,12);
    Hgt_b(nn,:) = b(Ib,12);
    end
end
%
%  Generate the Symmetrical regression coefficient and plot
%
hmax=ceil(max(max(a(:,12)),max(b(:,12))));
chs = sqrt(sum(sum(a(:,12))).^2 / sum(sum(b(:,12))).^2);
%
plot(b(:,12),a(:,12),'r.',[0,chs*hmax],[0,chs*hmax],'b--','LineWidth',3);
grid
ylabel('WAM453 H_{mo}  [m]','FontWeight','Bold');
xlabel('WAM451 H_{mo}  [m]','FontWeight','Bold');
axis([0, hmax, 0, hmax]);
axis('square');
titl1=['Storm Simulation:  ',storm_nam];
titl2=['Wind Forcing:  ',wtype_nam];
titl3=['Co-Located Save Stations:  ',int2str(length(m))];
titl4=['Time Paired Observations / Station:  ',int2str(length(Ia))];
titlt=[{titl1};{titl2};{titl3};{titl4}];
title(titlt,'FontWeight','Bold');
textslp=['H_{LOW} = ',num2str(chs),' \bullet H_{HIGH}'];
text(hmax-1,hmax-1.5,textslp,'FontWeight','Bold');
eval(['print -dpng -r400 ',storm_nam,'_pg1']);
%
%  Calculate simple statistics and plot them out
%   1.  Mean Height
nsta=nn;
for n=1:nsta
    hmna(n)=mean(Hgt_a(n,:));
    hmnb(n)=mean(Hgt_b(n,:));
end
%
%  2.  Bias (based on higher resolution simulation)  
for n=1:nsta
    bias_a(n)=mean(Hgt_a(n,:)-Hgt_b(n,:));
end
%
%  3.  RMSE of a versus b
for n=1:nsta
    rmse_a(n) = sqrt(sum((Hgt_a(n,:) - Hgt_b(n,:) - bias_a(n) ).^2) / length(Ia));
end
%
%  4.  SI of "a" versus "b"
for n=1:nsta
    si_a(n) = rmse_a(n) / hmna(n) * 100;
end
%
%  Plot up Statistics for low res comparison
%
clf
orient('Tall')
subplot(4,1,1)
stns=1:nsta;
H=plot(stns,hmnb,'b-',stns,hmna,'r-');
grid
title(titlt,'FontWeight','Bold');
ylabel('H_{MEAN}  [m]','FontWeight','Bold');
legend(H,'WAM451','WAM453','Location','Northeast');
subplot(4,1,2)
plot(stns,bias_a,'.r-')
ylabel('Bias   [m]','FontWeight','Bold');
grid;
[BIAS_mxx,indx]=max(bias_a);
[BIAS_min,indxm]=min(bias_a);

if abs(BIAS_min) > BIAS_mxx
    BIAS_max=BIAS_min;
    indxb=indxm;
else
    BIAS_max=BIAS_mxx;
    indxb=indx;
end
textB1=['Bias_{MAX} :  ',num2str(BIAS_max)];
textB2=['STN        :  ',int2str(indxb)];
textBT=[{textB1};{textB2}];
text(stns(end)-100,.8*BIAS_max,textBT,'FontSize',8,'FontWeight','Bold');

subplot(4,1,3)
plot(stns,rmse_a,'.r-');
grid;
ylabel('RMSE ','FontWeight','Bold');
[RMSE_max,indx]=max(rmse_a);
textR1=['RMS_{MAX} :  ',num2str(RMSE_max)];
textR2=['STN        :  ',int2str(indx)];
textRT=[{textR1};{textR2}];
text(stns(end)-100,.9*RMSE_max,textRT,'FontSize',8,'FontWeight','Bold');

subplot(4,1,4)
plot(stns,si_a,'.r-')
grid
ylabel('Scat Indx','FontWeight','Bold');
xlabel('Station No.','FontWeight','Bold');
[SI_max,indx]=max(si_a);
textS1=['SI_{MAX} :  ',num2str(SI_max)];
textS2=['STN        :  ',int2str(indx)];
textST=[{textS1};{textS2}];
text(stns(end)-100,.9*SI_max,textST,'FontSize',8,'FontWeight','Bold');

eval(['print -dpng -r400 ',storm_nam,'_pg2']); 
clf



    