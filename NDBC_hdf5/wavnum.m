function xk = wavnum(frq,dep)

tmp = (2*pi*frq)^2/9.81;
xk = tmp;

d20 = 2*pi/(20 * tmp);
if dep <= d20
    xk = (2*pi * frq) / sqrt(9.81 * dep);
    return
end

for ii = 1:150
    xk_new = tmp/tanh(xk*dep);
    diff = abs((xk_new - xk) /xk_new);
    if (diff <= 0.005)
        return
    end
    xk = xk_new;
end

        
        