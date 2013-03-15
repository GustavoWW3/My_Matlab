files = dir('tmeprd_*');
nn = 1;
cc = 1;
n1 = 1;
n2 = 1;
n3 = 1;
n4 = 1;
c1 = 1;
c2 = 1;
c3 = 1;
c4 = 1;

for zz = 1:size(files,1)
    filename = getfield(files(zz,1),'name');
    load(filename);
    data = timpr;
    storm = [filename(8:15),'-',filename(17:20),'-',...
                          filename(22:24)];
    if filename(26) == 'N'
        file_nn{nn} = data;
        storm_nn{nn} = storm;
        nn = nn + 1;
        if filename(42:46) == '45002'
            file_nn1{n1} = data;
            storm_nn1{n1} = storm;
            n1 = n1+1;
        elseif filename(42:46) == '45007'
            file_nn2{n2} = data;
            storm_nn2{n2} = storm;
            n2 = n2+1;
        elseif filename(42:46) == '45011'
            file_nn3{n3} = data;
            storm_nn3{n3} = storm;
            n3 = n3+1;
        else
            file_nn4{n4} = data;
            storm_nn4{n4} = storm;
            n4 = n4+1;
        end
    else 
        file_cf{cc} = data;
        storm_cf{cc} = storm;
        cc = cc + 1;
        if filename(42:46) == '45002'
            file_cf1{c1} = data;
            storm_cf1{c1} = storm;
            c1 = c1+1;
        elseif filename(42:46) == '45007'
            file_cf2{c2} = data;
            storm_cf2{c2} = storm;
            c2 = c2+1;
        elseif filename(42:46) == '45011'
            file_cf3{c3} = data;
            storm_cf3{c3} = storm;
            c3 = c3+1;
        else
            file_cf4{c4} = data;
            storm_cf4{c4} = storm;
            c4 = c4+1;
        end
    end
end
%  Scatter all time paired observations for All stations at 45002
%
clf;
figure(1)
hmax1 = 0;
for ii = 1:n1-1
    hmn = max(max(file_nn1{ii}(:,1:2)));
    hmc = max(max(file_cf1{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn1{ii}(:,1),file_nn1{ii}(:,2),'r+',file_cf1{ii}(:,1),file_cf1{ii}(:,2),...
        'bx',[0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2);hold on
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
ntotobs=0;
for ii = 1:n1-1
    legnd(ii,:)=[storm_nn1{ii},': ',int2str(length(file_nn1{ii}(:,2))),' OBS']; 
    ntotobs = ntotobs + length(file_nn1{ii}(:,2));
end
legndT=legnd;
text(0.25,ceil(hmax1)-0.1,legndT,'FontWeight','Bold','FontSize',7,'VerticalAlignment','Top');
titl1='Time Paired Comparisons NDBC 45002';
titl2=['Total Number of Time Paired Observations:  ',int2str(ntotobs)];
titT=[{titl1};{titl2}];
title(titT,'FontWeight','Bold','FontSize',12)
legend(H,'NN-SMTH','ORIG-CFSR',4)
print -dpng -r600 scat_all_45002
clf;
clear legnd; clear legndT; clear titT;
%
%Scatter all time paired observations for All stations at 45007
%  
hmax1 = 0;
for ii = 1:n2-1
    hmn = max(max(file_nn2{ii}(:,1:2)));
    hmc = max(max(file_cf2{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn2{ii}(:,1),file_nn2{ii}(:,2),'r+',file_cf2{ii}(:,1),file_cf2{ii}(:,2),...
        'bx',[0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2);hold on
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
ntotobs=0;
for ii = 1:n2-1
    legnd(ii,:)=[storm_nn2{ii},': ',int2str(length(file_nn2{ii}(:,2))),' OBS']; 
    ntotobs = ntotobs + length(file_nn2{ii}(:,2));
end
legndT=legnd;
text(0.25,ceil(hmax1)-0.1,legndT,'FontWeight','Bold','FontSize',7,'VerticalAlignment','Top');
titl1='Time Paired Comparisons NDBC 45007';
titl2=['Total Number of Time Paired Observations:  ',int2str(ntotobs)];
titT=[{titl1};{titl2}];
title(titT,'FontWeight','Bold','FontSize',12)
legend(H,'NN-SMTH','ORIG-CFSR',4)
print -dpng -r600 scat_all_45007
clear legnd; clear legndT; clear titT;
%
%Scatter all time paired observations for All stations at 45011
%  
figure(1)
hmax1 = 0;
for ii = 1:n3-1
    hmn = max(max(file_nn3{ii}(:,1:2)));
    hmc = max(max(file_cf3{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn3{ii}(:,1),file_nn3{ii}(:,2),'r+',file_cf3{ii}(:,1),file_cf3{ii}(:,2),...
        'bx',[0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2);hold on
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
ntotobs=0;
for ii = 1:n3-1
    legnd(ii,:)=[storm_nn3{ii},': ',int2str(length(file_nn3{ii}(:,2))),' OBS']; 
    ntotobs = ntotobs + length(file_nn3{ii}(:,2));
end
legndT=legnd;
text(0.25,ceil(hmax1)-0.1,legndT,'FontWeight','Bold','FontSize',7,'VerticalAlignment','Top');
titl1='Time Paired Comparisons NDBC 45011';
titl2=['Total Number of Time Paired Observations:  ',int2str(ntotobs)];
titT=[{titl1};{titl2}];
title(titT,'FontWeight','Bold','FontSize',12)
legend(H,'NN-SMTH','ORIG-CFSR',4)
print -dpng -r600 scat_all_45011
%
%  Scatter all time paired observations for All stations at 45010
%  
clf;
clear legnd; clear legndT; clear titT;
hmax1 = 0;
for ii = 1:n4-1
    hmn = max(max(file_nn4{ii}(:,1:2)));
    hmc = max(max(file_cf4{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn4{ii}(:,1),file_nn4{ii}(:,2),'r+',file_cf4{ii}(:,1),file_cf4{ii}(:,2),...
        'bx',[0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2);hold on
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
ntotobs=0;
for ii = 1:n4-1
    legnd(ii,:)=[storm_nn4{ii},': ',int2str(length(file_nn4{ii}(:,2))),' OBS']; 
    ntotobs = ntotobs + length(file_nn4{ii}(:,2));
end
legndT=legnd;
text(0.25,ceil(hmax1)-0.1,legndT,'FontWeight','Bold','FontSize',7,'VerticalAlignment','Top');
titl1='Time Paired Comparisons NDBC 45010';
titl2=['Total Number of Time Paired Observations:  ',int2str(ntotobs)];
titT=[{titl1};{titl2}];
title(titT,'FontWeight','Bold','FontSize',12)
legend(H,'NN-SMTH','ORIG-CFSR',4)
print -dpng -r600 scat_all_45010
%  
%
%  Now Scatter Model and Measurements but indicate the storms
%   Two Panel Plots (NN Top)  (CFSR Bottom)
% Set up the symbols for each of the N Storms
%
A1={'r^';'b^';'g^';'m^';'k^';'ro';'bo';'go';'mo';'ko';...
    'rs';'bs';'gs';'ms';'ks';'rv';'bv';'gv'};
clf;
%
%  NDBC BUOY 45002
% 
orient('Tall');
subplot(2,1,1) 
for ii = 1:n1-1
    hmn = max(max(file_nn1{ii}(:,1:2)));
    hmc = max(max(file_cf1{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn1{ii}(:,1),file_nn1{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
for ii = 1:n1-1
    legnd(ii,1:8)=storm_nn1{ii}(1:8);
    ntotobs = ntotobs + length(file_nn1{ii}(:,2));
end
[numstms,kk]=size(legnd);
clear kk;
%
titl1='Time Paired Comparisons NDBC 45002';
titl2=['WINDS:  NN Smoothed No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
%
%  CFSR FORCED WAM RUN
%
subplot(2,1,2) 
for ii = 1:c1-1
    H=plot(file_cf1{ii}(:,1),file_cf1{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titl1='Time Paired Comparisons NDBC 45002';
titl2=['WINDS:  CFSR         No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
print -dpng -r600 scat_storms_45002
clear legnd; clear ntotobs; clear ntotobs;  
%
% NDBC BUOY 45007 
clf;
hmax1 = 0.;
ntotobs=0;
orient('Tall');
subplot(2,1,1) 
for ii = 1:n2-1
    hmn = max(max(file_nn2{ii}(:,1:2)));
    hmc = max(max(file_cf2{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn2{ii}(:,1),file_nn2{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
for ii = 1:n2-1
    legnd(ii,1:8)=storm_nn2{ii}(1:8); 
    ntotobs = ntotobs + length(file_nn2{ii}(:,2));
end
[numstms,kk]=size(legnd);
clear kk;
%
titl1='Time Paired Comparisons NDBC 45007';
titl2=['WINDS:  NN Smoothed No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
%
%  CFSR FORCED WAM RUN
%
subplot(2,1,2) 
for ii = 1:c2-1
    H=plot(file_cf2{ii}(:,1),file_cf2{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titl1='Time Paired Comparisons NDBC 45007';
titl2=['WINDS:  CFSR         No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
print -dpng -r600 scat_storms_45007
%
%  Now for NDBC 45011
%
clf;
clear legnd; clear ntotobs;
hmax1=0;
ntotobs=0;
orient('Tall');
subplot(2,1,1) 
for ii = 1:n3-1
    hmn = max(max(file_nn4{ii}(:,1:2)));
    hmc = max(max(file_cf4{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn3{ii}(:,1),file_nn3{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
for ii = 1:n3-1
    legnd(ii,1:8)=storm_nn3{ii}(1:8);
    ntotobs = ntotobs + length(file_nn3{ii}(:,2));
end
[numstms,kk]=size(legnd);
clear kk;
%
titl1='Time Paired Comparisons NDBC 45011';
titl2=['WINDS:  NN Smoothed No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
%
%  CFSR FORCED WAM RUN
%
subplot(2,1,2) 
for ii = 1:c3-1
    H=plot(file_cf3{ii}(:,1),file_cf3{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titl1='Time Paired Comparisons NDBC 45011';
titl2=['WINDS:  CFSR         No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
print -dpng -r600 scat_storms_45011
%
%  NDBC 45010 Storm Scatter Plots
%
clf;
clear legnd; clear ntotobs;
hmax1=0;
ntotobs=0;
orient('Tall');
subplot(2,1,1) 
for ii = 1:n4-1
    hmn = max(max(file_nn4{ii}(:,1:2)));
    hmc = max(max(file_cf4{ii}(:,1:2)));
    hmm = max(hmn,hmc);
      if hmm > hmax1
        hmax1 = hmm;
      end
   H=plot(file_nn4{ii}(:,1),file_nn4{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
for ii = 1:n4-1
    legnd(ii,1:8)=storm_nn4{ii}(1:8);
    ntotobs = ntotobs + length(file_nn4{ii}(:,2));
end
[numstms,kk]=size(legnd);
clear kk;
%
titl1='Time Paired Comparisons NDBC 45010';
titl2=['WINDS:  NN Smoothed No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
%
%  CFSR FORCED WAM RUN
%
subplot(2,1,2) 
for ii = 1:c4-1
    H=plot(file_cf4{ii}(:,1),file_cf4{ii}(:,2),A1{ii},'MarkerSize',3);hold on;
end
grid
axis([0 ceil(hmax1) 0 ceil(hmax1)]);
axis('square');
xlabel('Measured H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titl1='Time Paired Comparisons NDBC 45010';
titl2=['WINDS:  CFSR         No. Obs:  ',int2str(ntotobs)];
titl3=['Number of Storms in Data Set:  ',int2str(numstms)];
titT=[{titl1};{titl2};{titl3}];
title(titT,'FontWeight','Bold','FontSize',12)
G=legend(legnd,-1);
set(G,'FontSize',8,'FontWeight','Bold');
plot([0 ceil(hmax1)],[0,ceil(hmax1)],'g--','LineWidth',2,'MarkerSize',3)
print -dpng -r600 scat_storms_45010
clf;
%
%  Peak to Peak Analysis
%  Buoy 45002
nn1_conc = [file_nn1{1};file_nn1{2}];
for ii = 3:size(file_nn1,2);nn1_conc = [nn1_conc;file_nn1{ii}];end

cf1_conc = [file_cf1{1};file_cf1{2}];
for ii = 3:size(file_cf1,2);cf1_conc = [cf1_conc;file_cf1{ii}];end
peak2peak(nn1_conc,cf1_conc,'45002','NN','CFSR')
clf
%
%  Buoy 45007
nn2_conc = [file_nn2{1};file_nn2{2}];
for ii = 3:size(file_nn2,2);nn2_conc = [nn2_conc;file_nn2{ii}];end

cf2_conc = [file_cf2{1};file_cf2{2}];
for ii = 3:size(file_cf2,2);cf2_conc = [cf2_conc;file_cf2{ii}];end
peak2peak(nn2_conc,cf2_conc,'45007','NN','CFSR')
clf
%
%  Buoy 45011
nn3_conc = [file_nn3{1};file_nn3{2}];
for ii = 3:size(file_nn3,2);nn3_conc = [nn3_conc;file_nn3{ii}];end

cf3_conc = [file_cf3{1};file_cf3{2}];
for ii = 3:size(file_cf3,2);cf3_conc = [cf3_conc;file_cf3{ii}];end
peak2peak(nn3_conc,cf3_conc,'45011','NN','CFSR')
clf
%
%  Buoy 45010
nn4_conc = [file_nn4{1};file_nn4{2}];
for ii = 3:size(file_nn4,2);nn4_conc = [nn4_conc;file_nn4{ii}];end

cf4_conc = [file_cf4{1};file_cf4{2}];
for ii = 3:size(file_cf4,2);cf4_conc = [cf4_conc;file_cf4{ii}];end
peak2peak(nn4_conc,cf4_conc,'45010','NN','CFSR')
clf