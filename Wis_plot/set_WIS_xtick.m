function set_WIS_xtick(minf,maxf)

xlimmx = [minf,maxf];
xtickdiff = maxf - minf;
xticks = [minf:ceil(xtickdiff/12):maxf];
xticklab = datestr(xticks,6);
set(gca,'xtick',xticks,'xticklabel',xticklab,'xlim', ...
    [minf maxf]);
