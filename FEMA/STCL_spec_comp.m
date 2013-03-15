clear all
storm = input('Storm number and year (ie. STCL-Storm03-1999): ','s');

[bnt,bpt] = uigetfile('*','Select Buoy File:');
[mnt,mpt] = uigetfile('*','Select Mod File:');

buoyfile = [bpt,bnt];
modfile = [mpt,mnt];

NDBC_spec_vsp(buoyfile);
wam_2_vsp(modfile);

buoyvsp = [bpt,bnt(1:end-5),'vsp'];
modvsp = [mpt,mnt(1:end-5),'vsp'];

[datem freqm specm] = readin_vsp(modvsp);
[dateb freqb specb] = readin_vsp(buoyvsp);

[date_buoy] = datenum(dateb(:,1),dateb(:,2),dateb(:,3),dateb(:,4),00,00);
[date_mod] = datenum(datem(:,1),datem(:,2),datem(:,3),datem(:,4),00,00);

for jj = 1:size(date_mod,1);
    qq = find(date_buoy == date_mod(jj,1));
    if size(qq,1) == 1
        break
    end
end
for jj = size(date_mod,1):-1:1
    mm = find(date_buoy == date_mod(jj,1));
    if size(mm,1) == 1
        break
    end
end
    
pp = [qq:1:mm];
%end
    
for jj = 1:size(pp,2)
    Hmobt(jj,1) = 4.0*sqrt(trapz(freqb(pp(jj),:),specb(pp(jj),:)));
end
for jj = 1:size(date_mod,1)
    Hmomt(jj,1) = 4.0*sqrt(trapz(freqm(jj,:),specm(jj,:)));
    
    ii = find(freqm(jj,:) <= 0.3 & freqm(jj,:) >= 0.2);
    Hmomm(jj,1) = 4.0*sqrt(trapz(freqm(jj,ii),specm(jj,ii)));
    
    rr = find(freqm(jj,:) > 0.3);
    Hmoms(jj,1) = 4.0*sqrt(trapz(freqm(jj,rr),specm(jj,rr)));
end

figure('inverthardcopy','on','color','white')
plot(date_buoy(pp(1)),Hmobt(1,1),'ro')
hold on
plot(date_mod(1),Hmomt(1,1),'bx')
plot(date_mod(1),Hmoms(1,1),'g-')
plot(date_mod(1),Hmomm(1,1),'k-')

plot(date_buoy(pp(2:end)),Hmobt(2:end,1),'ro')
plot(date_mod(2:end),Hmomt(2:end,1),'bx')
plot(date_mod,Hmoms,'g-')
plot(date_mod,Hmomm,'k-')

xticks=get(gca,'XTick');
xx=datestr(xticks,6);
set(gca,'XTick',xticks,'XTicklabel',xx);
year = storm(end-3:end);
xlabel(year)
ylabel('H_{mo} (m)')
legend('Total Buoy','Total Model','Model f > 0.3','Model 0.2 < f < 0.3')
grid
title(storm)


print(gcf,'-dpng','-r600',storm)
clf


figure('inverthardcopy','on','color','white')
plot(freqm(1,:),specm(1,:),'b-')
 hold on
plot(freqb(pp(1),:),specb(pp(1),:),'r-')


for jj = 2:size(date_mod,1)
   plot(freqm(jj,:),specm(jj,:),'b-')
end
for jj = 2:size(pp,2)
   plot(freqb(pp(jj),:),specb(pp(jj),:),'r-')
end

xlabel('Frequency (Hz)')
ylabel('S(f) (m^2/Hz)')
legend('Model','Buoy')
grid
fout2 = [storm,'-Spectra'];
title(fout2)
emax = max(max(max(specm)),max(max(specb(pp,:))));
axis([0 1.0 0 emax]);
print(gcf,'-dpng','-r600',fout2);
clf
close all


