clc;
clear all;

nlevt = 120;
nlev0 = 120;
nlev1 = nlevt - nlev0;

P0 = 100000.0; %Pa
Ps = 100000.0; %Pa
Pm = 70000.0;  %Pa
Pt = 291.7;    %Pa

dz_v = 20 * ones(1,nlev0); %m
Tbar = 265; %K

scale0 = 1.0040; 
scale1 = 1.340; 

%scale0 = 1.000; 
%scale1 = 1.000; 

P_layer0        = zeros(1,nlev0);
P_layer0(nlev0) = P0;

for i=nlev0-1:-1:1
    
    if (i>20)
        scale = scale0;
    else 
        scale = scale1;
    end
    
    dz_v (i) = scale * dz_v (i+1);
    P_layer0(i) = P_layer0(i+1) * exp ( - dz_v(i) / (29.3 * Tbar) );
    %P_layer0(i) = P_layer0(i+1) * exp ( - 25 / 7941 );
    
end

%Pm1      = P_layer0(1) - (P_layer0(1)-Pt)/nlev1;
%P_layer1 = linspace(Pt,Pm1,nlev1);
%P_comb   = [P_layer1, P_layer0]';
P_comb   = P_layer0';

A = zeros(nlevt,1);
B = zeros(nlevt,1);
s = zeros(nlevt,1);
d = zeros(nlevt,1);

eta = zeros(nlevt,1);



for i=1:nlevt
    
    % compute s:=sigma
    if P_comb(i) < Pm
        s(i) = ( P_comb(i) - Pm ) / ( Pm - Pt );
    else
        s(i) = ( P_comb(i) - Pm ) / ( Ps - Pm );
    end
    
    % compute d:=delta
    if s(i) < 0.0
        d(i) = 0.0;
    else
        d(i) = 1.0;
    end
    
    % compute A and B, pressure coefficients
    A(i) = Pm * (1-s(i)) * d(i) + (1-d(i)) * ( Pm * (1+s(i)) - s(i) * Pt );
    B(i) = s(i) * d(i);
    
    % compute eta vertical coordinate
    eta(nlevt-i+1) = ( A(i) + B(i) * P0 - Pt ) / ( P0 - Pt );
    
end

A = A / P0;

P_comb_flip = flipud(P_comb);

figure(1);

plot (P_comb_flip, '.');
hold on;
P_comb_mb = P_comb / 100.0;

plot (dz_v, P_comb , '.')

hyai = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hyai');
hyam = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hyam');

hybi = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hybi');
hybm = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hybm');

plev60 = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'lev');


%ncdisp('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hyai');

%figure(2);
%plot (hyai, '.');
%hold on;
%plot (hyam, 's');
%legend on;

figure(3);
%plot (hybi, plev60, '.');
%hold on;
semilogy (hybm, plev60, 's');
%legend on;


