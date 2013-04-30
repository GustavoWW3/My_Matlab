function aa = reflection(aa)

%Reflection Analysis
grav = 9.81;
numrec = 1;
g=aa.wave(:,1:3);
an=zeros(size(g,1)/2-1,3); bn=zeros(size(g,1)/2-1,3);
sn=zeros(size(g,1)/2-1,3);
for jj = 1:3
    reclen = max(floor(size(g)/2)*2)/numrec;
    df = 1/(reclen*aa.dt);
    f = (1:reclen/2-1).*df;
    fn = fft(aa.wave(:,jj),reclen);
    a0 = fn(1)/reclen;
    an(:,jj) = 2*real(fn(2:reclen/2))/reclen;
    bn(:,jj) = -2*imag(fn(2:reclen/2))/reclen;
    sn(:,jj) = 2*abs((an(:,jj)+1i*bn(:,jj))./2).^2 /df;
end

%--------------------------------------------------------------------------
%Solve the linear dispersion relation for all frequencies
w = [];k = [];
for ii = 1:size(f,2);
    w(ii) = 2*pi*f(ii);
    kk = w(ii)/sqrt(grav*aa.h);
    while(abs(w(ii)^2-grav*kk*tanh(kk*aa.h))>0.0001),
        kk = kk-(w(ii)^2 - grav*kk*tanh(kk*aa.h))/(-grav*tanh(kk*aa.h) - grav*kk*...
            aa.h*sech(kk*aa.h)^2);
    end
    k(ii) = kk;
end
%--------------------------------------------------------------------------
%Solve for inceident and reflected amplitudes at each frequency
ind=cell(3,1);
pos=[0 0.3048 0.9144];
g1 = [1 1 2];
g2 =[2 3 3];
ainc=zeros(3,length(k)); binc=zeros(3,length(k));
aref=zeros(3,length(k)); bref=zeros(3,length(k));
for j = 1:3
    teman1=an(:,g1(j));
    teman2=an(:,g2(j));
    tembn1=bn(:,g1(j));
    tembn2=bn(:,g2(j));
    tems1=sn(:,g1(j));
    tems2=sn(:,g2(j));
    pos1=pos(g1(j));
    pos2=pos(g2(j));
    ainc(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        -teman2'.*sin(k*pos1) + teman1'.*sin(k*pos2) + ...
        tembn2'.*cos(k*pos1) - tembn1'.*cos(k*pos2)  );
    binc(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        +teman2'.*cos(k*pos1) - teman1'.*cos(k*pos2) + ...
        +tembn2'.*sin(k*pos1) - tembn1'.*sin(k*pos2)  );
    aref(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        -teman2'.*sin(k*pos1) + teman1'.*sin(k*pos2) + ...
        -tembn2'.*cos(k*pos1) + tembn1'.*cos(k*pos2)  );
    bref(j,:) = 1./(2*sin(k*(pos2-pos1))) .* ( ...
        teman2'.*cos(k*pos1) - teman1'.*cos(k*pos2) + ...
        -tembn2'.*sin(k*pos1) + tembn1'.*sin(k*pos2)  );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %find the appropriate range to be seperated
    ind{j} = find(k*(pos2-pos1)<= .9*pi&k*(pos2-pos1)>=pi/10);
    %        eval(['ind',num2str(j),'=ind;']);
    if(j==1); maxind = max(ind{j});minind = min(ind{j});end
    maxind = max([maxind ind{j}]);minind = min([minind ind{j}]);
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Average the above overlapping results
    indtot = (minind:maxind);
    anincav = zeros(1,length(ainc(j,:)));anrefav = anincav;
    bnincav = anincav;bnrefav = anincav;
    countnum = zeros(1,length(ainc(j,:)));
    for j = 1:3;
%         eval(['ind = ind',num2str(j),';'])
        aninc=ainc(j,:);
        anref=aref(j,:);
        bninc=binc(j,:);
        bnref=bref(j,:);

        for jj = minind:maxind
            if length(find(ind{j}==jj))==1;
                anincav(jj) = anincav(jj)+aninc(jj);
                anrefav(jj) = anrefav(jj)+anref(jj);
                bnincav(jj) = bnincav(jj)+bninc(jj);
                bnrefav(jj) = bnrefav(jj)+bnref(jj);
                countnum(jj) = countnum(jj)+1;
            end
        end
    end
    anincav(minind:maxind) = anincav(minind:maxind)./countnum(minind:maxind);
    anrefav(minind:maxind) = anrefav(minind:maxind)./countnum(minind:maxind);
    bnincav(minind:maxind) = bnincav(minind:maxind)./countnum(minind:maxind);
    bnrefav(minind:maxind) = bnrefav(minind:maxind)./countnum(minind:maxind);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aa.refco = sqrt(sum((anrefav(indtot)).^2+(bnrefav(indtot)).^2) / ...
        sum((anincav(indtot)).^2+(bnincav(indtot)).^2));
    moi = df*sum(1/(2*df)*( (anincav(indtot)).^2+(bnincav(indtot)).^2 ));
    mor = df*sum(1/(2*df)*( (anrefav(indtot)).^2+(bnrefav(indtot)).^2 ));
    motot = df*sum(tems1(indtot));
    [ind22,ind2] = max( (anincav(indtot)).^2+ (bnincav(indtot)).^2);
    f2 = f(indtot);
    Tpi = 1/f2(ind2);
    aa.Hmoi=4*(moi)^0.5;
    aa.Hmor=4*(mor)^0.5;
    aa.Hmotot=4*(motot)^0.5;