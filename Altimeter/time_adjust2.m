function [sat_grid] = time_adjust2(time1,time2,tint,time,lon,lat,Hs)

timenum1 = [str2num(time1(1:4)),str2num(time1(5:6)),str2num(time1(7:8)), ...
    str2num(time1(9:10))+tint/60,str2num(time1(11:12)),str2num(time1(13:14))];
timenum2 = [str2num(time2(1:4)),str2num(time2(5:6)),str2num(time2(7:8)), ...
    str2num(time2(9:10)),str2num(time2(11:12)),str2num(time2(13:14))];
timenum05= [str2num(time1(1:4)),str2num(time1(5:6)),str2num(time1(7:8)), ...
    str2num(time1(9:10))+2*tint/60,str2num(time1(11:12)),str2num(time1(13:14))];
tstep = datenum(timenum05) - datenum(timenum1);
tt = datenum(timenum1):tstep:datenum(timenum2);
thalf = datenum(timenum1)-tstep/2:tstep:datenum(timenum2)+tstep/2;

[nt nd] = size(time);

long = 110.0:0.5:300.0;
latg = -64.0:0.5:64.0;
[X Y] = meshgrid(long,latg);

for zz = 1:length(thalf)-1
    pp = 1;
    for jj = 1:nd
        for ii = 1:nt
            qq = find(time{ii,jj} > thalf(zz) & time{ii,jj} <= thalf(zz+1));
            if size(qq,1) > 0
                lont{pp} = lon{ii,jj}(qq);
                latt{pp} = lat{ii,jj}(qq);
                %zilon{pp} = kNearestNeighbors(long',lon{ii,jj}(qq),1);
                %zilat{pp} = kNearestNeighbors(latg',lat{ii,jj}(qq),1);
                Hsnew{pp} = Hs{ii,jj}(qq);
                pp = pp + 1;
            elseif pp > 1
                break
            end
        end
        if pp > 1 && size(qq,1) == 0
            break
        end
    end
    
     Hsgrid = repmat(-999,length(long),length(latg));
     if exist('Hsnew','var')
         if pp > 2
              lon2 = [lont{1};lont{2}];
              lat2 = [latt{1};latt{2}];
%              zilon2 = [zilon{1};zilon{2}];
%              zilat2 = [zilat{1};zilat{2}];
              Hsnew2 = [Hsnew{1};Hsnew{2}];
 
         else
             lon2 = lont{1};
             lat2 = latt{1};
%             zilon2 = [zilon{1}];
%             zilat2 = [zilat{1}];
             Hsnew2 = Hsnew{1};
         end
       
         Hsgrid = bin2mat(lon2,lat2,Hsnew2,X,Y);
       
%             lonn = long(zilon2);
%             latt = latg(zilat2);
% %         Hsn = Hsnew2(1);
% %         Hsgrid(zilon2(1,:),zilat2(1,:)) = Hsn;
%         for ii = 1:size(zilon2,1)
%            % for qq = 1:1
%            %     for pp = 1:1
%                     if Hsgrid(zilon2(ii),zilat2(ii)) ~= -999
%             %if zilon2(ii,1) == zilon2(ii-1,1) && ...
%             %        zilat2(ii,1) == zilat2(ii-1,1)
%                         Hsn = (Hsnew2(ii)+ Hsgrid(zilon2(ii),zilat2(ii)))/2.;
%                     else 
%                         Hsn = Hsnew2(ii);
%                     end
%                     Hsgrid(zilon2(ii),zilat2(ii)) = Hsn;
%            %     end
%             %end
%         end
%         clear zilon zilat Hsnew
%     else
%         lonn = -999.00;latt = -999.00;
     end

    sat_grid(zz) = struct('stime',datestr(tt(zz)),'mtime',tt(zz),'Hs_grid',Hsgrid,'lon',lon2,'lat',lat2);        
end
