clear all

files = 'LakeSTCL_18SV4.dep';
fid2 = fopen(files,'r');
data = fscanf(fid2,'%f',6);
dx = data(1);
dy = data(2);
lats = data(3);
latn = data(4);
lonw = data(5);
lone = data(6);

ny = (latn - lats)/dx + 1;
nx = abs(lone - lonw)/dy + 1;
dep = fscanf(fid2,'%5i%1c',[2*nx ny]);
depth = dep(1:2:end-1,:)';
fclose(fid2);

[long latg] = meshgrid(lonw:dy:lone,lats:dx:latn);

depc = vertcat(depth(:,1),depth(:,2));
latc = vertcat(latg(:,1),latg(:,2));
lonc = vertcat(long(:,1),long(:,2));
for ii = 3:size(depth,2);
    depc = vertcat(depc,depth(:,ii));
    latc = vertcat(latc,latg(:,ii));
    lonc = vertcat(lonc,long(:,ii));
end

lsxyz(:,1) = lonc;
lsxyz(:,2) = latc;
lsxyz(:,3) = depc;

load_coast



figure('inverthardcopy','off','color','white')
hold on
for ii = 1:size(lsxyz,1)
    if (lsxyz(ii,3) > 0.0)
        plot(lsxyz(ii,1),lsxyz(ii,2),'b.')
    else
        plot(lsxyz(ii,1),lsxyz(ii,2),'r.')
    end
end

for ii = 1:123
   plot(lon{ii},lat{ii},'k');
end

cx1 = [-83.00:0.13:-82.35-0.13];
cx2 = [-83.00+0.13:0.13:83.35];
cy1 = [42.25:0.1:42.75-0.1];
cy2 = [42.25+0.1:0.1:42.75];
nn = 0;
% for jj = 1:5
%     for ii = 1:5
%         nn = nn + 1;
%         axis([cx1(ii) cx2(ii) cy1(jj) cy2(jj)]);
%         fname = ['LS-zone-',num2str(nn)];
%         title(fname);
%         print(gcf,'-dpng',fname);
%     end
% end

depth_cha = (dep(2:2:end,:)');
for jj = 1:fix(nx/2)
    for ii = 1:fix(ny/2)
        if (depth_cha(2*ii-1,2*jj-1) == 68)
            depio(ii,jj) = 0;
        else
            depio(ii,jj) = 1;
        end
    end
end

fid = fopen('fort36.20','wt');

for ii = 1:fix(nx/2)
    fprintf(fid,'%1i',depio(:,ii));
    fprintf(fid,'\n');
end
fclose(fid);
