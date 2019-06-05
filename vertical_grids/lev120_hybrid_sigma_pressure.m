clc;
clear all;

% read in the vertical grid structure from an available 30 level input file.
hyai30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hyai');
hyam30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hyam');
hybi30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hybi');
hybm30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hybm');
lev30  = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'lev');

ncomb = 20;  % use the top ncomb points from the 30 level for the new nlev layout
nlevi = 121; % number of interface points in the new nlev layout
nlevm = nlevi - 1; % number of mid-points in the new nlev layout

P0 = 100000.0; %Pa
Ps = 100000.0; %Pa
Pm = 20000.00; %Pa
%Pm = 8314.250; %Pa
Pt = 291.7;    %Pa

P30m = ( hyam30 * P0 + hybm30 * Ps ) / 100.0;
P30i = ( hyai30 * P0 + hybi30 * Ps ) / 100.0;

dz_v = 25 * ones(1,nlevi); %m
Tbar = 265; %K

scale0 = 1.0010; %scale dz for the lowest level of atmosphere
scale1 = 1.0100; %scale dz for the mid-level of atmosphere

P        = zeros(1,nlevi);
P(nlevi)  = P0;

hyai = zeros(nlevi,1);
hybi = zeros(nlevi,1);
hyam = zeros(nlevm,1);
hybm = zeros(nlevm,1);

si = zeros(nlevi,1);
di = zeros(nlevi,1);
sm = zeros(nlevm,1);
dm = zeros(nlevm,1);

for i=nlevi-1:-1:ncomb
    
    if (i<=50)
        scale = scale0;
    elseif (50<i<110)
        scale = scale1;
    end
    
    dz_v (i) = scale * dz_v (i+1);
    P(i) = P(i+1) * exp ( - dz_v(i) / (29.3 * Tbar) );
    %P(i) = P(i+1) * exp ( - 25 / 7941 );
    
end

P_comb   = P';

%eta = zeros(nlevi,1);

P_comb(1:ncomb)  = P30i(1:ncomb) * 100.0;

z (1:nlevi,1) = 29.3 * Tbar * log(P0 ./ P_comb(1:nlevi))';

for i=1:nlevi
    
    % compute s:=sigma
    if P_comb(i) < Pm
        si(i) = ( P_comb(i) - Pm ) / ( Pm - Pt );
    else
        si(i) = ( P_comb(i) - Pm ) / ( Ps - Pm );
    end
    
    % compute d:=delta
    if si(i) < 0.0
        di(i) = 0.0;
    else
        di(i) = 1.0;
    end
    
    % compute A and B, pressure coefficients
    hyai(i) = Pm * (1-si(i)) * di(i) + (1-di(i)) * ( Pm * (1+si(i)) - si(i) * Pt );
    hybi(i) = si(i) * di(i);
    
    % compute eta vertical coordinate
    %eta(nlevi-i+1) = ( Ai(i) + Bi(i) * P0 - Pt ) / ( P0 - Pt );
    
end

hyai = hyai / P0;

P_comb_flip = flipud(P_comb);

P_comb_mb = P_comb / 100.0;


% Interpolate i-points to m-points
for i=1:nlevi-1
    
    Pm_new(i,1) = 0.50 * ( P_comb(i,1) + P_comb(i+1,1) );
    
end

% Compute pressure coefficients for the new layout
for i=1:nlevm
    
    % compute s:=sigma
    if Pm_new(i) < Pm
        sm(i) = ( Pm_new(i) - Pm ) / ( Pm - Pt );
    else
        sm(i) = ( Pm_new(i) - Pm ) / ( Ps - Pm );
    end
    
    % compute d:=delta
    if sm(i) < 0.0
        dm(i) = 0.0;
    else
        dm(i) = 1.0;
    end
    
    % compute A and B, pressure coefficients for the new layout
    hyam(i) = Pm * (1-sm(i)) * dm(i) + (1-dm(i)) * ( Pm * (1+sm(i)) - sm(i) * Pt );
    hybm(i) = sm(i) * dm(i);
    
    % compute eta vertical coordinate
    %eta(nlevm-i+1) = ( Ai(i) + Bi(i) * P0 - Pt ) / ( P0 - Pt );
    
end

hyam = hyam / P0;

% compute pressure levels for the new layout
lev  = ( hyam * P0 + hybm * Ps ) / 100.0;
ilev = ( hyai * P0 + hybi * Ps ) / 100.0;

subplot (2,2,1)
plot (P_comb_flip, '.');
xlabel('grid index') % x-axis label
ylabel('P') % y-axis label

subplot (2,2,2)
semilogy (z, P_comb , '.')
xlabel('z') % x-axis label
ylabel('P') % y-axis label

subplot (2,2,3)
plot (z, P_comb , '.')
xlabel('z') % x-axis label
ylabel('P') % y-axis label
 
%%%%%%%%%%% write out to a netcdf file 

file_name = 'hparish_personal_cami_0000-01-01_1.9x2.5_L120_c150212.nc';
ncid      = netcdf.create(file_name,'NOCLOBBER');

dimid1 = netcdf.defDim(ncid,'ilev',nlevi);
dimid2 = netcdf.defDim(ncid,'lev',nlevm);

varid1 = netcdf.defVar(ncid,'hyai','NC_DOUBLE',dimid1);
varid2 = netcdf.defVar(ncid,'hyam','NC_DOUBLE',dimid2);
varid3 = netcdf.defVar(ncid,'hybi','NC_DOUBLE',dimid1);
varid4 = netcdf.defVar(ncid,'hybm','NC_DOUBLE',dimid2);
varid5 = netcdf.defVar(ncid,'ilev','NC_DOUBLE',dimid1);
varid6 = netcdf.defVar(ncid,'lev','NC_DOUBLE',dimid2);

netcdf.endDef(ncid);

netcdf.putVar(ncid,varid1,hyai);
netcdf.putVar(ncid,varid2,hyam);
netcdf.putVar(ncid,varid3,hybi);
netcdf.putVar(ncid,varid4,hybm);
netcdf.putVar(ncid,varid5,ilev);
netcdf.putVar(ncid,varid6,lev);

netcdf.close(ncid);

%%%%% read in the vertical grid structure from new 120 level netdcf file to double check.
hyai120 = ncread(file_name, 'hyai');
hyam120 = ncread(file_name, 'hyam');
hybi120 = ncread(file_name, 'hybi');
hybm120 = ncread(file_name, 'hybm');
lev120  = ncread(file_name, 'lev');
ilev120 = ncread(file_name, 'ilev');

% checkpoint: show the magnitude of the difference. must be zero. no exception!
% if diff = 0.000000000000, ok to proceed. 
% if any error message, you have messed things up!

diff = abs(sum(hyai120-hyai))+abs(sum(hybi120-hybi))+abs(sum(hyam120-hyam))+abs(sum(hybm120-hybm))

