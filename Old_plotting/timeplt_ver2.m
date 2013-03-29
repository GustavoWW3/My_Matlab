function timeplt_ver2(yrin,mntin,res)



%%
nodata = {'No Wave Height Data';'No Peak Period Data';'No Mean Period Data'; ...
    'No Wave Direction Data';'No Wind Speed Data';'No Wind Direction Data'};

ylimmax(1:4) = 0;
project_in = 'mercator';

%% Load in files
files = num2cell(ls('*.onlns'),2);
ib = strncmp(files,'n',1);
filesb = files(ib==1,:);
filesm = files(ib==0,:);
nw = size(filesm,1);
totlocs = size(filesb,1);

Btot = cell(1,nw);
for ii = 1:nw
    fid = fopen(filesm{ii},'r');
    AAtot = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
    Atot = cell(size(AAtot));
    if size(AAtot{2},1) > size(AAtot{3},1)
        Atot{1} = AAtot{1}(1:end-1);
        Atot{2} = AAtot{2}(1:end-1);
        Atot{3} = AAtot{3:end};
    else
        Atot = AAtot;
    end
    fclose(fid);
    Btot{ii} = cell2mat(Atot);
end

%% Load buoy data
aabuoy = cell(1,totlocs);
aabname = cell(1,totlocs);
aabtime = cell(1,totlocs);
for kk = 1:totlocs
    aabuoy{kk} = load(filesb{kk});
    aabname{kk} = filesb{kk}(2:6);
    yr = aabuoy{kk}(:,2);
    mn = aabuoy{kk}(:,3);
    dy = aabuoy{kk}(:,4);
    hr = aabuoy{kk}(:,5);
    min = 60*round(aabuoy{kk}(:,6)/60);
    aabtime{kk} = datenum(yr,mn,dy,hr,min,0);
    clear yr mn dy hr mn
end
B1 = cell(totlocs,nw);
Btime = cell(totlocs,nw);
for kkk = 1:totlocs
    buoy = str2double(aabname{kk});
    for jjj = 1:nw
        istn = Btot{jjj}(:,4) == buoy;
        B1{kkk,jjj} = Btot{jjj}(istn,:);
        time = num2str(B1{kkk,jjj}(:,3));
        yr = str2num(time(:,1:4)); %#ok<ST2NM>
        mn = str2num(time(:,5:6)); %#ok<ST2NM>
        dy = str2num(time(:,7:8)); %#ok<ST2NM>
        hr = str2num(time(:,9:10)); %#ok<ST2NM>
        Btime{kkk,jjj} = datenum(yr,mn,dy,hr,0,0);
        clear istn time yr mn dy hr
    end


%% recalculate values
        [u10buoy] = airsea(aabuoy{kkk}(:,14),aabuoy{kkk}(:,15), ...
            aabuoy{kkk}(:,18),aabuoy{kkk}(:,19));
        
        %
        %   Pull out the Wave Parameters for Time Plots  
        %       Control Missing Buoy Data using axis in plotting.
        %       Remove when time paired obs.
        %
        %   1.  Wave Height:    
        %           Buoy Col    21
        %           WAM  Col    12
        %  
        hgtB=aabuoy{kkk}(:,21);
        ihgB = find(aabuoy{kkk}(:,21) > 0, 1);
        nodir(1)=isempty(ihgB);
        hgtM = zeros(size(B1{kkk,jjj},1),nw);
        for jjj = 1:nw
            hgtM(:,jjj)=B1{kkk,jjj}(:,12);
        end
        hmax=ceil(max(max(max(hgtM)),max(hgtB)));
        comp(1) =struct('name','H_{mo} [m]','y1',hgtM,'y2',hgtB,'max',hmax);
  %
        %   2.  Peak Period  (Parabolic Fit)
        %           Buoy Col    23
        %           WAM  Col    13
        %
        tppfB=aabuoy{kkk,jjj}(:,22);
        itpB=find(aabuoy{kkk,jjj}(:,22) > 0);
        nodir(2)=isempty(itpB);
        itpM= B1{kkk,jjj}(:,13) > 0;
        tppfM = zeros(size(itpM,1),nw);
        for jjj=1:nw
            tppfM(:,jjj)=B1{kkk,jjj}(itpM,13);
        end
        
        tppmax=ceil(max(max(max(tppfM)),max(tppfB(itpB))));
        comp(2) = struct('name','T_{p} [s]','y1',tppfM,'y2',tppfB,'max',tppmax);
        %
        %  3.  Mean Wave Period  (inverse 1st moment)
        %           Buoy Col    24
        %           WAM  Col    14
        %
        tmnB=aabuoy{kkk}(:,24);
        ltmnB=find(aabuoy{kkk}(:,24) > 0);
        nodir(3)=isempty(ltmnB);
        tmnM = zeros(size(B1{kkk,},
        for jjj=1:nw
            tmnM(:,jjj)=B1(:,15,jjj);
        end
        if ~isempty(ltmnB)
             tmnmax2=ceil(max(max(max(tmnM(:))),max(tmnB)));
              tmnmax = tmnmax2;
         else
          tmnmax2=ceil(max(max(tmnM(:))));
         tmnmax=5*ceil(tmnmax2/5);
        end
        %tmnmax=ceil(max(max(tmnM),max(tmnB)));
        comp(3) = struct('name','T_{m} [s]','y1',tmnM,'y2',tmnB,'max',tmnmax);
        %
        %           
        %  4.  Mean Wave Direction  Overall Vector Mean  Transform to Geophys Met.
        %                           ADJUST THE WAM RESULTS
        %
        %           Buoy Col    25  (Meteorological 0 from   North / 90 from   East)
        %           WAM  Col    17  (Oceanographic  0 toward North / 90 toward East)
        %
        %   NOTE:  Determine if Buoy has Directional Information (look for finite directions)
        %                       If have flag to produce "No Directional Buoy Data")
        %                       called "nodir"
        %
        iwavB=find(a(:,25) >= 0, 1);
        wavdB=a(:,25);
        nodir(4)=isempty(iwavB);
        for jjj=1:nw
            wavdM(:,jjj)=180+B1(:,17,jjj);
            i1=find(wavdM(:,jjj) >= 360);
            wavdM(i1,jjj)=wavdM(i1,jjj)-360;
        end
        clear i1;
        comp(4) = struct('name','\theta_{wave}','y1',wavdM,'y2',wavdB,'max',360);
        %
        %  5.  Wind Speed   U10
        %       Buoy        From Above (tranform to 10 m)
        %       WAM         Column 5 
        %
        for jjj=1:nw
            wsM(:,jjj)=B1(:,7,jjj);
        end
        iu10 = find(u10buoy > 0);
        nodir(5)=isempty(iu10);
        wsmax=ceil(max(max(max(wsM)),max(u10buoy)));
        comp(5) = struct('name','WS [m/s]','y1',wsM,'y2',u10buoy,'max',wsmax);
        %
        %  6.  Wind Direction  (Use Meteorlogical coordinate)
        %
        %       Buoy  Col       17  (Meteorological 0 from   North / 90 from   East)
        %       WAM   Col        6  (Oceanographic  0 toward North / 90 toward East)
        %
        windB=a(:,17);
        nowndB=find(windB == 0);
        iwdB=length(nowndB);
        %iwdB2 = find(a(:,17) >= 0);
        nodir(6)=isempty(iu10);
        if iwdB > 0.5*totobsB
            windB(nowndB)=-999.;
        end
        for jjj=1:nw
            windM(:,jjj)=180+B1(:,8,jjj);
            i1=find(windM(:,jjj) >=360);
            windM(i1,jjj) = windM(i1,jjj)-360.;
        end
        comp(6) = struct('name','\theta_{wind}','y1',windM,'y2',windB,'max',360);
        %
end