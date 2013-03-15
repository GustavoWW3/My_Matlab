function stats_timeplt3(buoyin,mod_name,startyr,endyr)
%
%  Read in the two data sets (CFSR and OWI)
%
fname={'WAMCY451C-055';'ST4'};
aname{1} = ['C:\PACIFIC\WAM\Long_Term\OWI\',buoyin,'\'];
aname{2} = ['C:\PACIFIC\WW3\Long_Term\OWI\',buoyin,'\'];
for mm=1:2
filein=[aname{mm},'stats_',buoyin,'_',fname{mm},'.ALL'];
A(:,:,mm)=load(filein,'r');
end
%
buoystn=int2str(A(1,4,1));
long=num2str(A(1,5,1));
lat=num2str(A(1,6,1));
dep=num2str(A(1,7,1));
%
yr=A(1:4:end,1,1);
mnt=A(1:4:end,2,1);
timobs=datenum(yr,mnt,1,0,0,0);

timbeg=datenum(startyr,1,1,0,0,0);
timend=datenum(endyr+1,1,1,0,0,0);
xlimx=[timbeg,timend];

titlch1=['Pacific WIS Forensics-4 ',fname{1},' vs ',fname{2}];
titlch2=['Model Tested:  ',mod_name,'-OWI'];
titlch3=['Monthly Statistical Evaluation at Buoy: ',buoystn];
titlch4=['Location  LONG/LAT:  ',long,'\circE  / ',lat,'\circN'];
titlch5=['Water Depth:  ',dep];
titlchT=[{titlch1};{titlch2};{titlch3};{titlch4};{titlch5}];
%
set(0,'DefaultTextFontSize',10);
set(0,'DefaultAxesFontSize',10);
%  Wind Speed Bias
%
clf
%orient('Tall')
subplot(6,1,1) 
H=plot(timobs,A(4:4:end,8,1),'ok-',timobs,A(4:4:end,9,1),'.b-',...
    timobs,A(4:4:end,9,2),'.r-','LineWidth',2,'MarkerSize',6);
ymaxmax = max(max(A(4:4:end,8,1)),max(A(4:4:end,9,1)));
yticks = get(gca,'Ytick');
ytmax = [0 max(yticks)];
if ymaxmax <= 10
    ytmax = [0 10];
elseif ymaxmax > 10 & ymaxmax <= 15
    ytmax = [0 15];
elseif ymaxmax > 15 & ymaxmax <= 20
    ytmax = [0 20];
elseif ymaxmax > 20 & ymaxmax <= 25
    ytmax = [0 25];
end
set(gca,'Ylim',ytmax);
ylimt = max(ytmax);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
% set(gca,'YTick',yticks)
ylabel('Mean U_{10} [m/s]','FontWeight','Bold');
legend1 = legend(H,'Buoy Mean',fname{1},fname{2});
set(legend1,'Position',[0.76 0.9248 0.2075 0.06832]);
%hp = title(titlchT,'FontWeight','Bold');
%po = get(hp,'Position');
%po(2) = po(2) + po(2)*0.1;
%set(hp,'Position',[po(1)-1 po(2)],'VerticalAlignment','Middle');
text((xticks(5)+xticks(6))/2,ylimt,titlchT,'FontWeight','Bold','VerticalAlignment','bottom',...
    'HorizontalAlignment','Center')
%

subplot(6,1,2)
plot(timobs,A(4:4:end,10,1),'ob-',timobs,A(4:4:end,10,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('Bias U_{10} [m/s]','FontWeight','Bold');
%
%  Wave Height Bias
%
subplot(6,1,3)
plot(timobs,A(1:4:end,8,1),'ok-',timobs,A(1:4:end,9,1),'.b-',...
    timobs,A(1:4:end,9,2),'.r-','LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid;
xlabel(' ');
ylabel('Mean: H_{mo} [m]','FontWeight','Bold');

subplot(6,1,4)
plot(timobs,A(1:4:end,10,1),'ob-',...
    timobs,A(1:4:end,10,2),'or-','LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid;
xlabel(' ');
ylabel('Bias: H_{mo} [m]','FontWeight','Bold');
%
%  Mean / Bias Wave Period 
%
subplot(6,1,5);
plot(timobs,A(3:4:end,8,1),'ok-',timobs,A(3:4:end,9,1),'.b-',...
    timobs,A(3:4:end,9,2),'.r-','LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid;
xlabel(' ');
ylabel('Mean: T_{mean} [s]','FontWeight','Bold');
%
subplot(6,1,6);
plot(timobs,A(3:4:end,10,1),'ob-',...
    timobs,A(3:4:end,10,2),'or-','LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid;
xlabel(' ');
ylabel('Bias: T_{mean} [s]','FontWeight','Bold');
%
set(gcf,'units','inches')
set(gcf,'papersize',[8.5 11]);
set(gcf,'paperpositionmode','manual');
set(gcf,'paperposition',[0.5 0.1 7.5 10.8]);
% po=get(gcf,'position');
% po=[0.3 0.74 0.08 0.03];
% set(gcf,'position',po);
fout = ['Stats_BiasALL_',buoystn,'pg1'];
print(gcf,'-dpng','-r600',fout);

clf
%
%  Page 2:  Absolute and RMSE
%
%orient('Tall')
subplot(3,1,1) 
H=plot(timobs,A(4:4:end,12,1),'ob-',timobs,A(4:4:end,12,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('U_{10} RMSE [m/s]','FontWeight','Bold');
legend1 = legend(H,fname{1},fname{2});
set(legend1,'Position',[0.7208 0.9248 0.2075 0.06832]);
title(titlchT,'FontWeight','Bold');
%
%  Wave Height 
%
subplot(3,1,2)
plot(timobs,A(1:4:end,12,1),'ob-',timobs,A(1:4:end,12,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('H_{mo} RMSE [m]','FontWeight','Bold');
%
%  Mean Wave Period 
%
subplot(3,1,3)
plot(timobs,A(3:4:end,12,1),'ob-',timobs,A(3:4:end,12,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('T_{mean} RMSE [s]','FontWeight','Bold');
%
eval(['print -dpng -r600 Stats_ERRALL_',buoystn,'pg2']);
clf

%  Page 3:  Correlation and Symetric r (0 intercept)
%           Column 15       Column 16
orient('Tall')
subplot(3,1,1) 
H=plot(timobs,A(4:4:end,16,1),'ob-',timobs,A(4:4:end,16,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('U_{10} Sym-r','FontWeight','Bold');
legend1 = legend(H,fname{1},fname{2});
set(legend1,'Position',[0.7208 0.9248 0.2075 0.06832]);
title(titlchT,'FontWeight','Bold');
%
%  Wave Height 
%
subplot(3,1,2)
plot(timobs,A(1:4:end,16,1),'ob-',timobs,A(1:4:end,16,2),'or-',...
    'LineWidth',2,'MarkerSize',4,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('H_{mo} Sym-r]','FontWeight','Bold');
%
%  Mean Wave Period 
%
subplot(3,1,3)
plot(timobs,A(3:4:end,16,1),'ob-',timobs,A(3:4:end,16,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('T_{mean} Sym-r','FontWeight','Bold');
%
eval(['print -dpng -r600 Stats_SymRALL_',buoystn,'pg3']);
clf
%  Page 3:  Correlation 
%           Column 15       Column 16
orient('Tall')
subplot(3,1,1) 
H=plot(timobs,A(4:4:end,15,1),'ob-',timobs,A(4:4:end,15,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('U_{10} CORR.','FontWeight','Bold');
legend1 = legend(H,fname{1},fname{2});
set(legend1,'Position',[0.7208 0.9248 0.2075 0.06832]);
title(titlchT,'FontWeight','Bold');
%
%  Wave Height 
%
subplot(3,1,2)
plot(timobs,A(1:4:end,15,1),'ob-',timobs,A(1:4:end,15,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('H_{mo} CORR.]','FontWeight','Bold');
%
%  Mean Wave Period 
%
subplot(3,1,3)
plot(timobs,A(3:4:end,15,1),'ob-',timobs,A(3:4:end,15,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
grid
xlabel(' ')
ylabel('T_{mean} CORR.','FontWeight','Bold');
%
eval(['print -dpng -r600 Stats_CorrALL_',buoystn,'pg4']);
clf
%
%  Page 5 Scatter Index
%
maxofy=max(max(A(4:4:end,13)),max(A(1:4:end,13)));
maxofy=max(max(maxofy),max(A(3:4:end,13)));

orient('Tall');
subplot(3,1,1) 
H=plot(timobs,A(4:4:end,13,1),'ob-',timobs,A(4:4:end,13,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
ylimmx=[0,maxofy];
set(gca,'Ylim',ylimmx);
grid;
xlabel(' ');
ylabel('U_{10} Scatter Index','FontWeight','Bold');
legend1 = legend(H,fname{2},fname{2});
set(legend1,'Position',[0.7208 0.9248 0.2075 0.06832]);
title(titlchT,'FontWeight','Bold');
%
%  Wave Height 
%
subplot(3,1,2);
plot(timobs,A(1:4:end,13,1),'ob-',timobs,A(1:4:end,13,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
ylimmx=[0,maxofy];
set(gca,'Ylim',ylimmx);
grid;
xlabel(' ');
ylabel('H_{mo} Scatter Index','FontWeight','Bold');
%
%  Mean Wave Period 
%
subplot(3,1,3)
plot(timobs,A(3:4:end,13,1),'ob-',timobs,A(3:4:end,13,2),'or-',...
    'LineWidth',2,'MarkerSize',6);
set(gca,'Xlim',xlimx);
xticks=get(gca,'XTick');
xx=datestr(xticks,12);
set(gca,'XTick',xticks,'XTicklabel',xx);
ylimmx=[0,maxofy];
set(gca,'Ylim',ylimmx);
grid;
xlabel(' ');
ylabel('T_{mean} Scatter Index','FontWeight','Bold');
%
eval(['print -dpng -r600 Stats_ScatterIndx_',buoystn,'pg5']);
clf
