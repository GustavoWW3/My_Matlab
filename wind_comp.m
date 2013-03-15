clear all

file_mod = dir('*station*.dat');
file_g1 = dir('*CLSM4*');
file_g2 = dir('*lscm4*');
file_g3 = dir('*45147*');

filename1 = getfield(file_mod,'name');
mod = load(filename1);
date = num2str(mod(:,1));
date_mod = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
        str2num(date(:,9:10)),str2num(date(:,11:12)),00);

for ii = 1:size(file_g1,1)
    filename2 = getfield(file_g1(ii),'name');
    name1{ii} = ['y',filename2(8:11)];
    fid = fopen(filename2,'r');
     data = textscan(fid,'%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',3);
    fclose(fid);
    for jj = 3:size(data,2)
        g1{ii}(:,jj-2) = data{1,jj};
    end
    date = num2str(g1{ii}(:,1));
    yr1{ii} = str2num(date(:,1:4));
    mon1{ii} = str2num(date(:,5:6));
    date1{ii} = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
        str2num(date(:,9:10)),str2num(date(:,11:12)),00);
end

for ii = 1:size(file_g2,1)
    filename2 = getfield(file_g2(ii),'name');
    name2{ii} = ['y',filename2(8:11)];
    fid = fopen(filename2,'r');
    data = textscan(fid,'%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',3);
    fclose(fid);
    for jj = 3:size(data,2)
        g2{ii}(:,jj-2) = data{1,jj};
    end
    date = num2str(g2{ii}(:,1));
    yr2{ii} = str2num(date(:,1:4));
    mon2{ii} = str2num(date(:,5:6));
    date2{ii} = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
        str2num(date(:,9:10)),str2num(date(:,11:12)),00);
end

for ii = 1:size(file_g3,1)
    filename2 = getfield(file_g3(ii),'name');
    name3{ii} = ['y',filename2(14:17)];
    fid = fopen(filename2,'r');
    data = textscan(fid,'%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',3);
    fclose(fid);
    for jj = 3:size(data,2)
        g3{ii}(:,jj-2) = data{1,jj};
    end
    date = num2str(g3{ii}(:,1));
    yr3{ii} = str2num(date(:,1:4));
    mon3{ii} = str2num(date(:,5:6));
    date3{ii} = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
        str2num(date(:,9:10)),str2num(date(:,11:12)),00);
end

mond = [1 3 5 7 9 11 13];
for qq = 1:10
   jj = find(date_mod >= min(date3{qq}) & date_mod <= max(date3{qq}));
   windc = sqrt(mod(jj,2).^2 + mod(jj,3).^2);
   pp = length(windc);
   gg3(1:pp,1) = NaN;
   gg3 = g3{qq}(:,9);
   ig3k = find(gg3(:,1) > 0);
   cmax = max(max(gg3(ig3k,1)),max(windc(ig3k,1)));
%    if size(jj,1) > 0
   [qqB qqM] = qq_proc(gg3(ig3k,1),windc(ig3k,1));
   figure(1)
   orient('tall')
   for pp = 1:7
    subplot(7,1,pp)
    mm = find(mon3{qq} == pp); 
    if size(mm,1) > 0
   plot(date3{qq}(mm,1),gg3(mm,1),'r.','MarkerSize',8)
   hold on
   ll = find(date_mod(:,1) >= min(date3{qq}(mm,1)) & date_mod(:,1) <= max(date3{qq}(mm,1)));
   windt = sqrt(mod(ll,2).^2 + mod(ll,3).^2);
   plot(date_mod(ll,1),windt,'b-','LineWidth',1)
   axis([min(date3{qq}(mm,1)) max(date3{qq}(mm,1)) 0 cmax]);
   xticks=get(gca,'XTick');
   xx=datestr(xticks,6);
   set(gca,'XTick',xticks,'XTicklabel',xx);
    end
   end
    ff3 = ['QQ-CFSR-',name3{qq},'-p1'];
        print(gcf,'-dpng','-r400',ff3);
        clf
   figure(1)
   orient('tall')
   for pp = 8:12
      subplot(7,2,pp*2-15:pp*2-14)
    mm = find(mon3{qq} == pp); 
    if size(mm,1) > 0
   plot(date3{qq}(mm,1),gg3(mm,1),'r.','MarkerSize',8)
   hold on
   ll = find(date_mod(:,1) >= min(date3{qq}(mm,1)) & date_mod(:,1) <= max(date3{qq}(mm,1)));
   windt = sqrt(mod(ll,2).^2 + mod(ll,3).^2);
   plot(date_mod(ll,1),windt,'b-','LineWidth',1)
   axis([min(date3{qq}(mm,1)) max(date3{qq}(mm,1)) 0 cmax]);
   xticks=get(gca,'XTick');
   xx=datestr(xticks,6);
   set(gca,'XTick',xticks,'XTicklabel',xx);
    end
   end 
   subplot(7,2,[11 13])
        plot(gg3(ig3k,1),windc(ig3k,1),'r.',[0 cmax],[0 cmax],'b')
        grid
        axis([0,cmax,0,cmax]);
        axis('square')
        %name1 = ['WAM ',comp(ii).name];
        %name2 = ['Buoy ',comp(ii).name];
        %ylabel(name1);
        %xlabel(name2);
        %titchar1=['WAM4.5.1C  ',' at ',int2str(buoy),' ',montit,' ' ,YR1];
        %if ii == 1
        %    title(titchar1);
        %end
        %str(1) = {['No Obs = ',int2str(length(vars{rr(ii)-1}))]};
        %str(2) = {['Bias   = ',num2str(se(ii+1,4))]};
        %str(3) = {['RMSE   = ',num2str(se(ii+1,5))]};
        %str(4) = {['S.I.   = ',int2str(se(ii+1,6))]};
        %str(5) = {['Corr   = ',num2str(se(ii+1,8))]};
        %str(6) = {['Sym r  = ',num2str(se(ii+1,9))]};
        %text(comp(ii).max+ 0.1*comp(ii).max,0,str,'FontSize',7);
        %clear str; 
        %
        subplot(7,2,[12 14])
        plot(qqB,qqM,'r+',[0 cmax],[0 cmax],'b')
        grid
        axis([0,cmax,0,cmax]);
        axis('square')
        %ylabel(name1)
        %xlabel(name2)
        %titchar2=['WAM4.5.1C  ',' vs ',int2str(buoy),' Q-Q ',montit,' ' ,YR1];
        %if ii == 1
        %    title(titchar2);
        %end
        dist(1)= {['%tile  ','BUOY','  WAM']};
        dist(2)= {['  99    ',num2str(qqB(99),'%6.2f'),'      ',num2str(qqM(99),'%6.2f')]};
        dist(3)= {['  95    ',num2str(qqB(95),'%6.2f'),'      ',num2str(qqM(95),'%6.2f')]};
        dist(4)= {['  90    ',num2str(qqB(90),'%6.2f'),'      ',num2str(qqM(90),'%6.2f')]};
        dist(5)= {['  85    ',num2str(qqB(85),'%6.2f'),'      ',num2str(qqM(85),'%6.2f')]};
        dist(6)= {['  80    ',num2str(qqB(80),'%6.2f'),'      ',num2str(qqM(80),'%6.2f')]};
        %text(comp(ii).max+0.02*comp(ii).max,0,dist,'FontSize',7);
        %
        %  First Write To File
        %       Wave Height Statistics and QQ results  'filestats'
        %       Mean Buoy, Mean Model, Bias, abs(error), rms(error) [1:5]
        %       SI, SS, Corr, Sym r,                                {6:9]
        %       Prin r, Slope, intercept, Sys Error Usys Error      [10:14]
        %       RMSE-slope, Std-a, Std-b, Number Pts                [15:18]
        %
        %fprintf(fidstats,'  %4.0f  %2.0f  %1.0f  %5.0f',yrin,mntin,recno1,buoy);
        %fprintf(fidstats,'  %7.2f  %7.2f  %6.0f',LONout,LATout,DEPout);
        %fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',se(2,1:5));
        %fprintf(fidstats,'  %3.0f  %5.2f  %6.2f  %6.2f',se(2,6:9));
        %fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.3f %6.3f',se(2,10:14));
        %fprintf(fidstats,'  %6.3f  %6.4f  %6.4f  %6.0f',se(2,15:18));
        %
        %   Q-Q:  Buoy then Model Results
        %       
        %fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f',qqB(99),qqB(95),qqB(90),qqB(85),qqB(80));
        %fprintf(fidstats,'  %6.2f  %6.2f  %6.2f  %6.2f %6.2f \n',qqM(99),qqM(95),qqM(90),qqM(85),qqM(80));
        
        clear qqB; clear qqM;
        %
        %
        %end
        ff3 = ['QQ-CFSR-',name3{qq},'-p2'];
        print(gcf,'-dpng','-r400',ff3);
        clf
        clear ig3k jj windc
   %end
end