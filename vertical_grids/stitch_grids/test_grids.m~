clear; close all;
files = {'UP_hybrid.nc','SP_hybrid.nc'}; 
for k=1:2
    Ai = ncread(char(files(k)),'hyai'); 
    Bi = ncread(char(files(k)),'hybi'); 
    ilev = ncread(char(files(k)),'ilev'); 
    
    subplot (1,3,k);
    n = length(Ai); 
    plot ((1:n)/n,Ai,'k.-'); 
    %plot ((1:n)/n,B,'k.-'); 
    if (k == 2) % SP?
        dAdk = Ai(2:end)-Ai(1:end-1); 
        aux = find (dAdk > 0); 
        istitch = aux(end);         
        hold on;
        plot ((istitch/n),Ai(istitch),'rx');        
%        plot ((istitch/n),B(istitch),'rx');        
        Ainew = cat(1,Ai(1:istitch),Ai_UP(iend:end)); 
        Binew = cat(1,Bi(1:istitch),Bi_UP(iend:end));
        ilevnew = cat(1,ilev(1:istitch),ilev_UP(iend:end));
        
        nnew = length(Ainew); 
        subplot (1,3,3); 
        plot ((1:nnew)/nnew,Ainew,'b.-'); 
%        plot ((1:nnew)/nnew,Bnew,'b.-'); 
    else
        Ai_UP = Ai; Bi_UP = Bi; ilev_UP = ilev;  
        iend = find (Ai == max(Ai));         
    end
end

nsize = length (ilevnew);

for i=1:nsize-1   

    Amnew(i,1)  = 0.50 * ( Ainew(i,1) + Ainew(i+1,1) );
    Bmnew(i,1)  = 0.50 * ( Binew(i,1) + Binew(i+1,1) );
    levnew(i,1) = 0.50 * ( ilevnew(i,1) + ilevnew(i+1,1) );
    
end

%%%%%%%%%%% write out to a netcdf file

file_name = 'hp_built_cam_levels_L111_c170531.nc';
ncid      = netcdf.create(file_name,'NOCLOBBER');

dimid1 = netcdf.defDim(ncid,'ilev',length(Ainew));
dimid2 = netcdf.defDim(ncid,'lev',length(Amnew));

varid1 = netcdf.defVar(ncid,'hyai','NC_DOUBLE',dimid1);
varid2 = netcdf.defVar(ncid,'hyam','NC_DOUBLE',dimid2);
varid3 = netcdf.defVar(ncid,'hybi','NC_DOUBLE',dimid1);
varid4 = netcdf.defVar(ncid,'hybm','NC_DOUBLE',dimid2);
varid5 = netcdf.defVar(ncid,'ilev','NC_DOUBLE',dimid1);
varid6 = netcdf.defVar(ncid,'lev','NC_DOUBLE',dimid2);

netcdf.endDef(ncid);

netcdf.putVar(ncid,varid1,Ainew);
netcdf.putVar(ncid,varid2,Amnew);
netcdf.putVar(ncid,varid3,Binew);
netcdf.putVar(ncid,varid4,Bmnew);
netcdf.putVar(ncid,varid5,ilevnew);
netcdf.putVar(ncid,varid6,levnew);

netcdf.close(ncid);
