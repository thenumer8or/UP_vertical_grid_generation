clc;
clear all;

% read in the vertical grid structure from an available 30 level input file.
Ain1   = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hyai');
Amn1   = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hyam');
Bin1   = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hybi');
Bmn1   = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'hybm');
levn1  = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'lev');
ilevn1 = ncread('cami_0000-01-01_1.9x2.5_L60_c150205.nc', 'ilev');

% compute Am and Bm by averaging Ai and Bi.
% note: this is not a rigorous way of calculating the coefficients for the mid points.
% but since CAM5 requires m-point coeff to be arithmatic mean of i-points I
% did it this way.

%provide the start point for averaging.

%nstart = 51; % for 100 levels with n=6.
nstart = 49; % for 120 levels with n=7.
n      = 7;

Ain2   = vfill_linspace(Ain1, nstart, length(Ain1)-1, n);
Bin2   = vfill_linspace(Bin1, nstart, length(Bin1)-1, n);
ilevn2 = vfill_linspace(ilevn1, nstart, length(ilevn1)-1, n);

nsize2 = length (ilevn2);

for i=1:nsize2-1
    
    Amn2(i,1)  = 0.50 * ( Ain2(i,1) + Ain2(i+1,1) );
    Bmn2(i,1)  = 0.50 * ( Bin2(i,1) + Bin2(i+1,1) );
    levn2(i,1) = 0.50 * ( ilevn2(i,1) + ilevn2(i+1,1) );
    
end

plot (ilevn2, Ain2, '.');
hold on;
plot (ilevn1, Ain1, 's');
hold on;
plot (ilevn2, Bin2, '.');
hold on;
plot (ilevn1, Bin1, 'd');
xlabel ('lev [mb]');
ylabel ('A or B');

%%%%%%%%%%% write out to a netcdf file

% file_name = 'custom_cami_0000-01-01_1.9x2.5_L100_test_c150215.nc';
% ncid      = netcdf.create(file_name,'NOCLOBBER');
% 
% dimid1 = netcdf.defDim(ncid,'ilev',length (ilevn2));
% dimid2 = netcdf.defDim(ncid,'lev',length (levn2));
% 
% varid1 = netcdf.defVar(ncid,'hyai','NC_DOUBLE',dimid1);
% varid2 = netcdf.defVar(ncid,'hyam','NC_DOUBLE',dimid2);
% varid3 = netcdf.defVar(ncid,'hybi','NC_DOUBLE',dimid1);
% varid4 = netcdf.defVar(ncid,'hybm','NC_DOUBLE',dimid2);
% varid5 = netcdf.defVar(ncid,'ilev','NC_DOUBLE',dimid1);
% varid6 = netcdf.defVar(ncid,'lev','NC_DOUBLE',dimid2);
% 
% netcdf.endDef(ncid);
% 
% netcdf.putVar(ncid,varid1,Ain2);
% netcdf.putVar(ncid,varid2,Amn2);
% netcdf.putVar(ncid,varid3,Bin2);
% netcdf.putVar(ncid,varid4,Bmn2);
% netcdf.putVar(ncid,varid5,ilevn2);
% netcdf.putVar(ncid,varid6,levn2);
% 
% netcdf.close(ncid);
