function O=output(nc,nform,file,nz,f)

% Writes output to files

fid = fopen(file,'wt');
if nc == 20
    for k = 1:nz
        fprintf(fid,[nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform '\n'], ...
            f(k,1), f(k,2), f(k,3), f(k,4), f(k,5), f(k,6), f(k,7), f(k,8), f(k,9), ...
            f(k,10), f(k,11), f(k,12), f(k,13), f(k,14), f(k,15), f(k,16), f(k,17), f(k,18), f(k,19), f(k,20));
    end
elseif nc == 18
    for k = 1:nz
        fprintf(fid,[nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform '\n'], ...
            f(k,1), f(k,2), f(k,3), f(k,4), f(k,5), f(k,6), f(k,7), f(k,8), f(k,9), ...
            f(k,10), f(k,11), f(k,12), f(k,13), f(k,14), f(k,15), f(k,16), f(k,17), f(k,18));
    end
elseif nc == 15
    for k = 1:nz
        fprintf(fid,[nform nform nform nform nform nform nform nform nform nform nform nform nform nform nform '\n'], ...
            f(k,1), f(k,2), f(k,3), f(k,4), f(k,5), f(k,6), f(k,7), f(k,8), f(k,9), ...
            f(k,10), f(k,11), f(k,12), f(k,13), f(k,14), f(k,15));
    end
elseif nc == 6
    for k = 1:nz
        fprintf(fid,[nform nform nform nform nform nform '\n'], ...
            f(k,1), f(k,2), f(k,3), f(k,4), f(k,5), f(k,6));
    end
elseif nc == 3
    for k = 1:nz
        fprintf(fid,[nform nform nform '\n'],f(k,1), f(k,2), f(k,3));
    end
elseif nc == 2
    for k = 1:nz
        fprintf(fid,[nform nform '\n'],f(k,1), f(k,2));
    end
else
    for k = 1:nz
        fprintf(fid,[nform '\n'],f(k,1));
    end    
end
fclose(fid);
