%% load data
fn='MET-FINAL-LOC.dat';
DAT=load(fn);
kmzfile=regexprep(fn,'.dat','.kmz');

LNGT_REC=DAT(:,3)-DAT(:,2) + 1;

%create KML string
kml=[];
for k=1:length(DAT)
kml=[kml,ge_point(DAT(k,5),DAT(k,4),LNGT_REC(k),...
    'name',int2str(DAT(k,1)),...
    'iconURL','http://maps.google.com/mapfiles/kml/shapes/open-diamond.png',...
    'iconColor',ge_color('r',1),...
    'iconScale',0.9,...
    'altitudeMode','clampToGround')];
end
%    'iconColor',ge_color('r',1),...
%create KMZ file
ge_output(kmzfile,kml);

