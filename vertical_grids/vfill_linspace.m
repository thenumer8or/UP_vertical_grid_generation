function [v_out] = vfill_linspace(v_in, nstart, nstop, n)

p0 = 100000;
ps = 100000;
%pm = 18186.50;
pm = 18230.50;
pt = 225.52;

nsize = length (v_in);

%s     = zeros (n1,1);
%d     = zeros (n1,1);

%p02 = vert_p(n1-1,1);
%ps  = p02;

v_out (1:nstart-1,1) = v_in (1:nstart-1,1);

c1 = 0;

for i=nstart:nstop
    
    j = i + c1;
    
    v_out(j:j+n-1,1)   = linspace ( v_in(i,1), v_in(i+1,1), n );
    
    c1 = c1 + n - 2;
    
end

% a(n1,1) = 0.0;
% b(n1,1) = 1.0;
% level(n1,1) = ( a(n1,1) + b(n1,1) * p0 ) / 100.0;

end