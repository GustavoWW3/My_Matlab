% Script to convert MTS binary to ASCII file
% Requires the MTS matlab file loadbin in path
%
% Modified 17 June 2010; Ernie Smith
%
[fnt,pnt]=uigetfile('*.bin','Select MTS Binary File:');
nf=fullfile(pnt,fnt);
[ts,dt,desc,~,~,fileDate,header,~] = loadbin(nf);
lts=((size(ts,1)-1)*dt);
tstep=(0:dt:lts)';
[nt n2]=size(ts);
%
% Determine number of gages to write
% The time series normally includes the command and feedback channel in the
% last two columns of the binary file
% If the command and feedback are desired in the ascii file, set rg=0
% To remove the command and feedback, set rg=2
rg=2;
nogage=n2-rg;
%
% Write to ascii file
%
Adata=zeros(nt,nogage+1);
Adata(:,1)=tstep;
Adata(:,2:end)=ts(:,1:nogage);
fod=fopen([fnt(1:end-4),'_a.dat'],'w');
ascform=['%8.2f',repmat('%10.6f',1,13),'\n'];
fprintf(fod,ascform,Adata');
fclose(fod);
