function aa = read_swims_flume(fdir,fname)

bb = load([fdir,fname]);

aa.dir = fdir;
aa.name = fname;
aa.time = bb(:,1);
aa.wave = bb(:,2:end-1);
aa.runup = bb(:,end);
