function [a,b, level] = comp_ab(vert_p)

p0 = 100000;
ps = 100000;
%pm = 18186.50;
pm = 18230.50;
pt = 225.52;

nsize = size (vert_p);
n1    = nsize (1);

s     = zeros (n1,1);
d     = zeros (n1,1);

p02 = vert_p(n1-1,1);
ps  = p02;

for i=1:n1-2
    
    % compute s:=sigma
    if vert_p(i) < pm
        s(i) = ( vert_p(i) - pm ) / ( pm - pt );
    else
        s(i) = ( vert_p(i) - pm ) / ( ps - pm );
    end
    
    % compute d:=delta
    if s(i) < 0.0
        d(i) = 0.0;
    else
        d(i) = 1.0;
    end
    
    % compute A and B, pressure coefficients
    a(i,1) = pm * (1-s(i)) * d(i) + (1-d(i)) * ( pm * (1+s(i)) - s(i) * pt );
    b(i,1) = abs ( s(i) * d(i) );
    
    level(i,1) = ( a(i,1) + b(i,1) * ps ) / 100.0;
    
end

a(n1,1) = 0.0;
b(n1,1) = 1.0;
level(n1,1) = ( a(n1,1) + b(n1,1) * p0 ) / 100.0;

a(n1-1,1) = 0.0;
b(n1-1,1) = vert_p(n1-1,1)/p0;
level(n1-1,1) = ( a(n1-1,1) + b(n1-1,1) * p0 ) / 100.0;

a = a / p0;

end