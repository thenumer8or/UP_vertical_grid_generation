clc;
clear all;
close all;

z = load ('-ascii', './grd');
n = length (z);

for i=1:n-1
    dz(i) = z(i+1,1) - z(i,1);
end

dz = dz';
lev = z(1:n-1,1);

plot (dz, lev);
xlabel('dz(m)');
ylabel('z(m)');

save ('z.mat', 'lev');
save ('dz.mat', 'dz');
