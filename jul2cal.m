function [ICALDATE] = jul2cal(IYEAR_IN,JULDAT_IN,IHR_IN)
IMIN = 0;

mnt = [31,28,31,30,31,30,31,31,30,31,30,31];
mnt_strt = [1,32,60,91,121,152,182,213,244,274,305,335];
if (mod(IYEAR_IN,4) == 0) 
    mnt(2) = 29;
    for mm = 3:12
        mnt_strt(mm) = mnt_strt(mm) + 1;
    end
else
    mnt(2) = 28;
    mnt_strt(3) = 60;
    mnt_strt(4) = 91;
    mnt_strt(5) = 121;
    mnt_strt(6) = 152;
    mnt_strt(7) = 182;
    mnt_strt(8) = 213;
    mnt_strt(9) = 244;
    mnt_strt(10) = 274;
    mnt_strt(11) = 305;
    mnt_strt(12) = 335;
end

JULDATE = JULDAT_IN;
for ii = 1:12
    MNT_END = mnt_strt(ii) + mnt(ii) -1;
    if JULDATE >= mnt_strt(ii) && JULDATE <= MNT_END
       IOUT = ii;
       break
    end
end

MNT_OUT = IOUT;
IDAY_OUT = JULDAT_IN - mnt_strt(IOUT) + 1;
ICALDATE = 100000000*IYEAR_IN + 1000000*MNT_OUT + 10000*IDAY_OUT + 100*IHR_IN + IMIN;

end
    
        