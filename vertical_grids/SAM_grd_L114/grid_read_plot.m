%ilev = textread('L120_grid','%f');

ilev = ncread('hp_built_cami_0000-01-01_1.9x2.5_L114_c150325.nc','ilev');

subplot(1,3,1)
semilogy (ilev, '.');
set (gca, 'YDir', 'reverse');
%hold on;
subplot(1,3,2)
loglog (ilev, '.');
set (gca, 'YDir', 'reverse');
%hold on;
subplot(1,3,3)
plot (ilev, '.');
set (gca, 'YDir', 'reverse');