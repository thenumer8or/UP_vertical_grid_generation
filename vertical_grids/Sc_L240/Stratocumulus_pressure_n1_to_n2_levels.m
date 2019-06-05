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

nstart = 52; % top of the Sc layer around 800mb.
nstop  = 59; % bottom of the Sc layer around 970mb.
n      = 32; % produces 240 pressure levels total.

Ain2(1:nstart,1)     =  Ain1(1:nstart,1);
Bin2(1:nstart,1)     =  Bin1(1:nstart,1);
ilevn2(1:nstart,1)  =  ilevn1(1:nstart,1);

midAin2   = vfill2_linspace(Ain1(nstart+1:nstop,1), nstart+1, nstop, n);
midBin2   = vfill2_linspace(Bin1(nstart+1:nstop,1), nstart+1, nstop, n);
midilevn2 = vfill2_linspace(ilevn1(nstart+1:nstop,1), nstart+1, nstop, n);

Ain2   = cat (1, Ain2, midAin2);
Bin2   = cat (1, Bin2, midBin2);
ilevn2 = cat (1, ilevn2, midilevn2);

for i=nstop+1:length(Ain1)
    
    Ain2(length(Ain2)+1,1)      =  Ain1(i,1);
    Bin2(length(Bin2)+1,1)      =  Bin1(i,1);
    ilevn2(length(ilevn2)+1,1)  =  ilevn1(i,1);
end

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

% file_name = 'custom_cami_0000-01-01_1.9x2.5_L240_Sc1_c150309.nc';
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
