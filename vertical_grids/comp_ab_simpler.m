function [a,b, level] = comp_ab_simpler(vert_p)

p0 = 100000;
ps = 100000;
pm = 18186.50;
pt = 225.52;

nsize = size (vert_p);
n1    = nsize (1);

s     = zeros (n1,1);
d     = zeros (n1,1);

for i=1:n1
    
    % compute s:=sigma
    
    s(i) = ( vert_p(i) - pt ) / ( ps - pt );

    % compute A and B, pressure coefficients
    a(i,1) = pt * ( 1 - s(i) );
    b(i,1) = s(i);
    
    % compute eta vertical coordinate
    % eta(n1-i+1) = ( a(i) + b(i) * P0 - Pt ) / ( P0 - Pt );
    
    level(i,1) = ( pt * ( 1 - s(i) ) + s(i) * ps ) / 100.0;
    
end

a = a / pt;



end