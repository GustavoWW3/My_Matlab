function wiswave = read_WIS_spec(fname)
%--------------------------------------------------------------------
%
%         READ WIS SPECATRAL FILES
%
%         Written 05/01/11  TJ Hesser
%         Updated 01/05/12  TJ Hesser - added frequency and direction
%                 04/11/12  TJ Hesser - fixed direction array to start at 0
%
%
%         INPUT:
%            fname     : File name (Characters)
%
%         OUTPUT:
%         The output is a structured array with 17 parts:
%           .nsta :  Station number
%           .i, .j:  Grid location
%           .lon, .lat : Longitude and Latitude
%           .dep       : Depth (m)
%           .time      : Date (YYYYMMDDHH)
%           .nang      : Number of angles
%           .nfrq      : Number of frequencies
%           .hscale    : Energy in parametric tail 
%           .hsig      : Significant wave height (m)
%           .wang      : Wave angle (deg)
%           .tmm       : Mean period (sec)
%           .winds     : Wind speed (m/sec)
%           .windd     : Wind direction (deg)
%           .fma       : Internal wave model rep of peak frequency
%           .spec2d    : 2D spectra (nfrq,nang)
%           .dwfhz     : Frequency Spectrum
%           .dwdeg     : Angle Bins
%--------------------------------------------------------------------
freq = [0.03333 0.04000 0.05000 0.05500 0.06000 0.06666 0.07000 ...
    0.08000 0.09000 0.10000 0.11000 0.12000 0.13000 0.14000 0.15000 ...
    0.16000 0.18000 0.20000 0.25000 0.30000];
dir = [0:22.5:(22.5*15)];

fid = fopen(fname,'r');
zzz = 0;
while 1
    zzz = zzz + 1;
    % Read header information
    data1 = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',1);
    if size(data1{1},1) > 0
        nang = data1{8};
        nfrq = data1{9};
    % Read 2D spectra
        for jj = 1:nfrq
            data2 = fscanf(fid,'%f',nang);
            spec(:,jj) = data2;
        end
        spec2d = spec';
    % Create structured array
        wiswave(zzz) = struct('nsta',data1{1},'i',data1{2},'j',data1{3},'lon', ...
            data1{4},'lat',data1{5},'dep',data1{6},'time',data1{7},'nang', ...
            data1{8},'nfrq',data1{9},'hscale',data1{10},'hsig',data1{11}, ...
            'wang',data1{12},'tmm',data1{13},'winds',data1{14},'windd', ...
            data1{15},'fma',data1{16},'spec2d',spec2d,'dwfhz',freq,'dwdeg',dir);
        data = fscanf(fid,'\n',1);
    else
        break
    end
end
fclose(fid);