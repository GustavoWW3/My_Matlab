function [Hbin,bin] = prob_df(H,Ho)

bin = [0:0.05:4];
lnh = length(H);

H_ndim = H./Ho;
for jj = 1:length(bin)-1
    ii = find(H_ndim >= bin(jj) & H_ndim < bin(jj+1));
    Hbin(jj) = length(ii);
    clear ii
end    
ii = find(H_ndim > bin(end));
Hbin(jj+1) = length(ii);
Hbin = Hbin./lnh;


