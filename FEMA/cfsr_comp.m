clear all

%time = [2000:1:2009];
time = [2000:1:2009];
%time = 2003;
name = ['45147';'CLSM4';'LSCM4'];
month = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
fname = {'45147-';'CLSM4-';'lscm4-'};
    
file_mod = dir('*station*.dat');
for zzz = 1:size(file_mod,1)
filename1 = getfield(file_mod(zzz),'name');
mod{zzz} = load(filename1);
end
date = num2str(mod{1}(:,1));
date5 = num2str(mod{2}(:,1));
year_m = str2num(date(:,1:4));
mon_m = str2num(date(:,5:6));
date_mod = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
        str2num(date(:,9:10)),str2num(date(:,11:12)),00);
date_mod5 = datenum(str2num(date5(:,1:4)),str2num(date5(:,5:6)),str2num(date5(:,7:8)), ...
        str2num(date5(:,9:10)),str2num(date5(:,11:12)),00);
for ii = 1:3
    mod_mag(:,ii) = sqrt(mod{1}(:,2*ii).^2 + mod{1}(:,2*ii+1).^2);
    mod_dir(:,ii) = (-1.0*atan2(mod{1}(:,2*ii),-1.0*mod{1}(:,2*ii+1)))*180/pi;
    vv = find(mod_dir(:,ii) < 0);
    mod_dir(vv,ii) = mod_dir(vv,ii) + 360;
    mod_pre(:,ii) = mod{2}(:,ii+1);
   % else 
   %     mod_dir(:,ii) = (atan2(mod(:,2*ii),mod(:,2*ii+1)))*180/pi + 180;
   %     vv = find(mod_dir(:,ii) < 0);
   %     mod_dir(vv,ii) = mod_dir(vv,ii) + 360;
   % end
end
for zz = 1:size(time,2);
    %fname = ['*',num2str(time(zz)),'*'];
     %fname = ['*LSCM4-',num2str(time(zz)),'*'];        
     %files = dir(fname);
    % nl = size(files,1);
    for qq = 1:3
    %qq = 3;
        fname2 = ['999999-',fname{qq},num2str(time(zz)),'.OUT'];
        %filename2 = getfield(files(qq),'name');
        %fid = fopen(filename2,'r');
        if exist(fname2);
        fid = fopen(fname2,'r');
        data = textscan(fid,'%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',3);
        fclose(fid);
        for jj = 3:size(data,2)
            g1{qq}(:,jj-2) = data{1,jj};
        end
        date = num2str(g1{qq}(:,1));
        else
            g1{qq}(1,1:11) = 0;
            date = '000000000000';
        end
        yr1{qq} = str2num(date(:,1:4));
        mon1{qq} = str2num(date(:,5:6));
        date1{qq} = datenum(str2num(date(:,1:4)),str2num(date(:,5:6)),str2num(date(:,7:8)), ...
            str2num(date(:,9:10)),str2num(date(:,11:12)),00);
    end
    oo = 0;
    oo2 = 0;
    cmax3 = 0;
     for jj = 1:12

        for qq = 1:3
            pp = find(mon1{qq} == jj);
            if size(pp,1) > 0
            ll = find(year_m == time(zz) & mon_m == jj);
            oo = oo+1;
            figure(1)
            orient('tall');
            subplot(6,1,2*qq-1)
            rr = find(g1{qq}(pp,9) < 0); 
            g1{qq}(pp(rr),9:11) = NaN;
            nn = find(g1{qq}(pp,9) >= 99);
            g1{qq}(pp(nn),9:11) = NaN;
            plot(date1{qq}(pp,1),g1{qq}(pp,9),'r.','MarkerSize',8);
            hold on
            plot(date_mod(ll,1),mod_mag(ll,qq),'b-','LineWidth',1)
            capw{1}(qq) = max(max(g1{qq}(pp,9)),max(mod_mag(ll,qq)));
            
            subplot(6,1,2*qq)
            plot(date1{qq}(pp,1),g1{qq}(pp,10),'r.','MarkerSize',8);
            hold on
            plot(date_mod(ll,1),mod_dir(ll,qq),'b-','LineWidth',1)
            
            ll2 = find(str2num(date5(:,1:4)) == time(zz) & str2num(date5(:,5:6)) == jj);
            figure(2)
            orient('tall');
            subplot(3,1,qq)
            plot(date1{qq}(pp,1),g1{qq}(pp,11),'r.','MarkerSize',8);
            hold on
            plot(date_mod5(ll2,1),mod_pre(ll2,qq),'b-','LineWidth',1)
            capw{2}(qq) = max(max(g1{qq}(pp,11)),max(mod_pre(ll,qq)));
            capw{2}(qq) = 1050;
            end
        end
        if oo > 0
            for zzz = 1:2
            figure(zzz)
            ylim = max(capw{zzz});
            hleg=legend('BUOY','CFSR');
            po=get(hleg,'position');
            po=[0.15 0.95 0.08 0.03];
            set(hleg,'position',po);
            for qq = 1:3
                if zzz == 1
                subplot(6,1,2*qq-1)
                if qq == 1
                    tit1 = ['Lake St. Clair  CFSR vs Buoy Winds, ',month(jj,:),' ',num2str(time(zz))];
                    text(min(date_mod(ll,1))+6,ylim + 0.4*ylim,tit1,'FontSize',14);
                end
                else 
                    subplot(3,1,qq)
                   if qq == 1
                    tit1 = ['Lake St. Clair  CFSR vs Buoy Pressure, ',month(jj,:),' ',num2str(time(zz))];
                    text(min(date_mod(ll,1))+6,1072,tit1,'FontSize',14);
                end
                end
                %if qq == 1

                %end

                if zzz == 1
                axis([min(date_mod(ll,1)) max(date_mod(ll,1)) 0 ylim])
                else 
                   axis([min(date_mod(ll,1)) max(date_mod(ll,1)) 950 ylim]) 
                end
                xticks=get(gca,'XTick');
                xx=datestr(xticks,6);
                set(gca,'XTick',xticks,'XTicklabel',xx);
                grid
                if zzz == 1
                ylabel('WS (m/s)')
                else 
                    ylabel('SLPRE (mbar)')
                end
                text(max(date_mod(ll,1))-3.0,ylim-0.08*ylim,name(qq,:))
                if zzz == 1 
                ylimmx=[0,ylim];
                if ylimmx(2) <= 2
                    ytd1 = ylimmx(2)/4;
                    ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
                else
                    ytd1 = ceil(ylimmx(2)/4);
                    ytickm = [ytd1 2*ytd1 3*ytd1 4*ytd1];
                end
                else 
                    ylimmx = [950,ylim];
                    ytickm = [950 1000 1050];
                end
                set(gca,'YTick',ytickm);
                if zzz == 1
                subplot(6,1,2*qq)
                axis([min(date_mod(ll,1)) max(date_mod(ll,1)) 0 360])
                xticks=get(gca,'XTick');
                xx=datestr(xticks,6);
                set(gca,'XTick',xticks,'XTicklabel',xx);
                grid
                ylabel('\theta_{dir}')
                text(max(date_mod(ll,1))-3.0,360-0.08*360,name(qq,:))
                ytickm = [90 180 270 360];
                set(gca,'YTick',ytickm);
                end
            end
            if zzz == 1
            subplot(6,1,6)
            xlab = ['Year ',num2str(time(zz))];
            xlabel(xlab);
            ff3 = ['CFSR-',num2str(time(zz)),'-',num2str(jj)];
            print(gcf,'-dpng','-r600',ff3);
            clf
            else 
                subplot(3,1,3)
                xlab = ['Year ',num2str(time(zz))];
                xlabel(xlab);
                ff3 = ['CPRE-',num2str(time(zz)),'-',num2str(jj)];
                print(gcf,'-dpng','-r600',ff3);
                clf
            end
            end

        oo = 0;
        end
        
        for qq = 1:3
        %qq = 3;
            pp = find(mon1{qq} == jj);
            if size(pp,1) > 0
                oo2 = oo2 + 1;
            ll = find(year_m == time(zz) & mon_m == jj);
            windma = mod_mag(ll,qq);
            windd = mod_dir(ll,qq);

            date_mod2 = date_mod(ll,1);
            g2 = zeros(size(ll),2);
            for ii = 1:size(windma,1)
                %for ww = 1:size(pp,1)
                %    if (date1{qq}(pp(ww),1) == date_mod2(ii,1));
                ss = find(date1{qq}(pp,1) == date_mod2(ii,1)); 
                if size(ss,1) == 1
                g2(ii,1:2) = g1{qq}(pp(ss),9:10);
                else
                        g2(ii,1:2) = NaN;
                end
                if g2(ii,1:2) < 0
                    g2(ii,1:2) = NaN;
                end
                    clear ss
            
                
            end
            ss = find(isnan(g2(:,1)) == 0);
           for mm = 1:length(ss)
            if windma(ss(mm),1) <= 3.5 
                windm(mm,1) =  windma(ss(mm),1)*2.2 - 1.2;
%             elseif windma(ss(mm),1) > 7.5
%                windm(mm,1) =  -0.073.*windma(ss(mm),1).^2+windma(ss(mm),1).*2.7 - 4.2;
            else
                windm(mm,1) =  windma(ss(mm),1).*1.4 + 1.4;
            end
           end

            windm = windma(ss,1);
            [qqB qqM] = qq_proc(g2(ss,1),windm(:,1));
            bbop(1:size(ss,1),1) = -99.99;      
            aa = [date_mod2(ss,1),g2(ss,1),g2(ss,2),bbop,bbop,bbop,bbop];
            bb = [date_mod2(ss,1),windm(ss,1),windd(ss,1),bbop,bbop,bbop,bbop];
            [se, sd] = stats_ftn_no(aa,bb,'','','','','','');
            figure(2)
            orient('tall');
             cmax2 = max(max(g2(:,1)),max(windm));
            subplot(3,2,2*qq-1)
            plot(g2(:,1),windm,'r.',[0 cmax2],[0 cmax2],'b-','MarkerSize',8,'LineWidth',1);
            grid
            axis([0 cmax2 0 cmax2])
            axis('square');
            xlabel('Buoy WS');
            ylabel('CFSR WS');
            tit1 = ['CFSR at ',name(qq,:),' ',month(jj,:),' ',num2str(time(zz))];
            title(tit1);
            
            str(1) = {['No Obs = ',int2str(length(ss))]};
            str(2) = {['Bias   = ',num2str(se(1,4))]};
            str(3) = {['RMSE   = ',num2str(se(1,5))]};
            str(4) = {['S.I.   = ',int2str(se(1,6))]};
            str(5) = {['Corr   = ',num2str(se(1,8))]};
            str(6) = {['Sym r  = ',num2str(se(1,9))]};
            text(cmax2+ 0.1*cmax2,0,str,'FontSize',7);
            clear str;
            
            subplot(3,2,2*qq)
            plot(qqB,qqM,'r+',[0 cmax2],[0 cmax2],'b-','MarkerSize',4,'LineWidth',1);
            grid
            axis([0 cmax2 0 cmax2])
            axis('square');
            xlabel('Buoy WS')
            ylabel('CFSR WS')
            tit2 = ['CFSR vs ',name(qq,:),' Q-Q ',month(jj,:),' ',num2str(time(zz))];
            title(tit2); 
                                      
            figure(3)
            orient('tall');
            subplot(3,2,2*qq-1)
            plot(g2(:,2),windd,'r.',[0 360],[0 360],'b-','MarkerSize',8,'LineWidth',1);
            grid
            axis([0 360 0 360])
            axis('square');
            xlabel('Buoy \theta_{wind}');
            ylabel('CFSR \theta_{wind}');
            tit1 = ['CFSR at ',name(qq,:),' ',month(jj,:),' ',num2str(time(zz))];
            title(tit1);
            
            str(1) = {['No Obs = ',int2str(length(ss))]};
            str(2) = {['Scl X   = ',num2str(sd(1,1))]};
            str(3) = {['Scl Y   = ',num2str(sd(1,2))]};
            str(4) = {['Vec X  = ',num2str(sd(1,3))]};
            str(5) = {['Vec Y  = ',num2str(sd(1,4))]};
            str(6) = {['Diff   = ',num2str(sd(1,5))]};
            str(7) = {['Sigma  = ',num2str(sd(1,6))]};
            str(8) = {['Rho    = ',num2str(sd(1,7))]};
            str(9) = {['Phase = ',num2str(sd(1,8))]};
            text(360+ 0.075*360,-10,str,'FontSize',7);
            clear str;
            
            nbins=36;
            resbins=360/nbins;
            DIRINT=0:resbins:360-resbins;
            NHIB=hist(g2(ss,2),nbins);
            NHIM=hist(windd(ss,1),nbins);
            cumtotM=cumsum(NHIM)/length(ss);
            cumtotB=cumsum(NHIB)/length(ss);
            
            subplot(3,2,2*qq)
            HC=plot(DIRINT,cumtotB,'ro',DIRINT,cumtotM,'b*');
            grid
            axis([0,350,0 1]);
            legend(HC,'Buoy','Mod',4);
            axis('square');
            ylabel('Cum. %');
            xchar=['Dir Binned at ',int2str(resbins),'\circ' ];
            xlabel(xchar);
            clear HC; clear NHIB; clear NHIM; clear cumtotM; clear cumtotB;
            clear ss se sd
            qqBt(:,jj) = qqB;
            qqMt(:,jj) = qqM;
            cmax3 = max(cmax3,cmax2);
            
            ll2 = find(str2num(date5(:,1:4)) == time(zz) & str2num(date5(:,5:6)) == jj);
            windp = mod_pre(ll2,qq);
            date_mod6 = date_mod5(ll2,1);
            g3 = zeros(size(ll2),2);
            for ii = 1:size(windp,1)
                %for ww = 1:size(pp,1)
                %    if (date1{qq}(pp(ww),1) == date_mod2(ii,1));
                ss = find(date1{qq}(pp,1) == date_mod6(ii,1)); 
                if size(ss,1) == 1
                g3(ii,1) = g1{qq}(pp(ss),11);
                else
                        g3(ii,1) = NaN;
                end
                    clear ss
            end
            ss = find(isnan(g3(:,1)) == 0);
            bbop2(1:size(ss,1),1) = -99.99;      
            aa = [date_mod6(ss,1),bbop2,bbop2,g3(ss,1),bbop2,bbop2,bbop2];
            bb = [date_mod6(ss,1),bbop2,bbop2,windp(ss,1),bbop2,bbop2,bbop2];
            [se, sd] = stats_ftn_no(aa,bb,'','','','','','');
            figure(4)
            [qqB qqM] = QQ_proc(g3(ss,1),windp(ss,1));
            orient('tall');
            cmax2 = 1050;
            subplot(3,2,2*qq-1)
            plot(g3(:,1),windp,'r.',[950 cmax2],[950 cmax2],'b-','MarkerSize',8,'LineWidth',1);
            grid
            axis([950 cmax2 950 cmax2])
            axis('square');
            xlabel('Buoy SLPRE');
            ylabel('CFSR SLPRE');
            tit1 = ['CFSR at ',name(qq,:),' ',month(jj,:),' ',num2str(time(zz))];
            title(tit1);
            
            str(1) = {['No Obs = ',int2str(length(ss))]};
            str(2) = {['Bias   = ',num2str(se(2,3))]};
            str(3) = {['RMSE   = ',num2str(se(2,5))]};
            str(4) = {['S.I.   = ',int2str(se(2,6))]};
            str(5) = {['Corr   = ',num2str(se(2,8))]};
            str(6) = {['Sym r  = ',num2str(se(2,9))]};
            text(1060,952,str,'FontSize',7);
            clear str;
            
            subplot(3,2,2*qq)
            plot(qqB,qqM,'r+',[0 cmax2],[0 cmax2],'b-','MarkerSize',4,'LineWidth',1);
            grid
            axis([950 cmax2 950 cmax2])
            axis('square');
            xlabel('Buoy SLPRE')
            ylabel('CFSR SLPRE')
            tit2 = ['CFSR vs ',name(qq,:),' Q-Q ',month(jj,:),' ',num2str(time(zz))];
            title(tit2); 
            end
                 clear ss g2 bbop g3 bbop2 windm
         end
        if oo2 > 0
        ff4 = ['CFSR-',num2str(time(zz)),'-',num2str(jj),'-qq1'];
        ff5 = ['CFSR-',num2str(time(zz)),'-',num2str(jj),'-qq2'];
        ff6 = ['CPRE-',num2str(time(zz)),'-',num2str(jj),'-qq1'];
            print(figure(2),'-dpng','-r600',ff4);
            clf(figure(2))
            print(figure(3),'-dpng','-r600',ff5);
            clf(figure(3))
            print(figure(4),'-dpng','-r600',ff6);
            clf(figure(4))
            oo2 = 0;
        end
               
  end
  figure(4)
  orient('tall')
  subplot(4,2,zz)
     for jj = 1:12
        for mm = 1:size(qqBt,1)
            if qqMt(mm,jj) <= 3.5
                qqMta(mm,jj) = 2.2*qqMt(mm,jj)-1.2;
            else
                qqMta(mm,jj) = 1.4*qqMt(mm,jj)+1.4;
            end
        end
         qqMta(:,jj) = qqMt(:,jj);
        plot(qqBt(:,jj),qqMta(:,jj),'r-',[0 cmax3],[0 cmax3],'b-','MarkerSize',4,'LineWidth',1);
        hold on
        if jj == 12
           grid
           axis([0 cmax3 0 cmax3])
           axis('square');
           xlabel('LSCM4 WS')
           ylabel('CFSR WS')
           tit2 = ['CFSR vs ',name(3,:),' Q-Q ',' ',num2str(time(zz))];
           title(tit2);
        end
     
     end
     for jj = 1:size(qqBt,1)
        qqBtm(jj,1) = mean(qqBt(jj,:));
        qqMtm(jj,1) = mean(qqMta(jj,:));
     end
     plot(qqBtm,qqMtm,'g+','MarkerSize',4);
 
     cmax3 = 0;
    clear g1 mon1 date1 yr1 pp ll qqBt qqMt 
end  
     ff6 = ['CFSR-',name(3,:),'-total-qq'];
     print(figure(4),'-dpng','-r600',ff6);
     clf(figure(4));
     
    