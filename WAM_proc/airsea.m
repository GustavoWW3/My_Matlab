function [u10buoy] = airsea(elev,ws,at,st)

nww = size(elev,1);
iwnd=find(ws > 0 & at > -100 & st > -100);
jwnd=find(at <= -999 & st <= -999);
kwnd=find(ws <= -999);
u10buoy=zeros(nww);
ele=zeros(nww);
ielez=find(elev == 0.0, 1);
if isempty(ielez)
    ele=elev;
else
    ele(1:nww,1)=5.0;
end
air_sea(iwnd,1)=at(iwnd,1)-st(iwnd,1);
temdifa=length(find(at == 0));
temdifs=length(find(st == 0));
if temdifa > 0.5*nww || temdifs > 0.5*nww
    air_sea(1:nww,1)=0.;
end

[u10buoy(iwnd)]=windp(100*ws(iwnd,1),100*ele(iwnd,1),air_sea(iwnd,1),100*ele(iwnd,1));
u10buoy(jwnd)= ws(jwnd,1).*(ele(jwnd,1) / 10.).^(-1/7);
u10buoy(kwnd) = ws(kwnd,1);
kbadu10=find(imag(u10buoy));
u10buoy(kbadu10)=ws(kbadu10,1);
thresh=floor(0.05*length(u10buoy));
if length(iwnd) < thresh
    u10buoy(1:length(u10buoy)) = NaN;
end

end