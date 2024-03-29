clc;
close all;
clear all;

% read in the vertical grid structure from an available 30 level input file.
% hyai30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hyai');
% hyam30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hyam');
% hybi30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hybi');
% hybm30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'hybm');
% lev30  = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'lev');
% ilev30 = ncread('cami_0000-01-01_1.9x2.5_L30_c070703.nc', 'ilev');

zlev = load ('-ascii', './grd_47km_L253');   %reads in the interface height (m)
zlev = flipud (zlev);

Tbar    = 260;
Pi(:,1) = 1.0 * exp ( - zlev(:,1) / (29.3 * Tbar) );
Pi      = Pi * 100000.0;

%Pm = lev * 100.0;
%P = logspace(log10(Pt),log10(P0),nlevel)';

[Ai, Bi, ilev] = comp_ab (Pi);
%[Am, Bm, lev]  = comp_ab (Pm);

% compute Am and Bm by averaging Ai and Bi.
% note: this is not a rigorous way of calculating the coefficients for the mid points.
% but since CAM5 requires m-point coeff to be arithmatic mean of i-points I
% did it this way.

nsize = length (Pi);

for i=1:nsize-1   

    Am(i,1)  = 0.50 * ( Ai(i,1) + Ai(i+1,1) );
    Bm(i,1)  = 0.50 * ( Bi(i,1) + Bi(i+1,1) );
    lev(i,1) = 0.50 * ( ilev(i,1) + ilev(i+1,1) );
    
end

for i=1:nsize-1   

    dz(i,1)  = zlev(i,1) - zlev(i+1,1);
    
end

%zplev = 1000 * (Ai+Bi);
%plot (zplev, Pi, '.');

figure(1);
plot (ilev, Ai, '.', ilev, Bi, '.');
xlabel ('Pressure lev (mb)');
ylabel ('Pressure coeff. A, B');

figure(2);
%plot (zlev(3:nsize)/1000, dz(1:nsize-2), '.');
plot (zlev(3:nsize)/1000, dz(1:nsize-2), '.');
xlabel ('lev (km)'); 
ylabel ('dz (m)'); ylim([0 1600]);

%%%%%%%%%%% write out to a netcdf file

file_name = 'hp_built_cami_1.9x2.5_L253_c160708.nc';
ncid      = netcdf.create(file_name,'NOCLOBBER');

dimid1 = netcdf.defDim(ncid,'ilev',length(Ai));
dimid2 = netcdf.defDim(ncid,'lev',length(Am));

varid1 = netcdf.defVar(ncid,'hyai','NC_DOUBLE',dimid1);
varid2 = netcdf.defVar(ncid,'hyam','NC_DOUBLE',dimid2);
varid3 = netcdf.defVar(ncid,'hybi','NC_DOUBLE',dimid1);
varid4 = netcdf.defVar(ncid,'hybm','NC_DOUBLE',dimid2);
varid5 = netcdf.defVar(ncid,'ilev','NC_DOUBLE',dimid1);
varid6 = netcdf.defVar(ncid,'lev','NC_DOUBLE',dimid2);

netcdf.endDef(ncid);

% netcdf.putVar(ncid,varid1,hyai30);
% netcdf.putVar(ncid,varid2,hyam30);
% netcdf.putVar(ncid,varid3,hybi30);
% netcdf.putVar(ncid,varid4,hybm30);
% netcdf.putVar(ncid,varid5,ilev30);
% netcdf.putVar(ncid,varid6,lev30);

netcdf.putVar(ncid,varid1,Ai);
netcdf.putVar(ncid,varid2,Am);
netcdf.putVar(ncid,varid3,Bi);
netcdf.putVar(ncid,varid4,Bm);
netcdf.putVar(ncid,varid5,ilev);
netcdf.putVar(ncid,varid6,lev);

netcdf.close(ncid);
