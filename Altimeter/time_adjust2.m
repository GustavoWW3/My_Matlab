function [sat_grid] = time_adjust2(time1,time2,tint,time,lon,lat,Hs,long,latg)

timenum1 = [str2double(time1(1:4)),str2double(time1(5:6)),str2double(time1(7:8)), ...
    str2double(time1(9:10))+tint/60,str2double(time1(11:12)),str2double(time1(13:14))];
timenum2 = [str2double(time2(1:4)),str2double(time2(5:6)),str2double(time2(7:8)), ...
    str2double(time2(9:10)),str2double(time2(11:12)),str2double(time2(13:14))];
timenum05= [str2double(time1(1:4)),str2double(time1(5:6)),str2double(time1(7:8)), ...
    str2double(time1(9:10))+2*tint/60,str2double(time1(11:12)),str2double(time1(13:14))];
tstep = datenum(timenum05) - datenum(timenum1);
tt = datenum(timenum1):tstep:datenum(timenum2);
thalf = datenum(timenum1)-tstep/2:tstep:datenum(timenum2)+tstep/2;

[nt nd] = size(time);

% long = 110.0:0.5:300.0;
% latg = -64.0:0.5:64.0;

lont = lon{1};latt = lat{1};Hst = Hs{1};timet = time{1};
for jj = 2:size(lon,2)
    lont = [lont;lon{jj}];
    latt = [latt;lat{jj}];
    Hst = [Hst;Hs{jj}];
    timet = [timet;time{jj}];
end


Hsgrid = NaN(length(latg),length(long),length(thalf) - 1);
ktree = kdtree([lont latt]);
% for jj = 1:length(latg)
%     for ii = 1:length(long)
%         grd(ii + length(long)*(jj-1),:) = [long(ii) latg(jj)];
%     end
% end
% try

%[aa bb] = kdtree_range(ktree,...
%    [[grd(:,1)-1.0 grd(:,1)+1.0];[grd(:,2)-1.0 grd(:,2)+1.0]]);
for jj = 1:length(latg)
    for ii = 1:length(long)
        [aa bb] = kdtree_range(ktree, ...
            [[long(ii)-1.0 long(ii)+1.0];[latg(jj)-1.0 latg(jj)+1.0]]);
        if ~isempty(aa)
%             pp = 0;
            timetree = kdtree(timet(aa));
            for ztime = 1:length(thalf) - 1
                 cc = kdtree_range(timetree,[thalf(ztime) thalf(ztime+1)]);
                 if ~isempty(cc)
                    Hsgrid(jj,ii,ztime) =  mean(Hst(aa(cc)));
%                     pp = 1;
% %                 elseif isempty(Hst(aa(itime))) & pp == 1;
% %                     break
                 end
                 clear cc
             end
        end
        clear aa bb
    end
end

% for ztime = 1:length(thalf) - 1
%     sat_grid(ztime) = struct('stime',datestr(tt(ztime)),'mtime',tt(ztime),'Hs_grid',Hsgrid(:,:,ztime),'long',long,'latg',latg);         %#ok<AGROW>
% end
sat_grid = struct('Hs_grid',Hsgrid);
% for zz = 1:length(thalf)-1
%     pp = 1;
%     for jj = 1:nd
%         for ii = 1:nt
%             qq = (time{ii,jj} > thalf(zz) & time{ii,jj} <= thalf(zz+1));
%             if ~isempty(lon{ii,jj}(qq,1))
%                 if ~exist('lont','var')
%                     lont = lon{ii,jj}(qq); %#ok<*AGROW>
%                     latt = lat{ii,jj}(qq);
% %                 zilon{pp} = kNearestNeighbors(long',lon{ii,jj}(qq),1);
% %                 zilat{pp} = kNearestNeighbors(latg',lat{ii,jj}(qq),1);
%                     Hsnew = Hs{ii,jj}(qq);
%                 else
%                     lont = [lont;lon{ii,jj}(qq)];
%                     latt = [latt;lat{ii,jj}(qq)];
%                     Hsnew = [Hsnew;Hs{ii,jj}(qq)];
%                 end
% %             elseif pp > 1
% %                 break
%              end
%          end
% %         if pp > 1 && size(qq,1) == 0
% %             break
% %         end
%     end
%     
%      Hsgrid = NaN(length(latg),length(long));
%      ktree = kdtree(lont,latt);
%      for jj = 1:length(latg)
%          for ii = 1:length(long)
%              try
%                 [aa,bb] = kdtree_range(ktree,[[long(ii)-1.0 ...
%                     long(ii) + 1.0];[latg(jj)-1.0 latg(jj)+1.0]]);
%              catch
%                  continue
%             
%              end
%              Hsgrid(ii,jj) =  mean(Hsnew(aa));
%          end
%      end
%      if exist('Hsnew','var')
%          if pp > 2
%               lon2 = [lont{1};lont{2}];
%               lat2 = [latt{1};latt{2}];
% %               zilon2 = [zilon{1};zilon{2}];
% %               zilat2 = [zilat{1};zilat{2}];
%               Hsnew2 = [Hsnew{1};Hsnew{2}];
%  
%          else
%              lon2 = lont{1};
%              lat2 = latt{1};
% %              zilon2 = [zilon{1}];
% %              zilat2 = [zilat{1}];
%              Hsnew2 = Hsnew{1};
%          end
%        
% %         Hsgrid = bin2mat(lon2,lat2,Hsnew2,X,Y);
%        
% %              lonn = long(zilon2);
% %              latn = latg(zilat2);
%              [~, xind] = histc(lon2,long);
%              [~, yind] = histc(lat2,latg);
% % %         Hsn = Hsnew2(1);
% % %         Hsgrid(zilon2(1,:),zilat2(1,:)) = Hsn;
%          for ii = 1:size(xind,1)
%             % for qq = 1:1
%             %     for pp = 1:1
%                      if ~isnan(Hsgrid(yind(ii),xind(ii)))
%              %if zilon2(ii,1) == zilon2(ii-1,1) && ...
%              %        zilat2(ii,1) == zilat2(ii-1,1)
%                          Hsn = (Hsnew2(ii)+ Hsgrid(yind(ii),xind(ii)))/2.;
%                      else 
%                          Hsn = Hsnew2(ii);
%                      end
%                      Hsgrid(yind(ii),xind(ii)) = Hsn;
%             %     end
%              %end
%          end
%          clear zilon zilat Hsnew
%       else
%           lon2 = -999.00;lat2 = -999.00;
%      end
    %sat_grid(zz) = struct('stime',datestr(tt(zz)),'mtime',tt(zz),'Hs_grid',Hsgrid,'long',long,'latg',latg);         %#ok<AGROW>
end
