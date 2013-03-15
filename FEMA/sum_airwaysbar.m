load SUMMARY_METSTNS.dat

figure('inverthardcopy','off','color','white')
bar(SUMMARY_METSTNS(:,1),SUMMARY_METSTNS(:,2),'r')
grid
xlabel('YEARS PROCESSED','FontWeight','bold')
ylabel('Number of AIR WAYS Met Stations','FontWeight','bold')
title('TIME VARIATION OF AIRWAYS Meteorological Stations','FontWeight','bold')
print -dpng AIRWAYS_StnsvsTime