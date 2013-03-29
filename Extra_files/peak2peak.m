function peak2peak(MODEL1,MODEL2,STANUM,MODELNM1,MODELNM2)
%
%  Peak 2 Peak Analysis
%  This function compares Measured Wave Heights versus Model Wave Heights
%   for a time period defined by the size of the input matrix.
%  It finds the number of "SETS" of time periods where the wave heights
%   exceeds the threshold where THRESHOLD = MEAN + 2*VARIANCE 
%
%  From that it determines the index of the measured time series.
%  NOTE THAT THE BUOY AND MODEL RESULTS HAVE BEEN TIME PAIRED!
%
%  INPUT:
%  -----
%   BUOY:    MEASURED DATA LOCATED IN INDEX "1" of the FIRST MODEL INPUT 
%   MODEL1:  MODEL WAVE DATA LOCATED IN INDEX "2" 
%   MODEL2:  MODEL WAVE ESTIMATES LOCATED IN INDEX "2"
%
%   STANUM:     CHARACTER      BUOY ID NUMBER.
%   MODELNM1:   CHARACTER      NAME USED FOR TITLES (i.e. NN) 
%   MODELNM2:   CHARACTER      NAME USED FOR TITLES (i.e. CFSR)
%
hmeanBUOY=mean(MODEL1(:,1));
varBUOY=var(MODEL1(:,1));
thresh=hmeanBUOY+2*varBUOY;
in=MODEL1(:,1) >= thresh;
%
%  Find the sets of wave heights greateer than the threshold
%
ISET=0;
for ii=1:length(MODEL1)-1
idif(ii)=in(ii+1)-in(ii);
if idif(ii) == 1
    ISET=ISET+1;
    IDIF(ISET,1)=ii;
elseif idif(ii) == -1
    IDIF(ISET,2)=ii;
end
end
%
%  Set the Number of SETS BASED ON THE LAST END INDEX ENTRY
%
nsets=length(IDIF);
if IDIF(end,1) > length(MODEL1(:,1))-10;
    nsets=nsets-1;
end
%
%  Now find max wave height within each of the Sets of conditions above the
%  threshold.  
%  NOTE THAT IF THERE IS A PEAK DEFINED IN THE LAST SET:  SKIP SKIP SKIP
%
for jj=1:nsets
   [hmax(jj),indx(jj)]=max(MODEL1(IDIF(jj,1):IDIF(jj,2),1));
   indx(jj)=indx(jj)+IDIF(jj,1); 
end
%
%  Find the max wave heights from the Model Resuls based on the interval of
%  the measurements
%
for jj=1:nsets
   [dum,indx2(jj)]=max(MODEL1(IDIF(jj,1):IDIF(jj,2),2));
   indx2(jj)=indx2(jj)+IDIF(jj,1); 
end
%
for jj=1:nsets
   [dum,indx3(jj)]=max(MODEL2(IDIF(jj,1):IDIF(jj,2),2));
   indx3(jj)=indx3(jj)+IDIF(jj,1); 
end
%
%  Plot the RESULTS
%
subplot(2,2,1:2)
H1=plot(MODEL1(:,1),'.r-');
grid
hold on
H2=plot([0 length(MODEL1(:,1))],[thresh,thresh],'.k-','LineWidth',2);
H3=plot(indx,hmax,'b+');
HT=[H1;H2;H3];
xlabel('Observation','FontWeight','Bold')
ylabel('H_{mo} [m]','FontWeight','Bold')
legend(HT,'BUOY','Threshold','MAXs',1)
titch1=['PEAK TO PEAK ANALYSIS ALL STORMS NDBC:  ',STANUM];
titch2=['Threshold:  HMEAN + 2*VAR = ',sprintf('%5.2f',hmeanBUOY),'m + 2* ',...
    sprintf('%5.2f',varBUOY),'m'];
    titchT=[{titch1};{titch2}];
title(titchT,'FontWeight','Bold')
hold off
%
subplot(2,2,3)
hmaxNN=MODEL1(indx2,2)';
hmaxCFSR=MODEL2(indx3,2)';
hmax1=max(max(hmax),max(hmaxNN));
hmax1=ceil(max(max(hmax1),max(hmaxCFSR')));
plot(hmax,hmaxNN,'og',[0 hmax1],[0 hmax1],'r:','LineWidth',2);
axis('square')
grid
xlabel('Meas H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titlch22=[MODELNM1,' Peak2Peak'];
titlch222=['TOTAL Obs:  ',int2str(length(indx2))];
titlch22T=[{titlch22};{titlch222}];
title(titlch22T,'FontWeight','Bold')
%
subplot(2,2,4)
plot(hmax,hmaxCFSR','ob',[0 hmax1],[0 hmax1],'r:','LineWidth',2);
axis('square')
grid
xlabel('Meas H_{mo} [m]','FontWeight','Bold')
ylabel('Model H_{mo} [m]','FontWeight','Bold')
titlch23=[MODELNM2,' Peak2Peak'];
titlch23T=[{titlch23};{titlch222}];
title(titlch23T,'FontWeight','Bold')
eval(['print -dpng -r600 peak2peak_',STANUM]);

