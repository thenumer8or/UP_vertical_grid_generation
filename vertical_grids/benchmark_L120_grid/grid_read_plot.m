ilev = textread('L120_grid','%f');

dlnp = diff (log2(ilev));

%% claculate the equivalent height.
Tbar    = 260;
R       = 287.1;     %J/Kg K      gas constant of dry air

zlev = - log(ilev/1000.0) * (29.3 * Tbar);
dz   = - diff(zlev);

%% plot 
figure (2);

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


