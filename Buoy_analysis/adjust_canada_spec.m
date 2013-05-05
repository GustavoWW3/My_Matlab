function aa = adjust_canada_spec(bb)

ii = bb.hsb > 0.5;
aa.date = bb.date(ii,:);
aa.timemat = bb.timemat(ii,:);
aa.ef = bb.ef(:,ii);
aa.bw = bb.bw(:,ii);
aa.freq = bb.freq(:,ii);
aa.tm = bb.tm(ii);
aa.hsb = bb.hsb(ii);
aa.tpb = bb.tpb(ii);

aa.efold = aa.ef;

for ii = 1:size(aa.ef,2);
dum = 0;
nfreq = size(aa.freq,1);
for jj = nfreq:-1:1
    dum = dum + aa.efold(jj,ii).*aa.bw(jj,ii);
    if dum == aa.hsb(ii).^2/16
        aa.ef(1:jj-1,ii) = 0;
        break
    elseif dum > aa.hsb(ii).^2/16
        aa.ef(1:jj,ii) = 0;
        break
    end
end

aa.hs(ii) = 4.0*sqrt(sum(aa.ef(:,ii).*aa.bw(:,ii)));
ip = find(aa.ef(:,ii) == max(aa.ef(:,ii)));

if length(ip) > 1
    if ip(1) == ip(2)-1
        ip = ip(1);
    else
        ip = ip(2);
    end
end
% if ip < 12
%     ip = 12;
% end

aa.tp(ii) = 1.0/aa.freq(ip,ii);
end
    

